---
name: spec-component-loader
description: |
  점진적으로 컴포넌트 스펙을 로딩합니다.
  카테고리별, 우선순위별, 의존성 기반 로딩 지원.
  Agent의 컨텍스트 효율성을 위해 필요한 부분만 선택적으로 로딩합니다.
allowed-tools: Read, Glob, Grep
argument-hint: "<spec-folder> [--list] [--category <layout|display|cards|forms|...>] [--name <ComponentName>] [--with-deps] [--gap]"
permissionMode: bypassPermissions
---

# spec-component-loader

컴포넌트 스펙을 점진적으로 로딩하여 Agent의 컨텍스트를 효율적으로 관리합니다.

## 사용 목적

- 컴포넌트 스펙이 많으면 Agent 호출 시 컨텍스트 초과 위험
- 필요한 컴포넌트만 점진적으로 로딩
- 의존성 그래프를 고려한 효율적인 구현 순서 제공

## 사용법

### 전체 컴포넌트 목록

```
/spec-component-loader {spec-folder} --list
```

**출력:**
```markdown
# 컴포넌트 목록

## 카테고리별 분류

### Layout (4개)
- Header
- Sidebar
- Footer
- MainLayout

### Cards (6개)
- StockCard
- PortfolioCard
- NewsCard
- AlertCard
- WatchlistCard
- SummaryCard

### Display (8개)
- PriceDisplay
- ChangeIndicator
- Sparkline
- ChartWidget
- DataTable
- Badge
- Tooltip
- Avatar

### Forms (5개)
- SearchInput
- OrderForm
- AlertForm
- SettingsForm
- LoginForm

### Feedback (3개)
- Toast
- LoadingSpinner
- ErrorBoundary

## 의존성 요약
| 컴포넌트 | 의존 | 피의존 | 복잡도 |
|----------|------|--------|--------|
| StockCard | 3 | 5 | HIGH |
| PriceDisplay | 1 | 8 | MEDIUM |
| Header | 2 | 1 | LOW |
```

### 카테고리별 로딩

```
/spec-component-loader {spec-folder} --category layout
/spec-component-loader {spec-folder} --category cards
/spec-component-loader {spec-folder} --category display
/spec-component-loader {spec-folder} --category forms
```

**출력:** 해당 카테고리의 모든 컴포넌트 스펙 전체 내용

### 특정 컴포넌트 로딩

```
/spec-component-loader {spec-folder} --name StockCard
/spec-component-loader {spec-folder} --name PriceDisplay
```

**출력:** 해당 컴포넌트의 스펙 전체 내용

### 의존성 포함 로딩

```
/spec-component-loader {spec-folder} --name StockCard --with-deps
```

**출력:**
```markdown
# StockCard + 의존성

## 의존성 트리
StockCard
├── PriceDisplay (display)
├── ChangeIndicator (display)
└── Sparkline (display)

## 1. PriceDisplay (의존성)
{PriceDisplay spec content}

## 2. ChangeIndicator (의존성)
{ChangeIndicator spec content}

## 3. Sparkline (의존성)
{Sparkline spec content}

## 4. StockCard (대상)
{StockCard spec content}
```

### Gap Analysis (미구현 컴포넌트)

```
/spec-component-loader {spec-folder} --gap
```

**출력:**
```markdown
# 컴포넌트 Gap Analysis

## 미구현 컴포넌트 (12개)

### 우선순위별
| 우선순위 | 컴포넌트 | 카테고리 | 복잡도 |
|----------|----------|----------|--------|
| P0 | StockCard | cards | HIGH |
| P0 | PriceDisplay | display | MEDIUM |
| P1 | Header | layout | LOW |
| ... |

## 권장 구현 순서
1. PriceDisplay (display) - 의존성 없음, 8개 컴포넌트가 의존
2. ChangeIndicator (display) - 의존성 없음, 5개 컴포넌트가 의존
3. Sparkline (display) - 의존성 없음, 3개 컴포넌트가 의존
4. StockCard (cards) - 위 3개 의존, P0 우선순위
...

## 구현 배치 (병렬화 가능)
### Batch 1 (의존성 없음)
- PriceDisplay
- ChangeIndicator
- Sparkline
- Badge

### Batch 2 (Batch 1 완료 후)
- StockCard
- PortfolioCard
- AlertCard

### Batch 3
...
```

## Spec 폴더 구조

