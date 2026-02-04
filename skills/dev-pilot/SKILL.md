---
name: dev-pilot
description: "Parallel autopilot for spec-it output. Spawns up to 5 workers with file ownership partitioning."
aliases: [dp, devpilot, parallel-dev]
---

# Dev-Pilot Skill

[DEV-PILOT ACTIVATED - PARALLEL EXECUTION FROM SPEC-IT OUTPUT]

spec-it 산출물을 기반으로 병렬 워커를 생성하여 최대 5배 빠르게 개발을 수행합니다.

## Input Requirements

spec-it (P1-P14) 산출물이 필요합니다:
- `.spec-it/{sessionId}/spec-map.md` - Progressive context
- `.spec-it/{sessionId}/execute/task-registry.json` - Task breakdown
- `02-wireframes/` - UI wireframes (YAML)
- `03-components/` - Component specs
- `04-scenarios/` - Test scenarios

## Architecture

```
spec-it Output (P14)
        ↓
  [DEV-PILOT COORDINATOR]
        ↓
  Decomposition + File Partitioning
        ↓
  +-------+-------+-------+-------+-------+
  |       |       |       |       |       |
  v       v       v       v       v       v
[W-1]   [W-2]   [W-3]   [W-4]   [W-5]
backend frontend components tests  docs
        ↓
  [INTEGRATION PHASE]
  (shared files: package.json, tsconfig.json)
        ↓
  [VALIDATION PHASE]
  (build, lint, test)
```

## User's Task

{{ARGUMENTS}}

## Phase 0: Load spec-it Context

```
1. Read .spec-it/{sessionId}/spec-map.md
2. Read .spec-it/{sessionId}/execute/task-registry.json
3. Identify session artifacts
```

## Phase 1: Task Analysis

Determine if task is parallelizable:

**Parallelizable if:**
- task-registry.json has 2+ independent task groups
- File boundaries are clear between groups
- Dependencies between groups are minimal

**If NOT parallelizable:** Execute sequentially via `dev-executor`

## Phase 2: Decomposition

Break tasks into parallel-safe subtasks using task-registry.json:

```json
{
  "subtasks": [
    {
      "id": "1",
      "description": "Backend API implementation",
      "files": ["src/api/**", "src/services/**"],
      "blockedBy": [],
      "agentType": "dev-executor",
      "model": "sonnet"
    },
    {
      "id": "2",
      "description": "Frontend components",
      "files": ["src/components/**", "src/pages/**"],
      "blockedBy": [],
      "agentType": "dev-executor",
      "model": "sonnet"
    }
  ],
  "sharedFiles": ["package.json", "tsconfig.json"],
  "parallelGroups": [["1", "2"]]
}
```

**Output:** Save to `.spec-it/{sessionId}/execute/decomposition.json`

## Phase 3: File Ownership Partitioning

Create exclusive ownership map:

```
Worker 1: src/api/**        (exclusive)
Worker 2: src/components/** (exclusive)
Worker 3: src/pages/**      (exclusive)
Worker 4: src/services/**   (exclusive)
Worker 5: tests/**          (exclusive)
SHARED:   package.json, tsconfig.json (sequential)
```

**Rule:** No two workers can touch the same files

**Output:** Save to `.spec-it/{sessionId}/execute/file-ownership.json`

## Phase 4: Parallel Execution

Spawn workers using Task tool with `run_in_background: true`:

```javascript
Task(
  subagent_type="spec-it:dev-executor",
  model="sonnet",
  run_in_background=true,
  prompt=`DEV-PILOT WORKER [1/5]

