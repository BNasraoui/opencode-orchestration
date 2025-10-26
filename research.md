# OpenCode Integration Research

## Summary of Thoughts & Topic

Based on the analysis of the HumanLayer repository, the core topic is **identifying which markdown orchestration files from HumanLayer can be ported to OpenCode**.

### Key Observations from thoughts.md:

1. **Current Architecture**: HumanLayer is built as an orchestration layer specifically for Claude Code, providing:
   - Multi-session management via Go daemon (`hld/`)
   - Desktop UI (Tauri + React) for graphical approval workflows
   - CLI tool with MCP server integration (`hlyr/`)
   - Real-time event streaming and SQLite persistence

2. **Critical Limitation**: The system is tightly coupled to Claude Code and doesn't support other AI providers

3. **Desired Outcome**: Port the valuable processes and workflows to work with OpenCode instead

## Portable Markdown Orchestration Files

### 1. Planning & Implementation Commands

**Files**: `.claude/commands/create_plan.md`, `.claude/commands/implement_plan.md`, `.claude/commands/iterate_plan.md`, `.claude/commands/validate_plan.md`

**What to port**: The entire planning workflow system

- Interactive plan creation with research phases
- Structured implementation with verification steps
- Plan iteration and validation processes
- Clear separation of automated vs manual verification

**Adaptation needed**:

- Replace Claude Code-specific tool references with OpenCode equivalents
- Update file path patterns to match OpenCode's structure
- Modify success criteria to use OpenCode's build/test commands

### 2. Development Workflow Commands

**Files**: `.claude/commands/commit.md`, `.claude/commands/debug.md`, `.claude/commands/research_codebase.md`

**What to port**: Core development workflow automation

- Git commit creation without AI attribution
- Debugging methodology for logs, database, and git state
- Comprehensive codebase research with parallel sub-tasks

**Direct port**: These workflows are largely AI-agnostic and can be adapted

### 3. Specialized Agent Definitions

**Files**: `.claude/agents/codebase-analyzer.md`, `.claude/agents/codebase-locator.md`, `.claude/agents/codebase-pattern-finder.md`, `.claude/agents/thoughts-locator.md`, `.claude/agents/thoughts-analyzer.md`

**What to port**: Specialized research agent patterns

- Codebase analysis and location strategies
- Pattern finding for similar implementations
- Thoughts directory research and analysis

**Direct port**: Agent definitions are framework-agnostic

### 4. Documentation Templates

**Files**: `CLAUDE.md`, `DEVELOPMENT.md`, `CONTRIBUTING.md`, `TESTING.md`

**What to port**: Development documentation structure

- Repository overview and component descriptions
- Development setup and workflow guides
- Testing strategies and environment management

**Adaptation needed**: Update technology-specific references

## Components to Rebuild for OpenCode

### 1. Claude Code-Specific Commands

**Files requiring complete rewrite**:

- Commands that reference Claude Code's CLI or API
- MCP protocol integration commands
- Claude-specific model references

### 2. Integration Points

**New implementation needed**:

- Replace Claude Code session management with OpenCode equivalents
- Update tool integration from MCP to OpenCode's tool system
- Adapt approval workflows to OpenCode's permission model

## Implementation Strategy

### Phase 1: Core Workflow Port

1. Port planning commands (create_plan, implement_plan, iterate_plan, validate_plan)
2. Adapt development workflow commands (commit, debug, research_codebase)
3. Update agent definitions for OpenCode context
4. Create OpenCode-specific documentation templates

### Phase 2: OpenCode Integration

1. Replace Claude Code references with OpenCode equivalents
2. Update success criteria to use OpenCode's build/test commands
3. Adapt file path patterns and directory structures
4. Create OpenCode-specific debugging guides

### Phase 3: Specialization

1. Add OpenCode-specific commands and workflows
2. Create OpenCode-optimized agent configurations
3. Develop OpenCode-specific debugging and research patterns
4. Add multi-provider support to workflows

## Technical Considerations

### Advantages of Porting to OpenCode

- **Proven workflows**: HumanLayer has well-tested development processes
- **Comprehensive coverage**: Full lifecycle from planning to validation
- **Parallel execution**: Sophisticated use of sub-tasks for efficiency
- **Clear separation**: Distinction between automated and manual verification

### Challenges to Address

- **Tool references**: Many commands reference Claude Code-specific tools
- **File patterns**: Directory structures differ between projects
- **API differences**: Session management and event handling vary
- **Permission models**: Approval systems need adaptation

