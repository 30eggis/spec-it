---
name: spec-test-loader
description: |
  점진적으로 테스트 계획서를 로딩합니다.
  전체 로딩, 카테고리별, 우선순위별, 컴포넌트별 로딩 지원.
  Agent의 컨텍스트 효율성을 위해 필요한 부분만 선택적으로 로딩합니다.
allowed-tools: Read, Glob, Grep
argument-hint: "<spec-folder> [--list] [--category <unit|integration|e2e>] [--priority <P0|P1|P2>] [--component <name>] [--coverage-gap]"
permissionMode: bypassPermissions
---

# spec-test-loader

테스트 계획서를 점진적으로 로딩하여 Agent의 컨텍스트를 효율적으로 관리합니다.

## 사용 목적

- Spec 문서가 크면 Agent 호출 시 컨텍스트 초과 위험
- 필요한 테스트 계획만 점진적으로 로딩
- Agent가 현재 작업에 필요한 테스트만 가져오도록 함

## 사용법

### 전체 테스트 목록 (요약)

```
/spec-test-loader {spec-folder} --list
```

**출력:**
```markdown
# 테스트 목록 요약

## Unit Tests (23개)
- P0: 8개
- P1: 10개
- P2: 5개

## Integration Tests (12개)
- P0: 4개
- P1: 6개
- P2: 2개

## E2E Tests (8개)
- P0: 3개
- P1: 4개
- P2: 1개

## 컴포넌트별
| 컴포넌트 | Unit | Integration | E2E |
|----------|------|-------------|-----|
| StockCard | 5 | 2 | 1 |
| PriceDisplay | 3 | 1 | 0 |
| ...
```

### 카테고리별 로딩

```
/spec-test-loader {spec-folder} --category unit
/spec-test-loader {spec-folder} --category integration
/spec-test-loader {spec-folder} --category e2e
```

**출력:** 해당 카테고리의 모든 테스트 스펙 전체 내용

### 우선순위별 로딩

```
/spec-test-loader {spec-folder} --priority P0
/spec-test-loader {spec-folder} --priority P1
/spec-test-loader {spec-folder} --priority P2
```

**출력:** 해당 우선순위의 테스트 스펙만 로딩

### 특정 컴포넌트 테스트만

```
/spec-test-loader {spec-folder} --component StockCard
/spec-test-loader {spec-folder} --component PriceDisplay
```

**출력:** 해당 컴포넌트의 테스트 스펙 전체 내용

### 커버리지 갭 분석

```
/spec-test-loader {spec-folder} --coverage-gap
```

**출력:**
```markdown
# 커버리지 갭 분석

## 테스트 미작성 컴포넌트
| 컴포넌트 | 예상 테스트 | 작성됨 | 갭 |
|----------|-------------|--------|-----|
| Header | 5 | 2 | 3 |
| Footer | 3 | 0 | 3 |

## 우선순위별 미커버리지
- P0 미커버리지: 2건 (긴급)
- P1 미커버리지: 5건
- P2 미커버리지: 8건

## 권장 작성 순서
1. Header - P0 테스트 3건
2. Footer - P0 테스트 2건
3. ...
```

## Spec 폴더 구조

```
{spec-folder}/05-tests/
├── coverage-map.md          → 커버리지 맵핑
├── personas/                → 페르소나 기반 테스트
│   ├── busy-professional.md
│   └── casual-investor.md
├── scenarios/               → E2E 시나리오
│   ├── critical-path.md
│   └── screen-*.md
└── components/              → 컴포넌트별 테스트
    ├── StockCard.test.md    → Markdown (legacy)
    ├── StockCard.test.yaml  → YAML (preferred)
    ├── PriceDisplay.test.md
    └── ...
```

## Format Detection

The loader auto-detects spec format by file extension:

| Extension | Format | Priority |
|-----------|--------|----------|
| `.test.yaml` | YAML (structured) | **Preferred** |
| `.test.md` | Markdown (legacy) | Fallback |

When both formats exist, YAML takes precedence.

## 로딩 로직

