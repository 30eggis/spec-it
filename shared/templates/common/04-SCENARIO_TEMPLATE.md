# {{role_name}} 시나리오 리뷰

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 작성일 | {{date}} |
| 역할 | {{role_name}} ({{role_name_en}}) |
| 범위 | {{scope}} |

---

{{#each scenarios}}
## {{@index}}. 시나리오: {{title}}

### Given (사전 조건)
{{#each preconditions}}
- {{this}}
{{/each}}

### When (수행 단계)
{{#each steps}}
{{@index}}. {{this}}
{{/each}}

### Then (예상 결과)
{{#each expected_results}}
- {{this}}
{{/each}}

### Edge Cases
| Case | 현재 상태 | 이슈 |
|------|----------|------|
{{#each edge_cases}}
| {{case}} | {{status}} | {{issue}} |
{{/each}}

### Critical Issues
{{#each critical_issues}}
{{@index}}. **[{{severity}}] {{title}}**
   - {{description}}
   - 해결안: {{solution}}

{{/each}}

---

{{/each}}

## 권장 조치 요약

### 즉시 해결 필요 (Before Development)

| ID | 이슈 | 권장 조치 | 영향 범위 |
|----|------|----------|----------|
{{#each immediate_actions}}
| {{id}} | {{issue}} | {{action}} | {{scope}} |
{{/each}}

### 개발 중 해결

| ID | 이슈 | 권장 조치 | Phase |
|----|------|----------|-------|
{{#each development_actions}}
| {{id}} | {{issue}} | {{action}} | {{phase}} |
{{/each}}

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