## Recommended Files to Port First

1. **`create_plan.md`** - Core planning workflow (high value, framework-agnostic)
2. **`implement_plan.md`** - Implementation methodology (universally applicable)
3. **`commit.md`** - Git workflow (completely portable)
4. **`research_codebase.md`** - Research methodology (framework-agnostic)
5. **Agent definitions** - Specialized research patterns (reusable)

## Next Steps

1. **Create OpenCode commands directory**: Set up `.opencode/commands/` structure
2. **Port core workflows**: Start with planning and implementation commands
3. **Adapt success criteria**: Update to use OpenCode's build/test commands
4. **Test integration**: Verify workflows work with OpenCode's tool system
5. **Iterate and refine**: Add OpenCode-specific optimizations

## OpenCode Research Findings

### OpenCode Architecture & Capabilities

**Core Features**:

- Terminal-based AI coding agent with TUI interface
- Multi-provider support (Anthropic, OpenAI, Gemini, local models, OpenCode Zen)
- Built-in agent system (Build, Plan, General agents) with Tab switching
- Custom command and agent creation via markdown files with frontmatter
- Git-based undo/redo functionality with automatic change tracking
- Session management with parent/child session navigation
- Real-time sharing capabilities with link generation
- Built-in slash commands (`/init`, `/undo`, `/redo`, `/share`, `/sessions`, etc.)
- File reference system using `@` for fuzzy file search
- Shell command integration using `!` prefix
- SDK for programmatic control and integration

**Configuration System**:

- JSON/JSONC config with schema validation and autocompletion
- Global (`~/.config/opencode/`) and per-project (`.opencode/`) configs
- Environment variable (`{env:VAR}`) and file content (`{file:path}`) substitution
- Permission-based tool control (`allow`, `ask`, `deny`) with granular control
- Theme and keybind customization with multiple built-in themes
- Provider and model configuration per project
- Tool enable/disable controls
- Formatter integration for code formatting
- MCP server support for external tool integration
- Custom tool creation capabilities

**Command System**:

- Custom commands via markdown files in `command/` directories
- Support for arguments (`$ARGUMENTS`), shell output (`!command`), and file references (`@file`)
- Agent-specific command execution with `agent` configuration
- Template-based prompts with frontmatter configuration
- Subtask forcing for clean context separation
- Model override per command
- Command can override built-in commands
- Global and project-specific command locations

**Agent System**:

- Primary agents (switchable via Tab key or keybinds)
- Subagents (invoked via @mention or automatically based on descriptions)
- Tool and permission configuration per agent with inheritance
- Temperature and model customization per agent
- Built-in agents: Build (full access), Plan (restricted - asks for edits/bash), General (research)
- Agent creation via `opencode agent create` interactive command
- Markdown-based agent definitions with frontmatter
- Session navigation between parent and child sessions (Ctrl+Left/Right)
- Agent-specific prompts and additional model parameters

**Advanced Features**:

- Server mode with HTTP API and SDK for integrations
- Event streaming for real-time updates
- File search with text, files, and symbols
- LSP server integration for language support
- Enterprise features with team management
- Plugin system for extensibility
- Multi-session management with sharing
- Git integration for change tracking
- Export functionality for conversations

### Key Differences from HumanLayer

**OpenCode Advantages**:

- Multi-provider support (Anthropic, OpenAI, Gemini, local models, OpenCode Zen)
- Built-in permission system for safety with granular control (`allow`, `ask`, `deny`)
- Git-based change management (undo/redo) with automatic tracking
- Terminal-native interface with rich TUI and keybinds
- Simpler architecture (no external daemon required)
- Direct file operations without MCP dependency (though MCP is supported)
- SDK for programmatic control and integration
- Real-time event streaming and API access
- Session sharing with link generation
- Built-in agent system with Tab switching
- Custom command and agent creation via markdown
- Global and project-specific configuration
- Theme and keybind customization
- Server mode for remote access

**HumanLayer Advantages**:

- Sophisticated approval workflow system with human-in-the-loop
- Real-time session monitoring and streaming with desktop UI
- Multi-session orchestration with daemon coordination
- Database persistence for session history and analytics
- Desktop UI (CodeLayer) for graphical workflows
- Specialized research agents with parallel execution
- Linear integration for ticket management
- Worktree management for isolated development
- Handoff/resume system for session continuity
- Retroactive ticket creation for experimental work
- Collaborative review environment setup
- JSON-RPC protocol for external integrations

