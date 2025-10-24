#!/bin/bash
# Update OpenCode orchestration to new version
set -euo pipefail

OPencode_DIR="${OPencode_CONFIG_DIR:-$HOME/.config/opencode}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"
SCRIPT_NAME="$(basename "$0")"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

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

# Check if we're in the right directory
check_package_dir() {
    if [[ ! -d "$PACKAGE_DIR/.opencode" ]]; then
        log_error "This script must be run from the opencode-orchestration package directory"
        log_info "Expected to find .opencode directory in: $PACKAGE_DIR"
        exit 1
    fi
    
    log_success "Package directory found"
}

# Check if OpenCode config exists
check_config() {
    if [[ ! -d "$OPencode_DIR" ]]; then
        log_error "OpenCode configuration directory not found: $OPencode_DIR"
        log_info "Install OpenCode orchestration first:"
        echo "  cd $PACKAGE_DIR && ./install.sh"
        exit 1
    fi
    
    log_success "OpenCode configuration found"
}

# Get current version
get_current_version() {
    local version_file="$OPencode_DIR/opencode.json"
    
    if [[ -f "$version_file" ]]; then
        if command -v jq &> /dev/null; then
            jq -r '.version // "unknown"' "$version_file" 2>/dev/null || echo "unknown"
        else
            grep -o '"version": "[^"]*"' "$version_file" 2>/dev/null | cut -d'"' -f4 || echo "unknown"
        fi
    else
        echo "unknown"
    fi
}

# Get new version
get_new_version() {
    local version_file="$PACKAGE_DIR/.opencode/opencode.json"
    
    if [[ -f "$version_file" ]]; then
        if command -v jq &> /dev/null; then
            jq -r '.version // "unknown"' "$version_file" 2>/dev/null || echo "unknown"
        else
            grep -o '"version": "[^"]*"' "$version_file" 2>/dev/null | cut -d'"' -f4 || echo "unknown"
        fi
    else
        echo "unknown"
    fi
}

# Create backup before update
create_backup() {
    local backup_dir="$HOME/.opencode-update-backup-$TIMESTAMP"
    
    log_info "Creating backup before update..."
    cp -r "$OPencode_DIR" "$backup_dir"
    log_success "Backup created at: $backup_dir"
    echo "$backup_dir"
}

