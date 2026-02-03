# IA (Information Architecture) 리뷰

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 작성일 | {{date}} |
| 범위 | {{scope}} |

---

## 1. 네비게이션 구조 분석

### 1.1 현재 정의된 구조

```
{{navigation_structure}}
```

### 1.2 구조 평가

| 평가 항목 | 점수 | 비고 |
|----------|------|------|
{{#each structure_evaluation}}
| {{criteria}} | {{score}}/5 | {{notes}} |
{{/each}}

---

## 2. 이슈 목록

{{#each issues}}
### [{{id}}] {{title}}

**심각도**: {{severity}}

**현상**:
{{description}}

**문제점**:
{{#each problems}}
- {{this}}
{{/each}}

{{#if current_state}}
**현재 상태**:
{{#if current_state.table}}
| {{#each current_state.headers}}{{this}} | {{/each}}
|{{#each current_state.headers}}------|{{/each}}
{{#each current_state.rows}}
| {{#each this}}{{this}} | {{/each}}
{{/each}}
{{else}}
{{current_state.description}}
{{/if}}
{{/if}}

**권장 조치**:
{{#if recommended_action.code}}
```
{{recommended_action.code}}
```
{{else}}
{{#each recommended_action.points}}
{{@index}}. {{this}}
{{/each}}
{{/if}}

---

{{/each}}

## 3. 페이지 계층 구조 분석

{{#each mode_hierarchies}}
### 3.{{@index}} {{mode_name}} 계층도

| Page | Parent | Children | 깊이 | Issues |
|------|--------|----------|------|--------|
{{#each pages}}
| {{name}} | {{parent}} | {{children}} | {{depth}} | {{issues}} |
{{/each}}

{{/each}}

---

## 4. 사용자 플로우 일관성

{{#each flow_analyses}}
### 4.{{@index}} {{flow_name}} 분석

```
{{flow_diagram}}
```

**문제**: {{problem}}

**권장 조치**:
{{#each recommendations}}
{{@index}}. {{this}}
{{/each}}

{{/each}}

---

## 5. 모바일 IA 고려사항

### 5.1 현재 반응형 정의

| 디바이스 | 브레이크포인트 | 사이드바 동작 |
|----------|---------------|--------------|
{{#each responsive_definitions}}
| {{device}} | {{breakpoint}} | {{sidebar_behavior}} |
{{/each}}

### 5.2 모바일 메뉴 우선순위

**제안**: {{mobile_suggestion}}

```
{{#each mobile_nav}}
{{mode}}:
{{items}}
{{/each}}
```

---

## 6. 권장 개선안

{{#each improvement_phases}}
### 6.{{@index}} {{phase_name}}

| ID | 이슈 | 권장 조치 | 우선순위 |
|----|------|----------|----------|
{{#each items}}
| {{id}} | {{issue}} | {{action}} | {{priority}} |
{{/each}}

{{/each}}

---

## 7. 네비게이션 매트릭스

### 7.1 화면 간 이동 관계

| From \ To | {{#each screens}}{{name}} | {{/each}}
|-----------|{{#each screens}}------|{{/each}}
{{#each navigation_matrix}}
| {{from}} | {{#each destinations}}{{this}} | {{/each}}
{{/each}}

{{legend}}

### 7.2 크로스 링크 제안

{{#each cross_link_suggestions}}
{{@index}}. **{{title}}**
{{#each links}}
   - {{from}} > {{to}}
{{/each}}

{{/each}}

---

## 8. Breadcrumb 전략

### 8.1 제안 패턴

```
{{#each breadcrumb_patterns}}
{{depth}}: {{pattern}}
  예: {{example}}

{{/each}}
```

### 8.2 구현 우선순위

| 깊이 | 필요성 | Phase |
|------|--------|-------|
{{#each breadcrumb_priority}}
| {{depth}} | {{necessity}} | {{phase}} |
{{/each}}

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