### Porting Strategy for OpenCode

#### 1. Direct Ports (Minimal Adaptation)

**Planning Workflow**:

- Port `create_plan.md` → `.opencode/command/plan.md`
- Adapt to OpenCode's Plan agent (restricted mode with `ask` permissions)
- Replace Claude Code references with OpenCode equivalents
- Update success criteria to use OpenCode's tool system and `/undo` functionality
- Use OpenCode's Tab switching to leverage Plan agent's built-in restrictions

**Implementation Workflow**:

- Port `implement_plan.md` → `.opencode/command/implement.md`
- Use OpenCode's Build agent with full tool access
- Leverage Git-based undo/redo instead of manual change tracking
- Remove Claude Code-specific session management
- Integrate with OpenCode's automatic change staging

**Research Commands**:

- Port `research_codebase.md` → `.opencode/command/research.md`
- Use OpenCode's General subagent for parallel tasks via `@general`
- Adapt file search to use OpenCode's `@` file references and `!` commands
- Remove thoughts/ directory dependencies
- Leverage OpenCode's built-in file search capabilities

#### 2. Agent Definitions

**Codebase Analysis Agents**:

- Port `codebase-analyzer.md` → `.opencode/agent/analyzer.md`
- Port `codebase-locator.md` → `.opencode/agent/locator.md`
- Port `codebase-pattern-finder.md` → `.opencode/agent/pattern-finder.md`
- Configure as subagents with read-only permissions (`edit: deny`, `bash: deny`)
- Use OpenCode's `mode: subagent` configuration
- Add temperature settings for focused analysis (0.1-0.2)

**Research Agents**:

- Port `thoughts-locator.md` → `.opencode/agent/researcher.md`
- Port `thoughts-analyzer.md` → `.opencode/agent/analyzer.md`
- Adapt to work without HumanLayer's thoughts/ structure
- Use OpenCode's file search and symbol finding capabilities
- Configure with appropriate tool permissions

#### 3. Workflow Adaptations

**Git Integration**:

- Replace HumanLayer's manual commit process with OpenCode's built-in Git integration
- Use `/undo` and `/redo` commands instead of manual change tracking
- Leverage OpenCode's automatic change staging and revert capabilities
- Integrate with OpenCode's session-based change management

**Permission System**:

- Map HumanLayer's approval workflows to OpenCode's permission system
- Use `ask` permissions for high-stakes operations (file edits, bash commands)
- Create specialized agents with restricted tool access
- Implement granular bash command permissions with wildcards
- Use agent-specific permission overrides

**Session Management**:

- Replace HumanLayer's daemon-based sessions with OpenCode's session system
- Use `/sessions` command for session switching and parent/child navigation
- Leverage `/share` for collaboration instead of HumanLayer's real-time sharing
- Implement handoff system using OpenCode's session export/import
- Use `/compact` for session summarization

#### 4. OpenCode-Specific Enhancements

**Multi-Provider Support**:

- Create provider-agnostic workflows removing Claude-specific references
- Add model selection for different task types via command configuration
- Optimize prompts for different model capabilities (temperature, reasoning effort)
- Support local models and specialized providers
- Use OpenCode Zen for curated model selection

**Terminal Integration**:

- Leverage `!` command integration for shell operations and test execution
- Use `@` file references for context inclusion and file analysis
- Create keyboard shortcuts for common workflows via keybind configuration
- Integrate with OpenCode's TUI commands (`/init`, `/export`, `/editor`)
- Use OpenCode's toast notifications for workflow feedback

**Permission-Based Safety**:

- Implement approval workflows using `ask` permissions
- Create read-only agents for code review with `edit: deny`
- Use agent switching for different trust levels (Tab key)
- Configure granular bash permissions with glob patterns
- Implement tool-specific restrictions per agent

**SDK Integration**:

- Use OpenCode SDK for programmatic workflow control
- Implement event streaming for real-time progress updates
- Create custom tools using OpenCode's custom tool system
- Integrate with external systems via OpenCode's server mode
- Build plugins for specialized functionality

**Configuration Management**:

- Use OpenCode's JSON/JSONC configuration with schema validation
- Implement environment variable substitution for deployment flexibility
- Create project-specific configurations for different workflow needs
- Use file substitution for including large prompt templates
- Leverage global vs project configuration hierarchy

### Implementation Priority

1. **Core Planning Commands** (High Value)
   - `plan.md` - Adapt create_plan workflow using Plan agent
   - `implement.md` - Port implementation methodology with Build agent
   - `validate.md` - Create validation workflow with appropriate permissions
   - `research.md` - Port research methodology using General subagent

2. **Research Agents** (High Value)
   - `analyzer.md` - Codebase analysis agent with read-only permissions
   - `locator.md` - File location agent leveraging OpenCode's search
   - `pattern-finder.md` - Pattern detection using symbol search
   - `researcher.md` - General research agent for complex queries

3. **Workflow Automation** (Medium Value)
   - `research-plan.md` - Automated research-to-planning pipeline
   - `execute-ticket.md` - End-to-end ticket execution
   - `ticket.md` - Issue tracking integration (adapt from Linear)
   - `pr.md` - PR workflow automation

4. **Environment & Collaboration** (Medium Value)
   - `setup-review.md` - Collaborative review environment
   - `dev-env.md` - Environment management
   - `handoff.md` & `resume.md` - Session continuity management

5. **Utility Commands** (Low Value)
   - `commit.md` - May not be needed (OpenCode has Git integration)
   - `debug.md` - Adapt to OpenCode's debugging approach
   - `experimental-to-ticket.md` - Retroactive documentation

### Recommended OpenCode Structure

```
.opencode/
├── command/
│   ├── plan.md          # Planning workflow
│   ├── implement.md      # Implementation workflow
│   ├── research.md       # Codebase research
│   └── validate.md      # Validation workflow
├── agent/
│   ├── analyzer.md       # Codebase analysis
│   ├── locator.md        # File location
│   ├── researcher.md     # General research
│   └── reviewer.md      # Code review
└── opencode.json        # Configuration
```

## Additional Valuable Markdown Documents to Port

### 1. Development Documentation

**DEVELOPMENT.md** - Parallel development environment setup

- **Value**: Sophisticated environment isolation strategy
- **OpenCode Adaptation**: Create multi-environment development commands
- **Key Concepts**:
  - Separate dev/stable environments
  - Database isolation
  - Socket-based service separation
- **Port to**: `.opencode/command/dev-env.md` with environment switching

**CONTRIBUTING.md** - Contribution workflow and commands

- **Value**: Clear development process and cheat sheet
- **OpenCode Adaptation**: Map to OpenCode's contribution flow
- **Key Concepts**:
  - Standardized development commands
  - Pre-commit hooks
  - PR workflow integration
- **Port to**: Project-level `CONTRIBUTING.md` with OpenCode-specific commands

### 3. Architecture Documentation

**hld/PROTOCOL.md** - JSON-RPC protocol specification

- **Value**: Complete API documentation with examples
- **OpenCode Adaptation**: Reference for OpenCode extension development
- **Key Concepts**:
  - JSON-RPC 2.0 implementation
  - Session management patterns
  - Event subscription model
  - Approval workflow design
- **Port to**: Reference documentation for OpenCode plugin development

**humanlayer-wui/docs/ARCHITECTURE.md** - System architecture overview

- **Value**: Clear layer separation and data flow documentation
- **OpenCode Adaptation**: Guide for OpenCode extension architecture
- **Key Concepts**:
  - Frontend/Hooks/Client separation
  - Type safety across layers
  - Data enrichment patterns
  - Error handling strategies
- **Port to**: OpenCode extension development guide

**humanlayer-wui/docs/DEVELOPER_GUIDE.md** - Frontend development patterns

- **Value**: Best practices for UI development with daemon integration
- **OpenCode Adaptation**: Patterns for OpenCode UI extensions
- **Key Concepts**:
  - Hook-based architecture
  - Type safety principles
  - Error handling patterns
  - Real-time update management
- **Port to**: OpenCode UI development guidelines

### 4. Specialized Documentation

**hlyr/config.md** - Configuration management

- **Value**: Configuration patterns and environment handling
- **OpenCode Adaptation**: OpenCode configuration best practices
- **Port to**: `.opencode/config/` documentation templates

**humanlayer-wui/docs/API.md** - API reference documentation

- **Value**: Complete API documentation with examples
- **OpenCode Adaptation**: Reference for OpenCode API design
- **Port to**: OpenCode API documentation templates

### Implementation Priority for Additional Documents

