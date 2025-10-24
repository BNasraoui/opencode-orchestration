---
description: Resume work from handoff document with session restoration
agent: build
permissions:
  edit: allow
  bash: allow
---

# Resume from Handoff

You are tasked with resuming work from a handoff document using OpenCode's session import and restoration capabilities.

## Initial Response

When this command is invoked:

### 1. If handoff path provided

- Skip default message
- Immediately read handoff document completely
- Begin session restoration process
- Validate handoff integrity

### 2. If ticket number provided (like ENG-XXXX)

```bash
# Sync handoffs to ensure latest
opencode sync pull

# Find most recent handoff for ticket
HANDOFF_DIR="~/.opencode/handoffs/$TICKET"
if [[ -d "$HANDOFF_DIR" ]]; then
    LATEST_HANDOFF=$(ls -t "$HANDOFF_DIR"/*.md | head -1)
    echo "Found latest handoff: $LATEST_HANDOFF"
else
    echo "No handoffs found for ticket $TICKET"
    return 1
fi
```

### 3. If no parameters provided

```
I'll help you resume work from a handoff document. Let me find the available handoffs.

Which handoff would you like to resume from?

Tip: You can invoke this command directly with:
- A handoff path: /resume path/to/handoff.md
- A ticket number: /resume ENG-XXXX
- A session package: /resume --from-package path/to/package.tar.gz
```

## Session Restoration Process

### Step 1: Validate Handoff

```bash
# Read handoff metadata
HANDOFF_META=$(grep -A 20 "^---" "$HANDOFF_FILE" | grep -v "^---")

# Validate handoff integrity
if ! opencode handoff validate "$HANDOFF_FILE"; then
    echo "Handoff validation failed. Continue anyway? (y/N)"
    read -r response
    if [[ "$response" != "y" ]]; then
        return 1
    fi
fi

# Check for session package
HANDOFF_PACKAGE="${HANDOFF_FILE%.md}.tar.gz"
if [[ -f "$HANDOFF_PACKAGE" ]]; then
    echo "Session package found: $HANDOFF_PACKAGE"
else
    echo "No session package found. Will create new session from handoff metadata."
fi
```

### Step 2: Create New Session

```bash
# Generate session name
SESSION_NAME="resume-$(date +%Y%m%d-%H%M%S)"
if [[ -n "$TICKET" ]]; then
    SESSION_NAME="$SESSION_NAME-$TICKET"
fi

# Create session from package if available
if [[ -f "$HANDOFF_PACKAGE" ]]; then
    echo "Restoring session from package..."
    opencode session create "$SESSION_NAME" --from-package "$HANDOFF_PACKAGE"
else
    echo "Creating new session from handoff..."
    opencode session create "$SESSION_NAME"
fi

# Switch to new session
opencode session switch "$SESSION_NAME"
```

### Step 3: Restore Workspace State

```bash
# Extract workspace changes from handoff
if grep -q "### Workspace Changes" "$HANDOFF_FILE"; then
    echo "Restoring workspace changes..."

    # Apply git state if specified
    if grep -q "git_commit:" "$HANDOFF_FILE"; then
        COMMIT=$(grep "git_commit:" "$HANDOFF_FILE" | cut -d' ' -f2)
        echo "Checking out commit: $COMMIT"
        git checkout "$COMMIT"
    fi

    # Apply uncommitted changes if documented
    if grep -q "changed-files.txt" "$HANDOFF_FILE"; then
        echo "Found changed files list, applying patches..."
        # Logic to apply patches from handoff
    fi
fi

# Restore session configuration
if grep -q "session_id:" "$HANDOFF_FILE"; then
    ORIGINAL_SESSION=$(grep "session_id:" "$HANDOFF_FILE" | cut -d' ' -f2)
    echo "Restoring configuration from session: $ORIGINAL_SESSION"

    # Apply session-specific settings
    if [[ -f "$HANDOFF_PACKAGE" ]]; then
        tar -xzf "$HANDOFF_PACKAGE" -C ~/.opencode/sessions/ "$SESSION_NAME/config.json"
    fi
fi
```

### Step 4: Restore Todo List

```bash
# Extract todos from handoff
if grep -q "## Current Tasks" "$HANDOFF_FILE"; then
    echo "Restoring task list..."

    # Parse tasks from handoff and create todo list
    opencode todo import --from-handoff "$HANDOFF_FILE"
fi

# Import todo JSON if available from session package
if [[ -f "$HANDOFF_PACKAGE" ]]; then
    tar -xzf "$HANDOFF_PACKAGE" -C /tmp/ "todos.json" 2>/dev/null || true
    if [[ -f "/tmp/todos.json" ]]; then
        opencode todo import /tmp/todos.json
        rm /tmp/todos.json
    fi
fi
```

