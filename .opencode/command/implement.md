---
description: Implement technical plans from thoughts/shared/plans with verification
agent: build
permissions:
  edit: allow
  bash: allow
---

# Implement Plan

You are tasked with implementing an approved technical plan from `thoughts/shared/plans/`. These plans contain phases with specific changes and success criteria.

## Getting Started

When given a plan path:

- Read the plan completely and check for any existing checkmarks (- [x])
- Read the original ticket and all files mentioned in the plan
- **Read files fully** - never use limit/offset parameters, you need complete context
- Think deeply about how the pieces fit together
- Create a todo list to track your progress
- Start implementing if you understand what needs to be done

If no plan path provided, ask for one.

## Implementation Philosophy

Plans are carefully designed, but reality can be messy. Your job is to:

- Follow the plan's intent while adapting to what you find
- Implement each phase fully before moving to the next
- Verify your work makes sense in the broader codebase context
- Update checkboxes in the plan as you complete sections
- Use OpenCode's built-in undo/redo system (`/undo` and `/redo`) for change management

When things don't match the plan exactly, think about why and communicate clearly. The plan is your guide, but your judgment matters too.

If you encounter a mismatch:

- STOP and think deeply about why the plan can't be followed
- Present the issue clearly:

  ```
  Issue in Phase [N]:
  Expected: [what the plan says]
  Found: [actual situation]
  Why this matters: [explanation]

  How should I proceed?
  ```

## Verification Approach

After implementing a phase:

- Run the success criteria checks (usually `make check test` covers everything)
- Fix any issues before proceeding
- Update your progress in both the plan and your todos
- Check off completed items in the plan file itself using Edit
- **Pause for human verification**: After completing all automated verification for a phase, pause and inform the human that the phase is ready for manual testing. Use this format:

  ```
  Phase [N] Complete - Ready for Manual Verification

  Automated verification passed:
  - [List automated checks that passed]

  Please perform the manual verification steps listed in the plan:
  - [List manual verification items from the plan]

  Let me know when manual testing is complete so I can proceed to Phase [N+1].
  ```

If instructed to execute multiple phases consecutively, skip the pause until the last phase. Otherwise, assume you are just doing one phase.

do not check off items in the manual testing steps until confirmed by the user.

## OpenCode-Specific Features

### Change Management

- Use `/undo` to revert changes if something goes wrong
- Use `/redo` to reapply changes after an undo
- OpenCode automatically tracks all changes, no need for manual change tracking

### Git Integration

- Changes are automatically staged when appropriate
- Use `/git status` to see what will be committed
- Use `/git diff` to review changes before committing

### File References

- Use `@filename` to include file contents in your prompts
- Use `!command` to execute shell commands and include results

## If You Get Stuck

When something isn't working as expected:

- First, make sure you've read and understood all the relevant code
- Consider if the codebase has evolved since the plan was written
- Present the mismatch clearly and ask for guidance
- Use `/undo` to revert problematic changes if needed

Use sub-tasks sparingly - mainly for targeted debugging or exploring unfamiliar territory.

## Resuming Work

If the plan has existing checkmarks:

- Trust that completed work is done
- Pick up from the first unchecked item
- Verify previous work only if something seems off

Remember: You're implementing a solution, not just checking boxes. Keep the end goal in mind and maintain forward momentum.

## Working with OpenCode's Permission System

As the Build agent with full permissions:

- You can edit any file and run any command
- Use this power responsibly and follow the plan
- If the plan specifies certain restrictions, honor them
- Always test changes before moving to the next phase

## Best Practices

1. **Read First, Implement Second**: Always read all referenced files completely before making changes
2. **Test Incrementally**: Run tests after each significant change, not just at the end of phases
3. **Communicate Clearly**: When deviating from the plan, explain why
4. **Use OpenCode Features**: Leverage `@` file references, `!` commands, and `/undo`/`/redo`
5. **Maintain Context**: Keep relevant files open in tabs for easy reference
6. **Document Decisions**: If you make implementation choices not specified in the plan, note them

## Example Workflow

```
User: @implement thoughts/shared/plans/2025-01-08-feature-x.md

Assistant: [Reads plan and all referenced files]

I'll implement this plan phase by phase. Let me start with Phase 1.

[Creates todo list]

Phase 1: Database Schema Changes
- [ ] Create migration file
- [ ] Update model definitions
- [ ] Run migration tests

[Implements changes, running tests as needed]

Automated verification passed:
- ✓ make migrate
- ✓ make test-db

Phase 1 Complete - Ready for Manual Verification

Please perform the manual verification steps listed in the plan:
- [ ] Verify new tables exist in database
- [ ] Check schema matches documentation

Let me know when manual testing is complete so I can proceed to Phase 2.
```
