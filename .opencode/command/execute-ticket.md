---
description: Execute end-to-end implementation for a ticket from planning to completion
agent: build
permissions:
  edit: allow
  bash: allow
---

# Execute Ticket

You are tasked with executing a complete end-to-end implementation workflow for a ticket, from planning through implementation and verification.

## Initial Setup

When this command is invoked:

1. **Check if parameters were provided**:
   - If a ticket number, plan path, or feature description was provided, begin execution
   - If no parameters provided, respond with:

```
I'll help you execute a complete implementation workflow. Please provide:
1. A ticket number (e.g., ENG-1234)
2. A path to an existing implementation plan
3. A feature description for end-to-end execution

Example usage:
- @execute-ticket ENG-1478
- @execute-ticket thoughts/shared/plans/2025-01-08-ENG-1478-feature.md
- @execute-ticket "implement user authentication system"
```

## Process Steps

### Step 1: Planning Phase

1. **If no plan exists**, create one first:
   - Run `@research-plan` to research the ticket/topic
   - Wait for plan creation and user approval
   - Proceed only after plan is approved

2. **If plan exists**, read and verify it:
   - Read the complete implementation plan
   - Check for existing completion checkmarks
   - Identify which phases need to be executed

### Step 2: Implementation Execution

1. **Execute plan phase by phase**:
   - Use `@implement` command to execute each phase
   - Follow OpenCode's implementation methodology
   - Update checkboxes in plan as phases complete
   - Run automated verification after each phase

2. **Handle implementation issues**:
   - If plan doesn't match reality, adapt as needed
   - Communicate deviations clearly to user
   - Update plan to reflect actual implementation
   - Use `/undo` if needed and retry approaches

3. **Progress tracking**:
   - Create todo list to track implementation progress
   - Update todos as phases complete
   - Provide clear status updates between phases

### Step 3: Verification & Completion

1. **Run final verification**:
   - Execute all automated verification criteria
   - Present manual verification steps to user
   - Wait for user confirmation of manual testing

2. **Generate completion report**:

   ```
   ## Implementation Complete: [Ticket/Feature]

   ### Phases Executed:
   ✓ Phase 1: [Name] - Completed successfully
   ✓ Phase 2: [Name] - Completed with adaptations
   ✓ Phase 3: [Name] - Completed successfully

   ### Automated Verification:
   ✓ All tests pass: `make test`
   ✓ Build succeeds: `make build`
   ✓ No linting errors: `make lint`

   ### Manual Verification Required:
   - [ ] Feature works as expected in UI
   - [ ] Performance acceptable under load
   - [ ] Error handling verified

   ### Changes Made:
   - Files modified: [list]
   - New files created: [list]
   - Tests added: [list]

   Ready for PR creation and merge.
   ```

3. **Offer next steps**:
   - Generate PR description using `@pr`
   - Create commit with changes
   - Deploy if applicable

## OpenCode-Specific Features

### Git Integration

- Use `/git status` and `/git diff` to track changes
- Leverage `/undo` and `/redo` for change management
- Create atomic commits for each phase
- Generate meaningful commit messages

### Session Management

- Create parent session for overall execution
- Spawn child sessions for complex phases
- Use `/sessions` to navigate between phases
- Enable easy rollback to any phase

### Multi-Provider Optimization

- Use appropriate models for different tasks:
  - Planning: Use model with strong reasoning
  - Implementation: Use fast, efficient model
  - Verification: Use model with attention to detail

### Permission System

- Leverage OpenCode's permission system for safety
- Use `ask` permissions for potentially dangerous operations
- Create read-only sessions for verification
- Implement approval workflows for critical changes

## Error Handling

### Planning Phase Errors:

- If research fails, offer alternative approaches
- If plan creation fails, request more specific requirements
- If plan is rejected, iterate based on feedback

### Implementation Phase Errors:

- If code doesn't compile, use `/undo` and fix approach
- If tests fail, debug and fix issues before proceeding
- If plan is inaccurate, update plan and continue

### Verification Phase Errors:

- If automated tests fail, fix before completion
- If manual testing reveals issues, address immediately
- If performance is inadequate, optimize before finalizing

## Success Criteria

### Automated Verification:

- [ ] Implementation plan created or loaded successfully
- [ ] All phases executed according to plan
- [ ] All automated tests pass
- [ ] Code compiles and builds successfully
- [ ] No linting or type checking errors
- [ ] Git commits created with proper messages

### Manual Verification:

- [ ] Feature works as specified in requirements
- [ ] User interface is responsive and intuitive
- [ ] Error handling is robust and user-friendly
- [ ] Performance meets expectations
- [ ] No regressions in existing functionality

## Example Workflow

```
User: @execute-ticket ENG-1478

Assistant: I'll execute ENG-1478 end-to-end. Let me start by checking for an existing plan.

[Checks for plan, finds none]

I'll create a plan first using @research-plan:

[Runs @research-plan ENG-1478]

Plan created and approved. Now executing implementation:

Phase 1: Database Schema Changes
[Implements changes, runs tests]
✓ Phase 1 complete

Phase 2: API Implementation
[Implements changes, runs tests]
✓ Phase 2 complete

Phase 3: Frontend Integration
[Implements changes, runs tests]
✓ Phase 3 complete

All automated verification passed. Please perform manual testing:
- [ ] Feature works in UI
- [ ] Error handling verified

Implementation complete! Ready for PR creation.
```

## Integration with Other Commands

This command orchestrates multiple OpenCode commands:

- `@research-plan` for initial planning
- `@implement` for phase execution
- `@validate` for verification
- `@pr` for pull request creation

## Notes

- Provides complete end-to-end workflow automation
- Maintains full context throughout execution
- Adapts to reality while following plan intent
- Uses OpenCode's enhanced features for safety and efficiency
- Enables seamless progression from idea to production
