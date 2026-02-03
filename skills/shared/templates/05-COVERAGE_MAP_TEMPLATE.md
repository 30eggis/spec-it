# {{system_name}} 테스트 커버리지 맵

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 작성일 | {{date}} |
| 목표 커버리지 | {{target_coverage}}%+ |

---

## 1. 커버리지 요약

### 1.1 전체 커버리지 목표

| 테스트 유형 | 목표 | 현재 상태 | Phase |
|------------|------|----------|-------|
{{#each coverage_targets}}
| {{type}} | {{target}} | {{current}} | {{phase}} |
{{/each}}

### 1.2 Phase별 테스트 분포

```
{{#each phase_distribution}}
{{phase_name}}:
{{#each categories}}
├── {{type}}: {{count}}개
{{/each}}

{{/each}}
```

---

## 2. 요구사항 → 테스트 매핑

{{#each requirement_mappings}}
### 2.{{@index}} {{requirement_group}}

#### {{requirement_id}}: {{requirement_name}}

| 세부 요구사항 | 테스트 케이스 | 유형 | Status |
|-------------|-------------|------|--------|
{{#each sub_requirements}}
| {{id}} | {{test_case}} | {{type}} | {{status}} |
{{/each}}

---

{{/each}}

## 3. 화면 → 테스트 매핑

{{#each screen_mappings}}
### 3.{{@index}} {{screen_name}} ({{screen_id}})

| 기능 영역 | 테스트 케이스 | Status |
|---------|-------------|--------|
{{#each features}}
| {{name}} | {{test_cases}} | {{status}} |
{{/each}}

{{/each}}

---

## 4. 컴포넌트 → 테스트 매핑

### 4.1 기존 컴포넌트

| 컴포넌트 ID | 컴포넌트명 | 테스트 케이스 수 | Status |
|-----------|----------|----------------|--------|
{{#each existing_components}}
| {{id}} | {{name}} | {{test_count}} | {{status}} |
{{/each}}

### 4.2 신규 컴포넌트

| 컴포넌트 ID | 컴포넌트명 | 테스트 케이스 수 | Status |
|-----------|----------|----------------|--------|
{{#each new_components}}
| {{id}} | {{name}} | {{test_count}} | {{status}} |
{{/each}}

---

## 5. Edge Cases → 테스트 매핑

{{#each edge_case_categories}}
### 5.{{@index}} {{category_name}}

| 예외 케이스 | 테스트 케이스 | Status |
|-----------|-------------|--------|
{{#each cases}}
| {{id}}: {{description}} | {{test_case}} | {{status}} |
{{/each}}

{{/each}}

---

## 6. 테스트 실행 계획

{{#each execution_plans}}
### 6.{{@index}} {{phase_name}}

#### {{week_name}}
```bash
{{execution_steps}}
```

{{/each}}

---

## 7. 커버리지 갭 분석

### 7.1 미커버 영역

| 영역 | 이유 | 계획 |
|------|------|------|
{{#each uncovered_areas}}
| {{area}} | {{reason}} | {{plan}} |
{{/each}}

### 7.2 추가 테스트 필요

| 영역 | 테스트 케이스 수 | Status |
|------|----------------|--------|
{{#each additional_tests_needed}}
| {{area}} | {{count}} | {{status}} |
{{/each}}

---

## 8. 요약

### 8.1 테스트 통계

| 분류 | 개수 | 진행률 |
|------|------|--------|
{{#each test_statistics}}
| {{type}} | {{count}}개 | {{progress}} |
{{/each}}
| **총계** | **{{total_count}}개** | **{{total_progress}}** |

### 8.2 커버리지 목표 달성률

| 항목 | 목표 | 현재 | 갭 |
|------|------|------|-----|
{{#each coverage_status}}
| {{type}} | {{target}} | {{current}} | {{gap}} |
{{/each}}

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
