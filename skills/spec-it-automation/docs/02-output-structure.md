# Output Structure + Mode Differences + Agents Summary — automation

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
│   └── merged-decisions.md (auto-resolved)
├── 02-wireframes/
├── 03-components/
├── 04-review/
│   ├── scenario-review.md
│   ├── ia-review.md
│   ├── exception-review.md
│   ├── ambiguities.md
│   └── review-decisions.md (auto-resolved)
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

## Mode Differences Summary

| Aspect | stepbystep | complex | automation |
|--------|------------|---------|------------|
| P5 Resolution | critique-resolver | critique-resolver | **critic-moderator** |
| P11 Resolution | review-resolver | review-resolver | **review-moderator** |
| Approval Points | Every phase | 4 milestones | Final only |
| Auto Execute | No | No | **Yes** |

---

## Agents Summary

| Phase | Agent | Model | Mode |
|-------|-------|-------|------|
| P1 | design-interviewer | opus | Auto |
| P2 | persona-architect | sonnet | Auto |
| P3 | divergent-thinker | sonnet | Auto |
| P4 | critic-logic, critic-feasibility, critic-frontend | sonnet | Parallel |
| P4 | critic-analytics | sonnet | Auto |
| P5 | **critic-moderator** | opus | Auto consensus |
| P6 | chapter-planner | opus | Auto |
| P7 | ui-architect | sonnet | Parallel batch |
| P8 | component-auditor | haiku | Auto |
| P9 | component-builder, component-migrator | sonnet | Parallel |
| P10 | context-synthesizer | sonnet | Auto |
| P11 | scenario-reviewer, ia-reviewer, exception-reviewer | opus | Parallel |
| P11 | review-analytics | sonnet | Auto |
| P11 | **review-moderator** | opus | Auto consensus |
| P12 | test-spec-writer | sonnet | Auto |
| P13 | spec-assembler | haiku | Auto |
| P14 | dev-planner | sonnet | Auto |
| P15 | docs-hub-curator | haiku | Auto |
