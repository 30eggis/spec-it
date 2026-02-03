# 명세 모호성 분석

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 분석 대상 | {{analysis_targets}} |
| 작성일 | {{date}} |

---

## 요약

| 등급 | 개수 | 설명 |
|------|------|------|
| must-resolve | {{must_resolve_count}} | 구현 전 반드시 해결 |
| should-clarify | {{should_clarify_count}} | 가정 하에 진행 가능 |
| nice-to-have | {{nice_to_have_count}} | 선택적 개선 |

---

## must-resolve 이슈

{{#each must_resolve_issues}}
### [AMB-{{seq}}] {{title}}
- **위치**: {{location}}
- **설명**:
  {{description}}
- **영향**:
  {{#each impacts}}
  - {{this}}
  {{/each}}
- **제안 질문**:
  {{#each questions}}
  {{@index}}. {{this}}
  {{/each}}

---

{{/each}}

## should-clarify 이슈

{{#each should_clarify_issues}}
### [AMB-{{seq}}] {{title}}
- **위치**: {{location}}
- **설명**: {{description}}
- **영향**: {{impact}}
- **가정**: {{assumption}}
- **제안**: 확인 필요하지만, 가정 하에 구현 가능

---

{{/each}}

## nice-to-have 이슈

{{#each nice_to_have_issues}}
### [AMB-{{seq}}] {{title}}
- **위치**: {{location}}
- **설명**: {{description}}
- **영향**: {{impact}}
- **제안**: {{suggestion}}

---

{{/each}}

## 기존 이슈 해결 상태

| 이슈 ID | 상태 | 설명 |
|---------|------|------|
{{#each existing_issues}}
| {{id}} | {{status}} | {{description}} |
{{/each}}

---

## 사용자 확인 질문 요약

다음 항목들에 대한 확인이 필요합니다:

{{#each user_questions}}
### {{@index}}. {{title}} (AMB-{{seq}})
{{#each options}}
- {{label}}) {{description}}
{{/each}}

{{/each}}

---

## 다음 단계

{{#each next_steps}}
{{@index}}. **{{action}}**: {{description}}
{{/each}}
