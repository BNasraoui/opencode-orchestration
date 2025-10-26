# OpenCode HumanLayer Sessions Text Display Issue Implementation Plan

## Overview

Fix the issue where sessions are not showing text when the first prompt is a command in the opencode humanlayer implementation. The problem occurs because initial prompt text is conditionally skipped when command parameters are provided.

## Current State Analysis

### Issue Identified
- **Problem**: Sessions not showing text when first prompt is a command
- **Root Cause**: Conditional logic in command files skips default message when parameters provided
- **Location**: `.opencode/command/plan.md:17-21` and similar patterns in other commands

### Session Text Addition Flow Research

Based on comprehensive research using the @researcher subagent:

**Session Creation Process**:
1. User initiates OpenCode session
2. User invokes command (e.g., `@plan`) 
3. OpenCode validates command frontmatter and permissions
4. Command markdown content is processed as AI prompt
5. AI generates response based on command instructions
6. Response text appears in session conversation

**Key Finding**: OpenCode treats command markdown as internal system prompts rather than displaying them as visible first messages in sessions. This differs from user expectations where command invocation should show initial guidance text.

**Text Display Flow**:
```
Command Invocation → Frontmatter Validation → Markdown Prompt Processing → AI Response Generation → Session Text Display
```

**Most Likely Cause**: OpenCode's command system processes the markdown content as an internal prompt rather than displaying it as the first visible message in the session.

## Desired End State

Commands should always display initial guidance text regardless of whether parameters are provided, ensuring users see expected session text and understand the command's capabilities.

### Key Discoveries:

- **File Location**: `.opencode/command/plan.md:17-21` contains the problematic conditional logic
- **Pattern Found**: Similar conditional logic exists across multiple command files
- **OpenCode Behavior**: Command markdown treated as internal prompts, not displayed text
- **User Expectation**: Initial guidance should always be visible for better UX

## What We're NOT Doing

- Modifying OpenCode's core command processing system
- Changing the fundamental session text display mechanism
- Implementing complex workarounds that could break other functionality

## Implementation Approach

Modify the conditional logic in command files to **always** display initial guidance text, with conditional content based on whether parameters were provided. This ensures users see expected session text while maintaining the workflow functionality.

## Phase 1: Analyze Current Command Patterns

### Overview

Identify all command files with similar conditional logic that needs to be fixed.

### Changes Required:

#### 1. Command File Analysis

**Files to examine**:
- `.opencode/command/plan.md` - Primary planning command
- `.opencode/command/research.md` - Research command
- `.opencode/command/ticket.md` - Ticket management command
- `.opencode/command/validate.md` - Validation command
- `.opencode/command/pr.md` - PR description command

**Analysis approach**:
```bash
# Find conditional logic patterns
grep -r "If.*parameters.*provided" .opencode/command/
grep -r "skip.*default.*message" .opencode/command/
grep -r "no.*parameters.*provided" .opencode/command/
```

### Success Criteria:

#### Automated Verification:

- [ ] All command files identified and analyzed: `grep -r "parameters" .opencode/command/`
- [ ] Conditional logic patterns documented: `find .opencode/command/ -name "*.md" -exec echo "=== {} ===" \; -exec grep -n "parameters\|skip" {} \;`

#### Manual Verification:

- [ ] Each command file reviewed for conditional logic patterns
- [ ] Impact of changes assessed for each command
- [ ] User experience implications documented

---

## Phase 2: Implement Fix for Core Commands

### Overview

Modify the conditional logic to always show initial guidance text while maintaining parameter-based processing.

### Changes Required:

#### 1. Fix plan.md Command

**File**: `.opencode/command/plan.md`
**Current Logic** (lines 17-21):
```markdown
1. **Check if parameters were provided**:
   - If a file path or ticket reference was provided as a parameter, skip the default message
   - Immediately read any provided files FULLY
   - Begin the research process

2. **If no parameters provided**, respond with:
```

