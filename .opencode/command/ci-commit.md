---
description: Create git commits for session changes with clear, atomic messages (CI workflow)
permissions:
  edit: deny
  bash: allow
---

# CI Commit Changes

You are tasked with creating git commits for the changes made during this session using an automated CI workflow.

## Initial Setup

When this command is invoked:

1. **Always respond with initial guidance**:
   ```
   I'll help you create git commits for the changes made during this session using the CI workflow.

   I'll review the current changes, plan appropriate commits, and execute them automatically without asking for confirmation.

   Let me check the current git status first.
   ```

2. **Check current status**:
   - Use `/git status` to see current changes
   - Use `/git diff` to understand the modifications
   - Plan commits automatically without user confirmation

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

3. **Execute automatically:**
   - Use `git add` with specific files (never use `-A` or `.`)
   - Never commit temporary files, test scripts, or generated files that weren't part of the actual changes
   - Create commits with your planned messages until all changes are committed
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
- **CI Workflow**: Do not stop and ask for user feedback - execute automatically

## Remember:
- You have the full context of what was done in this session
- Group related changes together
- Keep commits focused and atomic when possible
- The user trusts your judgment - this is an automated CI workflow
- **IMPORTANT**: Execute commits automatically without asking for confirmation

## Success Criteria

### Automated Verification:
- [ ] Git status shows changes are committed
- [ ] No uncommitted changes remain
- [ ] Git log shows new commits with proper messages
- [ ] No temporary or generated files were committed

### Manual Verification:
- [ ] Commit messages are clear and descriptive
- [ ] Changes are logically grouped
- [ ] No unintended files were committed
- [ ] Workflow executed automatically without user prompts