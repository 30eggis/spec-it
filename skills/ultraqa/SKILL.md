---
name: ultraqa
description: "QA cycling workflow orchestrator. Test → Verify → Fix → Repeat until pass. Use for spec-it Execute Phase 6/7."
aliases: [qa, testloop]
---

# UltraQA Skill

[ULTRAQA ACTIVATED - TEST CYCLE ORCHESTRATION]

테스트 사이클을 관리하는 QA 워크플로우 오케스트레이터입니다.

## Purpose

spec-it Execute 단계에서 테스트 작성과 검증을 반복 수행:
- **Phase 6**: Unit Tests 작성 및 검증
- **Phase 7**: Scenario/E2E Tests 작성 및 검증

## User's Task

{{ARGUMENTS}}

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    ULTRAQA                          │
│              (Cycle Orchestrator)                   │
└─────────────────────┬───────────────────────────────┘
                      │
        ┌─────────────┴─────────────┐
        │                           │
        v                           v
┌───────────────┐           ┌───────────────┐
│   UNIT TEST   │           │   E2E TEST    │
│   (Phase 6)   │           │   (Phase 7)   │
└───────┬───────┘           └───────┬───────┘
        │                           │
        v                           v
┌─────────────────────────────────────────────┐
│              TEST CYCLE                      │
│  ┌────────┐    ┌────────┐    ┌────────┐     │
│  │ Write  │ -> │  Run   │ -> │ Verify │     │
│  │ Tests  │    │ Tests  │    │ Result │     │
│  └────────┘    └────────┘    └────┬───┘     │
│                                   │         │
│                    ┌──────────────┴───┐     │
│                    │                  │     │
│                    v                  v     │
│              ┌─────────┐        ┌─────────┐ │
│              │  FAIL   │        │  PASS   │ │
│              │  Fix &  │        │ Report  │ │
│              │ Repeat  │        │ Summary │ │
│              └─────────┘        └─────────┘ │
└─────────────────────────────────────────────┘
```

## Workflow

### Phase 6 Mode: Unit Tests

```bash
/spec-it:ultraqa unit --session={sessionId}
```

1. **Load Context**
   - Read `04-scenarios/unit/` from spec-it artifacts
   - Read `03-components/` for component specs
   - Read `02-wireframes/` for testId references

2. **Write Tests**
   - Generate unit test files based on scenarios
   - Agent: `qa-tester` (sonnet) for standard tests
   - Agent: `qa-tester-high` (opus) for complex tests

3. **Run Tests**
   ```bash
   npm run test
   # or
   npm run test:unit
   ```

4. **Verify Results**
   - Coverage 목표: 80%+
   - 실패 시 Fix cycle 진입

5. **Fix Cycle** (max 5 iterations)
   - 실패한 테스트 분석
   - 테스트 코드 또는 구현 코드 수정
   - 재실행

### Phase 7 Mode: E2E Tests

```bash
/spec-it:ultraqa e2e --session={sessionId}
```

1. **Load Context**
   - Read `04-scenarios/e2e/` from spec-it artifacts
   - Read `02-wireframes/` for user flow testIds

2. **Write Tests**
   - Generate E2E test files (Playwright/Cypress)
   - Agent: `qa-tester-high` (opus) for comprehensive E2E

3. **Run Tests**
   ```bash
   npm run test:e2e
   # or
   npx playwright test
   ```

4. **Verify Results**
   - Critical path 테스트 100% 통과 필수
   - 실패 시 Fix cycle 진입

5. **Fix Cycle** (max 3 iterations for E2E)
   - 실패한 시나리오 분석
   - 테스트 또는 구현 수정
   - 재실행

## Agent Selection

| Test Type | Complexity | Agent | Model |
|-----------|------------|-------|-------|
| Unit - Simple | Single function | qa-tester | sonnet |
| Unit - Complex | Multi-dependency | qa-tester-high | opus |
| Integration | Service layer | qa-tester-high | opus |
| E2E | User flows | qa-tester-high | opus |

## Test Cycle Rules

### Max Iterations
- Unit tests: 5 iterations
- E2E tests: 3 iterations
- 초과 시 HARD FAIL → 수동 개입 필요

### Fix Strategy
1. **Test Code Issue**: 테스트 assertion 또는 setup 수정
2. **Implementation Issue**: 구현 코드 버그 수정
3. **Spec Issue**: spec-it 산출물과 불일치 → spec-mirror 필요

### Coverage Targets
| Type | Target | Hard Gate |
|------|--------|-----------|
| Unit | 80% | 60% |
| Integration | 70% | 50% |
| E2E (Critical) | 100% | 100% |

## Output

### Unit Test Output
```
04-scenarios/unit/
├── *.test.ts        (generated)
└── coverage/
    └── lcov-report/
