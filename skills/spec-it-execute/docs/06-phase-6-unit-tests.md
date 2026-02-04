# Phase 6: Unit Tests

## Overview
Phase 4 (Bringup)에서 스킵된 테스트를 이 단계에서 작성하고 실행합니다.

## Skill
- **ultraqa** (unit mode)

## Agent
| Agent | Model | Role |
|-------|-------|------|
| qa-tester | sonnet | 표준 단위 테스트 작성/실행 |
| qa-tester-high | opus | 복잡한 테스트, 보안/성능 검증 |

## Process

```
┌─────────────────────────────────────────────────────┐
│              Phase 6: Unit Tests                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. Load Context                                    │
│     ├── 04-scenarios/unit/ (테스트 시나리오)         │
│     ├── 03-components/ (컴포넌트 스펙)               │
│     └── 02-wireframes/ (testId 참조)                │
│                                                     │
│  2. Write Tests                                     │
│     └── Agent: qa-tester / qa-tester-high          │
│                                                     │
│  3. Run Tests                                       │
│     └── npm run test / npm run test:unit           │
│                                                     │
│  4. Verify Results                                  │
│     ├── Coverage 목표: 80%+                         │
│     └── Hard Gate: 60%                             │
│                                                     │
│  5. Fix Cycle (max 5 iterations)                   │
│     ├── 실패 분석                                   │
│     ├── 테스트/구현 수정                            │
│     └── 재실행                                      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Step 1: Context Loading
- spec-it 산출물에서 테스트 시나리오 로딩
  - `04-scenarios/unit/` → 단위 테스트 시나리오
  - `03-components/` → 컴포넌트별 테스트 케이스
  - `02-wireframes/` → testId 추출

### Step 2: Test Writing
- 시나리오 기반 단위 테스트 작성
- Agent 선택:
  - **qa-tester** (sonnet): 표준 컴포넌트 테스트
  - **qa-tester-high** (opus): 복잡한 의존성, 보안 테스트

### Step 3: Test Execution
```bash
# 테스트 실행
npm run test
# or
npm run test:unit
```

### Step 4: Coverage Verification
- Coverage report 생성
- 목표: 80%+ (Hard Gate: 60%)

### Step 5: Fix Cycle
- 최대 5회 반복
- 실패 시: 테스트 코드 또는 구현 코드 수정
- 5회 초과 실패 → Phase FAIL (수동 개입 필요)

## Execution

```bash
/spec-it:ultraqa unit --session={sessionId}
```

## Input

| Artifact | Purpose |
|----------|---------|
| 04-scenarios/unit/ | 테스트 시나리오 (TDD guide 산출물) |
| 03-components/ | 컴포넌트 스펙 |
| 02-wireframes/ | testId 매핑 |

## Output

| Artifact | Description |
|----------|-------------|
| *.test.ts / *.spec.ts | 단위 테스트 파일 |
| coverage/ | Coverage report |
| ultraqa-state.json | 테스트 상태 |

## Success Criteria

| Metric | Target | Hard Gate |
|--------|--------|-----------|
| Test Pass Rate | 100% | 95% |
| Coverage | 80% | 60% |
| Max Iterations | - | 5 |

## Failure Handling

```
Phase 6 FAIL
├── iterations > 5
├── coverage < 60%
└── critical tests failing

→ test-fix-tasks.json 생성
→ Phase 3 (Execute)로 회귀
→ Phase 4 → Phase 5 → Phase 6 재검증
```

## 회귀 포인트

**실패 시 → Phase 3 (Execute)로 회귀**

1. `test-fix-tasks.json` 생성:
```json
{
  "source": "test-report.md",
  "sourcePhase": 6,
  "generatedAt": "...",
  "iteration": 1,
  "tasks": [
    {
      "id": "fix-001",
      "type": "test-fail",
      "description": "Button disabled 테스트 실패 - 구현 누락",
      "priority": "HIGH",
      "files": ["src/components/Button.tsx"],
      "errorDetail": "Expected disabled=true but got undefined"
    }
  ]
}
```

2. **Phase 3 (Execute)로 회귀**:
```bash
/spec-it:dev-pilot {sessionId} --mode=fix --tasks=test-fix-tasks.json
```

3. Phase 4 → Phase 5 → Phase 6 순차 재검증
4. 최대 시도 횟수 초과 시 `waiting` 상태, 사용자 개입 필요