#### High Priority (Immediate Value)

1. **DEVELOPMENT.md** → Environment management commands
2. **CONTRIBUTING.md** → Contribution guidelines

#### Medium Priority (Structural Value)

4. **hld/PROTOCOL.md** → Extension development reference
5. **humanlayer-wui/docs/ARCHITECTURE.md** → Architecture patterns
6. **humanlayer-wui/docs/DEVELOPER_GUIDE.md** → UI development patterns

#### Low Priority (Reference Value)

7. **Configuration and API docs** → Template documentation

### OpenCode-Specific Adaptations

#### Environment Management

```bash
# Create dev environment command
.opencode/command/dev-env.md:
---
description: Manage development environments
---
Create isolated development environments with separate databases and configurations.
Usage: /dev-env [create|switch|cleanup]
```

#### Architecture Patterns

```markdown
# OpenCode Extension Architecture Guide

Based on HumanLayer's architecture patterns:

- Layer separation (UI/Hooks/Client)
- Type safety across boundaries
- Data enrichment in middleware
- Error handling at each layer
```

## Additional Valuable Commands to Port

### 1. Workflow Automation Commands

**oneshot.md** - Research and planning automation

- **Value**: Automated research-to-planning workflow
- **OpenCode Adaptation**: Create automated research agents
- **Port to**: `.opencode/command/research-plan.md`

**oneshot_plan.md** - End-to-end ticket execution

- **Value**: Complete plan-to-implementation automation
- **OpenCode Adaptation**: Automated implementation pipeline
- **Port to**: `.opencode/command/execute-ticket.md`

**founder_mode.md** - Experimental feature workflow

- **Value**: Retroactive ticket and PR creation for experimental work
- **OpenCode Adaptation**: Post-hoc documentation workflow
- **Port to**: `.opencode/command/experimental-to-ticket.md`

### 2. Development Environment Commands

**local_review.md** - Collaborative review setup

- **Value**: Sophisticated branch review environment management
- **OpenCode Adaptation**: Multi-repo review workflow
- **Key Features**:
  - Remote worktree management
  - Environment isolation
  - Dependency setup automation
- **Port to**: `.opencode/command/setup-review.md`

### 3. Integration Commands

**linear.md** - Comprehensive ticket management

- **Value**: Complete Linear integration with workflow automation
- **OpenCode Adaptation**: Issue tracking integration
- **Key Features**:
  - Team workflow management
  - Automatic label assignment
  - Thoughts document integration
  - Status progression automation
- **Port to**: `.opencode/command/ticket.md` with issue tracker integration

**describe_pr.md** & **ci_describe_pr.md** - PR description automation

- **Value**: Automated PR description generation with verification
- **OpenCode Adaptation**: PR workflow automation
- **Key Features**:
  - Template-based descriptions
  - Automated verification
  - Diff analysis
  - Checklist management
- **Port to**: `.opencode/command/pr.md`

### 4. Specialized Agent Commands

**ralph_research.md**, **ralph_plan.md**, **ralph_impl.md** - Specialized workflow agents

- **Value**: Role-specific research and implementation agents
- **OpenCode Adaptation**: Specialized subagents
- **Port to**: `.opencode/agent/` directory with specialized roles

## Complete Porting Strategy

### Phase 1: Core Workflow Commands

1. `create_plan.md` → `.opencode/command/plan.md`
2. `implement_plan.md` → `.opencode/command/implement.md`
3. `validate_plan.md` → `.opencode/command/validate.md`
4. `research_codebase.md` → `.opencode/command/research.md`

### Phase 2: Automation Commands

5. `oneshot.md` → `.opencode/command/research-plan.md`
6. `oneshot_plan.md` → `.opencode/command/execute-ticket.md`
7. `linear.md` → `.opencode/command/ticket.md`
8. `describe_pr.md` → `.opencode/command/pr.md`

### Phase 3: Environment & Collaboration

