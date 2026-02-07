# Phase 7: E2E Tests (Hard Gate)

## Overview
04-scenarios/e2e/ 시나리오 기반으로 E2E 테스트를 작성하고 실행합니다.
Critical path 테스트 100% 통과가 필수인 Hard Gate 단계입니다.

## Skill
- **ultraqa** (e2e mode)

## Agent
| Agent | Model | Role |
|-------|-------|------|
| qa-tester-high | opus | E2E 테스트 작성/실행 (Playwright/Cypress) |

## Process

```
┌─────────────────────────────────────────────────────┐
│              Phase 7: E2E Tests                      │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. Load Context                                    │
│     ├── 04-scenarios/e2e/ (E2E 시나리오)            │
│     └── 02-wireframes/ (사용자 흐름, testId)        │
│                                                     │
│  2. Write E2E Tests                                 │
│     ├── Playwright / Cypress 선택                   │
│     └── Agent: qa-tester-high (opus)               │
│                                                     │
│  3. Run E2E Tests                                   │
│     └── npm run test:e2e / npx playwright test     │
│                                                     │
│  4. Verify Results                                  │
│     ├── Critical path: 100% 필수                   │
│     └── Non-critical: 90% 목표                     │
│                                                     │
│  5. Fix Cycle (max 3 iterations)                   │
│     ├── 실패 시나리오 분석                          │
│     ├── 테스트/구현 수정                            │
│     └── 재실행                                      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Step 1: Context Loading
- spec-it 산출물에서 E2E 시나리오 로딩
  - `04-scenarios/e2e/` → E2E 테스트 시나리오
  - `02-wireframes/` → 사용자 흐름, testId 추출

### Step 2: E2E Test Writing
- Playwright 또는 Cypress 기반 E2E 테스트 작성
- Agent: **qa-tester-high** (opus)
  - Comprehensive E2E 테스트
  - 보안 검증 포함
  - Performance 기본 검증

### Step 3: Test Execution
```bash
# Playwright
npm run test:e2e
# or
npx playwright test

# Cypress
npx cypress run
```

### Step 4: Critical Path Verification
- Critical path 시나리오: **100% 통과 필수**
  - 로그인/로그아웃
  - 핵심 사용자 여정
  - 결제 흐름 (해당 시)
- Non-critical: 90% 목표

### Step 5: Fix Cycle
- 최대 3회 반복 (E2E는 비용이 높아 제한)
- 실패 시: 테스트 또는 구현 수정
- 3회 초과 실패 → **HARD FAIL** (수동 개입 필수)

## Execution

```bash
/spec-it:ultraqa e2e --session={sessionId}
```

## Input

| Artifact | Purpose |
|----------|---------|
| 04-scenarios/e2e/ | E2E 테스트 시나리오 (TDD guide 산출물) |
| 02-wireframes/ | 사용자 흐름, testId 매핑 |
| critical-paths.md | Critical path 목록 |

## Output

| Artifact | Description |
|----------|-------------|
| *.spec.ts (Playwright) | E2E 테스트 파일 |
| *.cy.ts (Cypress) | E2E 테스트 파일 |
| test-results/ | 테스트 결과, 스크린샷 |
| ultraqa-state.json | 테스트 상태 |

## Success Criteria

| Metric | Target | Hard Gate |
|--------|--------|-----------|
| Critical Path | 100% | 100% |
| Non-Critical | 90% | 80% |
| Max Iterations | - | 3 |

## Hard Gate Policy

```
Phase 7 is a HARD GATE
├── Critical path 100% 필수
├── 실패 시 Phase 8 진입 불가
└── 3회 초과 실패 → 프로젝트 중단

HARD FAIL 발생 시:
├── Manual intervention required
├── Review E2E scenarios
├── Check spec-mirror compliance
└── Verify implementation matches spec
```

## E2E Test Categories

### Critical (P0) - Must Pass
- 로그인/로그아웃 흐름
- 핵심 비즈니스 기능
- 데이터 CRUD 기본 흐름
- 결제/주문 프로세스

### Important (P1) - Should Pass
- 에러 처리 흐름
- Edge case 시나리오
- 권한/역할 기반 접근

### Nice-to-have (P2) - Best Effort
- 성능 기본 검증
- 다국어 지원
- 접근성 기본 검증

## Tmux Integration

Interactive 서비스 테스트 시:

```bash
# 서비스 시작
tmux new-session -d -s qa-e2e-{sessionId}
tmux send-keys -t qa-e2e-{sessionId} 'npm run dev' Enter

