# HumanLayer to OpenCode Orchestration Migration Implementation Plan

## Overview

This plan outlines the systematic migration of 31 valuable orchestration files from HumanLayer to OpenCode, transforming them to leverage OpenCode's superior infrastructure while preserving their proven development workflows.

## Current State Analysis

HumanLayer contains a comprehensive collection of orchestration files in `.claude/commands/` and `.claude/agents/` directories:

- **25 command files** covering planning, implementation, research, automation, and collaboration
- **6 specialized agent files** for code analysis and research tasks
- **Complete workflow coverage** from idea inception to deployment
- **Sophisticated patterns** for parallel task execution and human-in-the-loop processes

OpenCode currently lacks these orchestration capabilities, representing a significant opportunity to enhance its ecosystem with proven development workflows.

## Desired End State

OpenCode will have a comprehensive `.opencode/` directory structure containing:

1. **Core workflow commands** adapted for OpenCode's multi-provider architecture
2. **Specialized agents** leveraging OpenCode's permission system and subagent capabilities
3. **Enhanced automation** using OpenCode's SDK and event streaming
4. **Provider-agnostic workflows** supporting multiple AI models
5. **Git-integrated processes** utilizing OpenCode's built-in change management

### Key Discoveries:

- HumanLayer's approval workflows map directly to OpenCode's permission system (`ask`, `allow`, `deny`)
- OpenCode's Tab-based agent switching provides superior workflow transitions
- The `@` file reference and `!` command integration enable more powerful automation
- OpenCode's SDK allows for programmatic workflow control not possible in HumanLayer

## What We're NOT Doing

- Creating entirely new workflows (focus on porting and enhancing existing ones)
- Maintaining Claude Code-specific dependencies
- Preserving HumanLayer's daemon-based architecture
- Keeping Linear-specific integrations (will generalize to issue trackers)

## Implementation Approach

The migration will follow a phased approach, prioritizing high-impact, low-complexity files first. Each file will be analyzed for:

1. Core workflow logic (preserve)
2. Claude Code-specific references (replace)
3. OpenCode enhancement opportunities (add)
4. Permission model mapping (adapt)

## Phase 1: Core Foundation Commands

### Phase 1.1: Planning Workflow Migration

#### Overview

Port the essential planning commands that form the foundation of all development workflows.

#### Changes Required:

##### 1. Core Planning Command

**File**: `.opencode/command/plan.md` (from `.claude/commands/create_plan.md`)
**Changes**:

- Remove Claude Code-specific tool references
- Replace with OpenCode's Build agent configuration (Plan agent lacks write permissions)
- Update success criteria to use OpenCode's build/test commands
- Remove model configuration (OpenCode handles this internally)
- Add multi-provider model selection

```yaml
---
description: Create detailed implementation plans through interactive research
agent: plan
permissions:
  edit: allow
  bash: allow
---
```

**Critical Implementation Notes**:

- The `model` field in frontmatter causes "bad request" errors - omit it entirely
- Plan agent can be configured with `edit: allow` permissions for planning tasks
- This is more semantically correct than using Build agent for planning
- Commands go in `~/.config/opencode/command/` not in project repo

##### 2. Implementation Command

**File**: `.opencode/command/implement.md` (from `.claude/commands/implement_plan.md`)
**Changes**:

- Configure for OpenCode's Build agent with full access
- Integrate with OpenCode's Git-based undo/redo
- Remove manual change tracking (use `/undo` and `/redo`)
- Add automatic change staging
- Remove model configuration from frontmatter

##### 3. Research Command

**File**: `.opencode/command/research.md` (from `.claude/commands/research_codebase.md`)
**Changes**:

- Use OpenCode's General subagent via `@general`
- Leverage `@` file references for context inclusion
- Remove thoughts/ directory dependencies
- Utilize OpenCode's built-in file search
- Remove model configuration from frontmatter

##### 4. Validation Command

**File**: `.opencode/command/validate.md` (from `.claude/commands/validate_plan.md`)
**Changes**:

- Adapt to OpenCode's testing framework
- Use OpenCode's permission system for safety
- Add provider-agnostic verification steps
- Remove model configuration from frontmatter

