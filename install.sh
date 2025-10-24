#!/bin/bash
# OpenCode Orchestration Installation Script
set -euo pipefail

INSTALL_DIR="${OPencode_CONFIG_DIR:-$HOME/.config/opencode}"
PROJECT_DIR="$(pwd)"
BACKUP_DIR="$HOME/.opencode-backup-$(date +%Y%m%d-%H%M%S)"
SCRIPT_NAME="$(basename "$0")"

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

# Check if OpenCode is installed
check_opencode() {
    if ! command -v opencode &> /dev/null; then
        log_error "OpenCode is not installed or not in PATH"
        log_info "Please install OpenCode first: https://opencode.ai"
        exit 1
    fi
    log_success "OpenCode installation found"
}

# Create backup of existing configuration
create_backup() {
    if [[ -d "$INSTALL_DIR" ]]; then
        log_info "Creating backup of existing configuration to $BACKUP_DIR"
        cp -r "$INSTALL_DIR" "$BACKUP_DIR"
        log_success "Backup created"
    else
        log_info "No existing configuration found, creating new directory"
        mkdir -p "$INSTALL_DIR"
    fi
}

# Install files from package
install_files() {
    log_info "Installing OpenCode orchestration files..."
    
    # Install commands
    if [[ -d "$PROJECT_DIR/.opencode/command" ]]; then
        mkdir -p "$INSTALL_DIR/command"
        cp -v "$PROJECT_DIR/.opencode/command"/*.md "$INSTALL_DIR/command/" || {
            log_error "Failed to copy command files"
            exit 1
        }
        log_success "Commands installed"
    fi
    
    # Install agents
    if [[ -d "$PROJECT_DIR/.opencode/agent" ]]; then
        mkdir -p "$INSTALL_DIR/agent"
        cp -v "$PROJECT_DIR/.opencode/agent"/*.md "$INSTALL_DIR/agent/" || {
            log_error "Failed to copy agent files"
            exit 1
        }
        log_success "Agents installed"
    fi
    
    # Install configuration templates
    if [[ -d "$PROJECT_DIR/.opencode/config" ]]; then
        mkdir -p "$INSTALL_DIR/config"
        cp -rv "$PROJECT_DIR/.opencode/config/"* "$INSTALL_DIR/config/" || {
            log_error "Failed to copy configuration files"
            exit 1
        }
        log_success "Configuration templates installed"
    fi
    
    # Install base configuration if it doesn't exist
    if [[ -f "$PROJECT_DIR/.opencode/opencode.json" ]] && [[ ! -f "$INSTALL_DIR/opencode.json" ]]; then
        cp -v "$PROJECT_DIR/.opencode/opencode.json" "$INSTALL_DIR/" || {
            log_error "Failed to copy base configuration"
            exit 1
        }
        log_success "Base configuration installed"
    fi
}

# Initialize configuration
init_config() {
    log_info "Initializing configuration..."
    
    # Create personal config if it doesn't exist
    if [[ ! -f "$INSTALL_DIR/config/personal.json" ]]; then
        if [[ -f "$INSTALL_DIR/config/personal.json.example" ]]; then
            cp "$INSTALL_DIR/config/personal.json.example" "$INSTALL_DIR/config/personal.json"
            log_info "Created personal configuration from template"
        else
            cat > "$INSTALL_DIR/config/personal.json" << 'EOF'
{
  "preferences": {
    "default_agent": "build",
    "auto_save": true,
    "theme": "dark"
  },
  "sync": {
    "enabled": false,
    "remote": null
  }
}
EOF
            log_info "Created default personal configuration"
        fi
    fi
    
    log_success "Configuration initialized"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    # Check if commands are accessible
    if command -v opencode &> /dev/null; then
        # Try to list commands (this may fail if OpenCode is not running, but that's OK)
        if timeout 5 opencode command list &> /dev/null; then
            log_success "Commands are accessible"
        else
            log_warning "Could not verify commands (OpenCode may need to be restarted)"
        fi
    fi
    
    # Check file permissions
    local errors=0
    for file in "$INSTALL_DIR/command"/*.md; do
        if [[ -f "$file" && ! -r "$file" ]]; then
            log_error "Command file not readable: $file"
            ((errors++))
        fi
    done
    
    for file in "$INSTALL_DIR/agent"/*.md; do
        if [[ -f "$file" && ! -r "$file" ]]; then
            log_error "Agent file not readable: $file"
            ((errors++))
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        log_success "All files have correct permissions"
    else
        log_error "Found $errors files with permission issues"
        exit 1
    fi
}

# Show next steps
show_next_steps() {
    echo
    log_success "OpenCode Orchestration installation complete!"
    echo
    echo "Next steps:"
    echo "1. Restart OpenCode to reload commands and agents"
    echo "2. Test with: opencode plan \"test\""
    echo "3. Configure your preferences in: $INSTALL_DIR/config/personal.json"
    echo
    echo "Backup location: $BACKUP_DIR"
    echo "Package directory: $PROJECT_DIR"
    echo
    echo "For help, see: $PROJECT_DIR/docs/README.md"
}

# Main installation flow
main() {
    echo "OpenCode Orchestration Installation Script"
    echo "=========================================="
    echo
    
    # Check if we're in the right directory
    if [[ ! -d "$PROJECT_DIR/.opencode" ]]; then
        log_error "This script must be run from the opencode-orchestration package directory"
        log_info "Expected to find .opencode directory in: $PROJECT_DIR"
        exit 1
    fi
    
    check_opencode
    create_backup
    install_files
    init_config
    verify_installation
    show_next_steps
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $SCRIPT_NAME [OPTIONS]"
        echo
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --version      Show version information"
        echo "  --uninstall    Run the uninstallation script"
        echo
        echo "Environment variables:"
        echo "  OPencode_CONFIG_DIR  Override OpenCode configuration directory"
        exit 0
        ;;
    --version)
        echo "OpenCode Orchestration Installer v1.0.0"
        exit 0
        ;;
    --uninstall)
        if [[ -f "$PROJECT_DIR/uninstall.sh" ]]; then
            exec "$PROJECT_DIR/uninstall.sh"
        else
            log_error "Uninstall script not found"
            exit 1
        fi
        ;;
    "")
        # No arguments, run main installation
        main
        ;;
    *)
        log_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac