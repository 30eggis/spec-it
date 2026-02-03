# {{phase_name}}: {{phase_description}}

## Document Information
| Item | Content |
|------|---------|
| Phase | {{phase_number}} - {{phase_code}} |
| Goal | {{goal}} |
| Created Date | {{created_date}} |

---

## 1. Phase Overview

### 1.1 Goal
{{goal_description}}

### 1.2 Scope
{{#each scope_items}}
- {{item}}
{{/each}}

### 1.3 Out of Scope
{{#each out_of_scope_items}}
- {{item}}
{{/each}}

---

## 2. Feature List

{{#each feature_sections}}
### 2.{{index}} {{section_name}}
| ID | Feature | Priority | Dependencies |
|----|---------|----------|--------------|
{{#each features}}
| {{id}} | {{feature}} | {{priority}} | {{dependencies}} |
{{/each}}

{{/each}}

---

## 3. Deliverables

### 3.1 Screens
{{#each screens}}
- {{screen_name}} ({{file_name}})
{{/each}}

### 3.2 Components
{{#each components}}
- {{component_name}}
{{/each}}

---

## 4. Completion Criteria

{{#each criteria}}
- [ ] {{criterion}}
{{/each}}
