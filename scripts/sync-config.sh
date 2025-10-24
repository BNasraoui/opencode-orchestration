#!/bin/bash
# Sync OpenCode orchestration between machines
set -euo pipefail

SYNC_REPO="${OPencode_SYNC_REPO:-$HOME/.opencode-orchestration}"
OPencode_DIR="${OPencode_CONFIG_DIR:-$HOME/.config/opencode}"
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

# Check if sync repo exists
check_sync_repo() {
    if [[ ! -d "$SYNC_REPO" ]]; then
        log_error "Sync repository not found: $SYNC_REPO"
        log_info "Clone the orchestration repository first:"
        echo "  git clone https://github.com/yourusername/opencode-orchestration.git $SYNC_REPO"
        exit 1
    fi
    
    if [[ ! -d "$SYNC_REPO/.git" ]]; then
        log_error "Sync repository is not a git repository: $SYNC_REPO"
        exit 1
    fi
    
    log_success "Sync repository found"
}

# Check if OpenCode config exists
check_opencode_config() {
    if [[ ! -d "$OPencode_DIR" ]]; then
        log_error "OpenCode configuration directory not found: $OPencode_DIR"
        log_info "Install OpenCode orchestration first:"
        echo "  cd $SYNC_REPO && ./install.sh"
        exit 1
    fi
    
    log_success "OpenCode configuration found"
}

# Load sync configuration
load_sync_config() {
    local sync_config_file="$OPencode_DIR/config/sync.json"
    
    if [[ ! -f "$sync_config_file" ]]; then
        log_warning "Sync configuration not found, using defaults"
        SYNC_COMMANDS=("plan.md" "implement.md" "research.md" "validate.md")
        SYNC_AGENTS=("analyzer.md" "locator.md" "pattern-finder.md" "researcher.md")
        SYNC_CONFIG=("personal.json")
        SYNC_EXCLUDE=("work.json" "team.json" "*.local.json")
        SYNC_METHOD="git"
        CLOUD_PROVIDER=""
        CLOUD_PATH=""
        return
    fi
    
    log_info "Loading sync configuration..."
    
    # Parse JSON using basic text processing (avoiding jq dependency)
    if command -v jq &> /dev/null; then
        SYNC_COMMANDS=($(jq -r '.sync.commands[]' "$sync_config_file" 2>/dev/null || echo ""))
        SYNC_AGENTS=($(jq -r '.sync.agents[]' "$sync_config_file" 2>/dev/null || echo ""))
        SYNC_CONFIG=($(jq -r '.sync.config[]' "$sync_config_file" 2>/dev/null || echo ""))
        SYNC_EXCLUDE=($(jq -r '.sync.exclude[]' "$sync_config_file" 2>/dev/null || echo ""))
        SYNC_METHOD=$(jq -r '.sync.method // "git"' "$sync_config_file" 2>/dev/null || echo "git")
        CLOUD_PROVIDER=$(jq -r '.sync.cloud_provider // ""' "$sync_config_file" 2>/dev/null || echo "")
        CLOUD_PATH=$(jq -r '.sync.cloud_path // ""' "$sync_config_file" 2>/dev/null || echo "")
    else
        log_warning "jq not found, using default sync configuration"
        SYNC_COMMANDS=("plan.md" "implement.md" "research.md" "validate.md")
        SYNC_AGENTS=("analyzer.md" "locator.md" "pattern-finder.md" "researcher.md")
        SYNC_CONFIG=("personal.json")
        SYNC_EXCLUDE=("work.json" "team.json" "*.local.json")
        SYNC_METHOD="git"
        CLOUD_PROVIDER=""
        CLOUD_PATH=""
    fi
    
    log_success "Sync configuration loaded (method: $SYNC_METHOD)"
}

# Create backup before sync
create_backup() {
    local backup_dir="$HOME/.opencode-sync-backup-$(date +%Y%m%d-%H%M%S)"
    
    log_info "Creating backup before sync..."
    cp -r "$OPencode_DIR" "$backup_dir"
    log_success "Backup created at: $backup_dir"
}