# 서비스 준비 대기
for i in {1..30}; do
  if tmux capture-pane -t qa-e2e-{sessionId} -p | grep -q 'ready'; then
    break
  fi
  sleep 1
done

# E2E 테스트 실행
npm run test:e2e

# 정리
tmux kill-session -t qa-e2e-{sessionId}
```

## Failure Handling

```
Phase 7 FAIL
├── Critical path failing
├── iterations > 3
└── Infrastructure issues

→ e2e-fix-tasks.json 생성
→ Phase 3 (Execute)로 회귀
→ Phase 4 → Phase 5 → Phase 6 → Phase 7 재검증
```

## Dual-Server E2E (if _meta.mockServerEnabled)

Phase 7은 Line A (UI)와 Line B (API)의 **합류 지점**입니다.
mock-server가 활성화된 경우, 두 서버를 동시 기동하여 E2E 테스트를 실행합니다.

### Playwright 설정

`playwright.config.ts`의 `webServer`를 배열로 구성:

```typescript
webServer: [
  {
    command: 'cd mock-server && npm run seed:reset && npm run dev',
    port: 4000,
    reuseExistingServer: !process.env.CI,
  },
  {
    command: 'npm run dev',
    port: 3000,
    reuseExistingServer: !process.env.CI,
    env: { NEXT_PUBLIC_API_URL: 'http://localhost:4000/api' },
  },
]
```

### 테스트 격리

- `beforeAll`: `POST http://localhost:4000/api/__admin/reset-db`
- 각 테스트 스위트 시작 전 DB 초기화로 격리 보장
- faker.seed(고정값)으로 결정적 시드 → assertion 안정성

### E2E 테스트 작성 시 주의

- 프론트엔드가 실제 mock-server API를 호출 (인라인 mock 아님)
- 데이터는 시드에서 결정적으로 생성 → assertion 가능
- `networkidle` 대신 `domcontentloaded` 사용 (타이머 있는 페이지)
- `waitForTimeout(1000)` 등으로 setInterval 안정화

### 합류 전 전제 조건

Phase 7 진입 전 반드시 확인:
- Line A: Phase 6A (Unit Tests) 통과
- Line B: Phase 6B (Unit Tests) 통과
- 두 라인 모두 `complete` 상태여야 Phase 7 진입 가능

### 루트 package.json 스크립트 추가

Phase 7 진입 시 다음 스크립트를 루트 `package.json`에 추가:

```json
{
  "mock:dev": "cd mock-server && npm run dev",
  "mock:seed": "cd mock-server && npm run seed:reset",
  "dev:full": "concurrently \"npm run dev\" \"npm run mock:dev\""
}
```

## 회귀 포인트

**실패 시 → Phase 3 (Execute)로 회귀**

1. `e2e-fix-tasks.json` 생성:
```json
{
  "source": "e2e-report.md",
  "sourcePhase": 7,
  "generatedAt": "...",
  "iteration": 1,
  "tasks": [
    {
      "id": "fix-001",
      "type": "e2e-critical",
      "description": "로그인 흐름 실패 - 에러 핸들링 누락",
      "priority": "CRITICAL",
      "files": ["src/pages/Login.tsx", "src/api/auth.ts"],
      "errorDetail": "Timeout waiting for selector [data-testid='error-message']"
    }
  ]
}
```

2. **Phase 3 (Execute)로 회귀**:
```bash
/spec-it:dev-pilot {sessionId} --mode=fix --tasks=e2e-fix-tasks.json
```

3. Phase 4 → Phase 5 → Phase 6 → Phase 7 순차 재검증
4. 최대 시도 횟수 초과 시 `waiting` 상태, 사용자 개입 필요
