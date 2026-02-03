# {{system_name}} - 페르소나 개요

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 작성일 | {{date}} |
| 버전 | {{version}} |
| 목적 | 사용자 페르소나 기반 테스트 시나리오 설계 |

---

## 1. 페르소나 목록

{{#each persona_groups}}
### 1.{{@index}} {{group_name}} ({{count}}개)

| 페르소나 | 직책 | {{column_3_name}} | 핵심 특징 |
|---------|------|----------|----------|
{{#each personas}}
| {{name}} | {{title}} | {{column_3_value}} | {{key_feature}} |
{{/each}}

{{/each}}

**총 {{total_count}}개 페르소나**

---

## 2. 페르소나별 주요 사용 패턴

### 2.1 접속 빈도 및 시간대

| 페르소나 | 주간 접속일 | 일일 접속 횟수 | 주요 시간대 |
|---------|-----------|--------------|-----------|
{{#each personas}}
| {{name}} ({{role}}) | {{weekly_access}} | {{daily_access}} | {{peak_times}} |
{{/each}}

### 2.2 디바이스 사용 분포

| 디바이스 | 주요 사용자 | 비고 |
|---------|-----------|------|
{{#each devices}}
| {{device_type}} | {{users}} | {{note}} |
{{/each}}

---

## 3. 페르소나별 핵심 니즈 매트릭스

| 니즈 | {{#each persona_headers}}{{this}} | {{/each}}
|-----|{{#each persona_headers}}---------|{{/each}}
{{#each needs_matrix}}
| {{need}} | {{#each scores}}{{this}} | {{/each}}
{{/each}}

**범례:** ●●● 매우 중요, ●● 중요, ● 보통, - 해당 없음

---

## 4. 페르소나별 불만 사항 분류

### 4.1 UI/UX 관련

| 불만 | 페르소나 | 우선순위 |
|-----|---------|---------|
{{#each ux_complaints}}
| {{complaint}} | {{persona}} | {{priority}} |
{{/each}}

### 4.2 기능 관련

| 불만 | 페르소나 | 우선순위 |
|-----|---------|---------|
{{#each feature_complaints}}
| {{complaint}} | {{persona}} | {{priority}} |
{{/each}}

### 4.3 정보/계산 관련

| 불만 | 페르소나 | 우선순위 |
|-----|---------|---------|
{{#each info_complaints}}
| {{complaint}} | {{persona}} | {{priority}} |
{{/each}}

---

## 5. 페르소나별 테스트 시나리오 매핑

{{#each scenario_groups}}
### 5.{{@index}} {{group_name}} 시나리오

| 시나리오 ID | {{#each persona_headers}}{{this}} | {{/each}}
|------------|{{#each persona_headers}}-------------|{{/each}}
{{#each scenarios}}
| {{id}} | {{#each relevance}}{{this}} | {{/each}}
{{/each}}

{{/each}}

**범례:** ●●● 핵심 시나리오, ●● 주요 시나리오, ● 보조 시나리오, - 해당 없음

---

## 6. 페르소나 기반 테스트 전략

{{#each phase_priorities}}
### 6.{{@index}} {{phase_name}} 우선순위 페르소나

{{#each personas}}
{{@index}}. **{{name}}** - {{reason}}
{{/each}}

{{/each}}

---

## 7. 페르소나별 성공 기준

{{#each persona_groups}}
### 7.{{@index}} {{group_name}}

| 페르소나 | 성공 기준 |
|---------|----------|
{{#each personas}}
| {{name}} | {{success_criteria}} |
{{/each}}

{{/each}}

---

## 8. 페르소나 활용 가이드

### 8.1 테스트 설계 시

1. 각 기능별로 연관 페르소나 선정
2. 페르소나의 니즈와 불만 사항 검토
3. 성공 기준에 맞춰 테스트 케이스 작성
4. 우선순위 페르소나부터 테스트 진행

### 8.2 UI/UX 리뷰 시

1. 페르소나의 기술 수준 고려
2. 디바이스 환경 고려 (PC/모바일/태블릿)
3. 사용 시간대 고려 (긴급/여유)
4. 불만 사항 해결 여부 확인

### 8.3 개발 우선순위 결정 시

1. 우선순위 높은 페르소나의 핵심 니즈 우선
2. 다수 페르소나에게 공통된 불만 우선 해결
3. PHASE별 페르소나 그룹 고려

---

## 9. 결정 사항 반영

{{#each decisions}}
### 9.{{@index}} {{decision_id}}: {{title}}
- **페르소나**: {{affected_persona}}
- **핵심 니즈**: {{key_need}}

{{/each}}

---

## 10. 파일 구조

```
{{output_folder}}/05-tests/personas/
├── 00-personas-overview.md          (본 문서)
{{#each persona_files}}
├── {{filename}}          ({{description}})
{{/each}}
```

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
