# Shared References

Reference documents for spec-it agents and skills.

## Organization

```
references/
├── common/                    # 2+ agents/skills reference
│   ├── critique-solve-format.md
│   ├── spec-map-format.md
│   ├── test-scenario-format.md
│   └── dev-plan-format.md
├── critic-analytics/          # critic-analytics only
│   └── synthesis-format.md
├── critique-resolver/         # critique-resolver only
│   └── question-templates.md
├── critical-review/           # critical-review skill only
│   ├── ambiguity-format.md
│   └── review-criteria.md
├── dev-planner/              # dev-planner only
│   └── task-template.md
├── api-predictor/            # api-predictor skill only
│   ├── api-format.md
│   └── design-principles.md
└── context-synthesizer/      # context-synthesizer only
    └── spec-map-guide.md
```

## Reference Index

### Common (Multi-Agent)

| File | Referenced By | Purpose |
|------|---------------|---------|
| `critique-solve-format.md` | critique-resolver, critic-analytics, critic-moderator | P5 output format |
| `spec-map-format.md` | context-synthesizer, spec-assembler, spec-it-execute | P10 artifact index |
| `test-scenario-format.md` | test-spec-writer, persona-architect | P12 test structure |
| `dev-plan-format.md` | dev-planner, spec-assembler, spec-it-execute | P14 task structure |

### Agent-Specific

| Folder | Agent/Skill | Files |
|--------|-------------|-------|
| `critic-analytics/` | critic-analytics | synthesis-format.md |
| `critique-resolver/` | critique-resolver | question-templates.md |
| `critical-review/` | critical-review skill | ambiguity-format.md, review-criteria.md |
| `dev-planner/` | dev-planner | task-template.md |
| `api-predictor/` | api-predictor skill | api-format.md, design-principles.md |
| `context-synthesizer/` | context-synthesizer | spec-map-guide.md |

## Usage

In agent/skill definitions, reference files using relative paths:

```markdown
Read: shared/references/common/spec-map-format.md
Read: shared/references/api-predictor/design-principles.md
```
