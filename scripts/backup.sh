#!/bin/bash
# Backup OpenCode orchestration configuration
set -euo pipefail

OPencode_DIR="${OPencode_CONFIG_DIR:-$HOME/.config/opencode}"
BACKUP_DIR="${OPencode_BACKUP_DIR:-$HOME/.opencode-backups}"
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

# Check if OpenCode config exists
check_config() {
    if [[ ! -d "$OPencode_DIR" ]]; then
        log_error "OpenCode configuration directory not found: $OPencode_DIR"
        exit 1
    fi
    
    log_success "OpenCode configuration found"
}

# Create backup directory
create_backup_dir() {
    mkdir -p "$BACKUP_DIR"
    log_success "Backup directory ready: $BACKUP_DIR"
}

# Create full backup
create_full_backup() {
    local backup_name="full-backup-$TIMESTAMP"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    log_info "Creating full backup: $backup_name"
    
    cp -r "$OPencode_DIR" "$backup_path"
    
    # Create backup metadata
    cat > "$backup_path/metadata.json" << EOF
{
  "type": "full",
  "timestamp": "$TIMESTAMP",
  "source": "$OPencode_DIR",
  "created_by": "$SCRIPT_NAME",
  "version": "1.0.0",
  "files": {
    "commands": $(find "$OPencode_DIR/command" -name "*.md" 2>/dev/null | wc -l),
    "agents": $(find "$OPencode_DIR/agent" -name "*.md" 2>/dev/null | wc -l),
    "config": $(find "$OPencode_DIR/config" -name "*.json" 2>/dev/null | wc -l)
  }
}
EOF
    
    log_success "Full backup created: $backup_path"
    echo "$backup_path"
}

# Create configuration-only backup
create_config_backup() {
    local backup_name="config-backup-$TIMESTAMP"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    log_info "Creating configuration backup: $backup_name"
    
    mkdir -p "$backup_path"
    
    # Backup only configuration files
    if [[ -d "$OPencode_DIR/config" ]]; then
        cp -r "$OPencode_DIR/config" "$backup_path/"
    fi
    
    # Backup base opencode.json if it exists
    if [[ -f "$OPencode_DIR/opencode.json" ]]; then
        cp "$OPencode_DIR/opencode.json" "$backup_path/"
    fi
    
    # Create backup metadata
    cat > "$backup_path/metadata.json" << EOF
{
  "type": "config",
  "timestamp": "$TIMESTAMP",
  "source": "$OPencode_DIR",
  "created_by": "$SCRIPT_NAME",
  "version": "1.0.0",
  "files": {
    "config": $(find "$backup_path/config" -name "*.json" 2>/dev/null | wc -l)
  }
}
EOF
    
    log_success "Configuration backup created: $backup_path"
    echo "$backup_path"
}

# Create custom backup
create_custom_backup() {
    local backup_name="custom-backup-$TIMESTAMP"
    local backup_path="$BACKUP_DIR/$backup_name"
    local include_patterns=("${CUSTOM_INCLUDE[@]}")
    local exclude_patterns=("${CUSTOM_EXCLUDE[@]}")
    
    log_info "Creating custom backup: $backup_name"
    
    mkdir -p "$backup_path"
    
    # Copy files based on patterns
    for pattern in "${include_patterns[@]}"; do
        log_info "Including pattern: $pattern"
        find "$OPencode_DIR" -name "$pattern" -exec cp --parents {} "$backup_path" \;
    done
    
    # Remove excluded patterns
    for pattern in "${exclude_patterns[@]}"; do
        log_info "Excluding pattern: $pattern"
        find "$backup_path" -name "$pattern" -delete 2>/dev/null || true
    done
    
    # Create backup metadata
    cat > "$backup_path/metadata.json" << EOF
{
  "type": "custom",
  "timestamp": "$TIMESTAMP",
  "source": "$OPencode_DIR",
  "created_by": "$SCRIPT_NAME",
  "version": "1.0.0",
  "include_patterns": [$(printf '"%s",' "${include_patterns[@]}" | sed 's/,$//')],
  "exclude_patterns": [$(printf '"%s",' "${exclude_patterns[@]}" | sed 's/,$//')]
}
EOF
    
    log_success "Custom backup created: $backup_path"
    echo "$backup_path"
}

