---
description: Manage advanced OpenCode configuration with schema validation
agent: build
permissions:
  edit: allow
  bash: allow
---

# Advanced Configuration Management

This command provides comprehensive configuration management for OpenCode with schema validation, environment variable substitution, and project-specific overrides.

## Usage

```bash
@advanced-config validate
@advanced-config edit personal
@advanced-config set "theme" "dark"
@advanced-config get "theme"
@advanced-config reset personal
@advanced-config export --format json
@advanced-config import config.json
```

## Configuration Structure

### Base Configuration (`opencode.json`)

```json
{
  "version": "1.0.0",
  "schema": "https://opencode.ai/schemas/config/v1",
  "defaults": {
    "theme": "auto",
    "keybindings": "default",
    "auto_save": true,
    "backup_enabled": true
  },
  "providers": {
    "primary": "openai",
    "fallback": "anthropic",
    "models": {
      "planning": "gpt-4o",
      "implementation": "gpt-4o",
      "research": "claude-3.5-sonnet"
    }
  }
}
```

### Personal Configuration (`config/personal.json`)

```json
{
  "user": {
    "name": "Ben Nasraoui",
    "email": "ben@example.com",
    "preferences": {
      "theme": "dark",
      "font_size": 14,
      "auto_complete": true
    }
  },
  "workflows": {
    "default_provider": "openai",
    "cost_limits": {
      "daily": 5.0,
      "monthly": 100.0
    },
    "cache_enabled": true
  },
  "shortcuts": {
    "save": "Ctrl+S",
    "run": "Ctrl+R",
    "debug": "Ctrl+D"
  }
}
```

### Work Configuration (`config/work.json`)

```json
{
  "organization": "company-name",
  "team": "development-team",
  "repositories": {
    "main": "git@github.com:company/main-repo.git",
    "docs": "git@github.com:company/docs.git"
  },
  "integrations": {
    "slack": {
      "webhook_url": "${SLACK_WEBHOOK_URL}",
      "channel": "#dev-alerts"
    },
    "jira": {
      "url": "https://company.atlassian.net",
      "project": "DEV"
    }
  }
}
```

## Schema Validation

### Configuration Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "OpenCode Configuration",
  "type": "object",
  "properties": {
    "version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+\\.\\d+$"
    },
    "user": {
      "type": "object",
      "properties": {
        "name": { "type": "string", "minLength": 1 },
        "email": { "type": "string", "format": "email" },
        "preferences": {
          "type": "object",
          "properties": {
            "theme": { "enum": ["light", "dark", "auto"] },
            "font_size": { "type": "integer", "minimum": 8, "maximum": 72 }
          }
        }
      }
    }
  }
}
```

### Validation Commands

```bash
@advanced-config validate                    # Validate all configs
@advanced-config validate personal          # Validate specific config
@advanced-config validate --strict          # Strict validation with warnings
@advanced-config validate --schema latest   # Use latest schema version
```

## Environment Variable Substitution

### Supported Patterns

```bash
# Direct substitution
"api_key": "${API_KEY}"

# With default value
"timeout": "${TIMEOUT:-30}"

# Multiple variables
"database_url": "${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}"