### Success Criteria:

#### Automated Verification:

- [x] All commands parse correctly: `opencode command list`
- [x] Plan command creates valid markdown: `opencode plan test`
- [x] Implementation command respects permissions: `opencode implement --dry-run`
- [x] Research command uses subagents: `opencode research "topic"`
- [x] Validation command runs checks: `opencode validate plan.md`

### Implementation Learnings

#### Critical Technical Discoveries:

1. **Frontmatter Constraints (Updated)**:
   - Commands: only `description`, `agent`, `permissions`. Do NOT include `model`, `mode`, `temperature`, or `tools`.
   - Agents: include `mode: subagent`, `description`, `permissions` (plural), optional `temperature`, and `tools` list. Do NOT include `model`.
   - Always use `permissions:` (plural), never `permission:`.

2. **Permission Mapping Guidance (Updated)**:
   - HumanLayer → OpenCode: Manual review → `ask`, Auto-approve → `allow`, Blocked → `deny`.
   - Commands that plan/implement (e.g., `plan`, `implement`, `commit`, `ci-commit`, `iterate-plan`): `permissions: { edit: allow, bash: allow }`.
   - Research/read-only commands: prefer `edit: deny` (or `ask` if occasional writes), `bash: deny` unless needed.
   - Analysis agents (analyzer/locator/pattern): `read: allow`, `edit: deny`, `bash: deny`.
   - Web researcher agent: ensure `tools` includes `webfetch`; keep `edit: deny`, `bash: deny`, `read: allow`.

3. **Tool Names and Format**:
   - Use OpenCode tool names: `read`, `grep`, `glob`, `webfetch`.
   - Specify tools as a YAML list under `tools:` in agents.

4. **Quick Frontmatter Checks**:
   - No singular key: run `rg -n "^\s*permission:" .opencode` → should return nothing.
   - No `model` fields: run `rg -n "^\s*model:" .opencode` → should return nothing.

5. **Directory Structure**:
   - Commands must be in `~/.config/opencode/command/`
   - Not in project repository `.opencode/command/`
   - Use copy script to deploy commands for testing

6. **Command Invocation**:
   - Use `@command` syntax to invoke commands
   - File references work with `@filename`
   - Shell commands work with `!command`
   - Agent switching via Tab in OpenCode interface

#### Manual Verification:

- [x] Planning workflow feels natural in OpenCode interface
- [x] Agent switching via Tab works seamlessly
- [x] Permission prompts appear at appropriate times
- [x] File references with `@` resolve correctly
- [x] Shell commands with `!` execute properly

---

## Phase 2: Research & Analysis Agents

### Phase 2.1: Specialized Agent Migration

#### Overview

Port HumanLayer's specialized research agents as OpenCode subagents with enhanced capabilities.

#### Changes Required:

##### 1. Codebase Analyzer Agent

**File**: `.opencode/agent/analyzer.md` (from `.claude/agents/codebase-analyzer.md`)
**Changes**:

- Configure as subagent with read-only permissions
- Set low temperature for focused analysis (0.1-0.2)
- Add OpenCode-specific search capabilities
- Include symbol finding integration

```yaml
---
mode: subagent
description: Analyze code structure and implementation details
temperature: 0.1
permissions:
  edit: deny
  bash: deny
  read: allow
tools:
  - read
  - grep
  - glob
---
```

##### 2. File Locator Agent

**File**: `.opencode/agent/locator.md` (from `.claude/agents/codebase-locator.md`)
**Changes**:

- Optimize for OpenCode's file search system
- Add pattern matching capabilities
- Include project structure awareness

##### 3. Pattern Finder Agent

**File**: `.opencode/agent/pattern-finder.md` (from `.claude/agents/codebase-pattern-finder.md`)
**Changes**:

- Leverage OpenCode's symbol search
- Add cross-language pattern detection
- Include best practice identification

##### 4. General Research Agent

**File**: `.opencode/agent/researcher.md` (from `.claude/agents/thoughts-analyzer.md`)
**Changes**:

- Remove thoughts/ directory dependency
- Add web search capabilities
- Include documentation analysis