### Step 5: Restore Environment

```bash
# Install dependencies if documented
if grep -q "### Dependencies to Install" "$HANDOFF_FILE"; then
    echo "Installing dependencies..."

    # Parse and install dependencies
    # This would be specific to the handoff content
fi

# Restore environment variables
if grep -q "### Environment Variables" "$HANDOFF_FILE"; then
    echo "Setting up environment variables..."

    # Export variables from handoff
    eval "$(grep -A 10 "### Environment Variables" "$HANDOFF_FILE" | grep 'export')"
fi

# Restart background processes if documented
if grep -q "### Active Processes" "$HANDOFF_FILE"; then
    echo "Restoring background processes..."

    # Restart processes based on handoff documentation
fi
```

### Step 6: Present Analysis

```
I've successfully restored the session from handoff [date] by [original_user].

**Session Restored:**
- Session name: $SESSION_NAME
- Original session: [session_id from handoff]
- Git commit: [commit_hash from handoff]
- Branch: [branch from handoff]

**Tasks Restored:**
- [List of tasks with statuses from handoff]

**Workspace State:**
- Git checkout: [commit_hash] ✓
- Uncommitted changes: [status] ✓
- Configuration: [status] ✓

**Environment:**
- Dependencies: [status] ✓
- Environment variables: [count] set ✓
- Background processes: [count] restored ✓

**Ready to Continue:**
Based on the handoff's action items, the next logical step is:
1. [Most important next step from handoff]

Would you like me to proceed with this step, or would you prefer to review the restored state first?
```

## Advanced Restoration Features

### Smart Conflict Resolution

```bash
# Check for conflicts between handoff and current state
if git status --porcelain | grep -q .; then
    echo "Warning: Current workspace has uncommitted changes."
    echo "Options:"
    echo "1. Stash changes and restore handoff"
    echo "2. Merge handoff changes with current state"
    echo "3. Cancel restoration"

    read -r choice
    case $choice in
        1) git stash ;;
        2) # Merge logic ;;
        3) return 1 ;;
    esac
fi
```

### Incremental Restoration

```bash
# For large handoffs, restore in stages
RESTORE_STAGES=("workspace" "configuration" "dependencies" "processes")

for stage in "${RESTORE_STAGES[@]}"; do
    echo "Restoring $stage..."
    # Stage-specific restoration logic

    echo "Stage $stage complete. Continue to next stage? (Y/n)"
    read -r response
    if [[ "$response" == "n" ]]; then
        break
    fi
done
```

### Validation and Verification

```bash
# Verify restoration success
validate_restoration() {
    local errors=0

    # Check git state
    if ! git rev-parse --verify HEAD >/dev/null; then
        echo "ERROR: Git state invalid"
        ((errors++))
    fi

    # Check session configuration
    if [[ ! -f ~/.opencode/sessions/"$SESSION_NAME"/config.json ]]; then
        echo "ERROR: Session configuration missing"
        ((errors++))
    fi

    # Check critical files from handoff
    if grep -q "### Key Files Referenced" "$HANDOFF_FILE"; then
        # Verify referenced files exist
        # Add validation logic
    fi

    return $errors
}
```

## Error Handling

### Handoff Corruption

- Detect malformed handoff files
- Offer partial restoration options
- Provide recovery from backup handoffs

### Session Creation Failures

- Insufficient permissions
- Session name conflicts
- Resource constraints

### Workspace Restoration Issues

- Git repository problems
- File permission conflicts
- Disk space limitations

### Dependency Installation Failures

- Missing package managers
- Network connectivity issues
- Version conflicts

## Example Usage

```bash
# Resume from specific handoff
opencode resume ~/.opencode/handoffs/ENG-2166/2025-01-24_14-30-15_ENG-2166_feature-implementation.md

# Resume from latest handoff for ticket
opencode resume ENG-2166

# Resume from session package directly
opencode resume --from-package ~/.opencode/handoffs/ENG-2166/2025-01-24_14-30-15_ENG-2166_feature-implementation.tar.gz
```

## Integration with OpenCode Features

### Session History

- All restoration actions logged to session history
- Ability to undo restoration if needed
- Track multiple restoration attempts

### Collaboration

- Share restored sessions with collaborators
- Real-time synchronization during restoration
- Conflict resolution for multi-user scenarios

### Analytics

- Track restoration success rates
- Identify common failure patterns
- Optimize handoff creation based on restoration data

## Configuration

Resume behavior configured in `~/.opencode/config/resume.json`:

```json
{
  "auto_validate": true,
  "conflict_resolution": "ask",
  "restore_stages": ["workspace", "config", "dependencies"],
  "backup_before_restore": true,
  "max_restore_attempts": 3,
  "timeout_seconds": 300
}
```
