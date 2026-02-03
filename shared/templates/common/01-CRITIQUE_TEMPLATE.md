# Critic Round {{round}}: {{critic_type}} Review

## 문서 정보
| 항목 | 내용 |
|------|------|
| 검토일 | {{date}} |
| 검토자 | {{critic_type}} Critic |
| 대상 문서 | {{target_documents}} |

---

## 검토 요약
| 항목 | 상태 | 이슈 수 |
|------|------|---------|
{{#each summary_items}}
| {{name}} | {{status}} | {{issue_count}} |
{{/each}}

---

## 이슈 목록

### CRITICAL (Blocker)

{{#if critical_issues}}
{{#each critical_issues}}
#### [{{id}}] {{title}}
- **심각도**: Critical
- **위치**: {{location}}
- **설명**: {{description}}
- **권장 조치**: {{recommendation}}
{{/each}}
{{else}}
없음
{{/if}}

---

### MAJOR (Fix Required)

{{#each major_issues}}
#### [{{id}}] {{title}}
- **심각도**: Major
- **위치**: {{location}}
- **설명**:
  {{description}}
- **권장 조치**:
  {{recommendation}}

{{/each}}

---

### MINOR (Nice to Have)

{{#each minor_issues}}
#### [{{id}}] {{title}}
- **심각도**: Minor
- **위치**: {{location}}
- **설명**: {{description}}
- **권장 조치**: {{recommendation}}

{{/each}}

---

## 상세 분석

{{#each analysis_sections}}
### {{index}}. {{title}}

**현재 상태**: {{status}}

**문제점**:
{{#each problems}}
{{@index}}. {{this}}
{{/each}}

**개선 방안**:
{{improvement}}

{{/each}}

---

## 총평

### Verdict: **{{verdict}}**

### 요약
{{summary}}

### 주요 권장 사항
{{#each recommendations}}
{{@index}}. **{{category}}**:
   {{#each items}}
   - {{this}}
   {{/each}}
{{/each}}

### 긍정적 측면
{{#each positive_aspects}}
- {{this}}
{{/each}}

### 개선 후 재검토 필요 여부
{{needs_review}}
