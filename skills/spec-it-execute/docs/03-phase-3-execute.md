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

## 병렬 라인 실행 (if _meta.mockServerEnabled)

mock-server가 활성화된 경우, Phase 3을 **두 라인으로 병렬 실행**합니다.

### 실행 방법

두 개의 dev-pilot 인스턴스를 동시 호출:

```javascript
// Line A (UI) - background
Task(
  subagent_type="spec-it:dev-pilot",
  run_in_background=true,
  prompt="Execute Line A (UI) tasks for session {sessionId}. Only process tasks with line: A (or no line specified)."
)

// Line B (API) - background
Task(
  subagent_type="spec-it:dev-pilot",
  run_in_background=true,
  prompt="Execute Line B (API/mock-server) tasks for session {sessionId}. Only process tasks with line: B. See docs/15-mock-server.md for tech stack and structure."
)
```

### File Ownership

```
Line A workers: src/**, tests/**, public/**    (프론트엔드 전체)
Line B workers: mock-server/**                 (mock-server 전체)
→ 두 라인 간 파일 충돌 없음
```

### 공유 파일

- `package.json`: Line A가 소유 (mock:* 스크립트는 Phase 7 integration에서 추가)
- `playwright.config.ts`: Phase 7 진입 시 수정

### 완료 조건

Line A, Line B **모두 완료**되어야 Phase 4 진입.
한 라인이 먼저 끝나면 다른 라인 완료를 대기.

## Completion

- All workers complete successfully
- dev-architect validates spec compliance
- Log results to `.spec-it/{sessionId}/execute/logs/`
- Proceed to Phase 4 (QA)
