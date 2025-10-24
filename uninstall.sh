#!/bin/bash
# OpenCode Orchestration Uninstallation Script
set -euo pipefail

INSTALL_DIR="${OPencode_CONFIG_DIR:-$HOME/.config/opencode}"
PROJECT_DIR="$(pwd)"
SCRIPT_NAME="$(basename "$0")"
BACKUP_DIR="$HOME/.opencode-backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if OpenCode configuration exists
check_installation() {
    if [[ ! -d "$INSTALL_DIR" ]]; then
        log_warning "OpenCode configuration directory not found: $INSTALL_DIR"
        log_info "Nothing to uninstall"
        exit 0
    fi
    
    # Check if orchestration files are present
    local has_orchestration=false
    if [[ -d "$INSTALL_DIR/command" ]] && ls "$INSTALL_DIR/command"/*.md &> /dev/null; then
        has_orchestration=true
    fi
    if [[ -d "$INSTALL_DIR/agent" ]] && ls "$INSTALL_DIR/agent"/*.md &> /dev/null; then
        has_orchestration=true
    fi
    
    if [[ "$has_orchestration" == "false" ]]; then
        log_warning "No OpenCode orchestration files found"
        log_info "Nothing to uninstall"
        exit 0
    fi
    
    log_success "OpenCode orchestration installation found"
}

# Create backup before uninstalling
create_backup() {
    log_info "Creating backup before uninstallation..."
    cp -r "$INSTALL_DIR" "$BACKUP_DIR"
    log_success "Backup created at: $BACKUP_DIR"
}

# Remove orchestration files
remove_orchestration_files() {
    log_info "Removing OpenCode orchestration files..."
    
    # Remove commands
    if [[ -d "$INSTALL_DIR/command" ]]; then
        log_info "Removing commands..."
        rm -rf "$INSTALL_DIR/command"
        log_success "Commands removed"
    fi
    
    # Remove agents
    if [[ -d "$INSTALL_DIR/agent" ]]; then
        log_info "Removing agents..."
        rm -rf "$INSTALL_DIR/agent"
        log_success "Agents removed"
    fi
    
    # Remove configuration templates (but preserve user configs)
    if [[ -d "$INSTALL_DIR/config" ]]; then
        log_info "Removing configuration templates..."
        # Remove example files but preserve user configs
        find "$INSTALL_DIR/config" -name "*.example" -delete 2>/dev/null || true
        find "$INSTALL_DIR/config" -name "sync.json" -delete 2>/dev/null || true
        
        # Remove config directory if it's empty
        if rmdir "$INSTALL_DIR/config" 2>/dev/null; then
            log_success "Configuration templates removed"
        else
            log_warning "Configuration directory not removed (contains user files)"
        fi
    fi
    
    # Remove base opencode.json if it's from our package
    if [[ -f "$INSTALL_DIR/opencode.json" ]]; then
        # Check if it's our base config (simple heuristic)
        if grep -q "HumanLayer orchestration" "$INSTALL_DIR/opencode.json" 2>/dev/null; then
            rm -f "$INSTALL_DIR/opencode.json"
            log_success "Base configuration removed"
        fi
    fi
}

# Clean up empty directories
cleanup_empty_dirs() {
    log_info "Cleaning up empty directories..."
    
    # Remove .opencode directory if it's empty
    if [[ -d "$INSTALL_DIR" ]]; then
        if rmdir "$INSTALL_DIR" 2>/dev/null; then
            log_success "Removed empty configuration directory"
        else
            log_info "Configuration directory preserved (contains other files)"
        fi
    fi
}

# Verify uninstallation
verify_uninstallation() {
    log_info "Verifying uninstallation..."
    
    local remaining_files=0
    
    # Check for remaining command files
    if [[ -d "$INSTALL_DIR/command" ]] && ls "$INSTALL_DIR/command"/*.md &> /dev/null; then
        log_warning "Some command files remain"
        ((remaining_files++))
    fi
    
    # Check for remaining agent files
    if [[ -d "$INSTALL_DIR/agent" ]] && ls "$INSTALL_DIR/agent"/*.md &> /dev/null; then
        log_warning "Some agent files remain"
        ((remaining_files++))
    fi
    
    if [[ $remaining_files -eq 0 ]]; then
        log_success "All orchestration files removed"
    else
        log_warning "$remaining_files file types may remain"
    fi
}

# Show completion message
show_completion() {
    echo
    log_success "OpenCode Orchestration uninstallation complete!"
    echo
    echo "What was preserved:"
    echo "- Your personal configuration files"
    echo "- Any custom modifications you made"
    echo "- Other OpenCode extensions"
    echo
    echo "Backup location: $BACKUP_DIR"
    echo "Configuration directory: $INSTALL_DIR"
    echo
    echo "To restore from backup:"
    echo "  rm -rf '$INSTALL_DIR'"
    echo "  mv '$BACKUP_DIR' '$INSTALL_DIR'"
    echo
    echo "To completely remove OpenCode configuration:"
    echo "  rm -rf '$INSTALL_DIR'"
}

# Interactive confirmation
confirm_uninstall() {
    echo "OpenCode Orchestration Uninstaller"
    echo "==================================="
    echo
    echo "This will remove:"
    echo "- All orchestration commands"
    echo "- All orchestration agents"
    echo "- Configuration templates"
    echo
    echo "What will be preserved:"
    echo "- Your personal configuration files"
    echo "- Any custom modifications"
    echo "- Other OpenCode extensions"
    echo
    echo "A backup will be created at: $BACKUP_DIR"
    echo
    
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstallation cancelled"
        exit 0
    fi
}

# Main uninstallation flow
main() {
    # Check for non-interactive mode
    if [[ "${1:-}" == "--force" ]]; then
        log_info "Running in force mode (no confirmation)"
    else
        confirm_uninstall
    fi
    
    check_installation
    create_backup
    remove_orchestration_files
    cleanup_empty_dirs
    verify_uninstallation
    show_completion
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $SCRIPT_NAME [OPTIONS]"
        echo
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --version      Show version information"
        echo "  --force        Skip confirmation prompt"
        echo
        echo "Environment variables:"
        echo "  OPencode_CONFIG_DIR  Override OpenCode configuration directory"
        exit 0
        ;;
    --version)
        echo "OpenCode Orchestration Uninstaller v1.0.0"
        exit 0
        ;;
    "")
        # No arguments, run main uninstallation with confirmation
        main
        ;;
    --force)
        # Force mode, skip confirmation
        main --force
        ;;
    *)
        log_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac