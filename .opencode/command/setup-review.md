---
description: Set up collaborative review environment using OpenCode sessions
agent: build
permissions:
  edit: allow
  bash: allow
---

# Collaborative Review Setup

You are tasked with setting up a collaborative review environment for a colleague's branch using OpenCode's session sharing capabilities.

## Process

When invoked with a parameter like `gh_username:branchName`:

### 1. Parse Input

- Extract GitHub username and branch name from format `username:branchname`
- If no parameter provided, ask for format: `gh_username:branchName`

### 2. Extract Ticket Information

- Look for ticket numbers in branch name (e.g., `eng-1696`, `ENG-1696`)
- Use to create session name
- If no ticket found, use sanitized branch name

### 3. Set Up Remote and Worktree

```bash
# Check if remote exists
if ! git remote | grep -q "$USERNAME"; then
    git remote add "$USERNAME" "git@github.com:$USERNAME/humanlayer"
fi

# Fetch from remote
git fetch "$USERNAME"

# Create worktree for review
SESSION_NAME="review-${TICKET:-$(echo $BRANCHNAME | sed 's/[^a-zA-Z0-9]/-/g')}"
git worktree add -b "$BRANCHNAME" "~/wt/humanlayer/$SESSION_NAME" "$USERNAME/$BRANCHNAME"
```

### 4. Configure OpenCode Session

```bash
# Create review session
mkdir -p ~/.opencode/sessions/$SESSION_NAME

# Configure session for collaboration
cat > ~/.opencode/sessions/$SESSION_NAME/config.json << EOF
{
  "session_name": "$SESSION_NAME",
  "purpose": "code_review",
  "branch": "$USERNAME/$BRANCHNAME",
  "ticket": "$TICKET",
  "collaboration": {
    "enabled": true,
    "auto_share": true,
    "review_mode": true
  },
  "permissions": {
    "edit": "ask",
    "bash": "allow"
  }
}
EOF

# Copy worktree to session workspace
cp -r ~/wt/humanlayer/$SESSION_NAME ~/.opencode/sessions/$SESSION_NAME/workspace/
```

### 5. Initialize Review Environment

```bash
# Set up dependencies in session workspace
cd ~/.opencode/sessions/$SESSION_NAME/workspace
make setup

# Create review-specific configuration
cat > ~/.opencode/sessions/$SESSION_NAME/review-config.json << EOF
{
  "review_focus": [
    "security",
    "performance",
    "code_style",
    "test_coverage"
  ],
  "auto_checks": [
    "lint",
    "typecheck",
    "unit_tests"
  ],
  "reviewer_tools": [
    "diff_viewer",
    "syntax_checker",
    "dependency_analyzer"
  ]
}
EOF
```

### 6. Enable Real-time Collaboration

```bash
# Start session with sharing enabled
opencode session start $SESSION_NAME --share

# Generate sharing link
SHARE_LINK=$(opencode session share $SESSION_NAME)

echo "Review session ready! Share this link with collaborators:"
echo "$SHARE_LINK"
```

## Session Sharing Features

### Real-time Collaboration

- **Live cursors**: See where collaborators are looking
- **Shared edits**: Multiple reviewers can suggest changes simultaneously
- **Comment system**: Line-by-line comments that persist across sessions
- **Voice chat**: Optional audio discussion for complex changes

### Environment Synchronization

- **Automatic sync**: Changes propagate to all participants in real-time
- **Conflict resolution**: Smart merging when multiple people edit same code
- **Version control**: All changes tracked with reviewer attribution
- **Rollback capability**: Easy reversion if review goes in wrong direction

### Review Tools Integration

- **Diff viewer**: Side-by-side comparison with original branch
- **Syntax highlighting**: Language-aware code display
- **Inline suggestions**: Proposed changes appear as suggestions
- **Approval workflow**: Built-in approval/rejection system

## Error Handling

### Worktree Conflicts

- If worktree exists, offer to remove and recreate
- Check for uncommitted changes before cleanup
- Provide option to switch to existing worktree

### Remote Issues

- Validate remote exists before fetching
- Handle authentication failures gracefully
- Provide clear instructions for SSH key setup

### Session Creation Failures

- Check for available disk space
- Validate session name doesn't conflict
- Provide recovery options for partial setups

## Example Usage

```bash
# Set up review for colleague's branch
opencode setup-review samdickson22:sam/eng-1696-hotkey-for-yolo-mode

# Output:
# Remote 'samdickson22' added successfully
# Worktree created at ~/wt/humanlayer/review-eng-1696
# Review session 'review-eng-1696' initialized
# Share link: https://opencode.ai/session/abc123
```

## Advanced Features

### Multi-branch Reviews

- Support for reviewing multiple related branches
- Automatic dependency detection between branches
- Unified review session for cross-branch changes

### Integration with Issue Trackers

- Automatic ticket status updates based on review progress
- Link review sessions to specific tickets
- Generate review summaries for ticket comments

### Review Analytics

- Track review time and participation
- Identify frequently changed files
- Generate review quality metrics

## Configuration Options

Review sessions can be customized via `~/.opencode/config/review.json`:

```json
{
  "default_checks": ["lint", "typecheck", "security"],
  "auto_approve_patterns": ["*test*", "*docs*"],
  "required_reviewers": 1,
  "timeout_hours": 24,
  "notification_settings": {
    "email": true,
    "slack": false
  }
}
```
