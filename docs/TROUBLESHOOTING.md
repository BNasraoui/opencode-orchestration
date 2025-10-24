# Troubleshooting Guide

This guide helps you diagnose and resolve common issues with OpenCode Orchestration.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Command Problems](#command-problems)
- [Agent Issues](#agent-issues)
- [Configuration Problems](#configuration-problems)
- [Synchronization Issues](#synchronization-issues)
- [Performance Problems](#performance-problems)
- [Permission Errors](#permission-errors)
- [Backup and Recovery](#backup-and-recovery)
- [Getting Help](#getting-help)

## Installation Issues

### Issue: "OpenCode is not installed"

**Error**: `OpenCode is not installed or not in PATH`

**Solutions**:

1. **Install OpenCode**:

   ```bash
   # Visit https://opencode.ai for installation instructions
   curl -fsSL https://opencode.ai/install.sh | sh
   ```

2. **Check PATH**:

   ```bash
   echo $PATH | grep opencode
   ```

3. **Add to PATH** (if needed):
   ```bash
   export PATH="$PATH:/usr/local/bin/opencode"
   echo 'export PATH="$PATH:/usr/local/bin/opencode"' >> ~/.bashrc
   ```

### Issue: "Permission denied" during installation

**Error**: `Permission denied` when running `./install.sh`

**Solutions**:

1. **Make script executable**:

   ```bash
   chmod +x install.sh
   ```

2. **Check directory permissions**:

   ```bash
   ls -la ~/.config/
   mkdir -p ~/.config/opencode
   ```

3. **Run with appropriate permissions**:
   ```bash
   # Don't use sudo unless necessary
   ./install.sh
   ```

### Issue: "Bad request" errors

**Error**: Commands fail with "bad request" error

**Cause**: Invalid frontmatter in command files

**Solutions**:

1. **Remove `model` field from frontmatter**:

   ```yaml
   # Remove this line:
   model: claude-3-5-sonnet

   # Keep only these fields:
   ---
   description: Your command description
   agent: build
   permissions:
     edit: allow
     bash: allow
   ---
   ```

2. **Validate frontmatter syntax**:

   ```bash
   # Check for YAML syntax errors
   python -c "import yaml; yaml.safe_load(open('command.md'))"
   ```

3. **Use template**:
   ```bash
   cp .opencode/command/plan.md ~/.config/opencode/command/my-command.md
   # Then modify the copy
   ```

## Command Problems

### Issue: Command not found

**Error**: `Command not found: my-command`

**Solutions**:

1. **Check command directory**:

   ```bash
   ls ~/.config/opencode/command/
   ```

2. **Verify file extension**:

   ```bash
   # Commands must have .md extension
   mv my-command ~/.config/opencode/command/my-command.md
   ```

3. **Restart OpenCode**:

   ```bash
   pkill -f opencode
   # Then restart OpenCode
   ```

4. **Check command registration**:
   ```bash
   opencode command list
   ```

### Issue: Command execution fails

**Error**: Command starts but fails during execution

**Solutions**:

1. **Check command syntax**:

   ```bash
   # Validate YAML frontmatter
   opencode config validate
   ```

2. **Check permissions**:

   ```bash
   # Verify agent has required permissions
   grep -A 5 "permissions:" ~/.config/opencode/command/my-command.md
   ```

3. **Test with verbose output**:

   ```bash
   opencode --verbose my-command "test"
   ```

4. **Check for missing dependencies**:
   ```bash
   # Verify required tools are available
   which git npm python
   ```

### Issue: Command hangs or freezes

**Error**: Command starts but never completes

**Solutions**:

1. **Check for infinite loops**:
   - Review command logic for potential infinite loops
   - Add timeout conditions

2. **Check resource usage**:

   ```bash
   # Monitor system resources
   top -p $(pgrep opencode)
   ```

3. **Kill and restart**:

   ```bash
   pkill -f opencode
   # Then restart and try again
   ```

4. **Test with simpler input**:
   ```bash
   opencode my-command "simple test"
   ```

## Agent Issues

### Issue: Agent not found

**Error**: `Agent not found: my-agent`

**Solutions**:

1. **Check agent directory**:

   ```bash
   ls ~/.config/opencode/agent/
   ```

2. **Verify file extension**:

   ```bash
   # Agents must have .md extension
   mv my-agent ~/.config/opencode/agent/my-agent.md
   ```

3. **Check agent registration**:

   ```bash
   opencode agent list
   ```

4. **Restart OpenCode**:
   ```bash
   pkill -f opencode
   # Then restart OpenCode
   ```

### Issue: Agent permission errors

**Error**: `Permission denied` when using agent

**Solutions**:

1. **Check agent permissions**:

   ```bash
   grep -A 10 "permissions:" ~/.config/opencode/agent/my-agent.md
   ```

2. **Update permissions**:

   ```yaml
   permissions:
     edit: allow # or deny
     bash: allow # or deny
     read: allow # or deny
   ```

3. **Use appropriate agent**:

   ```bash
   # Use build agent for file operations
   @build-agent edit files

   # Use general agent for read-only operations
   @general-agent research topic
   ```

### Issue: Agent gives poor responses

**Error**: Agent responses are low quality or irrelevant

**Solutions**:

1. **Adjust temperature**:

   ```yaml
   temperature: 0.1  # Lower for analytical tasks
   temperature: 0.7  # Higher for creative tasks
   ```

2. **Improve instructions**:

   ```markdown
   # Be specific about expected output format

   # Provide clear examples

   # Define success criteria
   ```

3. **Check tool access**:
   ```yaml
   tools:
     - read
     - grep
     - glob
     # Add other tools as needed
   ```

## Configuration Problems

### Issue: Configuration not loading

**Error**: Settings not applied or configuration ignored

**Solutions**:

1. **Check configuration path**:

   ```bash
   ls ~/.config/opencode/config/
   ```

2. **Validate JSON syntax**:

   ```bash
   python -c "import json; json.load(open('config.json'))"
   ```

3. **Check active configuration**:

   ```bash
   opencode config show
   ```

4. **Reload configuration**:
   ```bash
   opencode config reload
   ```

### Issue: Environment switching not working

**Error**: Changes to environment-specific configs not applied

**Solutions**:

1. **Verify config files exist**:

   ```bash
   ls ~/.config/opencode/config/{personal,work,team}.json
   ```

2. **Check config switching script**:

   ```bash
   # Test environment switching
   ./switch-env.sh work
   ```

3. **Validate configuration merge**:
   ```bash
   opencode config validate
   ```

### Issue: Synchronization configuration errors

**Error**: Sync fails or doesn't work as expected

**Solutions**:

1. **Check sync configuration**:

   ```bash
   cat ~/.config/opencode/config/sync.json
   ```

2. **Verify remote access**:

   ```bash
   cd ~/.opencode-orchestration
   git remote -v
   git pull origin main
   ```

3. **Test sync manually**:
   ```bash
   ./scripts/sync-config.sh --pull-only
   ```

## Synchronization Issues

### Issue: Sync conflicts

**Error**: Merge conflicts during synchronization

**Solutions**:

1. **Manual conflict resolution**:

   ```bash
   cd ~/.opencode-orchestration
   git status
   # Resolve conflicts manually
   git add .
   git commit -m "Resolve sync conflicts"
   ```

2. **Backup and restore**:

   ```bash
   ./scripts/backup.sh full
   # Then choose which version to keep
   ```

3. **Configure conflict resolution**:
   ```json
   {
     "sync": {
       "conflict_resolution": "manual"  # or "auto", "user"
     }
   }
   ```

### Issue: Sync not pushing changes

**Error**: Local changes not synchronized to remote

**Solutions**:

1. **Check remote configuration**:

   ```bash
   git remote -v
   git config --get remote.origin.url
   ```

2. **Test push manually**:

   ```bash
   cd ~/.opencode-orchestration
   git add .
   git commit -m "Test push"
   git push origin main
   ```

3. **Check authentication**:

   ```bash
   # For GitHub
   ssh -T git@github.com

   # Or configure token
   git config --global credential.helper store
   ```

### Issue: Sync not pulling changes

**Error**: Remote changes not appearing locally

**Solutions**:

1. **Check network connectivity**:

   ```bash
   ping github.com
   ```

2. **Fetch latest changes**:

   ```bash
   cd ~/.opencode-orchestration
   git fetch origin
   git log HEAD..origin/main --oneline
   ```

3. **Force pull**:
   ```bash
   git reset --hard origin/main
   ```

## Performance Problems

### Issue: Slow command execution

**Error**: Commands take too long to complete

**Solutions**:

1. **Check system resources**:

   ```bash
   # Monitor CPU and memory
   top -p $(pgrep opencode)

   # Check disk space
   df -h
   ```

2. **Optimize agent temperature**:

   ```yaml
   temperature: 0.1 # Lower temperature for faster responses
   ```

3. **Enable parallel execution**:

   ```json
   {
     "workflow": {
       "parallel_research": true
     }
   }
   ```

4. **Use appropriate models**:
   ```json
   {
     "workflow": {
       "default_model": "gpt-4"  # Faster than claude-3-5-sonnet
     }
   }
   ```

### Issue: High memory usage

**Error**: OpenCode using excessive memory

**Solutions**:

1. **Restart OpenCode**:

   ```bash
   pkill -f opencode
   # Then restart
   ```

2. **Clear cache**:

   ```bash
   rm -rf ~/.config/opencode/cache/
   ```

3. **Reduce context window**:
   ```json
   {
     "preferences": {
       "max_context_tokens": 4000
     }
   }
   ```

### Issue: Network timeouts

**Error**: Operations timeout due to network issues

**Solutions**:

1. **Increase timeout values**:

   ```json
   {
     "network": {
       "timeout_seconds": 120,
       "retry_attempts": 3
     }
   }
   ```

2. **Check network connection**:

   ```bash
   ping -c 4 api.openai.com
   ping -c 4 api.anthropic.com
   ```

3. **Use local models** (if available):
   ```json
   {
     "workflow": {
       "default_model": "local"
     }
   }
   ```

## Permission Errors

### Issue: "Edit not allowed" errors

**Error**: Agent cannot edit files despite needing to

**Solutions**:

1. **Check agent permissions**:

   ```yaml
   permissions:
     edit: allow # Must be allow for editing
   ```

2. **Use appropriate agent**:

   ```bash
   # Use build agent for editing
   @build-agent edit file.md

   # Not general agent (read-only)
   ```

3. **Check file permissions**:
   ```bash
   ls -la file.md
   chmod 644 file.md
   ```

### Issue: "Bash not allowed" errors

**Error**: Agent cannot execute shell commands

**Solutions**:

1. **Enable bash permissions**:

   ```yaml
   permissions:
     bash: allow # Must be allow for shell commands
   ```

2. **Use correct syntax**:

   ```bash
   # Use ! prefix for shell commands
   !git status
   !npm test
   ```

3. **Check command availability**:
   ```bash
   which git npm python
   ```

## Backup and Recovery

### Issue: Backup creation fails

**Error**: Cannot create backup files

**Solutions**:

1. **Check disk space**:

   ```bash
   df -h
   ```

2. **Check backup directory permissions**:

   ```bash
   ls -la ~/.opencode-backups/
   mkdir -p ~/.opencode-backups
   ```

3. **Run backup manually**:
   ```bash
   ./scripts/backup.sh full --verbose
   ```

### Issue: Cannot restore from backup

**Error**: Backup restoration fails

**Solutions**:

1. **Verify backup integrity**:

   ```bash
   ./scripts/backup.sh --list
   ```

2. **Check backup metadata**:

   ```bash
   cat ~/.opencode-backups/backup-*/metadata.json
   ```

3. **Manual restore**:
   ```bash
   rm -rf ~/.config/opencode
   cp -r ~/.opencode-backups/backup-* ~/.config/opencode
   ```

## Getting Help

### Diagnostic Information

Collect diagnostic information before seeking help:

```bash
# System information
opencode --version
uname -a

# Configuration
opencode config show
ls -la ~/.config/opencode/

# Commands and agents
opencode command list
opencode agent list

# Recent errors
tail -f ~/.config/opencode/logs/error.log
```

### Log Files

Check log files for detailed error information:

```bash
# Main log
tail -f ~/.config/opencode/logs/opencode.log

# Error log
tail -f ~/.config/opencode/logs/error.log

# Command execution log
tail -f ~/.config/opencode/logs/commands.log
```

### Community Support

1. **GitHub Issues**: Report bugs and request features
2. **GitHub Discussions**: Ask questions and share solutions
3. **Documentation**: Check for updated guides and examples

### Reporting Issues

When reporting issues, include:

1. **System information**:
   - OpenCode version
   - Operating system
   - Orchestration version

2. **Error details**:
   - Full error message
   - Steps to reproduce
   - Expected vs actual behavior

3. **Configuration**:
   - Relevant configuration settings
   - Custom commands/agents involved

4. **Logs**:
   - Relevant log entries
   - Diagnostic output

### Common Debugging Commands

```bash
# Validate configuration
opencode config validate

# Test command parsing
opencode --dry-run my-command "test"

# Check agent permissions
opencode agent test my-agent

# Verify file permissions
ls -la ~/.config/opencode/

# Test network connectivity
curl -I https://api.openai.com/v1/models
```

---

**Still need help?** Open an issue on GitHub with diagnostic information and we'll assist you.