# List existing backups
list_backups() {
    log_info "Available backups in $BACKUP_DIR:"
    
    if [[ ! -d "$BACKUP_DIR" ]] || [[ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        log_warning "No backups found"
        return
    fi
    
    for backup in "$BACKUP_DIR"/*; do
        if [[ -d "$backup" ]]; then
            local metadata_file="$backup/metadata.json"
            if [[ -f "$metadata_file" ]]; then
                local type=$(grep -o '"type": "[^"]*"' "$metadata_file" | cut -d'"' -f4)
                local timestamp=$(grep -o '"timestamp": "[^"]*"' "$metadata_file" | cut -d'"' -f4)
                local size=$(du -sh "$backup" 2>/dev/null | cut -f1)
                echo "  $(basename "$backup") ($type, $timestamp, $size)"
            else
                echo "  $(basename "$backup") (no metadata)"
            fi
        fi
    done
}

# Restore from backup
restore_backup() {
    local backup_name="$1"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    if [[ ! -d "$backup_path" ]]; then
        log_error "Backup not found: $backup_path"
        exit 1
    fi
    
    log_info "Restoring from backup: $backup_name"
    
    # Create backup of current config before restore
    local pre_restore_backup="$BACKUP_DIR/pre-restore-$TIMESTAMP"
    if [[ -d "$OPencode_DIR" ]]; then
        cp -r "$OPencode_DIR" "$pre_restore_backup"
        log_info "Created pre-restore backup: $pre_restore_backup"
    fi
    
    # Remove existing config
    rm -rf "$OPencode_DIR"
    
    # Restore from backup
    cp -r "$backup_path"/* "$OPencode_DIR/"
    
    # Remove metadata file from restored config
    rm -f "$OPencode_DIR/metadata.json"
    
    log_success "Backup restored to: $OPencode_DIR"
    log_info "Pre-restore backup available at: $pre_restore_backup"
}

# Clean old backups
cleanup_old_backups() {
    local retention_days="${1:-30}"
    
    log_info "Cleaning up backups older than $retention_days days..."
    
    local deleted=0
    while IFS= read -r -d '' backup; do
        local metadata_file="$backup/metadata.json"
        if [[ -f "$metadata_file" ]]; then
            local timestamp=$(grep -o '"timestamp": "[^"]*"' "$metadata_file" | cut -d'"' -f4)
            local backup_date=$(date -d "${timestamp:0:8}" +%s 2>/dev/null || echo 0)
            local cutoff_date=$(date -d "$retention_days days ago" +%s)
            
            if [[ $backup_date -lt $cutoff_date ]]; then
                log_info "Removing old backup: $(basename "$backup")"
                rm -rf "$backup"
                ((deleted++))
            fi
        fi
    done < <(find "$BACKUP_DIR" -maxdepth 1 -type d -name "*backup*" -print0 2>/dev/null)
    
    log_success "Removed $deleted old backups"
}

# Show backup summary
show_summary() {
    local backup_path="$1"
    
    echo
    log_success "Backup operation complete!"
    echo
    echo "Backup details:"
    echo "- Path: $backup_path"
    echo "- Size: $(du -sh "$backup_path" 2>/dev/null | cut -f1)"
    echo "- Timestamp: $TIMESTAMP"
    echo "- Configuration: $OPencode_DIR"
    echo "- Backup directory: $BACKUP_DIR"
    echo
    echo "To restore:"
    echo "  $SCRIPT_NAME --restore $(basename "$backup_path")"
    echo
    echo "To list all backups:"
    echo "  $SCRIPT_NAME --list"
}

# Main backup flow
main() {
    local backup_type="${1:-full}"
    
    echo "OpenCode Orchestration Backup"
    echo "=============================="
    echo
    
    check_config
    create_backup_dir
    
    case "$backup_type" in
        full)
            local backup_path=$(create_full_backup)
            show_summary "$backup_path"
            ;;
        config)
            local backup_path=$(create_config_backup)
            show_summary "$backup_path"
            ;;
        custom)
            if [[ -z "${CUSTOM_INCLUDE:-}" ]]; then
                log_error "Custom backup requires CUSTOM_INCLUDE environment variable"
                exit 1
            fi
            IFS=',' read -ra CUSTOM_INCLUDE <<< "$CUSTOM_INCLUDE"
            IFS=',' read -ra CUSTOM_EXCLUDE <<< "${CUSTOM_EXCLUDE:-}"
            local backup_path=$(create_custom_backup)
            show_summary "$backup_path"
            ;;
        *)
            log_error "Unknown backup type: $backup_type"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $SCRIPT_NAME [OPTIONS] [TYPE]"
        echo
        echo "Types:"
        echo "  full          Backup entire configuration (default)"
        echo "  config        Backup only configuration files"
        echo "  custom        Custom backup (requires CUSTOM_INCLUDE)"
        echo
        echo "Options:"
        echo "  --help, -h    Show this help message"
        echo "  --version     Show version information"
        echo "  --list        List existing backups"
        echo "  --restore     Restore from backup"
        echo "  --cleanup     Clean old backups"
        echo
        echo "Environment variables:"
        echo "  OPencode_CONFIG_DIR    Override OpenCode config directory"
        echo "  OPencode_BACKUP_DIR    Override backup directory"
        echo "  CUSTOM_INCLUDE         Comma-separated patterns for custom backup"
        echo "  CUSTOM_EXCLUDE         Comma-separated patterns to exclude"
        echo
        echo "Examples:"
        echo "  $SCRIPT_NAME full"
        echo "  $SCRIPT_NAME config"
        echo "  CUSTOM_INCLUDE='*.md,*.json' $SCRIPT_NAME custom"
        echo "  $SCRIPT_NAME --list"
        echo "  $SCRIPT_NAME --restore full-backup-20231201-120000"
        echo "  $SCRIPT_NAME --cleanup 30"
        exit 0
        ;;
    --version)
        echo "OpenCode Orchestration Backup v1.0.0"
        exit 0
        ;;
    --list)
        list_backups
        exit 0
        ;;
    --restore)
        if [[ -z "${2:-}" ]]; then
            log_error "Backup name required for restore"
            echo "Use --list to see available backups"
            exit 1
        fi
        check_config
        restore_backup "$2"
        exit 0
        ;;
    --cleanup)
        local retention_days="${2:-30}"
        cleanup_old_backups "$retention_days"
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac