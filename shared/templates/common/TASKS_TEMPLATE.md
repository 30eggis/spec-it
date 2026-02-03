# TASKS-PHASE-{{phase_number}}: {{phase_title}}

## 문서 정보
| 항목 | 내용 |
|------|------|
| Phase | {{phase_number}} - {{phase_name}} |
| 총 태스크 수 | {{total_tasks}}개 |
| 작성일 | {{date}} |

---

{{#each sprints}}
## Sprint {{sprint_number}}: {{sprint_name}} ({{task_count}} Tasks)

{{#each tasks}}
### TASK-P{{phase}}-{{task_seq}}: {{title}}
| 항목 | 내용 |
|------|------|
| ID | TASK-P{{phase}}-{{task_seq}} |
| 기능 ID | P{{phase}}-{{feature_seq}} |
| 우선순위 | {{priority}} |
| 예상 복잡도 | {{complexity}} |
{{#if dependencies}}
| 의존성 | {{dependencies}} |
{{/if}}

**설명**
{{description}}

**인수 조건**
{{#each acceptance_criteria}}
- [ ] {{this}}
{{/each}}

---

{{/each}}
{{/each}}

## 의존성 그래프

```
{{dependency_graph}}
```

---

## Sprint 요약

| Sprint | 태스크 수 | 복잡도 합계 | 핵심 산출물 |
|--------|---------|-----------|-----------|
{{#each sprint_summary}}
| Sprint {{number}} | {{task_count}}개 | {{complexity_sum}} | {{deliverables}} |
{{/each}}
| **합계** | **{{total_tasks}}개** | **{{total_complexity}}** | - |

---

## 체크포인트

{{#each checkpoints}}
### {{name}}
- **위치**: Sprint {{sprint}} 완료 후
- **확인 항목**:
  {{#each items}}
  - [ ] {{this}}
  {{/each}}

{{/each}}

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