9. `local_review.md` → `.opencode/command/setup-review.md`
10. `founder_mode.md` → `.opencode/command/experimental-to-ticket.md`
11. `commit.md` → `.opencode/command/commit.md` (adapt for OpenCode's Git integration)

### Phase 4: Specialized Agents

12. Research agents → `.opencode/agent/researcher.md`
13. Analysis agents → `.opencode/agent/analyzer.md`
14. Review agents → `.opencode/agent/reviewer.md`

### OpenCode-Specific Enhancements

#### Multi-Provider Support

- Replace Claude-specific references with provider-agnostic language
- Add model selection for different task types
- Support for local models and specialized providers

#### Git Integration

- Leverage OpenCode's built-in `/undo` and `/redo`
- Use `/sessions` for multi-session management
- Integrate with OpenCode's permission system

#### Terminal Optimization

- Use `!` command integration for shell operations
- Leverage `@` file references for context
- Create keyboard shortcuts for common workflows

#### Permission-Based Safety

- Map approval workflows to `ask` permissions
- Create read-only agents for code review
- Use agent switching for different trust levels

## Final OpenCode Structure

```
.opencode/
├── command/
│   ├── plan.md              # Planning workflow
│   ├── implement.md          # Implementation workflow
│   ├── validate.md           # Validation workflow
│   ├── research.md           # Codebase research
│   ├── research-plan.md       # Automated research-to-plan
│   ├── execute-ticket.md      # End-to-end execution
│   ├── ticket.md             # Issue tracking integration
│   ├── pr.md                # PR workflow automation
│   ├── setup-review.md       # Collaborative review setup
│   ├── experimental-to-ticket.md # Retroactive documentation
│   ├── commit.md            # Git workflow (adapted)
│   └── dev-env.md           # Environment management
├── agent/
│   ├── researcher.md         # Codebase research agent
│   ├── analyzer.md          # Code analysis agent
│   ├── locator.md           # File location agent
│   ├── pattern-finder.md    # Pattern detection agent
│   └── reviewer.md         # Code review agent
└── opencode.json           # Configuration
```

## Additional Workflow & Session Management Commands

### Session Handoff System

**create_handoff.md** & **resume_handoff.md** - Session continuity management

- **Value**: Sophisticated handoff/resume workflow for session continuity
- **OpenCode Adaptation**: Session state persistence and recovery
- **Key Features**:
  - Structured handoff format with metadata
  - Artifact tracking and references
  - Learning capture and transfer
  - Action item continuity
- **Port to**: `.opencode/command/handoff.md` and `.opencode/command/resume.md`

**create_worktree.md** - Implementation environment setup

- **Value**: Automated worktree creation for isolated development
- **OpenCode Adaptation**: Environment isolation for OpenCode
- **Key Features**:
  - Git worktree management
  - Branch-specific environments
  - Automated session launching
- **Port to**: `.opencode/command/setup-impl.md`

### Specialized Planning Variants

**create_plan_generic.md** - Generic planning without Claude-specific features

- **Value**: Framework-agnostic planning methodology
- **OpenCode Adaptation**: Direct port with provider-neutral language
- **Port to**: Replace core `create_plan.md` with this generic version

**research_codebase_generic.md** & **research_codebase_nt.md** - Specialized research variants

- **Value**: Different research approaches for different contexts
- **OpenCode Adaptation**: Research methodology variations
- **Port to**: `.opencode/command/research-generic.md` and `.opencode/command/research-focused.md`

### CI/CD Integration

**ci_commit.md** - Automated commit workflow

- **Value**: CI/CD integrated commit process
- **OpenCode Adaptation**: Git automation for OpenCode
- **Port to**: `.opencode/command/auto-commit.md`

## Complete HumanLayer Command Inventory

### Core Workflow Commands (8)

1. `create_plan.md` - Interactive planning with research
2. `create_plan_generic.md` - Framework-agnostic planning
3. `create_plan_nt.md` - Non-thinking planning variant
4. `implement_plan.md` - Implementation execution
5. `iterate_plan.md` - Plan iteration and updates
6. `validate_plan.md` - Implementation verification
7. `commit.md` - Git workflow management
8. `ci_commit.md` - CI/CD automation
9. `debug.md` - Issue investigation

### Research & Analysis Commands (6)

10. `research_codebase.md` - Comprehensive codebase research
11. `research_codebase_generic.md` - Generic research methodology
12. `research_codebase_nt.md` - Non-evaluative research
13. `oneshot.md` - Research-to-planning automation
14. `ralph_research.md` - Specialized research agent

### Automation & Workflow Commands (8)

15. `oneshot_plan.md` - End-to-end automation
16. `linear.md` - Issue tracking integration
17. `describe_pr.md` - PR description automation
18. `ci_describe_pr.md` - CI/CD PR workflow
19. `founder_mode.md` - Experimental retroactive documentation
20. `local_review.md` - Collaborative review setup
21. `create_worktree.md` - Implementation environment
22. `ralph_plan.md` - Specialized planning agent
23. `ralph_impl.md` - Specialized implementation agent

### Session Management Commands (2)

24. `create_handoff.md` - Session handoff creation
25. `resume_handoff.md` - Session recovery from handoff

### Specialized Agents (6)

26. `codebase-analyzer.md` - Code analysis specialist
27. `codebase-locator.md` - File discovery specialist
28. `codebase-pattern-finder.md` - Pattern detection specialist
29. `thoughts-analyzer.md` - Document analysis specialist
30. `thoughts-locator.md` - Document discovery specialist
31. `web-search-researcher.md` - External research specialist

**Total: 31 orchestration files covering complete development lifecycle**

## Final Assessment

Yes, `.claude/` is definitely where the valuable orchestration files are located. HumanLayer has built a comprehensive system with:

- **25 command files** covering every aspect of development
- **6 specialized agents** for different research and analysis tasks
- **Complete workflow coverage** from idea to deployment
- **Session management system** for handoffs and continuity
- **Integration with external tools** (Linear, Git, CI/CD)
- **Sophisticated documentation patterns** with metadata and versioning

This represents one of the most complete collections of development orchestration documentation available, providing a complete blueprint that could be adapted to enhance OpenCode's capabilities significantly.

## OpenCode Integration Opportunities

### Unique OpenCode Advantages for Migration

**Superior Infrastructure**:

- Built-in permission system provides safety without external approval workflows
- Git-based undo/redo offers superior change management over manual tracking
- Multi-provider support eliminates vendor lock-in
- SDK and server mode enable programmatic workflow control
- Real-time event streaming allows for advanced integrations

**Enhanced Agent Capabilities**:

- Tab-based agent switching provides seamless workflow transitions
- Subagent system with automatic invocation based on descriptions
- Granular tool and permission configuration per agent
- Temperature and model optimization per task type
- Parent/child session navigation for complex workflows

**Advanced Configuration**:

- Schema-validated JSON/JSONC configuration with autocompletion
- Environment variable and file substitution for deployment flexibility
- Global and project-specific configuration hierarchy
- Theme and keybind customization for user experience
- MCP server integration for external tool support

### Migration Synergies

**Direct Mapping Opportunities**:

- HumanLayer's approval workflows → OpenCode's permission system
- HumanLayer's session management → OpenCode's session system with sharing
- HumanLayer's research agents → OpenCode's subagents with enhanced capabilities
- HumanLayer's command system → OpenCode's markdown-based commands with superpowers
- HumanLayer's file operations → OpenCode's `@` references and `!` integration

**Enhanced Capabilities**:

- Parallel task execution using OpenCode's subagent system
- Real-time collaboration via session sharing instead of daemon coordination
- Provider-agnostic workflows supporting multiple AI models
- Programmatic control via SDK for automation and integrations
- Advanced file search with text, files, and symbols

### Strategic Implementation Recommendations

**Phase 1: Foundation**

1. Port core planning commands leveraging OpenCode's Plan agent
2. Adapt research methodology using General subagent
3. Implement Git integration using OpenCode's built-in capabilities
4. Create basic agent definitions with appropriate permissions

**Phase 2: Enhancement**

1. Implement advanced workflows using OpenCode's session management
2. Create specialized agents with granular tool permissions
3. Integrate with OpenCode's SDK for programmatic control
4. Add multi-provider support for different task types

**Phase 3: Optimization**

1. Implement custom tools using OpenCode's tool system
2. Create advanced integrations using event streaming
3. Optimize workflows for different model capabilities
4. Build specialized plugins for unique requirements

The migration to OpenCode represents not just a port, but an opportunity to enhance HumanLayer's sophisticated workflows with OpenCode's superior infrastructure, multi-provider support, and advanced agent capabilities.

## Missing Orchestration Files Analysis

### Currently Missing from OpenCode

Based on the complete inventory, **all 31 orchestration files** from HumanLayer are currently missing from OpenCode. This represents a significant opportunity to enhance OpenCode's capabilities with proven development workflows.

### Complete Missing Files List

**Core Workflow Commands (9 files):**

- `create_plan.md` - Interactive planning with research phases
- `create_plan_generic.md` - Framework-agnostic planning methodology
- `create_plan_nt.md` - Non-thinking planning variant
- `implement_plan.md` - Structured implementation with verification
- `iterate_plan.md` - Plan iteration and update processes
- `validate_plan.md` - Implementation verification workflow
- `commit.md` - Git workflow management without AI attribution
- `ci_commit.md` - CI/CD integrated commit automation
- `debug.md` - Systematic debugging methodology

**Research & Analysis Commands (6 files):**

- `research_codebase.md` - Comprehensive codebase research with parallel tasks
- `research_codebase_generic.md` - Generic research methodology
- `research_codebase_nt.md` - Non-evaluative research approach
- `oneshot.md` - Research-to-planning automation
- `ralph_research.md` - Specialized research agent

**Automation & Workflow Commands (9 files):**

- `oneshot_plan.md` - End-to-end ticket execution automation
- `linear.md` - Comprehensive Linear integration with workflow automation
- `describe_pr.md` - PR description generation with verification
- `ci_describe_pr.md` - CI/CD integrated PR workflow
- `founder_mode.md` - Retroactive documentation for experimental work
- `local_review.md` - Collaborative review environment setup
- `create_worktree.md` - Implementation environment automation
- `ralph_plan.md` - Specialized planning agent
- `ralph_impl.md` - Specialized implementation agent

**Session Management Commands (2 files):**

- `create_handoff.md` - Session handoff creation with metadata
- `resume_handoff.md` - Session recovery from handoff

**Specialized Agents (6 files):**

- `codebase-analyzer.md` - Code analysis specialist agent
- `codebase-locator.md` - File discovery specialist agent
- `codebase-pattern-finder.md` - Pattern detection specialist agent
- `thoughts-analyzer.md` - Document analysis specialist agent
- `thoughts-locator.md` - Document discovery specialist agent
- `web-search-researcher.md` - External research specialist agent

### Implementation Priority Matrix

**Phase 1: Core Foundation (High Impact, Low Complexity)**

1. `create_plan.md` - Foundation for all planning workflows
2. `implement_plan.md` - Core implementation methodology
3. `research_codebase.md` - Essential research capabilities
4. `commit.md` - Git workflow integration

**Phase 2: Workflow Enhancement (High Impact, Medium Complexity)** 5. `validate_plan.md` - Quality assurance workflow 6. `debug.md` - Systematic problem solving 7. `oneshot.md` - Automation foundation 8. `linear.md` - Issue tracking integration

**Phase 3: Advanced Features (Medium Impact, High Complexity)** 9. Session management commands (handoff/resume) 10. Specialized agents (analysis, location, patterns) 11. CI/CD integration commands 12. Environment management commands

**Phase 4: Specialization (Low Impact, Medium Complexity)** 13. Role-specific agents (ralph\__) 14. Generic variants (_\_generic.md, \*\_nt.md) 15. Experimental workflows (founder_mode.md)

This research identifies that HumanLayer's markdown orchestration files contain valuable, portable development workflows that can enhance OpenCode's capabilities with minimal adaptation. The comprehensive collection includes **31 orchestration files** from the `.claude/` directory covering planning, implementation, research, collaboration, automation, session management, and specialized agents that would significantly benefit OpenCode's ecosystem while leveraging its superior multi-provider support and built-in safety features.

## Session Text Addition Mechanism Research

### Issue Identified

**Problem**: Sessions not showing text when first prompt is a command in the OpenCode HumanLayer implementation.

**Root Cause Analysis**:

1. **Conditional Logic Pattern**: Command files contain conditional logic that skips default message when parameters are provided
2. **Location**: `.opencode/command/plan.md:17-21` and similar patterns across multiple command files
3. **User Expectation**: Initial guidance should always be visible for better UX

**Session Text Display Flow Research**:

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

**Solution Implemented**:

Modified the conditional logic in command files to **always** display initial guidance text, with conditional content based on whether parameters were provided. This ensures users see expected session text while maintaining the workflow functionality.

**Files Modified**:
- `.opencode/command/plan.md` - Primary planning command
- `.opencode/command/execute-ticket.md` - End-to-end execution command  
- `.opencode/command/research-plan.md` - Research and planning command
- `.opencode/command/handoff.md` - Session handoff command
- `.opencode/command/resume.md` - Session resume command

**Pattern Applied**:
- Always show initial guidance/message
- Include conditional content based on parameters
- Maintain existing workflow functionality

This fix ensures commands always display initial guidance text regardless of whether parameters are provided, improving user experience and session clarity.