**Fixed Logic**:
```markdown
1. **Always respond with initial guidance**:
   - If parameters were provided, acknowledge them and indicate processing
   - If no parameters provided, request the necessary information

```
[If parameters provided: I'm processing the provided input and starting research immediately.]
[If no parameters: Let me start by understanding what we're building. Please provide...]
```

2. **Proceed with processing**:
   - If parameters provided, immediately read any provided files FULLY
   - Begin the research process regardless of parameters
   - Continue with the standard planning workflow
```

#### 2. Apply Similar Fixes to Other Commands

**Files to modify**:
- `.opencode/command/research.md` - Research command initial response
- `.opencode/command/ticket.md` - Ticket command menu display
- `.opencode/command/validate.md` - Validation command context gathering
- `.opencode/command/pr.md` - PR command identification process

**Pattern to apply**:
- Always show initial guidance/message
- Include conditional content based on parameters
- Maintain existing workflow functionality

### Success Criteria:

#### Automated Verification:

- [ ] Modified files contain no "skip.*default.*message" patterns: `grep -r "skip.*default" .opencode/command/`
- [ ] All commands have initial response sections: `grep -r "Initial.*Response\|When.*invoked" .opencode/command/`
- [ ] No conditional logic that hides initial text: `grep -r "If.*parameters.*skip" .opencode/command/`

#### Manual Verification:

- [ ] Each modified command shows initial text when invoked
- [ ] Parameter-based processing still works correctly
- [ ] User experience is consistent across all commands
- [ ] Command functionality remains intact

---

## Phase 3: Test and Validate Changes

### Overview

Test the modified commands to ensure they display initial text correctly while maintaining functionality.

### Changes Required:

#### 1. Command Testing

**Test scenarios**:
- Invoke commands without parameters (should show initial guidance)
- Invoke commands with parameters (should show initial guidance + acknowledge parameters)
- Verify parameter processing still works correctly
- Check that workflows proceed normally after initial response

**Test commands**:
```bash
# Test plan command
opencode plan
opencode plan "test task description"

# Test research command  
opencode research
opencode research "specific research topic"

# Test other commands similarly
```

#### 2. User Experience Validation

**Validation points**:
- Initial text appears immediately when command is invoked
- Text is helpful and informative
- Parameter acknowledgment is clear when provided
- No confusion about command state or next steps

### Success Criteria:

#### Automated Verification:

- [ ] Commands execute without errors: `opencode plan && echo "SUCCESS"`
- [ ] No syntax errors in modified markdown files: `find .opencode/command/ -name "*.md" -exec echo "Checking {}" \; -exec markdownlint {} \; 2>/dev/null || echo "No markdownlint available"`

#### Manual Verification:

- [ ] Initial text displays for all commands when invoked without parameters
- [ ] Initial text displays for all commands when invoked with parameters
- [ ] Parameter processing works correctly in both cases
- [ ] User experience is intuitive and helpful
- [ ] No regression in existing functionality

---

## Phase 4: Documentation and Sync

### Overview

Update documentation and sync changes to ensure the fix is properly documented and available.

### Changes Required:

#### 1. Update Documentation

**Files to update**:
- `docs/TROUBLESHOOTING.md` - Add note about session text display fix
- `README.md` - Update command usage examples if needed
- `research.md` - Document the session text addition mechanism findings

**Documentation additions**:
```markdown
### Session Text Display

Commands now always display initial guidance text when invoked, regardless of whether parameters are provided. This ensures users see helpful context and understand command capabilities.

**Fixed Issue**: Previously, commands with parameters would skip initial guidance text, causing confusion about command state.
```

#### 2. Sync Configuration

**Sync actions**:
- Run configuration sync if applicable
- Update any cached command definitions
- Ensure changes are properly distributed

### Success Criteria:

#### Automated Verification:

- [ ] Documentation files updated with fix information: `grep -r "session.*text.*display" docs/`
- [ ] No broken links or references in documentation: `find docs/ -name "*.md" -exec echo "Checking {}" \;`

#### Manual Verification:

- [ ] Documentation accurately describes the fix
- [ ] Usage examples reflect the new behavior
- [ ] Troubleshooting guide includes session text display information
- [ ] Changes are properly synced and available

---

## Testing Strategy

### Unit Tests:

- Test command parsing with and without parameters
- Verify initial response generation in both cases
- Ensure workflow continuation works correctly

### Integration Tests:

- Test commands in actual OpenCode sessions
- Verify parameter processing and file reading
- Check that sub-tasks and research phases work normally

### Manual Testing Steps:

1. **Basic Command Invocation**:
   - Invoke `@plan` without parameters - should show initial guidance
   - Invoke `@plan "task description"` - should show initial guidance + acknowledgment

2. **Workflow Continuation**:
   - Verify that after initial response, normal workflow proceeds
   - Check that parameter processing works as expected
   - Ensure no regression in existing functionality

3. **Cross-Command Consistency**:
   - Test all modified commands for consistent behavior
   - Verify user experience is uniform across commands
   - Check that help text and guidance are appropriate

## Performance Considerations

- Minimal performance impact - only changes conditional logic display
- No additional processing overhead
- Slightly more text output, but negligible impact

## Migration Notes

- No breaking changes to existing functionality
- User experience improvement only
- Backward compatible with existing command usage patterns
- No migration required for existing users

## References

- Original issue: Sessions not showing text when first prompt is a command
- Root cause analysis: Conditional logic in `.opencode/command/plan.md:17-21`
- Research findings: Session text addition mechanism via @researcher subagent
- Pattern analysis: Similar conditional logic found across multiple command files
- OpenCode command system: Markdown-based commands with frontmatter configuration