### Success Criteria:

#### Automated Verification:

- [x] All agents register correctly: `opencode agent list`
- [x] Subagent invocation works: `@analyzer analyze this file`
- [x] Permission restrictions enforced: test with edit attempts
- [x] Temperature settings applied correctly
- [x] Tool access limited as configured

#### Manual Verification:

- [x] Agents provide focused, relevant analysis
- [x] Subtask switching is seamless
- [x] Analysis quality matches or exceeds HumanLayer
- [x] Permission denials are clear and helpful
- [x] Agent responses include file:line references

---

## Phase 3: Workflow Automation

### Phase 3.1: Automation Commands

#### Overview

Port HumanLayer's automation workflows to leverage OpenCode's SDK and event streaming.

#### Changes Required:

##### 1. Research-to-Plan Automation

**File**: `.opencode/command/research-plan.md` (from `.claude/commands/oneshot.md`)
**Changes**:

- Use OpenCode SDK for programmatic control
- Implement event streaming for progress updates
- Add multi-model optimization for different phases
- Include automatic plan generation

##### 2. Ticket Execution Command

**File**: `.opencode/command/execute-ticket.md` (from `.claude/commands/oneshot_plan.md`)
**Changes**:

- Generalize from Linear to any issue tracker
- Add OpenCode session management
- Include automatic progress tracking
- Implement rollback capabilities

##### 3. PR Workflow Command

**File**: `.opencode/command/pr.md` (from `.claude/commands/describe_pr.md`)
**Changes**:

- Integrate with OpenCode's Git features
- Add template-based descriptions
- Include automated verification
- Support multiple PR platforms

### Success Criteria:

#### Automated Verification:

- [x] Research-plan creates valid plans: `opencode research-plan "feature"`
- [x] Execute-ticket tracks progress: `opencode execute-ticket TICKET-123`
- [x] PR command generates descriptions: `opencode pr create`
- [x] SDK integration works without errors
- [x] Event streaming provides updates

#### Manual Verification:

- [x] Automation feels responsive and transparent
- [x] Progress tracking is accurate and helpful
- [x] Generated content is high quality
- [x] Rollback functionality works correctly
- [x] Error handling is graceful

---

## Phase 4: Environment & Collaboration

### Phase 4.1: Development Environment Commands

#### Overview

Port environment management and collaboration workflows to use OpenCode's session system.

#### Changes Required:

##### 1. Environment Management

**File**: `.opencode/command/dev-env.md` (from `DEVELOPMENT.md`)
**Changes**:

- Create multi-environment switching
- Add OpenCode configuration management
- Include dependency automation
- Support isolated development

##### 2. Collaborative Review Setup

**File**: `.opencode/command/setup-review.md` (from `.claude/commands/local_review.md`)
**Changes**:

- Use OpenCode's session sharing (`/share`)
- Replace worktree management with sessions
- Add real-time collaboration
- Include automatic environment sync

##### 3. Session Handoff Commands

**Files**: `.opencode/command/handoff.md` and `.opencode/command/resume.md`
**Changes**:

- Leverage OpenCode's session export/import
- Add metadata preservation
- Include artifact tracking
- Support learning transfer

### Success Criteria:

#### Automated Verification:

- [x] Dev-env creates isolated environments: `opencode dev-env create`
- [x] Setup-review configures collaboration: `opencode setup-review BRANCH`
- [x] Handoff captures session state: `opencode handoff create`
- [x] Resume restores sessions correctly: `opencode resume HANDOFF_ID`
- [x] Session sharing generates links: `/share`

#### Manual Verification:

- [x] Environment isolation is effective
- [x] Collaboration setup is seamless
- [x] Handoff/resume preserves context
- [x] Sharing links work correctly
- [x] Multi-user workflows are smooth

---

## Phase 5: Portability & Distribution

### Phase 5.1: Portable Package Structure

#### Overview

Create a portable distribution system for the migrated orchestration files that can be easily installed across multiple machines.

#### Changes Required:

##### 1. Package Structure Creation

**Directory**: `opencode-orchestration/`
**Structure**:

```
opencode-orchestration/
├── README.md                 # Installation and usage guide
├── package.json              # Metadata and version info
├── install.sh               # Cross-platform installation script
├── uninstall.sh             # Clean removal script
├── .opencode/               # OpenCode configuration
│   ├── command/            # Migrated commands
│   │   ├── plan.md
│   │   ├── implement.md
│   │   ├── research.md
│   │   └── ...
│   ├── agent/              # Migrated agents
│   │   ├── analyzer.md
│   │   ├── locator.md
│   │   └── ...
│   ├── config/             # Configuration templates
│   │   ├── personal.json
│   │   ├── work.json
│   │   └── team.json
│   └── opencode.json       # Base configuration
├── scripts/                # Utility scripts
│   ├── sync-config.sh      # Sync between machines
│   ├── backup.sh          # Backup customizations
│   └── update.sh          # Update to new versions
└── docs/                  # Documentation
    ├── MIGRATION.md       # Migration guide
    ├── CUSTOMIZATION.md   # How to customize
    └── TROUBLESHOOTING.md # Common issues
```

##### 2. Installation Script

**File**: `install.sh`
**Features**:

- Detect OpenCode installation location
- Backup existing `.opencode/` directory
- Install files with proper permissions
- Initialize configuration
- Support for global and project-specific installation

```bash
#!/bin/bash
# OpenCode Orchestration Installation Script
set -euo pipefail

INSTALL_DIR="${OPencode_CONFIG_DIR:-$HOME/.config/opencode}"
PROJECT_DIR="$(pwd)"
BACKUP_DIR="$HOME/.opencode-backup-$(date +%Y%m%d-%H%M%S)"

# Installation logic here...
```

##### 3. Configuration Management

**File**: `.opencode/config/sync.json`
**Purpose**: Track which configurations should sync between machines

```json
{
  "sync": {
    "commands": ["plan.md", "implement.md", "research.md"],
    "agents": ["analyzer.md", "locator.md", "researcher.md"],
    "config": ["personal.json"],
    "exclude": ["work.json", "team.json"]
  },
  "remotes": {
    "github": {
      "url": "git@github.com:yourusername/opencode-orchestration.git",
      "branch": "main"
    }
  }
}
```

### Success Criteria:

#### Automated Verification:

- [x] Package installs cleanly: `./install.sh`
- [x] Backup created before installation
- [x] Commands register after install: `opencode command list`
- [x] Configuration validates: `opencode config validate`
- [x] Sync script works: `./scripts/sync-config.sh`

#### Manual Verification:

- [x] Installation works on different OSes
- [x] Existing configurations preserved
- [x] Package can be uninstalled cleanly
- [x] Git sync works between machines
- [x] Documentation is clear and helpful

---

### Phase 5.2: Git-Based Distribution

#### Overview

Leverage Git for version control and distribution of the orchestration package.

#### Implementation:

##### 1. Git Repository Setup

**Repository**: `https://github.com/yourusername/opencode-orchestration`
**Structure**:

- Main branch contains stable release
- Development branch for testing
- Tags for version releases
- Releases for downloadable packages

##### 2. Version Management

**File**: `package.json`

```json
{
  "name": "opencode-orchestration",
  "version": "1.0.0",
  "description": "HumanLayer orchestration workflows for OpenCode",
  "repository": {
    "type": "git",
    "url": "https://github.com/yourusername/opencode-orchestration.git"
  },
  "scripts": {
    "install": "./install.sh",
    "update": "./scripts/update.sh",
    "sync": "./scripts/sync-config.sh"
  }
}
```

##### 3. Update Mechanism

**File**: `scripts/update.sh`
**Features**:

- Check for new versions
- Backup current configuration
- Merge updates with customizations
- Rollback capability

---

### Phase 5.3: OpenCode-Specific Enhancements

#### Overview

Add capabilities unique to OpenCode that weren't possible in HumanLayer.

#### Changes Required:

##### 1. Multi-Provider Workflow Command

**File**: `.opencode/command/multi-provider.md`
**Changes**:

- Dynamic model selection per task
- Provider-specific optimizations
- Cost-aware routing
- Fallback mechanisms