# Conditional values
"debug_mode": "${DEBUG:-false}"
```

### Environment Files

Create `.env` files in your project:

```bash
# .env
API_KEY=your_api_key_here
DEBUG=true
TIMEOUT=60
DB_HOST=localhost
```

### Substitution Commands

```bash
@advanced-config substitute                 # Substitute in all configs
@advanced-config substitute personal        # Substitute in specific config
@advanced-config substitute --dry-run       # Preview substitutions
@advanced-config substitute --backup        # Backup before substituting
```

## Project-Specific Overrides

### Project Configuration (`.opencode/project.json`)

```json
{
  "name": "my-project",
  "type": "web-application",
  "overrides": {
    "providers": {
      "primary": "anthropic",
      "models": {
        "implementation": "claude-3.5-sonnet"
      }
    },
    "workflows": {
      "cost_limits": {
        "daily": 10.0
      }
    }
  },
  "scripts": {
    "pre_commit": ["lint", "test"],
    "pre_push": ["build", "e2e-test"]
  },
  "tools": {
    "custom": ["database-migration", "deploy-staging"]
  }
}
```

### Override Resolution

1. Base configuration (`opencode.json`)
2. Personal configuration (`config/personal.json`)
3. Work configuration (`config/work.json`)
4. Project configuration (`.opencode/project.json`)
5. Environment variables
6. Command-line arguments

### Override Commands

```bash
@advanced-config overrides show              # Show effective configuration
@advanced-config overrides resolve          # Show resolution order
@advanced-config overrides merge            # Merge all configurations
```

## Configuration Management

### Edit Configuration

```bash
@advanced-config edit personal              # Edit personal config
@advanced-config edit --editor vim personal # Use specific editor
@advanced-config edit --validate personal   # Validate after editing
```

### Get Configuration Values

```bash
@advanced-config get "theme"                # Get specific value
@advanced-config get "user.preferences.theme"  # Get nested value
@advanced-config get --json "theme"         # Get as JSON
@advanced-config get --all                  # Get all values
```

### Set Configuration Values

```bash
@advanced-config set "theme" "dark"         # Set simple value
@advanced-config set "user.preferences.theme" "dark"  # Set nested value
@advanced-config set --json "shortcuts" '{"save": "Ctrl+S"}'  # Set JSON value
@advanced-config set --env "API_KEY"       # Set from environment
```

### Reset Configuration

```bash
@advanced-config reset personal             # Reset to defaults
@advanced-config reset "theme"             # Reset specific key
@advanced-config reset --all               # Reset all configurations
```

## Import/Export

### Export Configuration

```bash
@advanced-config export                     # Export all configs
@advanced-config export personal           # Export specific config
@advanced-config export --format json      # Export as JSON
@advanced-config export --format yaml      # Export as YAML
@advanced-config export --no-secrets       # Exclude sensitive values
```

### Import Configuration

```bash
@advanced-config import config.json        # Import from file
@advanced-config import --merge config.json # Merge with existing
@advanced-config import --backup config.json # Backup before import
@advanced-config import --validate config.json # Validate before import
```

## Configuration Templates

### Available Templates

```bash
@advanced-config templates list            # List available templates
@advanced-config templates show web-app    # Show template details
@advanced-config templates apply web-app   # Apply template
```

### Web Application Template

```json
{
  "type": "web-application",
  "providers": {
    "primary": "openai",
    "models": {
      "implementation": "gpt-4o",
      "testing": "claude-3.5-sonnet"
    }
  },
  "scripts": {
    "dev": "npm run dev",
    "build": "npm run build",
    "test": "npm run test",
    "deploy": "npm run deploy"
  },
  "tools": ["lint-fix", "test-runner", "build-checker"]
}
```

### API Service Template

```json
{
  "type": "api-service",
  "providers": {
    "primary": "anthropic",
    "models": {
      "implementation": "claude-3.5-sonnet",
      "documentation": "gpt-4o"
    }
  },
  "scripts": {
    "start": "npm start",
    "test": "npm test",
    "migrate": "npm run migrate",
    "seed": "npm run seed"
  },
  "tools": ["database-migration", "api-tester", "health-check"]
}
```

## Advanced Features

### Configuration Profiles

```bash
@advanced-config profile create development  # Create profile
@advanced-config profile use development     # Switch profile
@advanced-config profile list               # List profiles
@advanced-config profile remove development  # Remove profile
```

### Conditional Configuration

```json
{
  "conditions": {
    "if": "${NODE_ENV} === 'production'",
    "then": {
      "debug": false,
      "logging": "error"
    },
    "else": {
      "debug": true,
      "logging": "debug"
    }
  }
}
```

### Dynamic Configuration

```json
{
  "dynamic": {
    "git_branch": {
      "command": "git branch --show-current",
      "cache": 60
    },
    "system_info": {
      "command": "uname -a",
      "cache": 3600
    }
  }
}
```

## Security

### Sensitive Data Handling

```bash
@advanced-config secrets list              # List sensitive keys
@advanced-config secrets encrypt "api_key" # Encrypt specific value
@advanced-config secrets decrypt "api_key" # Decrypt specific value
@advanced-config secrets rotate             # Rotate all secrets
```

### Access Control

```json
{
  "permissions": {
    "personal": ["read", "write"],
    "work": ["read"],
    "project": ["read", "write"]
  },
  "audit": {
    "enabled": true,
    "log_file": "~/.config/opencode/audit.log"
  }
}
```

## Troubleshooting

### Validation Errors

```bash
@advanced-config validate --verbose        # Detailed validation errors
@advanced-config validate --fix            # Auto-fix common issues
@advanced-config validate --backup         # Backup before fixing
```

### Configuration Conflicts

```bash
@advanced-config conflicts show            # Show configuration conflicts
@advanced-config conflicts resolve          # Resolve conflicts interactively
```

### Debug Mode

```bash
@advanced-config --debug validate          # Debug validation
@advanced-config --debug get "theme"       # Debug get operation
```

## Best Practices

1. **Version Control**: Commit non-sensitive configurations
2. **Environment Separation**: Use different configs for different environments
3. **Schema Validation**: Always validate configurations
4. **Secrets Management**: Never commit sensitive data
5. **Documentation**: Document custom configuration options
6. **Backup**: Regularly backup configurations
7. **Testing**: Test configuration changes in development first

---

_This command provides comprehensive configuration management for OpenCode with enterprise-grade features._
