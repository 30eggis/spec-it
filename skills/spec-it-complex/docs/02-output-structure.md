# Output Structure + Agents Summary — complex

## Output Structure

```
tmp/
├── 00-requirements/requirements.md
├── 01-chapters/
│   ├── personas/
│   ├── alternatives/
│   ├── critique-*.md
│   ├── critique-synthesis.md
│   └── chapter-plan-final.md
├── critique-solve/
│   ├── merged-decisions.md
│   ├── ambiguity-resolved.md
│   └── undefined-specs.md
├── 02-wireframes/
├── 03-components/
├── 04-review/
│   ├── scenario-review.md
│   ├── ia-review.md
│   ├── exception-review.md
│   ├── ambiguities.md
│   └── review-decisions.md
├── 05-tests/test-scenarios/
│   ├── {persona-id}/
│   └── cross-persona/
├── 06-final/
├── spec-map.md
├── dev-plan/
│   ├── development-map.md
│   ├── api-map.md
│   └── {persona-id}/Phase-{n}/
└── README-DOC/
    └── index.md
```

---

## Agents Summary

| Phase | Agent | Model |
|-------|-------|-------|
| P1 | design-interviewer | opus |
| P2 | persona-architect | sonnet |
| P3 | divergent-thinker | sonnet |
| P4 | critic-logic, critic-feasibility, critic-frontend | sonnet |
| P4 | critic-analytics | sonnet |
| P5 | critique-resolver | sonnet |
| P6 | chapter-planner | opus |
| P7 | ui-architect | sonnet |
| P8 | component-auditor | haiku |
| P9 | component-builder, component-migrator | sonnet |
| P10 | context-synthesizer | sonnet |
| P11 | scenario-reviewer, ia-reviewer, exception-reviewer | opus |
| P11 | review-analytics, review-resolver | sonnet |
| P12 | test-spec-writer | sonnet |
| P13 | spec-assembler | haiku |
| P14 | dev-planner | sonnet |
| P15 | docs-hub-curator | haiku |