### --list 모드

```
1. Glob: {spec-folder}/05-tests/**/*.{yaml,md}
2. 각 파일에서 메타데이터 추출:
   - YAML: direct parse from id, priority, category fields
   - MD: regex parse from headers
   - 테스트 개수
   - 우선순위 분포
   - 카테고리
3. 요약 테이블 생성
```

### --category 모드

```
1. 카테고리 매핑:
   - unit → {spec-folder}/05-tests/components/*.{yaml,md}
   - integration → {spec-folder}/05-tests/scenarios/*-integration.{yaml,md}
   - e2e → {spec-folder}/05-tests/scenarios/*.{yaml,md}
2. Glob으로 파일 목록 획득 (YAML 우선)
3. 모든 파일 내용 Read
4. 통합 출력
```

### --priority 모드

```
1. YAML: Grep for "priority: \"P0\"" (etc)
2. MD: Grep: "Priority: {P0|P1|P2}" 또는 "우선순위: {P0|P1|P2}"
3. 매칭된 파일에서 해당 우선순위 섹션만 추출
4. 통합 출력
```

### --component 모드

```
1. Read: {spec-folder}/05-tests/components/{ComponentName}.test.yaml (preferred)
2. Fallback: {spec-folder}/05-tests/components/{ComponentName}.test.md
3. 없으면: Grep으로 컴포넌트명 검색
4. 관련 테스트 스펙 출력
```

### --coverage-gap 모드

```
1. Read: {spec-folder}/05-tests/coverage-map.md
2. Glob: {spec-folder}/05-tests/components/*.{yaml,md}
3. 기대 테스트 vs 실제 테스트 비교
4. 갭 분석 리포트 생성
```

## YAML Parsing Guide

YAML 포맷 테스트 스펙에서 데이터 추출:

```yaml
# 메타데이터
id: "TST-001"           → 테스트 ID
component: "StockCard"  → 컴포넌트 이름
category: "unit"        → unit | integration | e2e
priority: "P0"          → P0 | P1 | P2

# 테스트 케이스
tests:
  unit:
    - description: "renders correctly with props"
      type: "render"
      priority: "P0"
    - description: "handles click events"
      type: "interaction"
      priority: "P1"

  accessibility:
    - description: "meets WCAG 2.1 AA"
      type: "axe"
```

## Agent 연동 예시

### Phase 6: UNIT-TEST에서 사용

```
Task(test-implementer, opus):
  prompt: "
    # Step 1: 테스트 목록 확인
    Skill(spec-test-loader {spec-folder} --list)

    # Step 2: P0 우선순위 테스트만 로딩
    Skill(spec-test-loader {spec-folder} --priority P0)

    # Step 3: 해당 테스트 구현
    FOR test IN P0_tests:
      - Read test spec
      - Write test file
      - Run test
      - Verify pass

    # Step 4: P1 우선순위
    Skill(spec-test-loader {spec-folder} --priority P1)
    ...

    # Step 5: 커버리지 갭 확인
    Skill(spec-test-loader {spec-folder} --coverage-gap)
    → 추가 테스트 구현
  "
```

### 점진적 로딩 패턴

```
# 1단계: 전체 구조 파악 (가벼운 로딩)
Skill(spec-test-loader specs --list)

# 2단계: 필요한 부분만 상세 로딩
Skill(spec-test-loader specs --component StockCard)

# 3단계: 구현 후 다음 컴포넌트
Skill(spec-test-loader specs --component PriceDisplay)
```

## 출력 포맷

모든 출력은 Markdown 형식으로 제공됩니다:

```markdown
# {로딩 타입} 결과

## 메타데이터
- 로딩 일시: {timestamp}
- 소스: {spec-folder}
- 필터: {filter-type}

## 내용
{actual content}

---
*Loaded by spec-test-loader*
```

## 관련 Skill

- `spec-scenario-loader`: 시나리오 계획서 로딩
- `spec-component-loader`: 컴포넌트 스펙 로딩
- `spec-it-execute`: Phase 6에서 이 skill 사용
