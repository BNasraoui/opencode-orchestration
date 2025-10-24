---
description: Create and manage multi-environment development setups
agent: build
permissions:
  edit: allow
  bash: allow
---

# Development Environment Management

You are tasked with creating and managing isolated development environments using OpenCode's session system. This enables parallel development without disrupting active work sessions.

## Environment Types

### Stable Environment

- Purpose: Regular development work
- Default session configuration
- Persistent across reboots

### Dev Environment

- Purpose: Testing breaking changes
- Isolated from stable work
- Fresh state per session

## Commands

### Create Environment

When invoked with `create [name]`:

1. **Parse parameters**:
   - If no name provided, use "dev"
   - Sanitize name for filesystem use

2. **Create session configuration**:

   ```bash
   # Create isolated session directory
   mkdir -p ~/.opencode/sessions/[name]

   # Copy base configuration
   cp ~/.opencode/config/base.json ~/.opencode/sessions/[name]/config.json

   # Set environment-specific overrides
   cat >> ~/.opencode/sessions/[name]/config.json << EOF
   {
     "session_name": "[name]",
     "isolation": true,
     "auto_save": false
   }
   EOF
   ```

3. **Initialize environment**:
   - Create session-specific workspace
   - Set up isolated tool configurations
   - Initialize dependency tracking

### Switch Environment

When invoked with `switch [name]`:

1. **Validate environment exists**
2. **Export current session state** if needed
3. **Load target environment configuration**
4. **Restart OpenCode with new session**

### List Environments

When invoked with `list`:

1. **Scan session directory**: `~/.opencode/sessions/`
2. **Display environment status**:
   - Name
   - Last accessed
   - Active processes
   - Isolation status

### Clean Environment

When invoked with `clean [name]`:

1. **Confirm environment not active**
2. **Archive session data** if requested
3. **Remove session directory**
4. **Update environment registry**

## OpenCode Integration

### Session Sharing

- Use `/share` to collaborate within environments
- Sessions maintain isolation unless explicitly shared
- Automatic environment sync for shared sessions

### Permission Management

- Each environment maintains separate permission contexts
- Inherited from base configuration with environment overrides
- Support for temporary permission elevation

### Dependency Automation

- Track environment-specific dependencies
- Auto-install missing tools when switching environments
- Maintain separate package caches per environment

## Error Handling

- **Environment exists**: Offer to switch or create new name
- **Missing dependencies**: Auto-install with confirmation
- **Active processes**: Warn before switching environments
- **Corrupted session**: Offer recovery or reset options

## Examples

```bash
# Create new dev environment
opencode dev-env create feature-x

# Switch to existing environment
opencode dev-env switch stable

# List all environments
opencode dev-env list

# Clean up unused environment
opencode dev-env clean old-feature
```

## Configuration Templates

Environment-specific configurations stored in:

- `~/.opencode/sessions/[name]/config.json`
- `~/.opencode/sessions/[name]/tools.json`
- `~/.opencode/sessions/[name]/permissions.json`

## Integration with Existing Tools

- Git worktrees: Each environment can manage separate worktrees
- Build caches: Isolated build artifacts per environment
- Database connections: Separate connection pools for testing
- API keys: Environment-specific credential management
