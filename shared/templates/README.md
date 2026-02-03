# Shared Templates

Output templates for spec-it agents and skills.

## Organization

```
templates/
├── common/              # Templates used by multiple agents (6+ skills)
├── api-predictor/       # api-predictor agent-specific templates
├── dev-planner/         # dev-planner agent-specific templates
└── {agent-name}/        # Other agent-specific templates
```

## Common Templates

Templates in `common/` are used by multiple skills:
- spec-it-stepbystep
- spec-it-complex
- spec-it-automation
- spec-it-fast-launch
- hack-2-spec
- spec-it

## Usage

Reference templates using paths like:
```
shared/templates/common/00-REQUIREMENTS_TEMPLATE.md
shared/templates/common/01-CHAPTER_PLAN_TEMPLATE.md
```
