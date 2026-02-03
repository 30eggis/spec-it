# {{phase_name}}: {{phase_description}}

## Document Information
| Item | Content |
|------|---------|
| Phase | {{phase_number}} - {{phase_code}} |
| Total Tasks | {{total_tasks}} |
| Created Date | {{created_date}} |
| Dependencies | {{dependencies}} |

---

{{#each sprints}}
## Sprint {{sprint_number}}: {{sprint_name}} ({{task_count}} Tasks)

{{#each tasks}}
### {{task_id}}: {{task_title}}
| Item | Content |
|------|---------|
| ID | {{task_id}} |
| Feature ID | {{feature_id}} |
| Priority | {{priority}} |
| Estimated Complexity | {{complexity}} |
{{#if dependency}}
| Dependencies | {{dependency}} |
{{/if}}

**Description**
{{description}}

**Acceptance Criteria**
{{#each acceptance_criteria}}
- [ ] {{criterion}}
{{/each}}

---

{{/each}}
{{/each}}

## Task Summary

| Sprint | Area | Task Count |
|--------|------|------------|
{{#each sprint_summary}}
| Sprint {{number}} | {{area}} | {{count}} |
{{/each}}
| **Total** | | **{{total_tasks}}** |
