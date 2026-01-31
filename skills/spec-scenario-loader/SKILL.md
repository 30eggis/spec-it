---
name: spec-scenario-loader
description: |
  점진적으로 시나리오 계획서를 로딩합니다.
  페르소나별, 화면별, Critical Path별 로딩 지원.
  Agent의 컨텍스트 효율성을 위해 필요한 부분만 선택적으로 로딩합니다.
allowed-tools: Read, Glob, Grep
argument-hint: "<spec-folder> [--list] [--persona <name>] [--screen <name>] [--critical-path] [--failed]"
permissionMode: bypassPermissions
---

# spec-scenario-loader

시나리오 계획서를 점진적으로 로딩하여 Agent의 컨텍스트를 효율적으로 관리합니다.

## 사용 목적

- E2E 시나리오가 많으면 Agent 호출 시 컨텍스트 초과 위험
- 필요한 시나리오만 점진적으로 로딩
- Critical Path 우선, 화면별/페르소나별 세분화된 로딩

## 사용법

### 전체 시나리오 목록 (요약)

```
/spec-scenario-loader {spec-folder} --list
```

**출력:**
```markdown
# 시나리오 목록 요약

## Critical Path (5개)
1. 회원가입 → 로그인 → 대시보드 접근
2. 종목 검색 → 상세 보기 → 관심종목 추가
3. 포트폴리오 조회 → 매수/매도
4. 알림 설정 → 알림 수신 확인
5. 설정 변경 → 로그아웃

## 화면별 시나리오
| 화면 | 시나리오 수 | 주요 플로우 |
|------|-------------|-------------|
| Dashboard | 8 | 실시간 데이터, 위젯 상호작용 |
| StockDetail | 6 | 차트, 매매, 알림 |
| Settings | 4 | 프로필, 알림, 테마 |
| Search | 3 | 검색, 필터, 정렬 |

## 페르소나별 시나리오
| 페르소나 | 시나리오 수 | 핵심 니즈 |
|----------|-------------|-----------|
| Busy Professional | 5 | 빠른 정보 확인 |
| Casual Investor | 4 | 간단한 매매 |
| Day Trader | 6 | 실시간 데이터, 빠른 주문 |
```

### 페르소나별 로딩

```
/spec-scenario-loader {spec-folder} --persona "Busy Professional"
/spec-scenario-loader {spec-folder} --persona "Casual Investor"
```

**출력:** 해당 페르소나의 모든 시나리오 전체 내용

### 화면별 시나리오

```
/spec-scenario-loader {spec-folder} --screen dashboard
/spec-scenario-loader {spec-folder} --screen stock-detail
/spec-scenario-loader {spec-folder} --screen settings
```

**출력:** 해당 화면의 모든 시나리오 전체 내용

### Critical Path만

```
/spec-scenario-loader {spec-folder} --critical-path
```

**출력:** Critical Path 시나리오만 로딩 (가장 중요한 사용자 흐름)

### 실패한 시나리오만 (재실행용)

```
/spec-scenario-loader {spec-folder} --failed
```

**출력:** 마지막 E2E 실행에서 실패한 시나리오만 로딩

## Spec 폴더 구조

```
{spec-folder}/04-review/scenarios/
├── critical-path.md           → Critical Path 시나리오
├── screen-dashboard.md        → Dashboard 화면 시나리오
├── screen-stock-detail.md     → 종목 상세 화면 시나리오
├── screen-settings.md         → 설정 화면 시나리오
├── screen-search.md           → 검색 화면 시나리오
├── persona-busy-professional.md
├── persona-casual-investor.md
└── persona-day-trader.md
```

## 로딩 로직

### --list 모드

```
1. Glob: {spec-folder}/04-review/scenarios/*.md
2. 각 파일에서 메타데이터 추출:
   - 시나리오 개수
   - 화면/페르소나 분류
   - Critical Path 여부
3. 요약 테이블 생성
```

### --persona 모드

```
1. Read: {spec-folder}/04-review/scenarios/persona-{name}.md
2. 없으면 Grep으로 페르소나명 검색
3. 관련 시나리오 통합 출력
```

### --screen 모드

