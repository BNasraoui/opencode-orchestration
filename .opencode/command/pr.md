---
description: Generate comprehensive PR descriptions following repository templates
agent: plan
permissions:
  edit: allow
  bash: allow
---

# Generate PR Description

You are tasked with generating a comprehensive pull request description following repository's standard template using OpenCode's enhanced workflow capabilities.

## Initial Setup

When this command is invoked:

1. **Identify PR to describe**:
   - Check if current branch has an associated PR: `!gh pr view --json url,number,title,state 2>/dev/null`
   - If no PR exists for current branch, list open PRs: `!gh pr list --limit 10 --json number,title,headRefName,author`
   - Ask user which PR they want to describe
   - If on main/master, ask user to switch to feature branch or specify PR number

2. **Check for existing description**:
   - Check if `docs/shared/prs/{number}_description.md` already exists
   - If it exists, read it and inform user you'll be updating it
   - Consider what has changed since the last description was written

## Process Steps

### Step 1: Template Discovery

1. **Read PR description template**:
   - First, check if `docs/pr_description.md` exists
   - If it doesn't exist, inform the user that their setup is incomplete
   - If no template exists, create a basic template structure
   - Read template carefully to understand all sections and requirements

2. **Adapt template for OpenCode**:
   - Update any Claude Code-specific references
   - Include OpenCode-specific verification steps
   - Add sections for OpenCode features used

### Step 2: PR Information Gathering

1. **Gather comprehensive PR information** using OpenCode's git integration:
   - Get full PR diff: `!gh pr diff {number}`
   - Get commit history: `!gh pr view {number} --json commits`
   - Review base branch: `!gh pr view {number} --json baseRefName`
   - Get PR metadata: `!gh pr view {number} --json url,title,number,state`
   - Get git context: `!git log --oneline -n 10`

2. **Analyze changes thoroughly**:
   - Read through the entire diff carefully
   - Use `@filename` to include relevant files for context
   - Understand the purpose and impact of each change
   - Identify user-facing changes vs internal implementation details
   - Look for breaking changes or migration requirements

### Step 3: Verification Execution

1. **Handle verification requirements**:
   - Look for any checklist items in the "How to verify it" section of the template
   - For each verification step:
     - If it's a command you can run (like `make check test`, `npm test`, etc.), run it using `!command`
     - If it passes, mark the checkbox as checked: `- [x]`
     - If it fails, keep it unchecked and note what failed: `- [ ]` with explanation
     - If it requires manual testing (UI interactions, external services), leave unchecked and note for user
   - Document any verification steps you couldn't complete

2. **Use OpenCode's testing capabilities**:
   - Run `@validate` command for comprehensive verification
   - Include validation results in PR description
   - Document any issues found and how they were resolved

### Step 4: Description Generation

1. **Generate comprehensive description**:
   - Fill out each section from the template thoroughly:
     - Answer each question/section based on your analysis
     - Be specific about problems solved and changes made
     - Focus on user impact where relevant
     - Include technical details in appropriate sections
     - Write a concise changelog entry
   - Ensure all checklist items are addressed (checked or explained)
   - Include OpenCode-specific enhancements and features used

2. **Include OpenCode integration notes**:
   - Document any OpenCode-specific features used in development
   - Note any multi-provider optimizations implemented
   - Include permission system configurations if relevant
   - Reference any custom commands or agents created

### Step 5: Documentation & Sync

1. **Save and sync description**:
   - Write the completed description to `docs/shared/prs/{number}_description.md`
   - If thoughts sync is available, run appropriate sync command
   - Show the user the generated description

2. **Update PR directly**:
   - Update PR description: `!gh pr edit {number} --body-file docs/shared/prs/{number}_description.md`
   - Confirm the update was successful
   - If any verification steps remain unchecked, remind the user to complete them before merging

## OpenCode-Specific Enhancements

### Git Integration

- Use `!git diff` to analyze changes comprehensively
- Leverage `!git log` to understand commit history
- Include specific commit references in description
- Use `/git status` to verify working directory state

### File Reference System

- Use `@filename` to include relevant files in analysis
- Reference specific file:line numbers in description
- Include code snippets directly in PR description
- Link to relevant documentation or plans

### Multi-Provider Support

- Document if implementation uses multiple AI providers
- Include any provider-specific optimizations
- Note any model selection strategies used
- Reference any cost optimization implemented

### Permission System

- Document any permission configurations used
- Include safety measures implemented
- Note any approval workflows created
- Reference any access controls added

## Success Criteria

### Automated Verification:

- [ ] PR information gathered successfully
- [ ] Template read and understood
- [ ] All automated verification steps executed
- [ ] Description file created successfully
- [ ] PR updated with new description
- [ ] All git commands executed without errors

### Manual Verification:

- [ ] Description accurately reflects changes made
- [ ] Technical details are correct and complete
- [ ] User impact is clearly explained
- [ ] Verification steps are appropriate and comprehensive
- [ ] PR formatting follows repository standards

## Error Handling

### If PR Access Fails:

- Check GitHub CLI authentication: `!gh auth status`
- Instruct user to run `gh auth login` if needed
- Check if repository has default set: `!gh repo set-default`
- Provide alternative manual PR update instructions

### If Template Missing:

- Create a basic template structure
- Inform user about missing template
- Offer to create a comprehensive template
- Proceed with basic description structure

### If Verification Fails:

- Document all failures clearly
- Provide specific error messages
- Suggest fixes for verification issues
- Offer to re-run verification after fixes

## Example Workflow

```
User: @pr

Assistant: I'll generate a comprehensive PR description for your current branch.

[Checks for PR, finds #1234]

Found PR #1234: "Add user authentication system"

[Reads template, gathers PR info, runs verification]

Generated comprehensive PR description at:
`docs/shared/prs/1234_description.md`

✓ Automated verification passed:
- [x] All tests pass: make test
- [x] Build succeeds: make build
- [ ] UI testing: requires manual verification

PR updated successfully! Please complete manual verification:
- [ ] Test login flow in browser
- [ ] Verify error handling
- [ ] Check mobile responsiveness

Link to PR: https://github.com/repo/pull/1234
```

## Template Structure

If no template exists, use this OpenCode-enhanced structure:

```markdown
# [PR Title]

## Summary

[Brief description of what this PR accomplishes]

## Problem Solved

[What issue or requirement this addresses]

## Solution

[How the problem was solved]

## Changes Made

### Database Changes

- [List any schema or data changes]

### API Changes

- [List any endpoint or logic changes]

### Frontend Changes

- [List any UI or UX changes]

### OpenCode Enhancements

- [Any OpenCode-specific features used]

## Verification

### Automated

- [x] Tests pass: `make test`
- [x] Build succeeds: `make build`
- [x] Linting passes: `make lint`

### Manual

- [ ] Feature works as expected in UI
- [ ] Performance is acceptable
- [ ] Error handling verified

## Breaking Changes

[Any breaking changes or migration requirements]

## Related Issues

- [Links to related tickets or issues]

## Notes

[Additional context or considerations]
```

## Notes

- Integrates with OpenCode's git and file reference systems
- Provides comprehensive verification using OpenCode's testing capabilities
- Supports repository-specific templates while providing OpenCode enhancements
- Enables seamless PR workflow from development to merge
- Includes OpenCode-specific features and optimizations in descriptions
