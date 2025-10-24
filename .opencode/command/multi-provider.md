---
description: Execute workflows using optimal AI providers for each task
agent: build
permissions:
  edit: allow
  bash: allow
---

# Multi-Provider Workflow Execution

This command automatically selects the optimal AI provider and model for different phases of your workflow, balancing cost, speed, and quality.

## Usage

```bash
@multi-provider "Implement user authentication with JWT tokens"
```

## Provider Selection Strategy

### Planning Phase (Plan Agent)

- **Primary**: GPT-4o (balanced reasoning and speed)
- **Fallback**: Claude 3.5 Sonnet (complex planning)
- **Cost**: ~$0.005/1K tokens

### Research Phase (General Agent)

- **Primary**: Claude 3.5 Sonnet (deep analysis)
- **Fallback**: GPT-4o (quick research)
- **Cost**: ~$0.003/1K tokens

### Implementation Phase (Build Agent)

- **Primary**: GPT-4o (code generation)
- **Fallback**: Claude 3.5 Sonnet (complex implementations)
- **Cost**: ~$0.005/1K tokens

### Validation Phase (Test Agent)

- **Primary**: Claude 3.5 Sonnet (detailed analysis)
- **Fallback**: GPT-4o (quick validation)
- **Cost**: ~$0.003/1K tokens

## Workflow Steps

1. **Task Analysis**: Analyze the request to determine complexity and requirements
2. **Provider Selection**: Choose optimal provider for each phase
3. **Cost Estimation**: Calculate estimated cost for the workflow
4. **Execution**: Run each phase with the selected provider
5. **Fallback Handling**: Switch providers if errors occur
6. **Cost Reporting**: Provide detailed cost breakdown

## Cost Optimization Features

- **Smart Caching**: Reuse results from similar previous tasks
- **Token Optimization**: Minimize prompt sizes while maintaining context
- **Batch Processing**: Combine multiple small tasks when possible
- **Provider Switching**: Dynamically switch based on real-time performance

## Configuration

Add to your `personal.json`:

```json
{
  "multi_provider": {
    "preferred_providers": {
      "planning": "gpt-4o",
      "research": "claude-3.5-sonnet",
      "implementation": "gpt-4o",
      "validation": "claude-3.5-sonnet"
    },
    "cost_limits": {
      "max_workflow_cost": 1.0,
      "max_phase_cost": 0.5
    },
    "fallback_enabled": true,
    "cache_enabled": true
  }
}
```

## Examples

### Simple Feature Implementation

```bash
@multi-provider "Add password reset functionality"
```

### Complex System Design

```bash
@multi-provider "Design and implement microservices architecture for e-commerce platform"
```

### Bug Investigation

```bash
@multi-provider "Investigate and fix memory leak in data processing pipeline"
```

## Cost Estimates

| Task Type         | Estimated Cost | Time      |
| ----------------- | -------------- | --------- |
| Simple Feature    | $0.05-0.15     | 2-5 min   |
| Complex Feature   | $0.20-0.50     | 5-15 min  |
| System Design     | $0.30-0.80     | 10-25 min |
| Bug Investigation | $0.10-0.30     | 3-8 min   |

## Monitoring and Reporting

The command provides:

- Real-time cost tracking
- Provider performance metrics
- Token usage statistics
- Error rates and fallback usage

## Advanced Features

### Custom Provider Rules

```json
{
  "provider_rules": {
    "security_sensitive": {
      "provider": "claude-3.5-sonnet",
      "reason": "Better security analysis"
    },
    "performance_critical": {
      "provider": "gpt-4o",
      "reason": "Faster response times"
    }
  }
}
```

### Workflow Templates

```json
{
  "workflow_templates": {
    "feature_development": {
      "phases": ["planning", "research", "implementation", "validation"],
      "providers": [
        "gpt-4o",
        "claude-3.5-sonnet",
        "gpt-4o",
        "claude-3.5-sonnet"
      ]
    }
  }
}
```

## Error Handling

- **Provider Failures**: Automatic fallback to secondary provider
- **Cost Limits**: Workflow pauses if limits are exceeded
- **Quality Checks**: Re-run phases if quality thresholds not met
- **Recovery**: Resume from failed phase without losing progress

## Best Practices

1. **Start Small**: Test with simple tasks first
2. **Monitor Costs**: Keep an eye on usage, especially for complex tasks
3. **Review Results**: Always validate multi-provider outputs
4. **Customize Rules**: Tailor provider selection to your specific needs
5. **Use Caching**: Enable caching to reduce costs on similar tasks

---

_This command leverages OpenCode's multi-provider capabilities to optimize both cost and quality for your development workflows._
