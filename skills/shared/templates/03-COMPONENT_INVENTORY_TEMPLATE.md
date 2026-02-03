# {{system_name}} - Component Inventory

## Document Information
| Item | Content |
|------|---------|
| System Name | {{system_name}} |
| Created Date | {{created_date}} |
| Version | {{version}} |

---

{{#each categories}}
## {{index}}. {{category_name}} Components

{{#each components}}
### {{component_id}}: {{component_name}}
| Item | Content |
|------|---------|
| ID | {{component_id}} |
| Name | {{component_name}} |
| Category | {{category}} |
| Phase | {{phase}} |

**Description**: {{description}}

**Props**
| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
{{#each props}}
| {{name}} | {{type}} | {{required}} | {{default}} | {{description}} |
{{/each}}

{{#if states}}
**States**
{{#each states}}
- {{state_name}}: {{state_description}}
{{/each}}
{{/if}}

**Usage Screens**: {{usage_screens}}

---

{{/each}}
{{/each}}

## Component Summary

| Category | Count | Phase Distribution |
|----------|-------|-------------------|
{{#each category_summary}}
| {{category}} | {{count}} | {{phase_distribution}} |
{{/each}}
| **Total** | **{{total_count}}** | |