```

### E2E Test Output
```
04-scenarios/e2e/
├── *.spec.ts        (Playwright)
└── test-results/
```

## State Management

Track state in `.spec-it/{sessionId}/execute/ultraqa-state.json`:

```json
{
  "active": true,
  "mode": "unit",
  "sessionId": "abc123",
  "phase": "fix_cycle",
  "iteration": 2,
  "maxIterations": 5,
  "results": {
    "total": 45,
    "passed": 42,
    "failed": 3,
    "coverage": "76%"
  },
  "failedTests": [
    {
      "name": "Button.test.ts",
      "reason": "Expected disabled state",
      "fixAttempts": 1
    }
  ]
}
```

## Report Format

```markdown
## UltraQA Report

### Test Summary
| Metric | Value |
|--------|-------|
| Mode | Unit / E2E |
| Total Tests | 45 |
| Passed | 45 |
| Failed | 0 |
| Coverage | 82% |
| Iterations | 2 |

### Test Categories
#### Unit Tests
| Component | Tests | Passed | Coverage |
|-----------|-------|--------|----------|
| Button | 5 | 5 | 100% |
| LoginForm | 8 | 8 | 85% |

#### Edge Cases Verified
- [x] Null/undefined inputs
- [x] Empty arrays/strings
- [x] Boundary values
- [x] Error handling

### Verdict
**PASS** - All tests passing, coverage target met (82% > 80%)
```

## Integration with spec-it Execute

### Phase 6 Integration
```markdown
## Phase 6: Unit Tests

### Skill
- **ultraqa** (unit mode)

### Process
1. ultraqa unit --session={sessionId}
2. Test cycle until 80%+ coverage
3. Generate test files and coverage report

### Output
- Unit test files (*.test.ts)
- Coverage report
```

### Phase 7 Integration
```markdown
## Phase 7: E2E Tests

### Skill
- **ultraqa** (e2e mode)

### Process
1. ultraqa e2e --session={sessionId}
2. E2E cycle until critical paths pass
3. Generate E2E test files and results

### Output
- E2E test files (*.spec.ts)
- Test results
```

## Error Handling

### Test Framework Not Found
```
ERROR: Test framework not detected
ACTION: Install jest/vitest for unit, playwright/cypress for E2E
```

### Coverage Tool Not Found
```
ERROR: Coverage tool not configured
ACTION: Add coverage config to package.json or vitest.config.ts
```

### Max Iterations Exceeded
```
ERROR: Max iterations (5) exceeded with 3 failing tests
ACTION: Manual intervention required
FAILED_TESTS: [list of failing tests]
SUGGESTION: Check spec compliance with spec-mirror
```

## Tmux Integration

For interactive testing (CLI apps, services):

```bash
# Uses qa-tester agent with tmux
tmux new-session -d -s qa-{sessionId}-{testType}
tmux send-keys -t qa-{sessionId}-{testType} 'npm run test' Enter

# Capture results
tmux capture-pane -t qa-{sessionId}-{testType} -p
```

## Cancellation

Say "cancel" or "stop ultraqa" to gracefully terminate:
- Current test run cancelled
- Partial results saved
- Can resume with current state

## Resume

```
/spec-it:ultraqa resume {sessionId}
```

Continues from last iteration with preserved state.