# Pull latest changes from remote
pull_changes() {
    log_info "Pulling latest changes from remote..."
    
    cd "$SYNC_REPO"
    
    if ! git pull origin main 2>/dev/null; then
        log_warning "Could not pull from remote, working with local version"
    else
        log_success "Latest changes pulled"
    fi
}

# Sync commands
sync_commands() {
    log_info "Syncing commands..."
    
    local local_commands_dir="$OPencode_DIR/command"
    local remote_commands_dir="$SYNC_REPO/.opencode/command"
    local synced=0
    
    if [[ ! -d "$remote_commands_dir" ]]; then
        log_warning "Remote commands directory not found"
        return
    fi
    
    mkdir -p "$local_commands_dir"
    
    for cmd in "${SYNC_COMMANDS[@]}"; do
        local remote_file="$remote_commands_dir/$cmd"
        local local_file="$local_commands_dir/$cmd"
        
        if [[ -f "$remote_file" ]]; then
            if [[ -f "$local_file" ]]; then
                # Check if files are different
                if ! cmp -s "$remote_file" "$local_file"; then
                    cp "$remote_file" "$local_file"
                    log_info "Updated command: $cmd"
                    ((synced++))
                fi
            else
                cp "$remote_file" "$local_file"
                log_info "Added command: $cmd"
                ((synced++))
            fi
        fi
    done
    
    log_success "Synced $synced commands"
}

# Sync agents
sync_agents() {
    log_info "Syncing agents..."
    
    local local_agents_dir="$OPencode_DIR/agent"
    local remote_agents_dir="$SYNC_REPO/.opencode/agent"
    local synced=0
    
    if [[ ! -d "$remote_agents_dir" ]]; then
        log_warning "Remote agents directory not found"
        return
    fi
    
    mkdir -p "$local_agents_dir"
    
    for agent in "${SYNC_AGENTS[@]}"; do
        local remote_file="$remote_agents_dir/$agent"
        local local_file="$local_agents_dir/$agent"
        
        if [[ -f "$remote_file" ]]; then
            if [[ -f "$local_file" ]]; then
                # Check if files are different
                if ! cmp -s "$remote_file" "$local_file"; then
                    cp "$remote_file" "$local_file"
                    log_info "Updated agent: $agent"
                    ((synced++))
                fi
            else
                cp "$remote_file" "$local_file"
                log_info "Added agent: $agent"
                ((synced++))
            fi
        fi
    done
    
    log_success "Synced $synced agents"
}

# Sync configuration files
sync_config() {
    log_info "Syncing configuration files..."
    
    local local_config_dir="$OPencode_DIR/config"
    local remote_config_dir="$SYNC_REPO/.opencode/config"
    local synced=0
    
    if [[ ! -d "$remote_config_dir" ]]; then
        log_warning "Remote config directory not found"
        return
    fi
    
    mkdir -p "$local_config_dir"
    
    for config_file in "${SYNC_CONFIG[@]}"; do
        local remote_file="$remote_config_dir/$config_file"
        local local_file="$local_config_dir/$config_file"
        
        if [[ -f "$remote_file" ]]; then
            if [[ -f "$local_file" ]]; then
                # Check if files are different
                if ! cmp -s "$remote_file" "$local_file"; then
                    cp "$remote_file" "$local_file"
                    log_info "Updated config: $config_file"
                    ((synced++))
                fi
            else
                cp "$remote_file" "$local_file"
                log_info "Added config: $config_file"
                ((synced++))
            fi
        fi
    done
    
    log_success "Synced $synced configuration files"
}

# Push local changes to remote
push_changes() {
    log_info "Checking for local changes to push..."
    
    cd "$SYNC_REPO"
    
    # Check if there are any changes to commit
    if git diff --quiet && git diff --cached --quiet; then
        log_info "No local changes to push"
        return
    fi
    
    log_info "Pushing local changes to remote..."
    
    if ! git add . && git commit -m "Sync configuration updates $(date +%Y-%m-%d)" && git push origin main 2>/dev/null; then
        log_warning "Could not push changes to remote"
    else
        log_success "Changes pushed to remote"
    fi
}