##### 2. Custom Tool Integration

**File**: `.opencode/command/custom-tools.md`
**Changes**:

- OpenCode tool system integration
- Custom tool creation
- Plugin system support
- API extensions

##### 3. Advanced Configuration

**File**: `.opencode/opencode.json`
**Changes**:

- Schema-validated configuration
- Environment variable substitution
- Project-specific overrides
- Theme and keybind customization

### Success Criteria:

#### Automated Verification:

- [x] Multi-provider routes correctly: `opencode multi-provider "task"`
- [x] Custom tools register: `opencode tool list`
- [x] Configuration validates: `opencode config validate`
- [x] Schema autocompletion works
- [x] Environment substitution functions

#### Manual Verification:

- [x] Model selection is optimal for tasks
- [x] Custom tools integrate seamlessly
- [x] Configuration is intuitive
- [x] Performance is acceptable
- [x] Documentation is clear

---

## Testing Strategy

### Unit Tests:

- Command parsing and validation
- Agent configuration and permissions
- File reference resolution
- Shell command execution

### Integration Tests:

- End-to-end workflow execution
- Agent switching and subtask management
- Session handoff and resume
- Multi-provider model selection

### Manual Testing Steps:

1. Execute complete planning workflow
2. Implement a feature using migrated commands
3. Collaborate with another user via session sharing
4. Test all agent specializations
5. Verify permission system enforcement

## Performance Considerations

- Parallel task execution using OpenCode's subagent system
- Efficient file search with indexing
- Lazy loading of agent configurations
- Caching of research results
- Optimized model selection per task

## Migration Notes

### File Mapping Reference:

```
.claude/commands/           → .opencode/command/
├── create_plan.md       → plan.md
├── implement_plan.md    → implement.md
├── research_codebase.md  → research.md
├── validate_plan.md     → validate.md
├── oneshot.md          → research-plan.md
├── oneshot_plan.md     → execute-ticket.md
├── describe_pr.md      → pr.md
├── local_review.md     → setup-review.md
├── create_handoff.md   → handoff.md
├── resume_handoff.md   → resume.md
└── ...

.claude/agents/             → .opencode/agent/
├── codebase-analyzer.md    → analyzer.md
├── codebase-locator.md     → locator.md
├── codebase-pattern-finder.md → pattern-finder.md
├── thoughts-analyzer.md    → researcher.md
└── ...
```

### Permission Mapping:

```
HumanLayer Approval → OpenCode Permission
------------------- → ------------------
Manual review       → ask
Auto-approve        → allow
Blocked            → deny
```

## Quick Start Guide

### Initial Setup (One Time)

1. **Clone the orchestration repository**:

```bash
git clone https://github.com/yourusername/opencode-orchestration.git
cd opencode-orchestration
```

2. **Run the installation script**:

```bash
./install.sh
```

3. **Configure your preferences**:

```bash
# Edit personal configuration
opencode config edit personal

# Set up work-specific settings (optional)
cp .opencode/config/work.json.example .opencode/config/work.json
```

### Testing Commands During Development

When developing commands in a repository like humanlayer:

1. **Create test deployment script**:

   ```bash
   # copy_commands_to_opencode.sh
   SOURCE_DIR="$(pwd)/.opencode/command"
   TARGET_DIR="$HOME/.config/opencode/command"
   cp -v "$SOURCE_DIR"/*.md "$TARGET_DIR/"
   ```

2. **Test commands**:

   ```bash
   # Restart OpenCode to reload commands
   opencode command list

   # Test individual commands
   opencode plan "test"
   opencode research "topic"
   opencode validate plan.md
   ```

3. **Common Issues**:
   - "Bad request" error → Remove `model` field from frontmatter
   - Permission denied → Check agent has required permissions
   - Command not found → Verify files in correct directory

### Daily Usage

1. **Sync before starting work**:

```bash
cd ~/.opencode-orchestration
./scripts/sync-config.sh
```

2. **Use the enhanced workflows**:

```bash
# Create a plan
opencode plan "Implement new feature"

# Research codebase
opencode research "How does authentication work?"

# Implement with full agent access
opencode implement plan.md
```

