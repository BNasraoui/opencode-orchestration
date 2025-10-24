# Migration Guide: HumanLayer to OpenCode Orchestration

This guide helps you migrate from HumanLayer orchestration workflows to OpenCode Orchestration, preserving your existing workflows while taking advantage of OpenCode's enhanced capabilities.

## Overview

OpenCode Orchestration provides the same powerful workflows as HumanLayer, but with:

- **Superior Architecture**: Built on OpenCode's permission system and subagent capabilities
- **Enhanced Automation**: SDK integration and event streaming
- **Multi-Provider Support**: Works with multiple AI models automatically
- **Git Integration**: Built-in change management with `/undo` and `/redo`
- **Better Performance**: Optimized for parallel task execution

## Pre-Migration Checklist

### Before You Start

- [ ] Backup your current HumanLayer configuration
- [ ] Install OpenCode (https://opencode.ai)
- [ ] Test basic OpenCode functionality
- [ ] Review your current HumanLayer workflows

### Required Tools

- OpenCode CLI installed and working
- Git (for synchronization)
- Basic shell access

## Migration Process

### Step 1: Install OpenCode Orchestration

1. **Clone the repository**:

   ```bash
   git clone https://github.com/humanlayer/opencode-orchestration.git
   cd opencode-orchestration
   ```

2. **Run the installation script**:

   ```bash
   ./install.sh
   ```

3. **Verify installation**:
   ```bash
   opencode command list
   opencode agent list
   ```

### Step 2: Map Your Workflows

#### Command Mapping

| HumanLayer Command  | OpenCode Command | Notes                           |
| ------------------- | ---------------- | ------------------------------- |
| `create_plan`       | `plan`           | Same functionality, enhanced UI |
| `implement_plan`    | `implement`      | Git integration added           |
| `research_codebase` | `research`       | Subagent-based, more powerful   |
| `validate_plan`     | `validate`       | OpenCode testing framework      |
| `oneshot`           | `research-plan`  | Enhanced automation             |
| `oneshot_plan`      | `execute-ticket` | Generalized for any tracker     |
| `describe_pr`       | `pr`             | Multi-platform support          |
| `local_review`      | `setup-review`   | Session-based collaboration     |
| `create_handoff`    | `handoff`        | OpenCode session export         |
| `resume_handoff`    | `resume`         | OpenCode session import         |

#### Agent Mapping

| HumanLayer Agent          | OpenCode Agent   | Changes                      |
| ------------------------- | ---------------- | ---------------------------- |
| `codebase-analyzer`       | `analyzer`       | Read-only permissions        |
| `codebase-locator`        | `locator`        | Enhanced search              |
| `codebase-pattern-finder` | `pattern-finder` | Symbol search integration    |
| `thoughts-analyzer`       | `researcher`     | Removed thoughts/ dependency |

### Step 3: Update Your Workflow Habits

#### Permission System Changes

HumanLayer's approval system maps to OpenCode's permissions:

```
HumanLayer Approval → OpenCode Permission
------------------- → ------------------
Manual review       → ask
Auto-approve        → allow
Blocked            → deny
```

#### New Features to Adopt

1. **File References**: Use `@filename` to include files
2. **Shell Commands**: Use `!command` to execute shell commands
3. **Agent Switching**: Use Tab to switch between agents
4. **Undo/Redo**: Use `/undo` and `/redo` for change management
5. **Session Sharing**: Use `/share` for collaboration

### Step 4: Migrate Customizations

#### Custom Commands

If you have custom HumanLayer commands:

1. **Locate your custom commands**:

   ```bash
   find ~/.claude/commands -name "*.md" -not -name "*_*"
   ```

2. **Update frontmatter** (remove `model` field):

   ```yaml
   ---
   description: Your command description
   agent: build # or plan, test, general
   permissions:
     edit: allow # or deny
     bash: allow # or deny
   ---
   ```

3. **Update command references**:
   - Replace Claude Code tool references with OpenCode equivalents
   - Use `@` for file references
   - Use `!` for shell commands

4. **Copy to OpenCode**:
   ```bash
   cp your-custom-command.md ~/.config/opencode/command/
   ```

#### Custom Agents

If you have custom HumanLayer agents:

1. **Update agent configuration**:

   ```yaml
   ---
   mode: subagent
   description: Your agent description
   temperature: 0.2
   permissions:
     edit: deny # Most agents are read-only
     bash: deny
     read: allow
   tools:
     - read
     - grep
     - glob
   ---
   ```

2. **Copy to OpenCode**:
   ```bash
   cp your-custom-agent.md ~/.config/opencode/agent/
   ```

### Step 5: Configure Synchronization

Set up multi-machine synchronization:

1. **Initialize sync repository**:

   ```bash
   cd ~/.opencode-orchestration
   git remote set-url origin git@github.com:yourusername/opencode-orchestration.git
   ```

2. **Configure sync settings**:

   ```json
   {
     "sync": {
       "enabled": true,
       "remote": "github",
       "auto_sync": true
     }
   }
   ```

3. **Test synchronization**:
   ```bash
   ./scripts/sync-config.sh
   ```

## Post-Migration Verification

### Test Core Workflows

1. **Planning workflow**:

   ```bash
   opencode plan "Test migration"
   ```

2. **Research workflow**:

   ```bash
   opencode research "How does authentication work?"
   ```

3. **Implementation workflow**:

   ```bash
   opencode implement plan.md
   ```

4. **Validation workflow**:
   ```bash
   opencode validate plan.md
   ```

### Verify Customizations

1. **Check custom commands**:

   ```bash
   opencode command list
   ```

2. **Check custom agents**:

   ```bash
   opencode agent list
   ```

3. **Test agent switching**:
   ```bash
   @analyzer analyze this file
   ```

### Performance Comparison

Compare performance metrics:

| Metric             | HumanLayer | OpenCode  | Improvement     |
| ------------------ | ---------- | --------- | --------------- |
| Plan creation time | ~2-3 min   | ~1-2 min  | 30-50% faster   |
| Research accuracy  | Good       | Excellent | Better context  |
| Agent switching    | Manual     | Tab-based | Seamless        |
| Change management  | Manual     | Git-based | Version control |
| Collaboration      | Worktrees  | Sessions  | Real-time       |

## Troubleshooting

### Common Migration Issues

#### Issue: Commands not found

**Solution**: Verify files are in correct directory

```bash
ls ~/.config/opencode/command/
```

#### Issue: Permission errors

**Solution**: Check agent permissions in frontmatter

```yaml
permissions:
  edit: allow # Make sure this matches your needs
```

#### Issue: "Bad request" errors

**Solution**: Remove `model` field from frontmatter

```yaml
# Remove this line:
# model: claude-3-5-sonnet
```

#### Issue: Custom agents not working

**Solution**: Verify agent configuration syntax

```bash
opencode agent list
```

### Getting Help

1. **Check logs**: Look for error messages in OpenCode output
2. **Verify configuration**: Use `opencode config validate`
3. **Test with simple commands**: Start with basic workflows
4. **Consult documentation**: Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Advanced Migration

### Migrating Complex Workflows

For complex HumanLayer workflows:

1. **Break down into steps**: Identify individual workflow components
2. **Map to OpenCode features**: Find OpenCode equivalents
3. **Test incrementally**: Verify each step works
4. **Optimize**: Take advantage of OpenCode-specific features

### Preserving Team Workflows

For team migrations:

1. **Migrate one team member first**: Test with power user
2. **Document changes**: Create team-specific guide
3. **Train team members**: Show new features and workflows
4. **Establish new conventions**: Update team practices

### Performance Optimization

After migration, optimize performance:

1. **Configure model selection**: Set optimal models per task
2. **Enable parallel execution**: Use OpenCode's subagent system
3. **Configure caching**: Enable result caching where appropriate
4. **Monitor usage**: Track performance improvements

## Rollback Plan

If you need to rollback:

1. **Backup OpenCode config**:

   ```bash
   ./scripts/backup.sh full
   ```

2. **Restore HumanLayer**:

   ```bash
   # Restore from your HumanLayer backup
   cp -r ~/.claude-backup-* ~/.claude/
   ```

3. **Uninstall OpenCode Orchestration**:
   ```bash
   cd ~/.opencode-orchestration
   ./uninstall.sh
   ```

## Success Metrics

Your migration is successful when:

- [ ] All core workflows work in OpenCode
- [ ] Custom commands and agents function correctly
- [ ] Team members can use new workflows
- [ ] Performance is improved
- [ ] Synchronization works between machines
- [ ] Backup and recovery processes are tested

## Next Steps

After successful migration:

1. **Explore new features**: Try OpenCode-specific capabilities
2. **Optimize workflows**: Refine based on new possibilities
3. **Share feedback**: Report issues and suggest improvements
4. **Contribute**: Help improve the orchestration package

---

**Need help?** Check our [Troubleshooting Guide](TROUBLESHOOTING.md) or open an issue on GitHub.