# Cloud storage sync functions
sync_cloud_dropbox() {
    local dropbox_path="${CLOUD_PATH:-$HOME/Dropbox/Apps/OpenCode}"
    
    log_info "Syncing with Dropbox: $dropbox_path"
    
    if [[ ! -d "$dropbox_path" ]]; then
        log_warning "Dropbox directory not found: $dropbox_path"
        log_info "Creating Dropbox directory..."
        mkdir -p "$dropbox_path"
    fi
    
    # Sync to Dropbox
    rsync -av --delete "$OPencode_DIR/" "$dropbox_path/" || {
        log_error "Failed to sync to Dropbox"
        return 1
    }
    
    log_success "Dropbox sync complete"
}

sync_cloud_onedrive() {
    local onedrive_path="${CLOUD_PATH:-$HOME/OneDrive/OpenCode}"
    
    log_info "Syncing with OneDrive: $onedrive_path"
    
    if [[ ! -d "$onedrive_path" ]]; then
        log_warning "OneDrive directory not found: $onedrive_path"
        log_info "Creating OneDrive directory..."
        mkdir -p "$onedrive_path"
    fi
    
    # Sync to OneDrive
    rsync -av --delete "$OPencode_DIR/" "$onedrive_path/" || {
        log_error "Failed to sync to OneDrive"
        return 1
    }
    
    log_success "OneDrive sync complete"
}

sync_cloud_google_drive() {
    local gdrive_path="${CLOUD_PATH:-$HOME/Google Drive/OpenCode}"
    
    log_info "Syncing with Google Drive: $gdrive_path"
    
    if [[ ! -d "$gdrive_path" ]]; then
        log_warning "Google Drive directory not found: $gdrive_path"
        log_info "Creating Google Drive directory..."
        mkdir -p "$gdrive_path"
    fi
    
    # Sync to Google Drive
    rsync -av --delete "$OPencode_DIR/" "$gdrive_path/" || {
        log_error "Failed to sync to Google Drive"
        return 1
    }
    
    log_success "Google Drive sync complete"
}

sync_cloud_custom() {
    local custom_path="$CLOUD_PATH"
    
    if [[ -z "$custom_path" ]]; then
        log_error "Custom cloud path not specified"
        return 1
    fi
    
    log_info "Syncing with custom cloud storage: $custom_path"
    
    if [[ ! -d "$custom_path" ]]; then
        log_warning "Custom cloud directory not found: $custom_path"
        log_info "Creating custom cloud directory..."
        mkdir -p "$custom_path"
    fi
    
    # Sync to custom location
    rsync -av --delete "$OPencode_DIR/" "$custom_path/" || {
        log_error "Failed to sync to custom cloud storage"
        return 1
    }
    
    log_success "Custom cloud sync complete"
}

# Cloud sync dispatcher
sync_cloud() {
    case "$CLOUD_PROVIDER" in
        dropbox)
            sync_cloud_dropbox
            ;;
        onedrive)
            sync_cloud_onedrive
            ;;
        google-drive)
            sync_cloud_google_drive
            ;;
        custom)
            sync_cloud_custom
            ;;
        "")
            log_warning "No cloud provider specified"
            return 1
            ;;
        *)
            log_error "Unknown cloud provider: $CLOUD_PROVIDER"
            return 1
            ;;
    esac
}

# Pull from cloud storage
pull_cloud() {
    case "$CLOUD_PROVIDER" in
        dropbox)
            local dropbox_path="${CLOUD_PATH:-$HOME/Dropbox/Apps/OpenCode}"
            if [[ -d "$dropbox_path" ]]; then
                rsync -av --delete "$dropbox_path/" "$OPencode_DIR/"
                log_success "Pulled from Dropbox"
            fi
            ;;
        onedrive)
            local onedrive_path="${CLOUD_PATH:-$HOME/OneDrive/OpenCode}"
            if [[ -d "$onedrive_path" ]]; then
                rsync -av --delete "$onedrive_path/" "$OPencode_DIR/"
                log_success "Pulled from OneDrive"
            fi
            ;;
        google-drive)
            local gdrive_path="${CLOUD_PATH:-$HOME/Google Drive/OpenCode}"
            if [[ -d "$gdrive_path" ]]; then
                rsync -av --delete "$gdrive_path/" "$OPencode_DIR/"
                log_success "Pulled from Google Drive"
            fi
            ;;
        custom)
            local custom_path="$CLOUD_PATH"
            if [[ -n "$custom_path" && -d "$custom_path" ]]; then
                rsync -av --delete "$custom_path/" "$OPencode_DIR/"
                log_success "Pulled from custom cloud storage"
            fi
            ;;
        *)
            log_warning "Cannot pull from unknown cloud provider: $CLOUD_PROVIDER"
            ;;
    esac
}