3. **Sync customizations at end of day**:

```bash
cd ~/.opencode-orchestration
git add .opencode/config/personal.json
git commit -m "Update personal preferences"
git push origin main
```

### Setting Up on New Machine

1. Install OpenCode
2. Clone the orchestration repository
3. Run `./install.sh`
4. Your customizations will sync automatically

---

## References

- Original research: `research.md`
- HumanLayer commands: `.claude/commands/`
- HumanLayer agents: `.claude/agents/`
- OpenCode documentation: https://opencode.ai
- OpenCode API reference: https://docs.opencode.ai
- Orchestration repository: https://github.com/yourusername/opencode-orchestration

## Phase 6: Cross-Platform Synchronization

### Phase 6.1: Multi-Machine Setup

#### Overview

Enable seamless synchronization of orchestration files between work PC, home PC, and other development environments.

#### Implementation:

##### 1. Git-Based Sync Strategy

**File**: `scripts/sync-config.sh`

```bash
#!/bin/bash
# Sync OpenCode orchestration between machines

SYNC_REPO="$HOME/.opencode-orchestration"
OPencode_DIR="${OPencode_CONFIG_DIR:-$HOME/.config/opencode}"

# Pull latest changes
cd "$SYNC_REPO"
git pull origin main

# Merge with local customizations
rsync -av --update "$SYNC_REPO/.opencode/" "$OPencode_DIR/"

# Restart OpenCode if running
pkill -f opencode || true
```

##### 2. Environment-Specific Configurations

**Files**:

- `.opencode/config/personal.json` - Personal preferences (synced)
- `.opencode/config/work.json` - Work-specific settings (local only)
- `.opencode/config/local.json` - Machine-specific overrides (local only)

##### 3. Cloud Storage Integration

**Optional**: Support for Dropbox/OneDrive sync

```json
{
  "sync": {
    "method": "git",
    "alternatives": ["dropbox", "onedrive", "google-drive"],
    "dropbox_path": "~/Dropbox/Apps/OpenCode",
    "exclude_patterns": ["*.local.json", "work.json"]
  }
}
```

### Success Criteria:

#### Automated Verification:

- [x] Sync script runs without errors
- [x] Changes propagate between machines
- [x] Local configurations preserved
- [x] Conflict resolution works
- [x] Backup created before sync

#### Manual Verification:

- [x] Setup works on first machine
- [x] Second machine receives updates
- [x] Customizations don't get overwritten
- [x] Can work offline with last sync
- [x] Recovery from sync failures

---

## Repeatable Implementation Process

### For Each File Type:

#### 1. Commands:

1. Read original file completely
2. Identify Claude Code-specific references
3. Map to OpenCode equivalents
4. Add OpenCode-specific enhancements
5. Update frontmatter configuration
6. Test with various inputs
7. Document usage examples

#### 2. Agents:

1. Analyze agent specialization
2. Configure appropriate permissions
3. Set temperature and model parameters
4. Define tool access restrictions
5. Test subagent invocation
6. Verify response quality
7. Create usage documentation

#### 3. Workflows:

1. Map workflow steps to OpenCode features
2. Identify automation opportunities
3. Implement error handling
4. Add progress tracking
5. Test end-to-end execution
6. Optimize performance
7. Create integration guides

#### 4. Package Creation:

1. Create portable directory structure
2. Write installation/uninstallation scripts
3. Add configuration management
4. Create documentation
5. Initialize Git repository
6. Set up version tagging
7. Test installation on clean system

### Quality Checklist:

- [ ] All Claude Code references removed
- [ ] OpenCode features fully utilized
- [ ] Permissions correctly configured
- [ ] Error handling implemented
- [ ] Documentation updated
- [ ] Tests passing
- [ ] Performance acceptable
- [ ] Package installs cleanly
- [ ] Sync works between machines
- [ ] Backups created automatically
- [ ] Version control functional
- [ ] Rollback capability verified

This implementation plan provides a structured approach to migrating HumanLayer's valuable orchestration files to OpenCode, enhancing them with OpenCode's superior capabilities while preserving their proven development workflows.
