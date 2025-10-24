---
description: Create handoff document for transferring work between OpenCode sessions
agent: plan
permissions:
  edit: allow
  bash: allow
---

# Create Handoff

You are tasked with creating a handoff document to transfer work between OpenCode sessions. This leverages OpenCode's session export/import capabilities for seamless context preservation.

## Process

### 1. Generate Handoff Metadata

When invoked without parameters:

1. **Auto-detect context**:
   - Current git branch and commit hash
   - Active session name and configuration
   - Recent file changes in session
   - Current todo list status

2. **Generate handoff ID**:

   ```bash
   HANDOFF_ID="$(date +%Y-%m-%d_%H-%M-%S)"
   if [[ -n "$TICKET" ]]; then
       HANDOFF_ID="${HANDOFF_ID}_${TICKET}"
   fi
   HANDOFF_ID="${HANDOFF_ID}_$(git rev-parse --abbrev-ref HEAD | sed 's/[^a-zA-Z0-9]/-/g')"
   ```

3. **Create handoff directory**:
   ```bash
   HANDOFF_DIR="~/.opencode/handoffs/${TICKET:-general}"
   mkdir -p "$HANDOFF_DIR"
   HANDOFF_FILE="$HANDOFF_DIR/${HANDOFF_ID}.md"
   ```

### 2. Export Session State

```bash
# Export current session configuration
opencode session export > ~/.opencode/sessions/current/session-state.json

# Export workspace changes
git diff --name-only > ~/.opencode/sessions/current/changed-files.txt

# Export todo list
opencode todo export > ~/.opencode/sessions/current/todos.json

# Capture recent command history
opencode history --last 50 > ~/.opencode/sessions/current/recent-commands.txt
```

### 3. Generate Handoff Document

Use this template structure:

```markdown
---
date: $(date -Iseconds)
session: $(opencode session current --name)
git_commit: $(git rev-parse HEAD)
branch: $(git rev-parse --abbrev-ref HEAD)
repository: $(git remote get-url origin 2>/dev/null || echo "local")
topic: "Session Handoff: [Brief Description]"
tags: [handoff, session-transfer, $(git rev-parse --abbrev-ref HEAD)]
status: complete
last_updated: $(date +%Y-%m-%d)
last_updated_by: $(opencode session current --user)
type: session_handoff
session_id: $(opencode session current --id)
handoff_id: ${HANDOFF_ID}
---

# Handoff: ${HANDOFF_ID}

## Session Context

**Session Name**: $(opencode session current --name)  
**Session Purpose**: [Purpose from session config]  
**Active Duration**: [Time since session start]  
**Environment**: [dev/stable/custom]

## Current Tasks

[Extract from current todo list with statuses]

## Session State

### Workspace Changes

[Files modified in current session with git status]

### Configuration Changes

[Session-specific config modifications]

### Tools and Dependencies

[Tools installed or configured in session]

## Critical Context

### Key Files Referenced

[List of frequently accessed files in session]

### Environment Variables

[Session-specific environment variables]

### Active Processes

[Background processes started in session]

## Learnings & Discoveries

[Key insights gained during session]

## Session Artifacts

### Generated Files

[Files created during session]

### Command History

[Recent relevant commands]

### Browser Tabs/References

[External resources referenced]

## Next Session Setup

### Required Environment

[Specific setup needed for next session]

### Dependencies to Install

[Tools/packages needed]

### Session Configuration

[Recommended session settings]

## Action Items for Next Agent

[Clear list of what to continue with]

## Session Export Data

### Session State

\`\`\`json
$(cat ~/.opencode/sessions/current/session-state.json)
\`\`\`

### Todo List

\`\`\`json
$(cat ~/.opencode/sessions/current/todos.json)
\`\`\`

### Changed Files

\`\`\`
$(cat ~/.opencode/sessions/current/changed-files.txt)
\`\`\`
```

### 4. Create Session Package

```bash
# Create handoff package
HANDOFF_PACKAGE="$HANDOFF_DIR/${HANDOFF_ID}.tar.gz"
tar -czf "$HANDOFF_PACKAGE" \
    ~/.opencode/sessions/current/ \
    "$HANDOFF_FILE"

# Generate import script
cat > "$HANDOFF_DIR/import-${HANDOFF_ID}.sh" << EOF
#!/bin/bash
# Import handoff ${HANDOFF_ID}
set -euo pipefail

HANDOFF_PACKAGE="$HANDOFF_PACKAGE"
SESSION_NAME="resume-$(date +%Y%m%d-%H%M%S)"

# Create new session from handoff
opencode session create "$SESSION_NAME" --from-package "$HANDOFF_PACKAGE"

echo "Handoff imported! Resume with:"
echo "opencode session switch $SESSION_NAME"
echo "opencode resume ${HANDOFF_FILE}"
EOF

chmod +x "$HANDOFF_DIR/import-${HANDOFF_ID}.sh"
```

### 5. Sync and Share

```bash
# Sync handoff to cloud storage if configured
if [[ -f ~/.opencode/config/sync.json ]]; then
    opencode sync push "$HANDOFF_DIR"
fi

# Generate sharing link
SHARE_LINK=$(opencode share create --handoff "$HANDOFF_FILE")
```

## OpenCode-Specific Features

### Session Export/Import

- **Complete state preservation**: All session context captured
- **Cross-machine compatibility**: Handoffs work between different computers
- **Version control integration**: Git state preserved with session
- **Incremental exports**: Only capture changes since last handoff

### Metadata Preservation

- **Session configuration**: All settings and preferences maintained
- **Tool states**: Editor positions, open tabs, command history
- **Environment context**: Variables, paths, active processes
- **User preferences**: Personalized settings per session

### Smart Resumption

- **Dependency detection**: Automatically install missing tools
- **File synchronization**: Restore workspace to exact state
- **Process restoration**: Restart background services if needed
- **Context validation**: Verify handoff integrity before import

## Error Handling

### Session Export Failures

- Check for sufficient disk space
- Validate session directory permissions
- Handle locked files gracefully
- Provide partial export options

### Package Creation Issues

- Verify tar/gz availability
- Handle large file compression
- Check for path length limits
- Provide split-package options for very large sessions

### Sync Failures

- Validate network connectivity
- Handle authentication errors
- Provide offline fallback options
- Queue sync for later retry

## Example Usage

```bash
# Create handoff from current session
opencode handoff

# Output:
# Handoff created: 2025-01-24_14-30-15_ENG-2166_feature-implementation.md
# Session exported to: ~/.opencode/handoffs/ENG-2166/2025-01-24_14-30-15_ENG-2166_feature-implementation.tar.gz
# Import script: ~/.opencode/handoffs/ENG-2166/import-2025-01-24_14-30-15_ENG-2166_feature-implementation.sh
# Share link: https://opencode.ai/handoff/abc123
```

## Advanced Features

### Automatic Handoffs

- Configure periodic handoffs for long-running sessions
- Auto-handoff on session timeout or crash
- Integration with CI/CD for build session handoffs

### Handoff Templates

- Pre-defined handoff structures for different workflows
- Custom metadata fields for specific use cases
- Integration with external systems (Jira, GitHub, etc.)

### Handoff Analytics

- Track handoff frequency and success rates
- Identify common session patterns
- Optimize session configurations based on usage

## Configuration

Handoff behavior configured in `~/.opencode/config/handoff.json`:

```json
{
  "auto_export": true,
  "include_history": 50,
  "compress_threshold": "100MB",
  "sync_enabled": true,
  "retention_days": 30,
  "templates": {
    "feature": { "include_tests": true, "include_docs": false },
    "bugfix": { "include_logs": true, "include_history": 100 },
    "research": { "include_browser": true, "include_notes": true }
  }
}
```
