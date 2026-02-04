# Phase 3: Execute (via dev-pilot)

## Overview

Phase 3 uses the `dev-pilot` skill for parallel execution with file ownership partitioning.

## Invoke dev-pilot

```
Skill(skill="dev-pilot", args="{sessionId}")
```

Or via Task tool:
```javascript
Task(
  subagent_type="spec-it:dev-pilot",
  model="sonnet",
  prompt="Execute spec-it session: {sessionId}"
)
```

## dev-pilot Phases (Internal)

| Sub-Phase | Description |
|-----------|-------------|
| 0 | Load Context (spec-map.md, task-registry.json) |
| 1 | Task Analysis (parallelizable?) |
| 2 | Decomposition (task → subtasks) |
| 3 | File Ownership Partitioning |
| 4 | Parallel Execution (up to 5 workers) |
| 5 | Integration (shared files) |
| 6 | Validation (build, spec compliance) |

## Agents Used

| Agent | Model | Role |
|-------|-------|------|
| dev-executor-low | haiku | Simple single-file tasks |
| dev-executor | sonnet | Standard feature implementation |
| dev-executor-high | opus | Complex multi-file architecture |
| dev-build-fixer | sonnet | Build/type error resolution |
| dev-architect | opus | Spec compliance verification |

## File Ownership Strategy

- Each worker owns exclusive file set (no conflicts)
- Shared files (package.json, tsconfig.json) handled sequentially in integration
- Boundary files assigned to most relevant worker

## Fallback

If task is NOT parallelizable (< 2 independent groups):
- Execute sequentially via single `dev-executor` agent

## Completion

- All workers complete successfully
- dev-architect validates spec compliance
- Log results to `.spec-it/{sessionId}/execute/logs/`
- Proceed to Phase 4 (QA)