# Check for customizations
check_customizations() {
    log_info "Checking for customizations..."
    
    local customizations=()
    
    # Check for custom commands
    if [[ -d "$OPencode_DIR/command" ]]; then
        for cmd_file in "$OPencode_DIR/command"/*.md; do
            if [[ -f "$cmd_file" ]]; then
                local cmd_name=$(basename "$cmd_file")
                local package_cmd="$PACKAGE_DIR/.opencode/command/$cmd_name"
                
                if [[ ! -f "$package_cmd" ]]; then
                    customizations+=("custom command: $cmd_name")
                elif ! cmp -s "$cmd_file" "$package_cmd"; then
                    customizations+=("modified command: $cmd_name")
                fi
            fi
        done
    fi
    
    # Check for custom agents
    if [[ -d "$OPencode_DIR/agent" ]]; then
        for agent_file in "$OPencode_DIR/agent"/*.md; do
            if [[ -f "$agent_file" ]]; then
                local agent_name=$(basename "$agent_file")
                local package_agent="$PACKAGE_DIR/.opencode/agent/$agent_name"
                
                if [[ ! -f "$package_agent" ]]; then
                    customizations+=("custom agent: $agent_name")
                elif ! cmp -s "$agent_file" "$package_agent"; then
                    customizations+=("modified agent: $agent_name")
                fi
            fi
        done
    fi
    
    # Check for custom config files
    if [[ -d "$OPencode_DIR/config" ]]; then
        for config_file in "$OPencode_DIR/config"/*.json; do
            if [[ -f "$config_file" ]]; then
                local config_name=$(basename "$config_file")
                if [[ "$config_name" != *"example"* ]]; then
                    customizations+=("user config: $config_name")
                fi
            fi
        done
    fi
    
    if [[ ${#customizations[@]} -gt 0 ]]; then
        log_warning "Found customizations:"
        for customization in "${customizations[@]}"; do
            echo "  - $customization"
        done
        return 0
    else
        log_info "No customizations found"
        return 1
    fi
}

# Merge customizations
merge_customizations() {
    log_info "Preserving customizations..."
    
    local temp_dir="/tmp/opencode-customizations-$TIMESTAMP"
    mkdir -p "$temp_dir"
    
    # Preserve custom commands
    if [[ -d "$OPencode_DIR/command" ]]; then
        for cmd_file in "$OPencode_DIR/command"/*.md; do
            if [[ -f "$cmd_file" ]]; then
                local cmd_name=$(basename "$cmd_file")
                local package_cmd="$PACKAGE_DIR/.opencode/command/$cmd_name"
                
                if [[ ! -f "$package_cmd" ]]; then
                    cp "$cmd_file" "$temp_dir/"
                    log_info "Preserving custom command: $cmd_name"
                elif ! cmp -s "$cmd_file" "$package_cmd" && [[ "${PRESERVE_MODIFIED:-yes}" == "yes" ]]; then
                    cp "$cmd_file" "$temp_dir/"
                    log_info "Preserving modified command: $cmd_name"
                fi
            fi
        done
    fi
    
    # Preserve custom agents
    if [[ -d "$OPencode_DIR/agent" ]]; then
        for agent_file in "$OPencode_DIR/agent"/*.md; do
            if [[ -f "$agent_file" ]]; then
                local agent_name=$(basename "$agent_file")
                local package_agent="$PACKAGE_DIR/.opencode/agent/$agent_name"
                
                if [[ ! -f "$package_agent" ]]; then
                    cp "$agent_file" "$temp_dir/"
                    log_info "Preserving custom agent: $agent_name"
                elif ! cmp -s "$agent_file" "$package_agent" && [[ "${PRESERVE_MODIFIED:-yes}" == "yes" ]]; then
                    cp "$agent_file" "$temp_dir/"
                    log_info "Preserving modified agent: $agent_name"
                fi
            fi
        done
    fi
    
    # Preserve user config files
    if [[ -d "$OPencode_DIR/config" ]]; then
        mkdir -p "$temp_dir/config"
        for config_file in "$OPencode_DIR/config"/*.json; do
            if [[ -f "$config_file" ]]; then
                local config_name=$(basename "$config_file")
                if [[ "$config_name" != *"example"* ]] && [[ "$config_name" != "sync.json" ]]; then
                    cp "$config_file" "$temp_dir/config/"
                    log_info "Preserving user config: $config_name"
                fi
            fi
        done
    fi
    
    echo "$temp_dir"
}

# Install new files
install_new_files() {
    log_info "Installing new files..."
    
    # Install new commands
    if [[ -d "$PACKAGE_DIR/.opencode/command" ]]; then
        mkdir -p "$OPencode_DIR/command"
        cp -v "$PACKAGE_DIR/.opencode/command"/*.md "$OPencode_DIR/command/" || {
            log_error "Failed to install new commands"
            return 1
        }
        log_success "New commands installed"
    fi
    
    # Install new agents
    if [[ -d "$PACKAGE_DIR/.opencode/agent" ]]; then
        mkdir -p "$OPencode_DIR/agent"
        cp -v "$PACKAGE_DIR/.opencode/agent"/*.md "$OPencode_DIR/agent/" || {
            log_error "Failed to install new agents"
            return 1
        }
        log_success "New agents installed"
    fi
    
    # Install new configuration templates
    if [[ -d "$PACKAGE_DIR/.opencode/config" ]]; then
        mkdir -p "$OPencode_DIR/config"
        cp -rv "$PACKAGE_DIR/.opencode/config/"* "$OPencode_DIR/config/" || {
            log_error "Failed to install new configuration"
            return 1
        }
        log_success "New configuration templates installed"
    fi
    
    # Update base configuration
    if [[ -f "$PACKAGE_DIR/.opencode/opencode.json" ]]; then
        cp "$PACKAGE_DIR/.opencode/opencode.json" "$OPencode_DIR/" || {
            log_error "Failed to update base configuration"
            return 1
        }
        log_success "Base configuration updated"
    fi
}

# Restore customizations
restore_customizations() {
    local temp_dir="$1"
    
    if [[ ! -d "$temp_dir" ]]; then
        return
    fi
    
    log_info "Restoring customizations..."
    
    # Restore custom commands
    for cmd_file in "$temp_dir"/*.md; do
        if [[ -f "$cmd_file" ]]; then
            cp "$cmd_file" "$OPencode_DIR/command/"
            log_info "Restored custom command: $(basename "$cmd_file")"
        fi
    done
    
    # Restore custom agents
    for agent_file in "$temp_dir"/*.md; do
        if [[ -f "$agent_file" ]]; then
            cp "$agent_file" "$OPencode_DIR/agent/"
            log_info "Restored custom agent: $(basename "$agent_file")"
        fi
    done
    
    # Restore user config files
    if [[ -d "$temp_dir/config" ]]; then
        for config_file in "$temp_dir/config"/*.json; do
            if [[ -f "$config_file" ]]; then
                cp "$config_file" "$OPencode_DIR/config/"
                log_info "Restored user config: $(basename "$config_file")"
            fi
        done
    fi
    
    # Clean up temp directory
    rm -rf "$temp_dir"
}

# Verify update
verify_update() {
    log_info "Verifying update..."
    
    local new_version=$(get_new_version)
    local current_version=$(get_current_version)
    
    if [[ "$new_version" != "$current_version" ]]; then
        log_success "Version updated: $current_version → $new_version"
    else
        log_warning "Version unchanged: $current_version"
    fi
    
    # Check if files are accessible
    local errors=0
    for file in "$OPencode_DIR/command"/*.md; do
        if [[ -f "$file" && ! -r "$file" ]]; then
            log_error "Command file not readable: $file"
            ((errors++))
        fi
    done
    
    for file in "$OPencode_DIR/agent"/*.md; do
        if [[ -f "$file" && ! -r "$file" ]]; then
            log_error "Agent file not readable: $file"
            ((errors++))
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        log_success "All files have correct permissions"
    else
        log_error "Found $errors files with permission issues"
        return 1
    fi
}

# Restart OpenCode
restart_opencode() {
    log_info "Restarting OpenCode to reload configuration..."
    
    if pgrep -f opencode > /dev/null; then
        pkill -f opencode || true
        sleep 2
        log_success "OpenCode restarted"
    else
        log_info "OpenCode not running, no restart needed"
    fi
}

# Show update summary
show_summary() {
    local backup_dir="$1"
    local old_version="$2"
    local new_version="$3"
    
    echo
    log_success "Update complete!"
    echo
    echo "Update summary:"
    echo "- Old version: $old_version"
    echo "- New version: $new_version"
    echo "- Backup: $backup_dir"
    echo "- Configuration: $OPencode_DIR"
    echo
    echo "Next steps:"
    echo "1. Restart OpenCode to reload configuration"
    echo "2. Test with: opencode plan \"test\""
    echo "3. Check release notes for new features"
    echo
    echo "To rollback:"
    echo "  rm -rf '$OPencode_DIR'"
    echo "  mv '$backup_dir' '$OPencode_DIR'"
}

# Main update flow
main() {
    echo "OpenCode Orchestration Update"
    echo "=============================="
    echo
    
    check_package_dir
    check_config
    
    local old_version=$(get_current_version)
    local new_version=$(get_new_version)
    
    log_info "Current version: $old_version"
    log_info "New version: $new_version"
    
    if [[ "$old_version" == "$new_version" ]]; then
        log_info "Already up to date"
        exit 0
    fi
    
    local backup_dir=$(create_backup)
    
    local has_customizations=false
    if check_customizations; then
        has_customizations=true
    fi
    
    local temp_dir=""
    if [[ "$has_customizations" == true ]]; then
        temp_dir=$(merge_customizations)
    fi
    
    install_new_files
    
    if [[ -n "$temp_dir" ]]; then
        restore_customizations "$temp_dir"
    fi
    
    verify_update
    restart_opencode
    show_summary "$backup_dir" "$old_version" "$new_version"
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $SCRIPT_NAME [OPTIONS]"
        echo
        echo "Options:"
        echo "  --help, -h           Show this help message"
        echo "  --version            Show version information"
        echo "  --check-only         Check for updates without applying"
        echo "  --force              Force update even if same version"
        echo "  --no-preserve-mods   Don't preserve modified files"
        echo
        echo "Environment variables:"
        echo "  OPencode_CONFIG_DIR  Override OpenCode config directory"
        echo "  PRESERVE_MODIFIED    Preserve modified files (yes/no, default: yes)"
        exit 0
        ;;
    --version)
        echo "OpenCode Orchestration Update v1.0.0"
        exit 0
        ;;
    --check-only)
        check_package_dir
        check_config
        local old_version=$(get_current_version)
        local new_version=$(get_new_version)
        echo "Current version: $old_version"
        echo "Available version: $new_version"
        if [[ "$old_version" != "$new_version" ]]; then
            echo "Update available!"
            exit 1
        else
            echo "Up to date"
            exit 0
        fi
        ;;
    --force)
        export FORCE_UPDATE=true
        main
        ;;
    --no-preserve-mods)
        export PRESERVE_MODIFIED=no
        main
        ;;
    "")
        main
        ;;
    *)
        log_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac