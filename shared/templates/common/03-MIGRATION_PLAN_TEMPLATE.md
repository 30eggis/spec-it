# {{system_name}} 컴포넌트 마이그레이션 계획

## 문서 정보
| 항목        | 내용                        |
| ----------- | --------------------------- |
| 버전        | {{version}}                 |
| 작성일      | {{date}}                    |
| 대상 시스템 | {{target_system}}           |

---

## 1. 마이그레이션 개요

### 1.1 목적
{{#each purposes}}
- {{this}}
{{/each}}

### 1.2 범위
| 구분                       | 개수     | 상태      |
| -------------------------- | -------- | --------- |
{{#each scope_items}}
| {{name}}                   | {{count}}개 | {{status}} |
{{/each}}
| **합계**                   | **{{total_count}}개** |           |

---

## 2. 신규 컴포넌트 ({{new_component_range}})

### 2.1 개요
{{overview_description}}

| ID      | 컴포넌트명     | 우선순위 | Phase    |
| ------- | -------------- | -------- | -------- |
{{#each new_components}}
| {{id}} | {{name}}     | {{priority}} | {{phase}} |
{{/each}}

### 2.2 의존성 맵

```
{{dependency_map}}
```

---

## 3. Gap 컴포넌트 추가 계획

{{#each gap_categories}}
### 3.{{@index}} {{priority}} ({{priority_code}}) - {{description}}

| ID       | 컴포넌트명 | 설명                | 예상 공수 |
| -------- | ---------- | ------------------- | --------- |
{{#each components}}
| {{id}} | {{name}} | {{description}} | {{effort}} |
{{/each}}

**소계**: {{subtotal}}

{{/each}}

---

## 4. Phase별 배포 로드맵

{{#each phase_roadmap}}
### 4.{{@index}} {{phase_name}}

**기존 컴포넌트 ({{existing_count}}개)**
{{#each existing_components}}
- {{category}}: {{components}}
{{/each}}

**신규 추가 ({{new_count}}개)**
{{#each new_components}}
- {{id}}: {{name}}
{{/each}}

**{{phase_name}} 합계: {{total_count}}개**

{{/each}}

---

## 5. 구현 가이드라인

### 5.1 파일 구조

```
{{file_structure}}
```

### 5.2 네이밍 규칙

| 항목          | 규칙          | 예시                     |
| ------------- | ------------- | ------------------------ |
{{#each naming_rules}}
| {{item}} | {{rule}} | `{{example}}` |
{{/each}}

### 5.3 필수 Export

모든 컴포넌트 디렉토리는 `index.ts`를 포함해야 함:

```typescript
{{export_example}}
```

### 5.4 테스트 커버리지 목표

| 유형               | 목표        |
| ------------------ | ----------- |
{{#each coverage_goals}}
| {{type}}          | {{target}} |
{{/each}}

---

## 6. 마이그레이션 일정

### 6.1 상세 일정

```
{{schedule}}
```

### 6.2 마일스톤

| 마일스톤 | 완료 기준              | 목표일 |
| -------- | ---------------------- | ------ |
{{#each milestones}}
| {{id}}       | {{criteria}} | {{target_date}} |
{{/each}}

---

## 7. 리스크 및 대응

| 리스크                 | 영향   | 대응 방안               |
| ---------------------- | ------ | ----------------------- |
{{#each risks}}
| {{risk}}                 | {{impact}}   | {{mitigation}}               |
{{/each}}

---

## 8. 체크리스트

### 8.1 컴포넌트 구현 체크리스트

{{#each implementation_checklist}}
- [ ] {{this}}
{{/each}}

### 8.2 통합 체크리스트

{{#each integration_checklist}}
- [ ] {{this}}
{{/each}}

---

## 변경 이력

| 버전 | 날짜       | 작성자  | 변경 내용 |
| ---- | ---------- | ------- | --------- |
| {{version}} | {{date}} | {{author}} | {{change_description}} |
