# {{system_name}} - Screen List

## Document Information
| Item | Content |
|------|---------|
| System Name | {{system_name}} |
| Created Date | {{created_date}} |
| Version | {{version}} |
| Total Screens | {{total_screens}} ({{screen_breakdown}}) |

---

{{#each user_modes}}
## {{index}}. {{mode_name}} Screens

{{#each screen_categories}}
### {{category_index}}.{{sub_index}} {{category_name}}
| ID | Screen Name | File Name | Description |
|----|-------------|-----------|-------------|
{{#each screens}}
| {{id}} | {{name}} | {{file_name}} | {{description}} |
{{/each}}

**Key Components:**
{{#each key_components}}
- {{component}}
{{/each}}

{{/each}}
{{/each}}

---

## {{common_section_number}}. Common Components

### {{common_section_number}}.1 Layout
| ID | Component Name | Description |
|----|---------------|-------------|
{{#each layout_components}}
| {{id}} | {{name}} | {{description}} |
{{/each}}

### {{common_section_number}}.2 Sidebar Menu Structure

{{#each sidebar_modes}}
**{{mode_name}}:**
{{#each menu_items}}
- {{item}}
{{/each}}

{{/each}}

### {{common_section_number}}.3 Header
{{#each header_components}}
- {{component}}
{{/each}}

---

## {{flow_section_number}}. Screen Flow Diagram

```
{{flow_diagram}}
```

---

## Notes

{{#each notes}}
- {{note}}
{{/each}}