```
{spec-folder}/03-components/
├── component-inventory.md     → 전체 컴포넌트 목록
├── gap-analysis.md            → Gap 분석 결과
└── specs/
    ├── layout/
    │   ├── Header.md
    │   ├── Sidebar.md
    │   └── Footer.md
    ├── cards/
    │   ├── StockCard.md
    │   └── PortfolioCard.md
    ├── display/
    │   ├── PriceDisplay.md
    │   └── ChangeIndicator.md
    ├── forms/
    │   └── SearchInput.md
    └── feedback/
        └── Toast.md
```

## 로딩 로직

### --list 모드

```
1. Read: {spec-folder}/03-components/component-inventory.md
2. Glob: {spec-folder}/03-components/specs/**/*.md
3. 각 파일에서 메타데이터 추출
4. 카테고리별, 의존성 요약 생성
```

### --category 모드

```
1. Glob: {spec-folder}/03-components/specs/{category}/*.md
2. 모든 파일 내용 Read
3. 통합 출력
```

### --name 모드

```
1. Glob: {spec-folder}/03-components/specs/**/{name}.md
2. Read 해당 파일
3. 출력
```

### --with-deps 모드

```
1. --name으로 대상 컴포넌트 로딩
2. 스펙에서 "Dependencies:" 섹션 파싱
3. 각 의존성 재귀적으로 로딩 (순환 참조 방지)
4. 토폴로지 정렬하여 출력 (의존성 먼저)
```

### --gap 모드

```
1. Read: {spec-folder}/03-components/gap-analysis.md
2. 또는 동적 분석:
   - 스펙에 정의된 컴포넌트 목록
   - 실제 구현된 컴포넌트 (src/components/**/*.tsx)
   - 차집합 계산
3. 구현 순서 권장 (의존성 고려)
```

## 컴포넌트 스펙 포맷

각 컴포넌트 스펙은 다음 형식을 따릅니다:

```markdown
# StockCard

**카테고리:** cards
**우선순위:** P0
**복잡도:** HIGH

## 의존성 (Dependencies)
- PriceDisplay
- ChangeIndicator
- Sparkline

## 피의존성 (Used By)
- Dashboard
- WatchlistPage
- SearchResults

## Props

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| symbol | string | Yes | - | 종목 코드 |
| onSelect | () => void | No | - | 선택 시 콜백 |
| variant | 'compact' \| 'full' | No | 'full' | 표시 모드 |

## States

| State | Description | Visual |
|-------|-------------|--------|
| default | 기본 상태 | 흰색 배경 |
| hover | 마우스 오버 | 밝은 그림자 |
| selected | 선택됨 | 파란 테두리 |
| loading | 로딩 중 | 스켈레톤 |
| error | 에러 | 빨간 테두리 |

## Interactions

| Trigger | Action | Result |
|---------|--------|--------|
| Click | onSelect 호출 | 상세 페이지 이동 |
| Long Press | 컨텍스트 메뉴 | 빠른 액션 표시 |

## 접근성 (a11y)
- role: article
- aria-label: "{symbol} 주식 카드"
- 키보드: Enter/Space로 선택

## 테스트 힌트
- 실시간 가격 업데이트 테스트
- 로딩 상태 렌더링
- 에러 상태 렌더링
```

## Agent 연동 예시

### Phase 3: EXECUTE에서 사용

```
Task(spec-executor, opus):
  prompt: "
    # Step 1: 구현할 컴포넌트 스펙 로딩
    Skill(spec-component-loader {spec-folder} --name PriceDisplay --with-deps)

    # Step 2: 구현
    - 의존성부터 구현
    - 대상 컴포넌트 구현
    - 테스트 작성

    # Step 3: 다음 컴포넌트
    Skill(spec-component-loader {spec-folder} --name StockCard --with-deps)
  "
```

### 점진적 로딩 패턴

```
# 1단계: 전체 구조 파악
Skill(spec-component-loader specs --list)

# 2단계: Gap 분석으로 구현 순서 결정
Skill(spec-component-loader specs --gap)

# 3단계: Batch 1 컴포넌트 (의존성 없음) 병렬 구현
Skill(spec-component-loader specs --category display)

# 4단계: Batch 2 컴포넌트 (의존성 있음)
Skill(spec-component-loader specs --name StockCard --with-deps)
```

## 출력 포맷

모든 출력은 Markdown 형식으로 제공됩니다:

```markdown
# {로딩 타입} 결과

## 메타데이터
- 로딩 일시: {timestamp}
- 소스: {spec-folder}
- 필터: {filter-type}
- 컴포넌트 수: {count}

## 내용

{actual content}

---
*Loaded by spec-component-loader*
```

## 관련 Skill

- `spec-test-loader`: 테스트 계획서 로딩
- `spec-scenario-loader`: 시나리오 계획서 로딩
- `spec-it-execute`: Phase 3, 5에서 이 skill 사용
