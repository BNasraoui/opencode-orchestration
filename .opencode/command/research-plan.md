---
description: Research and create implementation plan for a ticket or topic
agent: plan
permissions:
  edit: allow
  bash: allow
---

# Research & Plan

You are tasked with researching a ticket or topic and automatically creating a comprehensive implementation plan through OpenCode's enhanced workflow system.

## Initial Setup

When this command is invoked:

1. **Check for input parameters**:
   - OpenCode provides the input as `$ARGUMENTS` variable
   - If `$ARGUMENTS` is not empty or contains meaningful content, begin research immediately
   - If `$ARGUMENTS` is empty or just whitespace, respond with:

```
I'll help you research and create a comprehensive implementation plan. Please provide:
1. A ticket number (e.g., ENG-1234)
2. A topic or feature description
3. A path to a thoughts document or existing plan
4. Or any reference to what needs to be implemented

Example usage:
- @research-plan ENG-1478
- @research-plan "add user authentication"
- @research-plan research/auth-flow.md
```

2. **Parse the input**:
   - If input looks like a ticket number (e.g., ENG-1478, TICKET-123), treat as ticket reference
   - If input is a quoted string or sentence, treat as topic description
   - If input looks like a file path (contains / or .md), treat as file reference
   - If input is ambiguous, ask for clarification

## Process Steps

### Step 1: Context Discovery & Research

1. **Identify research target from `$ARGUMENTS`**:
   - If input looks like a ticket number (e.g., ENG-1478), search for related files
   - If input is a topic description (e.g., "add smileys to markdowns"), search codebase for relevant components
   - If input looks like a file path (contains / or .md), read it completely first
   - Use the parsed input to drive all subsequent research steps

2. **Spawn parallel research tasks** using OpenCode's subagent system:
   - Use **@locator** to find all files related to the ticket/topic
   - Use **@analyzer** to understand current implementation patterns
   - Use **@researcher** to find any existing research or plans
   - Use **@pattern-finder** to discover similar implementations

3. **Wait for all sub-tasks to complete** before proceeding

### Step 2: Analysis & Planning

1. **Synthesize research findings**:
   - Cross-reference information from all sub-tasks
   - Identify current state, gaps, and implementation requirements
   - Note any constraints or dependencies discovered

2. **Create implementation plan** using OpenCode's enhanced planning workflow:
   - Follow the same structure as the `@plan` command
   - Include specific phases with clear success criteria
   - Separate automated vs manual verification steps
   - Use OpenCode-specific features (undo/redo, git integration)

3. **Write plan to appropriate location**:
   - Format: `docs/plans/YYYY-MM-DD-ENG-XXXX-description.md`
   - Use today's date and ticket number if available
   - Include comprehensive research findings in the plan

### Step 3: Plan Presentation

1. **Present completed plan**:

   ```
   I've researched [topic/ticket] and created a comprehensive implementation plan at:
   `docs/plans/YYYY-MM-DD-ENG-XXXX-description.md`

   ## Research Summary:
   - [Key finding about current state]
   - [Pattern or constraint discovered]
   - [Implementation approach recommended]

   ## Plan Overview:
   - [Number of phases] phases covering [key areas]
   - Estimated complexity: [low/medium/high]
   - Key dependencies: [any external requirements]

   The plan includes:
   ✓ Detailed phase breakdown with specific changes
   ✓ Automated verification criteria using `make` commands
   ✓ Manual testing steps for validation
   ✓ Success criteria for each phase

   Ready to proceed with implementation using @implement?
   ```

2. **Offer next steps**:
   - If user approves, offer to run `@implement` on the plan
   - If changes needed, offer to refine the plan
   - If more research required, spawn additional sub-tasks

## OpenCode-Specific Enhancements

### Multi-Provider Optimization

- Leverage OpenCode's multi-provider support for different research phases
- Use appropriate models for different tasks (research vs planning)
- Optimize prompts for provider-agnostic execution

### Git Integration

- Use `!git log` and `!git diff` to understand recent changes
- Reference specific commits in research findings
- Include git context in implementation decisions

### File Reference System

- Use `@filename` to include relevant files in research prompts
- Leverage `!command` for running analysis tools
- Include file:line references in all findings

### Session Management

- Create parent-child session relationships for complex research
- Use `/sessions` to navigate between research and planning phases
- Enable easy handoff to implementation phase

## Success Criteria

### Automated Verification:

- [ ] Research tasks complete without errors
- [ ] Plan file created with proper structure
- [ ] All referenced files exist and are readable
- [ ] Plan includes both automated and manual verification
- [ ] Git history properly referenced if applicable

### Manual Verification:

- [ ] Research findings accurately capture current state
- [ ] Plan phases are logically sequenced
- [ ] Success criteria are specific and measurable
- [ ] Implementation approach is technically sound
- [ ] Plan addresses all discovered constraints

## Error Handling

### If Research Fails:

- Present specific errors to user
- Suggest alternative research approaches
- Offer to focus on specific aspects of the research

### If Planning Fails:

- Identify what information is missing
- Request clarification from user
- Provide partial findings for review

## Example Workflow

```
User: @research-plan ENG-1478

Assistant: I'll research ENG-1478 and create a comprehensive implementation plan.

[Spawns parallel research tasks]

Research complete. I've created implementation plan at:
`docs/plans/2025-01-24-ENG-1478-parent-child-tracking.md`

Ready to proceed with @implement?
```

```
User: @research-plan "add smileys to markdowns"

Assistant: I'll research "add smileys to markdowns" and create a comprehensive implementation plan.

[Spawns parallel research tasks]

Research complete. I've created implementation plan at:
`docs/plans/2025-01-24-add-smileys-to-markdowns.md`

Ready to proceed with @implement?
```

## Notes

- This command combines research and planning into one automated workflow
- Uses OpenCode's enhanced subagent system for comprehensive research
- Creates implementation-ready plans with specific success criteria
- Integrates with OpenCode's git and file reference systems
- Provides seamless handoff to implementation phase
