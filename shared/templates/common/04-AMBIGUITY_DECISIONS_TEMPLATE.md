# 모호성 해결 결정 사항

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 결정일 | {{date}} |
| 결정자 | {{decision_maker}} |

---

## 결정 사항

{{#each decisions}}
### {{id}}: {{title}}
- **결정**: {{decision}}
- **구현 방향**:
{{#each implementation_points}}
  - {{this}}
{{/each}}

{{/each}}

---

## 추가 확인 필요 사항 (should-clarify 유지)

| 항목 | 기본 가정 | 비고 |
|------|----------|------|
{{#each pending_clarifications}}
| {{item}} | {{assumption}} | {{notes}} |
{{/each}}

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