```
1. Read: {spec-folder}/04-review/scenarios/screen-{name}.md
2. 해당 화면의 모든 시나리오 출력
```

### --critical-path 모드

```
1. Read: {spec-folder}/04-review/scenarios/critical-path.md
2. 전체 내용 출력
```

### --failed 모드

```
1. Read: .spec-it/execute/{sessionId}/logs/e2e-results.json
2. 실패한 시나리오 ID 추출
3. 해당 시나리오만 로딩
4. 실패 원인 컨텍스트 포함
```

## 시나리오 포맷

각 시나리오 파일은 다음 형식을 따릅니다:

```markdown
# Screen: Dashboard

## Scenario: SC-001 실시간 주가 확인

**페르소나:** Busy Professional
**Priority:** P0
**Critical Path:** Yes

### Given (전제조건)
- 사용자가 로그인된 상태
- 관심종목이 최소 1개 이상 등록됨

### When (동작)
1. Dashboard 페이지 접근
2. 실시간 주가 위젯 확인

### Then (기대결과)
- [ ] 관심종목 주가가 실시간으로 업데이트됨
- [ ] 등락률이 색상으로 구분됨 (상승: 빨강, 하락: 파랑)
- [ ] 마지막 업데이트 시간이 표시됨

### Playwright 힌트
```typescript
await page.goto('/dashboard');
await expect(page.locator('[data-testid="price-widget"]')).toBeVisible();
await expect(page.locator('[data-testid="last-update"]')).toContainText(/\d{2}:\d{2}/);
```
```

## Agent 연동 예시

### Phase 7: SCENARIO-TEST에서 사용

```
Task(e2e-implementer, opus):
  prompt: "
    # Step 1: Critical Path 먼저 구현
    Skill(spec-scenario-loader {spec-folder} --critical-path)
    → E2E 테스트 구현

    # Step 2: 화면별 시나리오
    FOR screen IN [dashboard, stock-detail, settings]:
      Skill(spec-scenario-loader {spec-folder} --screen {screen})
      → E2E 테스트 구현

    # Step 3: 실패 케이스 재확인
    Skill(spec-scenario-loader {spec-folder} --failed)
    → 실패 원인 분석 및 수정
  "
```

### 점진적 로딩 패턴

```
# 1단계: 전체 구조 파악
Skill(spec-scenario-loader specs --list)

# 2단계: Critical Path 우선 (가장 중요)
Skill(spec-scenario-loader specs --critical-path)

# 3단계: 화면별 세부 시나리오
Skill(spec-scenario-loader specs --screen dashboard)

# 4단계: 특정 페르소나 시나리오
Skill(spec-scenario-loader specs --persona "Busy Professional")
```

## 출력 포맷

모든 출력은 Markdown 형식으로 제공됩니다:

```markdown
# {로딩 타입} 시나리오

## 메타데이터
- 로딩 일시: {timestamp}
- 소스: {spec-folder}
- 필터: {filter-type}
- 시나리오 수: {count}

## 시나리오 목록

{actual content}

---
*Loaded by spec-scenario-loader*
```

## E2E 실행 결과 연동

### 실패 시나리오 추적

```json
// .spec-it/execute/{sessionId}/logs/e2e-results.json
{
  "timestamp": "2026-01-30T15:00:00Z",
  "total": 15,
  "passed": 13,
  "failed": 2,
  "failures": [
    {
      "scenarioId": "SC-003",
      "file": "screen-dashboard.md",
      "error": "Timeout waiting for price update",
      "screenshot": "screenshots/sc-003-failure.png"
    }
  ]
}
```

### --failed 모드 출력

```markdown
# 실패한 시나리오 (2건)

## SC-003: 실시간 주가 업데이트

**파일:** screen-dashboard.md
**에러:** Timeout waiting for price update
**스크린샷:** screenshots/sc-003-failure.png

### 원본 시나리오
{scenario content}

### 실패 분석
- WebSocket 연결 지연 가능성
- Mock 서버 응답 확인 필요

---
```

## 관련 Skill

- `spec-test-loader`: 테스트 계획서 로딩
- `spec-component-loader`: 컴포넌트 스펙 로딩
- `spec-it-execute`: Phase 7에서 이 skill 사용
