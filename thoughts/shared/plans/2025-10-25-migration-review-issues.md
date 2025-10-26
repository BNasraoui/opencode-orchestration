# Migration Review: Issues Found in HumanLayer to OpenCode Migration

## Overview

After reviewing the 16 migrated files (10 commands + 4 agents + 2 additional), several significant migration issues were identified. The migration was incomplete and contained numerous HumanLayer-specific references that weren't properly adapted for OpenCode.

## Critical Issues Found

### 1. **Agent Frontmatter Configuration Errors**

**Issue**: Inconsistent and incorrect frontmatter in agent files
- `analyzer.md` and `locator.md` use `permission:` (singular) instead of `permissions:` (plural)
- This will cause OpenCode to fail parsing these agent configurations

**Files Affected**:
- `.opencode/agent/analyzer.md` (line 5)
- `.opencode/agent/locator.md` (line 5)

**Impact**: Agents will not register correctly in OpenCode

**Fix Required**:
```yaml
# WRONG:
permission:
  edit: deny

# CORRECT:
permissions:
  edit: deny
```

### 2. **HumanLayer Directory References Not Updated**

**Issue**: Extensive references to HumanLayer-specific directories and commands throughout migrated files

**Examples Found**:
- `thoughts/shared/plans/` - Referenced in `plan.md`, `implement.md`, `research.md`
- `thoughts/shared/research/` - Referenced in `research.md`
- `thoughts/shared/tickets/` - Referenced in `plan.md`
- `humanlayer-wui/` directory - Referenced in `plan.md`
- `hld/` directory - Referenced in `plan.md`

**Impact**: Commands will fail when trying to access non-existent directories

### 3. **HumanLayer Command References**

**Issue**: Commands reference HumanLayer-specific tools and workflows

**Examples Found**:
- `humanlayer thoughts sync` - Referenced in `plan.md`, `research.md`
- `humanlayer-nightly launch` - Referenced in Ralph workflow analysis
- `make check test` - Referenced in `implement.md`, `validate.md`
- HumanLayer-specific make targets throughout

**Impact**: Commands will fail when executed in OpenCode environment

### 4. **Linear Integration Dependencies**

**Issue**: Several commands still reference Linear ticket management

**Examples Found**:
- Linear ticket references in `plan.md` examples
- Linear workflow states mentioned in `plan.md`
- Linear URL formats in examples

**Impact**: While not breaking functionality, creates confusion about supported integrations

### 5. **Tool Configuration Inconsistencies**

**Issue**: Agent tool configurations don't match OpenCode's expected format

**Examples Found**:
- Agents use `tools: read: true, grep: true` format
- OpenCode expects different tool specification format

**Files Affected**:
- All agent files (`.opencode/agent/*.md`)

### 6. **Missing OpenCode Feature Adaptation**

**Issue**: Commands don't leverage OpenCode-specific features properly

**Examples Found**:
- Limited use of `@file` references
- Missing `/undo` and `/redo` integration
- No adaptation of OpenCode's session system
- Commands still reference HumanLayer's permission model

## File-by-File Issues

### Commands

#### `plan.md`
- **Line 32**: References `thoughts/allison/tickets/eng_1234.md` (non-existent)
- **Line 33**: References `thoughts/allison/tickets/eng_1234.md` (non-existent)
- **Lines 87, 89**: References `thoughts/allison/tickets/eng_1234.md`
- **Line 295**: References `humanlayer thoughts sync`
- **Lines 287, 291**: References `thoughts/shared/tickets/eng_XXXX.md`
- **Lines 287, 291**: References `thoughts/shared/research/[relevant].md`
- **Lines 287, 291**: References `thoughts/allison/tickets/eng_XXXX.md`

#### `implement.md`
- **Line 12**: References `thoughts/shared/plans/`
- **Line 33**: References `/undo` and `/redo` (good adaptation)
- **Line 57**: References `make check test` (HumanLayer-specific)
- **Line 139**: References `thoughts/shared/plans/2025-01-08-feature-x.md`

#### `research.md`
- **Line 2**: References `thoughts directory`
- **Line 60**: References `thoughts/shared/research/`
- **Line 61**: References `thoughts directory`
- **Line 89**: References `thoughts/` directory
- **Line 98**: References `thoughts/` directory
- **Line 108**: References `thoughts/searchable/` paths
- **Line 109-113**: Specific path transformation examples using `thoughts/searchable/`

#### `validate.md`
- **Line 33**: References `make check test` (HumanLayer-specific)
- **Lines 29, 30**: References `git` commands (good adaptation)
- **Line 139**: References `thoughts/shared/plans/`

### Agents

#### `analyzer.md`
- **Line 5**: `permission:` should be `permissions:`
- **Lines 9-12**: Tool configuration format may not match OpenCode expectations

#### `locator.md`
- **Line 5**: `permission:` should be `permissions:`
- **Lines 9-11**: Tool configuration format may not match OpenCode expectations

#### `pattern-finder.md` & `researcher.md`
- Tool configuration format may not match OpenCode expectations

## Missing Migration Opportunities

### 1. **OpenCode Session System**
- Commands don't leverage OpenCode's session sharing (`/share`)
- No adaptation for OpenCode's session export/import
- Missing integration with OpenCode's multi-tab workflow

### 2. **OpenCode Permission Model**
- Commands still reference HumanLayer's permission concepts
- Not adapted for OpenCode's `ask`, `allow`, `deny` model
- Missing OpenCode-specific permission prompts

### 3. **File Reference System**
- Limited use of `@filename` syntax
- Missing `!command` integration examples
- Not leveraging OpenCode's enhanced file referencing

### 4. **Git Integration**
- While some `/undo` and `/redo` references exist, not fully integrated
- Missing `/git status`, `/git diff` command usage
- Not leveraging OpenCode's built-in change management

## Impact Assessment

### High Impact Issues
1. **Agent frontmatter errors** - Will prevent agents from loading
2. **Directory path references** - Commands will fail at runtime
3. **Command references** - Scripts will fail when executed

### Medium Impact Issues
1. **Tool configuration** - May cause agent functionality issues
2. **Linear references** - Confusion about supported integrations
3. **Missing OpenCode features** - Suboptimal user experience

### Low Impact Issues
1. **Inconsistent examples** - User confusion but not breaking functionality

## Recommended Fixes

### Immediate (Critical)
1. Fix agent frontmatter: `permission:` → `permissions:`
2. Update all directory references from `thoughts/` to appropriate OpenCode equivalents
3. Replace HumanLayer commands with OpenCode equivalents

### Short Term (High Priority)
1. Adapt tool configurations to OpenCode format
2. Remove Linear-specific references
3. Add proper OpenCode file reference examples

### Long Term (Enhancement)
1. Fully integrate OpenCode session system
2. Leverage OpenCode's permission model
3. Add comprehensive OpenCode feature usage

## Testing Recommendations

After fixes, test:
1. Agent registration: `opencode agent list`
2. Command parsing: `opencode command list`
3. Basic command execution with dummy inputs
4. File reference functionality
5. Git integration features

## Conclusion

The migration captured the core workflow logic but failed to properly adapt HumanLayer-specific infrastructure references. The most critical issues are the agent configuration errors and directory path references that will cause immediate failures. The migration represents a good foundation but requires significant cleanup to be functional in the OpenCode environment.
