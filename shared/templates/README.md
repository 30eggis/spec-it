# Shared Templates

Output templates for spec-it agents and skills.

## Organization

```
templates/
├── common/              # Templates used by multiple agents
└── {agent-name}/        # Agent-specific templates
```

## Note

Most templates currently reside in `skills/shared/templates/`.
This directory is for new templates that follow the updated organization pattern.

## Migration

Templates will be gradually migrated from `skills/shared/templates/` to this location
as agents are updated to reference the new paths.
