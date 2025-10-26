---
description: Create git commits with user approval and no Claude attribution
permissions:
  edit: deny
  bash: allow
---

# Commit Changes

You are tasked with creating git commits for the changes made during this session.

## Initial Setup

When this command is invoked:

1. **Always respond with initial guidance**:
   ```
   I'll help you create git commits for the changes made during this session.

   I'll review the current changes, plan appropriate commits, and ask for your approval before proceeding.

   Let me check the current git status first.
   ```

2. **Check current status**:
   - Use `/git status` to see current changes
   - Use `/git diff` to understand the modifications
   - Consider whether changes should be one commit or multiple logical commits

## Process:

1. **Think about what changed:**
   - Review the conversation history and understand what was accomplished
   - Use `/git status` to see current changes
   - Use `/git diff` to understand the modifications
   - Consider whether changes should be one commit or multiple logical commits

2. **Plan your commit(s):**
   - Identify which files belong together
   - Draft clear, descriptive commit messages
   - Use imperative mood in commit messages
   - Focus on why the changes were made, not just what

3. **Present your plan to the user:**
   - List the files you plan to add for each commit
   - Show the commit message(s) you'll use
   - Ask: "I plan to create [N] commit(s) with these changes. Shall I proceed?"

4. **Execute upon confirmation:**
   - Use `git add` with specific files (never use `-A` or `.`)
   - Create commits with your planned messages
   - Show the result with `git log --oneline -n [number]`

## OpenCode-Specific Features

### Git Integration
- Use `/git status` to check current changes
- Use `/git diff` to review modifications
- Use `/git log` to show commit history
- Changes are automatically staged when appropriate

## Important:
- **NEVER add co-author information or Claude attribution**
- Commits should be authored solely by the user
- Do not include any "Generated with Claude" messages
- Do not add "Co-Authored-By" lines
- Write commit messages as if the user wrote them

## Remember:
- You have the full context of what was done in this session
- Group related changes together
- Keep commits focused and atomic when possible
- The user trusts your judgment - they asked you to commit

## Success Criteria

### Automated Verification:
- [ ] Git status shows changes are committed
- [ ] No uncommitted changes remain
- [ ] Git log shows new commits with proper messages

### Manual Verification:
- [ ] Commit messages are clear and descriptive
- [ ] Changes are logically grouped
- [ ] No unintended files were committed