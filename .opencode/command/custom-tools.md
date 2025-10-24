---
description: Create and manage custom tools for OpenCode workflows
agent: build
permissions:
  edit: allow
  bash: allow
---

# Custom Tool Integration

This command enables you to create, install, and manage custom tools that extend OpenCode's capabilities for your specific development needs.

## Usage

```bash
@custom-tools create "database-migration" --type "bash" --description "Run database migrations"
@custom-tools list
@custom-tools install "database-migration"
@custom-tools remove "database-migration"
```

## Tool Types

### 1. Bash Tools

Execute shell commands and scripts with proper error handling.

```bash
@custom-tools create "deploy-staging" --type bash --command "npm run build && rsync -av build/ staging:/var/www/"
```

### 2. API Tools

Integrate with external APIs and services.

```bash
@custom-tools create "notify-slack" --type api --endpoint "https://hooks.slack.com/..." --method POST
```

### 3. File Tools

Custom file operations and transformations.

```bash
@custom-tools create "generate-config" --type file --template "config.template.json" --output "config.json"
```

### 4. Database Tools

Database operations and queries.

```bash
@custom-tools create "backup-db" --type database --operation "backup" --target "production"
```

## Creating Tools

### Interactive Creation

```bash
@custom-tools create
```

This will prompt you for:

- Tool name
- Tool type
- Description
- Command/Configuration
- Permissions required
- Dependencies

### Direct Creation

```bash
@custom-tools create "tool-name" \
  --type "bash" \
  --command "echo 'Hello World'" \
  --description "A simple greeting tool" \
  --permissions "read,write"
```

## Tool Configuration

Tools are stored in `~/.config/opencode/tools/` with this structure:

```json
{
  "name": "database-migration",
  "type": "bash",
  "description": "Run database migrations safely",
  "version": "1.0.0",
  "command": "npm run migrate",
  "permissions": ["bash", "read"],
  "dependencies": ["node", "npm"],
  "environment": {
    "DATABASE_URL": "${DATABASE_URL}"
  },
  "validation": {
    "pre_check": "npm run migrate:status",
    "post_check": "npm run migrate:verify"
  },
  "rollback": "npm run migrate:rollback",
  "timeout": 300,
  "retry_count": 3
}
```

## Built-in Tool Templates

### Database Migration Template

```bash
@custom-tools create "migrate-db" --template database-migration
```

### Deployment Template

```bash
@custom-tools create "deploy" --template deployment
```

### Testing Template

```bash
@custom-tools create "test-suite" --template testing
```

### Code Quality Template

```bash
@custom-tools create "lint-fix" --template code-quality
```

## Tool Management

### List All Tools

```bash
@custom-tools list
```

### Show Tool Details

```bash
@custom-tools show "database-migration"
```

### Update Tool

```bash
@custom-tools update "database-migration" --command "npm run migrate:new"
```

### Remove Tool

```bash
@custom-tools remove "database-migration"
```

## Tool Execution

### Direct Execution

```bash
@database-migration
```

### With Parameters

```bash
@database-migration --env "staging" --dry-run
```

### In Workflows

```bash
@custom-tools execute "database-migration" --before "deploy"
```

## Security and Permissions

### Permission Levels

- **read**: Read files and directories
- **write**: Create and modify files
- **bash**: Execute shell commands
- **network**: Make network requests
- **admin**: Full system access

### Sandboxing

Tools run in isolated environments when possible:

- File system restrictions
- Network access controls
- Resource limits
- Audit logging

### Approval Required

High-risk tools require approval:

- Tools with `admin` permissions
- Tools that modify system files
- Tools that make external network calls

## Integration with Workflows

### Pre-commit Hooks

```json
{
  "pre_commit": ["@lint-fix", "@test-suite"]
}
```

### Deployment Pipeline

```json
{
  "deployment": {
    "pre_deploy": ["@backup-db", "@test-suite"],
    "deploy": "@deploy-staging",
    "post_deploy": ["@health-check", "@notify-slack"]
  }
}
```

## Advanced Features

### Tool Composition

Create tools that combine other tools:

```json
{
  "name": "full-deploy",
  "type": "composite",
  "tools": [
    "backup-db",
    "test-suite",
    "deploy-staging",
    "health-check",
    "notify-slack"
  ]
}
```

### Conditional Execution

```json
{
  "name": "smart-deploy",
  "conditions": {
    "if": "git diff --name-only | grep -q 'package.json'",
    "then": "npm install && @deploy-staging",
    "else": "@deploy-staging"
  }
}
```

### Parallel Execution

```json
{
  "name": "parallel-tests",
  "type": "parallel",
  "tools": ["unit-tests", "integration-tests", "e2e-tests"]
}
```

## Tool Marketplace

### Browse Available Tools

```bash
@custom-tools marketplace browse
```

### Install from Marketplace

```bash
@custom-tools marketplace install "react-component-generator"
```

### Publish Tool

```bash
@custom-tools marketplace publish "my-custom-tool"
```

## Examples

### Environment Setup Tool

```bash
@custom-tools create "setup-dev" \
  --type bash \
  --command "npm install && cp .env.example .env && npm run db:setup" \
  --description "Set up development environment"
```

### Code Generation Tool

```bash
@custom-tools create "generate-component" \
  --type file \
  --template "component.template.tsx" \
  --description "Generate React component from template"
```

### Health Check Tool

```bash
@custom-tools create "health-check" \
  --type api \
  --endpoint "https://api.example.com/health" \
  --method GET \
  --description "Check application health status"
```

## Best Practices

1. **Start Simple**: Begin with basic bash tools
2. **Test Thoroughly**: Validate tools before production use
3. **Document Well**: Clear descriptions and usage examples
4. **Use Templates**: Leverage built-in templates when possible
5. **Security First**: Limit permissions to what's actually needed
6. **Version Control**: Track tool changes in git
7. **Monitor Usage**: Review tool execution logs regularly

## Troubleshooting

### Common Issues

- **Permission Denied**: Check tool permissions in configuration
- **Command Not Found**: Verify dependencies are installed
- **Timeout Issues**: Increase timeout value for long-running tools
- **Network Errors**: Check network connectivity and API endpoints

### Debug Mode

```bash
@custom-tools execute "tool-name" --debug
```

### Logs

```bash
@custom-tools logs "tool-name" --tail 50
```

---

_This command provides a powerful framework for extending OpenCode with custom tools tailored to your development workflow._
