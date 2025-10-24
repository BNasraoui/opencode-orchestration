# Customization Guide

This guide shows you how to customize OpenCode Orchestration to fit your specific workflow needs, from simple preference changes to creating custom commands and agents.

## Table of Contents

- [Configuration](#configuration)
- [Custom Commands](#custom-commands)
- [Custom Agents](#custom-agents)
- [Workflow Customization](#workflow-customization)
- [Environment-Specific Settings](#environment-specific-settings)
- [Advanced Customization](#advanced-customization)
- [Examples](#examples)

## Configuration

### Personal Configuration

Edit your personal configuration at `~/.config/opencode/config/personal.json`:

```json
{
  "preferences": {
    "default_agent": "build",
    "auto_save": true,
    "theme": "dark",
    "editor": {
      "tab_size": 2,
      "word_wrap": true,
      "line_numbers": true
    }
  },
  "workflow": {
    "auto_create_plans": true,
    "require_validation": true,
    "parallel_research": true,
    "default_model": "auto"
  },
  "sync": {
    "enabled": false,
    "remote": "github",
    "auto_sync": false,
    "conflict_resolution": "manual"
  },
  "notifications": {
    "enabled": true,
    "types": ["completion", "error", "permission_request"],
    "sound": false
  },
  "permissions": {
    "auto_approve_readonly": true,
    "prompt_for_edits": true,
    "remember_choices": true
  }
}
```

### Configuration Options

#### Preferences

| Option                | Type    | Default | Description                      |
| --------------------- | ------- | ------- | -------------------------------- |
| `default_agent`       | string  | "build" | Default agent for new sessions   |
| `auto_save`           | boolean | true    | Automatically save session state |
| `theme`               | string  | "dark"  | UI theme (dark/light/auto)       |
| `editor.tab_size`     | number  | 2       | Default tab size                 |
| `editor.word_wrap`    | boolean | true    | Enable word wrap                 |
| `editor.line_numbers` | boolean | true    | Show line numbers                |

#### Workflow

| Option               | Type    | Default | Description                                     |
| -------------------- | ------- | ------- | ----------------------------------------------- |
| `auto_create_plans`  | boolean | true    | Auto-create plans for complex tasks             |
| `require_validation` | boolean | true    | Require validation after implementation         |
| `parallel_research`  | boolean | true    | Use parallel research when possible             |
| `default_model`      | string  | "auto"  | Default AI model (auto/gpt-4/claude-3-5-sonnet) |

#### Synchronization

| Option                | Type    | Default  | Description                                |
| --------------------- | ------- | -------- | ------------------------------------------ |
| `enabled`             | boolean | false    | Enable synchronization                     |
| `remote`              | string  | "github" | Remote service (github/gitlab/custom)      |
| `auto_sync`           | boolean | false    | Automatically sync changes                 |
| `conflict_resolution` | string  | "manual" | How to handle conflicts (manual/auto/user) |

## Custom Commands

### Creating a Custom Command

1. **Create command file**:

   ```bash
   touch ~/.config/opencode/command/my-command.md
   ```

2. **Add frontmatter**:

   ```yaml
   ---
   description: Your command description
   agent: build
   permissions:
     edit: allow
     bash: allow
   ---
   ```

3. **Add command logic**:

   ```markdown
   # My Custom Command

   This command does something specific for my workflow.

   ## Steps

   1. First step
   2. Second step
   3. Final step

   ## Usage

   Run this command when you need to...
   ```

### Command Templates

#### Simple Command Template

```yaml
---
description: Simple command with basic functionality
agent: build
permissions:
  edit: allow
  bash: allow
---

# Simple Command

This is a template for a simple command.

## What it does

- Performs a specific task
- Uses basic file operations
- Has clear success criteria

## Implementation

1. Analyze the current state
2. Perform the required action
3. Verify the result
```

#### Research Command Template

```yaml
---
description: Research-focused command with read-only access
agent: general
permissions:
  edit: deny
  bash: deny
---

# Research Command Template

This command performs research and analysis.

## Research Areas

- Codebase structure
- Implementation patterns
- Best practices

## Process

1. Use @analyzer to understand the codebase
2. Use @locator to find relevant files
3. Use @pattern-finder to identify patterns
4. Synthesize findings into recommendations
```

#### Automation Command Template

```yaml
---
description: Automated workflow with full system access
agent: build
permissions:
  edit: allow
  bash: allow
---

# Automation Command Template

This command automates a complex workflow.

## Automation Steps

1. !git status - Check current state
2. @analyzer - Analyze affected files
3. Make necessary changes
4. !git add . - Stage changes
5. !git commit -m "Automated change" - Commit
6. Verify results

## Error Handling

- Rollback on failure
- Create backup before changes
- Log all actions
```

### Command Best Practices

1. **Clear descriptions**: Explain what the command does
2. **Appropriate permissions**: Request minimum necessary permissions
3. **Error handling**: Include rollback procedures
4. **Documentation**: Provide usage examples
5. **Testing**: Include verification steps

## Custom Agents

### Creating a Custom Agent

1. **Create agent file**:

   ```bash
   touch ~/.config/opencode/agent/my-agent.md
   ```

2. **Add agent configuration**:

   ```yaml
   ---
   mode: subagent
   description: Specialized agent for specific tasks
   temperature: 0.2
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

3. **Add agent instructions**:

   ```markdown
   # My Custom Agent

   You are a specialized agent focused on...

   ## Your Role

   - Specific task 1
   - Specific task 2
   - Specific task 3

   ## Guidelines

   - Always provide file:line references
   - Focus on accuracy and detail
   - Ask for clarification when needed
   ```

### Agent Templates

#### Analysis Agent Template

```yaml
---
mode: subagent
description: Code analysis specialist
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

# Code Analysis Agent

You are a code analysis specialist focused on understanding code structure and implementation details.

## Your Expertise

- Code architecture analysis
- Design pattern identification
- Dependency mapping
- Performance analysis

## Analysis Process

1. Understand the request context
2. Examine relevant files and structure
3. Identify patterns and relationships
4. Provide detailed analysis with file:line references
5. Suggest improvements when appropriate

## Output Format

- Start with a summary
- Provide detailed findings
- Include specific file:line references
- End with recommendations
```

#### Research Agent Template

```yaml
---
mode: subagent
description: Research and documentation specialist
temperature: 0.3
permissions:
  edit: deny
  bash: deny
  read: allow
tools:
  - read
  - grep
  - glob
---

# Research Agent

You are a research specialist focused on gathering and synthesizing information.

## Your Expertise

- Documentation research
- Codebase exploration
- Best practice identification
- Trend analysis

## Research Process

1. Clarify research objectives
2. Explore relevant sources
3. Synthesize findings
4. Provide comprehensive summary
5. Include references and sources

## Output Format

- Executive summary
- Detailed findings
- Supporting evidence
- Recommendations and next steps
```

### Agent Best Practices

1. **Focused scope**: Each agent should have a clear specialty
2. **Appropriate temperature**: Lower for analytical tasks, higher for creative tasks
3. **Minimal permissions**: Request only necessary tools
4. **Clear instructions**: Provide specific guidelines and output formats
5. **Consistent style**: Maintain consistent response patterns

## Workflow Customization

### Custom Workflow Example

Create a workflow for code review:

```yaml
---
description: Comprehensive code review workflow
agent: build
permissions:
  edit: deny
  bash: allow
---

# Code Review Workflow

This workflow performs a comprehensive code review.

## Review Process

1. **Setup Analysis**
   - !git diff --name-only HEAD~1
   - @analyzer analyze changed files

2. **Code Quality Check**
   - @pattern-finder find anti-patterns
   - Check for security issues
   - Verify test coverage

3. **Documentation Review**
   - Check README updates
   - Verify API documentation
   - Review inline comments

4. **Performance Analysis**
   - Identify performance bottlenecks
   - Check resource usage
   - Suggest optimizations

5. **Generate Report**
   - Summarize findings
   - Create actionable checklist
   - Assign priority levels

## Output

- Detailed review report
- Actionable recommendations
- Priority-based task list
```

### Workflow Integration

Integrate custom workflows with existing commands:

```bash
# Create a wrapper command
opencode review-branch feature-branch

# Which calls your custom workflow
# and integrates with standard tools
```

## Environment-Specific Settings

### Work Configuration

Create `~/.config/opencode/config/work.json`:

```json
{
  "preferences": {
    "default_agent": "build",
    "auto_save": true,
    "theme": "light"
  },
  "workflow": {
    "auto_create_plans": false,
    "require_validation": true,
    "parallel_research": false
  },
  "work_specific": {
    "company": "Example Corp",
    "project_prefix": "PROJ",
    "approval_required": true,
    "log_hours": true,
    "code_reviewers": ["senior-dev@example.com"],
    "deployment_branch": "main"
  }
}
```

### Team Configuration

Create `~/.config/opencode/config/team.json`:

```json
{
  "preferences": {
    "default_agent": "plan",
    "auto_save": true,
    "theme": "auto"
  },
  "workflow": {
    "auto_create_plans": true,
    "require_validation": true,
    "parallel_research": true,
    "team_review": true
  },
  "team_specific": {
    "members": ["dev1@example.com", "dev2@example.com"],
    "reviewers": ["lead@example.com"],
    "standup_time": "09:00",
    "timezone": "America/New_York",
    "slack_channel": "#dev-team",
    "rotation_schedule": "weekly"
  }
}
```

### Switching Environments

Create environment switching scripts:

```bash
#!/bin/bash
# switch-env.sh

ENVIRONMENT="${1:-personal}"
CONFIG_DIR="$HOME/.config/opencode/config"

case "$ENVIRONMENT" in
  personal)
    cp "$CONFIG_DIR/personal.json" "$CONFIG_DIR/active.json"
    ;;
  work)
    cp "$CONFIG_DIR/work.json" "$CONFIG_DIR/active.json"
    ;;
  team)
    cp "$CONFIG_DIR/team.json" "$CONFIG_DIR/active.json"
    ;;
  *)
    echo "Unknown environment: $ENVIRONMENT"
    echo "Usage: $0 [personal|work|team]"
    exit 1
    ;;
esac

echo "Switched to $ENVIRONMENT environment"
```

## Advanced Customization

### Custom Tool Integration

Create custom tools by extending existing commands:

````yaml
---
description: Custom tool integration example
agent: build
permissions:
  edit: allow
  bash: allow
---

# Custom Tool Integration

This command demonstrates custom tool integration.

## Custom Tools

### Database Migration Tool

```bash
# Custom migration script
migrate_database() {
  local version="$1"
  echo "Running migration to version $version"
  !npm run migrate -- --version "$version"
}
````

### API Testing Tool

```bash
# Custom API testing
test_api() {
  local endpoint="$1"
  echo "Testing API endpoint: $endpoint"
  !curl -X POST "http://localhost:3000$endpoint" \
    -H "Content-Type: application/json" \
    -d '{"test": true}'
}
```

## Usage

1. Run database migration
2. Test API endpoints
3. Verify results
4. Generate report

````

### Plugin System

Create a plugin system for extensibility:

```yaml
---
description: Plugin-enabled command
agent: build
permissions:
  edit: allow
  bash: allow
---

# Plugin-Enabled Command

This command supports plugin extensions.

## Plugin Loading

1. Load plugins from `~/.config/opencode/plugins/`
2. Initialize plugin hooks
3. Execute plugin pre/post actions

## Available Plugins

- `security-checker`: Security vulnerability scanning
- `performance-analyzer`: Performance profiling
- `documentation-generator`: Auto-documentation

## Plugin Development

Create plugins by adding `.sh` files to the plugins directory:

```bash
#!/bin/bash
# ~/.config/opencode/plugins/my-plugin.sh

plugin_pre_hook() {
  echo "Running pre-hook for my-plugin"
}

plugin_post_hook() {
  echo "Running post-hook for my-plugin"
}
````

````

## Examples

### Example 1: Custom Deployment Command

```yaml
---
description: Deploy application with custom checks
agent: build
permissions:
  edit: allow
  bash: allow
---

# Custom Deployment

Deploy application with comprehensive checks and rollback capability.

## Pre-Deployment Checks

1. !npm test - Run all tests
2. !npm run lint - Check code quality
3. !npm run security-audit - Security scan
4. @analyzer analyze deployment files

## Deployment Process

1. Create backup
2. Deploy to staging
3. Run integration tests
4. Deploy to production
5. Verify deployment

## Rollback Plan

If any step fails:
1. Restore from backup
2. Notify team
3. Document failure
````

### Example 2: Custom Documentation Agent

```yaml
---
mode: subagent
description: Documentation specialist
temperature: 0.2
permissions:
  edit: allow
  bash: deny
  read: allow
tools:
  - read
  - grep
  - glob
---

# Documentation Agent

You are a documentation specialist focused on creating and maintaining high-quality documentation.

## Your Expertise

- API documentation
- User guides
- Technical documentation
- Code comments

## Documentation Process

1. Analyze the code or feature
2. Identify documentation needs
3. Create comprehensive documentation
4. Ensure consistency and clarity
5. Update related documentation

## Documentation Standards

- Use clear, concise language
- Include code examples
- Provide step-by-step instructions
- Maintain consistent formatting
- Include troubleshooting sections
```

### Example 3: Environment-Specific Workflow

```yaml
---
description: Environment-aware development workflow
agent: build
permissions:
  edit: allow
  bash: allow
---

# Environment-Aware Workflow

This workflow adapts based on the current environment.

## Environment Detection

1. Check current environment configuration
2. Load environment-specific settings
3. Adjust workflow accordingly

## Environment-Specific Steps

### Development Environment
- Skip production checks
- Enable debug logging
- Use development database

### Staging Environment
- Run full test suite
- Use staging database
- Enable monitoring

### Production Environment
- Require approval
- Run security scans
- Enable full monitoring
- Create deployment backup

## Configuration

Environment settings are loaded from:
- `~/.config/opencode/config/personal.json`
- `~/.config/opencode/config/work.json`
- `~/.config/opencode/config/team.json`
```

## Testing Customizations

### Testing Commands

Test your custom commands:

```bash
# Test command parsing
opencode command list

# Test command execution
opencode my-command "test input"

# Test with different agents
opencode --agent general my-command "test input"
```

### Testing Agents

Test your custom agents:

```bash
# Test agent registration
opencode agent list

# Test agent functionality
@my-agent analyze this file

# Test with different temperatures
@my-agent --temperature 0.5 creative task
```

### Testing Configuration

Test configuration changes:

```bash
# Validate configuration
opencode config validate

# Test environment switching
./switch-env.sh work

# Test synchronization
./scripts/sync-config.sh
```

## Best Practices

1. **Start simple**: Begin with basic customizations
2. **Test thoroughly**: Test all customizations before deployment
3. **Document changes**: Keep documentation up to date
4. **Version control**: Track customizations in git
5. **Backup regularly**: Create backups before major changes
6. **Share with team**: Share useful customizations with your team

---

**Need more help?** Check our [Troubleshooting Guide](TROUBLESHOOTING.md) or open an issue on GitHub.
