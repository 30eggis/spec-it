# {{system_name}} - 컴포넌트 인벤토리

**문서 정보**
| 항목 | 내용 |
|------|------|
| 시스템명 | {{system_name}} |
| 감사 일시 | {{date}} |
| Phase | {{phase_range}} |
| 상태 | {{status}} |

---

## 1. 컴포넌트 요약 (Summary)

### 카테고리별 분포

| 카테고리 | 개수 | Phase | 상태 |
|----------|------|-------|------|
{{#each category_summary}}
| {{category}} | {{count}} | {{phase}} | {{status}} |
{{/each}}
| **합계** | **{{total_count}}** | - | **{{overall_status}}** |

### Phase별 분포

| Phase | 컴포넌트 수 | 범위 |
|-------|----------|------|
{{#each phase_summary}}
| {{phase}} | {{count}} | {{scope}} |
{{/each}}

---

{{#each categories}}
## {{@index}}. {{category_name}} 컴포넌트 ({{id_range}})

{{#each components}}
### {{id}}: {{name}}

| 항목 | 내용 |
|------|------|
| **ID** | {{id}} |
| **이름** | {{name}} |
| **카테고리** | {{category}} |
| **Phase** | {{phase}} |
| **설명** | {{description}} |
| **상태** | {{status}} |
| **사용 화면** | {{used_screens}} |

**주요 Props**
{{#each props}}
- `{{name}}`: {{type}} {{#if required}}(필수){{else}}(선택{{#if default}}, 기본값: {{default}}{{/if}}){{/if}}
{{/each}}

{{#if special_features}}
**특수 기능**
{{#each special_features}}
- {{this}}
{{/each}}
{{/if}}

{{#if variants}}
**변형**
{{#each variants}}
- {{name}}: {{description}}
{{/each}}
{{/if}}

{{#if sizes}}
**크기**
{{#each sizes}}
- {{name}}: {{value}}
{{/each}}
{{/if}}

---

{{/each}}
{{/each}}

## {{section_number}}. 화면별 컴포넌트 사용 현황

{{#each screen_usage}}
### {{screen_name}} ({{screen_id}})

| 컴포넌트 | 사용 위치 | 역할 |
|---------|---------|------|
{{#each components}}
| {{id}} | {{location}} | {{role}} |
{{/each}}

{{#if missing_components}}
**사용하지만 정의되지 않은 컴포넌트**
{{#each missing_components}}
- `{{name}}`: {{description}}
{{/each}}
{{/if}}

---

{{/each}}

## {{section_number}}. 조합 컴포넌트 (Composite Components)

현재 정의되지 않았으나 와이어프레임에서 자주 사용되는 조합:

{{#each composite_components}}
### {{name}}
{{#each children}}
- {{id}} ({{name}})
{{/each}}
{{#if container}}
- 컨테이너 레이아웃
{{/if}}

**사용 화면**: {{used_screens}}

{{/each}}

---

## {{section_number}}. 컴포넌트 의존성 맵

```
{{dependency_tree}}
```

---

## {{section_number}}. 검증 결과

### 문제점

{{#each issues}}
{{@index}}. **{{category}}**
{{#each items}}
   - `{{name}}`: {{description}}
{{/each}}

{{/each}}

---

## {{section_number}}. 권장 사항

{{#each recommendations}}
### {{phase}}

{{#each items}}
{{@index}}. **{{id}}: {{name}}**
   - {{description}}

{{/each}}
{{/each}}

---

## {{section_number}}. 버전 히스토리

| 버전 | 날짜 | 변경 사항 |
|------|------|----------|
{{#each version_history}}
| {{version}} | {{date}} | {{changes}} |
{{/each}}

---

## 주의사항

{{#each notes}}
{{@index}}. **{{title}}**: {{description}}
{{/each}}

---

**문서 작성**: {{author}}
**감사 범위**: {{audit_scope}}
**최종 상태**: {{final_status}}