SESSION: {sessionId}
OWNED FILES: src/api/**

SPEC CONTEXT:
- Read: .spec-it/{sessionId}/spec-map.md
- Read: 02-wireframes/ for EXACT prop values (labels, colors, data)
- Read: 03-components/ for component specs
- Read: 04-scenarios/ for test requirements

TASK: {specific subtask from decomposition}

════════════════════════════════════════════════════════════════
WIREFRAME ADHERENCE LAW (설계 준수 불변의 법칙) - NON-NEGOTIABLE
════════════════════════════════════════════════════════════════

🚫 FORBIDDEN:
- Guessing/estimating ANY value
- Translating labels (Korean → English)
- Changing colors (green-100 → emerald, success, etc.)
- Simplifying UI structure
- Using "reasonable defaults"
- Adding features not in spec
- Using English when spec uses Korean

✅ MANDATORY:
- Read wireframe YAML BEFORE coding
- Use EXACT label text from wireframe props
- Use EXACT color values from wireframe props
- Use EXACT mock data from wireframe props
- Keep spec language (Korean → Korean)

Example:
  Wireframe: { label: "출근 인원", iconBg: "green-100", name: "김철수" }
  Code MUST use: label="출근 인원", iconBg="green-100", name="김철수"
  NOT: label="Present", color="success", name="John"

════════════════════════════════════════════════════════════════

CRITICAL RULES:
1. ONLY modify files in your ownership set
2. Follow spec-it component specifications EXACTLY (every prop)
3. Include testId attributes from wireframes
4. Match wireframe language (no translations)
5. Signal WORKER_COMPLETE when done`
)
```

**Max Workers:** 5 (Claude Code limit)
**Monitor:** Poll TaskOutput for each worker

## Phase 5: Integration

After all workers complete:

1. Handle shared files (package.json, configs) sequentially
2. Resolve cross-component imports
3. Ensure all pieces work together

## Phase 6: Validation

Spawn parallel validators:

```javascript
// Build check
Task(subagent_type="spec-it:dev-build-fixer", model="sonnet", ...)

// Spec compliance check
Task(subagent_type="spec-it:dev-architect", model="opus",
  prompt="Verify implementation matches spec-it specifications...")
```

**All must pass before completion.**

## Delegation Rules (MANDATORY)

**YOU ARE A COORDINATOR, NOT AN IMPLEMENTER.**

| Action | YOU Do | DELEGATE |
|--------|--------|----------|
| Read spec-it artifacts | ✓ | |
| Decompose tasks | ✓ | |
| Partition files | ✓ | |
| Spawn workers | ✓ | |
| Track progress | ✓ | |
| **ANY code change** | ✗ NEVER | dev-executor workers |

**Path Exception**: Only write to `.spec-it/`, `.claude/`

## State Management

Track state in `.spec-it/{sessionId}/execute/dev-pilot-state.json`:

```json
{
  "active": true,
  "mode": "dev-pilot",
  "sessionId": "abc123",
  "phase": "parallel_execution",
  "workers": [
    {"id": "w1", "status": "running", "files": ["src/api/**"], "task_id": "..."},
    {"id": "w2", "status": "complete", "files": ["src/components/**"], "task_id": "..."}
  ],
  "shared_files": ["package.json", "tsconfig.json"],
  "startTime": "2026-02-04T10:30:00Z"
}
```

## Smart Model Routing

| Task Complexity | Agent | Model |
|-----------------|-------|-------|
| Simple/single-file | `dev-executor-low` | haiku |
| Standard feature | `dev-executor` | sonnet |
| Complex/multi-file | `dev-executor-high` | opus |
| Architecture verify | `dev-architect` | opus |
| Build errors | `dev-build-fixer` | sonnet |

## CRITICAL: Complete Implementation Rules (함축 금지)

**YOU MUST IMPLEMENT ALL TASKS COMPLETELY. NO PARTIAL IMPLEMENTATION.**

### Rule 1: Execute ALL Tasks in task-registry.json
```
❌ WRONG: "Implementing core P0 tasks first, P1 later"
❌ WRONG: "Skipping low-priority tasks for now"
❌ WRONG: "Basic implementation complete, advanced features pending"

✅ CORRECT: Execute EVERY task in task-registry.json
✅ CORRECT: All priorities (CRITICAL, HIGH, MEDIUM, LOW) must be implemented
✅ CORRECT: No task marked as "pending" or "deferred"
```

### Rule 2: Complete Each Task Fully
```
❌ WRONG: Skeleton/placeholder implementations
❌ WRONG: "TODO: implement later" comments
❌ WRONG: Missing features within a screen

✅ CORRECT: All UI elements from wireframe implemented
✅ CORRECT: All interactions from spec functional
✅ CORRECT: All data bindings connected
```

### Rule 3: Match Spec Exactly
```
For EACH screen in the spec:
- Every widget/component rendered
- Every button/action implemented
- Every text label matches (language, content)
- Every style matches (colors, spacing, typography)
- Every animation/transition included
```

### Rule 4: No Feature Dropping
```
If a task seems complex:
❌ WRONG: Skip it and mark as "future work"
❌ WRONG: Implement simplified version
❌ WRONG: Replace with placeholder

✅ CORRECT: Break into smaller subtasks
✅ CORRECT: Spawn additional workers if needed
✅ CORRECT: Request opus model for complex tasks
```

### Rule 5: Completion Verification
Before marking dev-pilot as complete:

```yaml
verification_checklist:
  - task_count_executed == task_count_in_registry
  - screens_implemented == screens_in_spec
  - components_created == components_in_spec
  - no_todo_comments_in_code: true
  - no_placeholder_implementations: true
  - all_workers_completed_all_assigned_tasks: true
```

### Rule 6: Language and Localization
```
If spec uses Korean (한국어):
- All UI labels MUST be Korean (not English)
- All mock data MUST use Korean names/content
- All date formats MUST match spec locale

❌ WRONG: "HR Dashboard" when spec says "HR 대시보드"
❌ WRONG: "John Smith" when spec uses "김철수"
✅ CORRECT: Match spec language exactly
```

### Violation Warning
If dev-pilot produces partial implementation:
- Validation will FAIL
- Regression to Phase 3 triggered
- All missing features flagged as fix-tasks

## Completion

When all phases complete and validation passes:

1. Clean up state files
2. Display summary:
   - Workers spawned
   - Files modified per worker
   - Build/test status
   - Time comparison vs sequential

```markdown
## Dev-Pilot Summary

**Session:** {sessionId}
**Workers:** 5 parallel
**Duration:** 12 minutes (estimated sequential: 45 minutes)

### Worker Results
| Worker | Files | Status |
|--------|-------|--------|
| W-1 Backend | 8 files | ✓ Complete |
| W-2 Frontend | 12 files | ✓ Complete |
| W-3 Components | 6 files | ✓ Complete |
| W-4 Services | 4 files | ✓ Complete |
| W-5 Tests | 15 files | ✓ Complete |

### Validation
- Build: ✓ Pass
- Lint: ✓ Pass
- Tests: 45/45 passing
- Spec Compliance: ✓ Verified
```

## Cancellation

Say "cancel" or "stop dev-pilot" to gracefully terminate:
- All active workers terminated
- Partial progress saved
- Can resume later

## Resume

```
/spec-it:dev-pilot resume {sessionId}
```

Restarts failed workers only, re-uses completed outputs.

## 보완 모드 (Fix Mode)

Phase 4-8 실패 시, 실패 원인을 수정하는 모드입니다.

### 사용법

```bash
/spec-it:dev-pilot {sessionId} --mode=fix --tasks={fix-tasks-file.json}
```

### 회귀 시나리오별 Input

| 실패 Phase | 생성 파일 | 실행 명령 |
|-----------|----------|----------|
| Phase 4 (Bringup) | fix-tasks.json | `--tasks=fix-tasks.json` |
| Phase 5 (Spec-Mirror) | mirror-report-tasks.json | `--tasks=mirror-report-tasks.json` |
| Phase 6 (Unit Tests) | test-fix-tasks.json | `--tasks=test-fix-tasks.json` |
| Phase 7 (E2E Tests) | e2e-fix-tasks.json | `--tasks=e2e-fix-tasks.json` |
| Phase 8 (Validate) | review-fix-tasks.json | `--tasks=review-fix-tasks.json` |

### Input 구조

| 파일 | 용도 |
|------|------|
| task-registry.json | 참조용 (원본 컨텍스트, 불변) |
| `{*-tasks.json}` | 실행 대상 (보완 태스크) - 외부 주입 |

### 공통 *-tasks.json 스키마

```json
{
  "source": "{실패 리포트 경로}",
  "sourcePhase": 4 | 5 | 6 | 7 | 8,
  "generatedAt": "2026-02-04T12:00:00Z",
  "iteration": 1,
  "tasks": [
    {
      "id": "fix-001",
      "type": "build-error" | "missing" | "test-fail" | "security" | "code-quality",
      "specRef": "{관련 spec 파일 경로}",
      "description": "{수정 필요 사항}",
      "priority": "CRITICAL" | "HIGH" | "MEDIUM" | "LOW",
      "files": ["src/components/Button.tsx"],
      "errorDetail": "{상세 에러 메시지 (optional)}"
    }
  ]
}
```

### Phase별 type 매핑

| Phase | type 값 | 설명 |
|-------|---------|------|
| 4 | `build-error` | lint/typecheck/build 에러 |
| 5 | `missing`, `over-spec` | Spec 누락/초과 |
| 6 | `test-fail`, `coverage` | 테스트 실패, 커버리지 미달 |
| 7 | `test-fail`, `e2e-critical` | E2E 시나리오 실패 |
| 8 | `security`, `code-quality` | 보안/코드 품질 이슈 |

### 보완 모드 동작

1. **기존 파일 보호**: 이미 구현된 파일은 최소 수정
2. **태스크 파일 기반 실행**: 주입된 *-tasks.json의 태스크만 실행
3. **증분 빌드**: 변경된 파일만 검증

### 보완 모드 흐름

```
{*-tasks.json} (외부 주입)
        ↓
  [DEV-PILOT FIX MODE]
        ↓
  태스크 분석 & 분해
        ↓
  필요한 워커만 생성
        ↓
  [INTEGRATION]
  (기존 코드와 통합)
        ↓
  [VALIDATION]
        ↓
  Phase 4 → 5 → 6 → 7 → 8 순차 재검증
```

### State 파일

보완 모드 실행 시 별도 상태 관리:

```json
// dev-pilot-state.json
{
  "active": true,
  "mode": "fix",
  "sourcePhase": 5,
  "iteration": 1,
  "sourceTaskFile": "mirror-report-tasks.json",
  "originalTaskFile": "task-registry.json",
  "tasksCount": 3,
  "completedTasks": 1,
  ...
}
```

### 예시: Phase 6 실패 후 회귀

```bash
# Phase 6에서 테스트 실패
# → test-fix-tasks.json 자동 생성

# Phase 3 재실행 (Fix Mode)
/spec-it:dev-pilot abc123 --mode=fix --tasks=test-fix-tasks.json

# 이후 자동으로:
# → Phase 4 (Bringup) 재검증
# → Phase 5 (Spec-Mirror) 재검증
# → Phase 6 (Unit Tests) 재검증
```
