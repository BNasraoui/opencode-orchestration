# OpenCode Orchestration

A comprehensive collection of orchestration workflows and specialized agents for OpenCode, migrated from HumanLayer with enhanced capabilities.

## Overview

OpenCode Orchestration provides powerful workflows that enhance your development experience with:

- **Planning Commands**: Create detailed implementation plans through interactive research
- **Implementation Commands**: Execute plans with full agent access and Git integration
- **Research Agents**: Specialized subagents for codebase analysis and pattern discovery
- **Automation Tools**: Streamlined workflows for common development tasks
- **Collaboration Features**: Session management and team coordination tools

## Quick Start

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/humanlayer/opencode-orchestration.git
   cd opencode-orchestration
   ```

2. **Run the installation script**:

   ```bash
   ./install.sh
   ```

3. **Restart OpenCode** to reload the commands and agents.

### Basic Usage

```bash
# Create a plan for a new feature
opencode plan "Implement user authentication"

# Research your codebase
opencode research "How does the payment system work?"

# Implement a plan
opencode implement plan.md

# Validate your implementation
opencode validate plan.md
```

## Features

### Core Commands

| Command     | Description                          | Agent   |
| ----------- | ------------------------------------ | ------- |
| `plan`      | Create detailed implementation plans | Plan    |
| `implement` | Execute plans with full access       | Build   |
| `research`  | Research codebase and documentation  | General |
| `validate`  | Validate implementations             | Test    |

### Workflow Commands

| Command            | Description                          | Use Case                  |
| ------------------ | ------------------------------------ | ------------------------- |
| `research-plan`    | Research and create plan in one step | Quick feature development |
| `execute-ticket`   | Execute issue tracker tickets        | Ticket-based development  |
| `pr`               | Generate PR descriptions             | Code review workflow      |
| `dev-env`          | Manage development environments      | Environment switching     |
| `setup-review`     | Configure collaborative review       | Team collaboration        |
| `handoff`/`resume` | Session handoff and resume           | Context sharing           |

### Specialized Agents

| Agent            | Specialization           | Permissions |
| ---------------- | ------------------------ | ----------- |
| `analyzer`       | Code structure analysis  | Read-only   |
| `locator`        | File and symbol location | Read-only   |
| `pattern-finder` | Pattern detection        | Read-only   |
| `researcher`     | General research         | Read-only   |

## Configuration

### Personal Configuration

Edit your personal configuration at `~/.config/opencode/config/personal.json`:

```json
{
  "preferences": {
    "default_agent": "build",
    "auto_save": true,
    "theme": "dark"
  },
  "workflow": {
    "auto_create_plans": true,
    "require_validation": true
  },
  "sync": {
    "enabled": false,
    "remote": "github"
  }
}
```

### Environment-Specific Configurations

- **Personal**: `personal.json` - Your individual preferences
- **Work**: `work.json` - Work-specific settings (local only)
- **Team**: `team.json` - Team collaboration settings

## Synchronization

Keep your orchestration configuration synchronized across multiple machines:

```bash
# Sync configuration from remote
./scripts/sync-config.sh

# Push local changes to remote
./scripts/sync-config.sh --push-only

# Pull only remote changes
./scripts/sync-config.sh --pull-only
```

## Backup and Recovery

### Creating Backups

```bash
# Full backup
./scripts/backup.sh full

# Configuration only
./scripts/backup.sh config

# Custom backup
CUSTOM_INCLUDE='*.md,*.json' ./scripts/backup.sh custom
```

### Managing Backups

```bash
# List all backups
./scripts/backup.sh --list

# Restore from backup
./scripts/backup.sh --restore full-backup-20231201-120000

# Clean old backups (older than 30 days)
./scripts/backup.sh --cleanup 30
```

## Updates

### Checking for Updates

```bash
./scripts/update.sh --check-only
```

### Updating to New Version

```bash
# Standard update (preserves customizations)
./scripts/update.sh

# Force update
./scripts/update.sh --force

# Update without preserving modified files
./scripts/update.sh --no-preserve-mods
```

## Advanced Usage

### Multi-Provider Workflows

OpenCode Orchestration supports multiple AI providers automatically. The system will:

- Select optimal models for different tasks
- Handle provider-specific optimizations
- Provide fallback mechanisms
- Manage cost-aware routing

### Custom Commands

Create custom commands by adding `.md` files to `~/.config/opencode/command/`:

```yaml
---
description: Your custom command description
agent: build
permissions:
  edit: allow
  bash: allow
---
```

### Custom Agents

Create specialized agents by adding `.md` files to `~/.config/opencode/agent/`:

```yaml
---
mode: subagent
description: Your agent description
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

## Development

### Testing Commands During Development

When developing commands in a repository:

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
   ```

### Common Issues

- **"Bad request" error**: Remove `model` field from frontmatter
- **Permission denied**: Check agent has required permissions
- **Command not found**: Verify files in correct directory
- **Agent not responding**: Check agent configuration syntax

## Uninstallation

Remove OpenCode Orchestration completely:

```bash
./uninstall.sh
```

This will:

- Remove all orchestration commands and agents
- Remove configuration templates
- Preserve your personal configuration files
- Create a backup before removal

## Support

### Documentation

- [Migration Guide](docs/MIGRATION.md) - Migrating from HumanLayer
- [Customization Guide](docs/CUSTOMIZATION.md) - Customizing your setup
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions

### Getting Help

- **Issues**: Report bugs and request features on GitHub
- **Discussions**: Ask questions and share workflows
- **Documentation**: Check the docs directory for detailed guides

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

This project is based on the orchestration workflows originally developed for HumanLayer, enhanced and adapted for OpenCode's superior architecture.

---

**OpenCode Orchestration** - Enhancing development workflows with intelligent automation.