# Restart OpenCode if running
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

# Show sync summary
show_summary() {
    echo
    log_success "Configuration sync complete!"
    echo
    echo "Sync summary:"
    echo "- Repository: $SYNC_REPO"
    echo "- Configuration: $OPencode_DIR"
    echo "- Commands: ${#SYNC_COMMANDS[@]} files"
    echo "- Agents: ${#SYNC_AGENTS[@]} files"
    echo "- Config files: ${#SYNC_CONFIG[@]} files"
    echo
    echo "Next steps:"
    echo "1. Restart OpenCode to reload configuration"
    echo "2. Test with: opencode plan \"test\""
    echo "3. Commit any local customizations:"
    echo "   cd $SYNC_REPO && git add . && git commit -m 'Local customizations'"
}

# Main sync flow
main() {
    echo "OpenCode Orchestration Sync"
    echo "============================"
    echo
    
    check_opencode_config
    load_sync_config
    
    if [[ "${1:-}" != "--no-backup" ]]; then
        create_backup
    fi
    
    case "$SYNC_METHOD" in
        git)
            check_sync_repo
            pull_changes
            sync_commands
            sync_agents
            sync_config
            push_changes
            ;;
        cloud)
            pull_cloud
            sync_commands
            sync_agents
            sync_config
            sync_cloud
            ;;
        hybrid)
            check_sync_repo
            pull_changes
            pull_cloud
            sync_commands
            sync_agents
            sync_config
            push_changes
            sync_cloud
            ;;
        *)
            log_error "Unknown sync method: $SYNC_METHOD"
            exit 1
            ;;
    esac
    
    restart_opencode
    show_summary
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $SCRIPT_NAME [OPTIONS]"
        echo
        echo "Options:"
        echo "  --help, -h       Show this help message"
        echo "  --version        Show version information"
        echo "  --no-backup      Skip creating backup"
        echo "  --push-only      Only push local changes"
        echo "  --pull-only      Only pull remote changes"
        echo "  --cloud-only     Only sync with cloud storage"
        echo "  --method METHOD  Force sync method (git/cloud/hybrid)"
        echo
        echo "Environment variables:"
        echo "  OPencode_SYNC_REPO     Override sync repository path"
        echo "  OPencode_CONFIG_DIR    Override OpenCode config directory"
        echo
        echo "Sync methods:"
        echo "  git       - Git-based synchronization (default)"
        echo "  cloud     - Cloud storage synchronization"
        echo "  hybrid    - Both Git and cloud synchronization"
        echo
        echo "Cloud providers:"
        echo "  dropbox     - Dropbox folder sync"
        echo "  onedrive    - OneDrive folder sync"
        echo "  google-drive - Google Drive folder sync"
        echo "  custom      - Custom path sync"
        exit 0
        ;;
    --version)
        echo "OpenCode Orchestration Sync v1.0.0"
        exit 0
        ;;
    --push-only)
        check_sync_repo
        push_changes
        exit 0
        ;;
    --pull-only)
        check_sync_repo
        check_opencode_config
        load_sync_config
        pull_changes
        sync_commands
        sync_agents
        sync_config
        restart_opencode
        exit 0
        ;;
    --cloud-only)
        check_opencode_config
        load_sync_config
        if [[ "${2:-}" != "--no-backup" ]]; then
            create_backup
        fi
        pull_cloud
        sync_commands
        sync_agents
        sync_config
        sync_cloud
        restart_opencode
        exit 0
        ;;
    --method)
        export SYNC_METHOD="$2"
        main "$@"
        ;;
    *)
        main "$@"
        ;;
esac