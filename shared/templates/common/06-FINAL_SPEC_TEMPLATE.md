# {{system_name}} Final Specification Document

## Document Information
| Item | Content |
|------|---------|
| System Name | {{system_name}} |
| Version | {{version}} ({{phase}} MVP) |
| Created Date | {{created_date}} |
| Session | {{session_id}} |
| Status | {{status}} |

---

## 1. System Overview

### 1.1 Purpose
{{purpose_description}}

### 1.2 Main Features
{{#each main_features}}
{{index}}. **{{feature_name}}**: {{description}}
{{/each}}

### 1.3 User Types
| User | Description | Main Screens |
|------|-------------|--------------|
{{#each user_types}}
| {{user}} | {{description}} | {{main_screens}} |
{{/each}}

---

## 2. Functional Requirements

{{#each requirement_sections}}
### 2.{{index}} {{section_name}} ({{local_name}})

#### {{requirement_id}}: {{requirement_title}}
| Item | Content |
|------|---------|
| Description | {{description}} |
| Priority | {{priority}} |

**Detail Features:**
{{#each detail_features}}
- {{id}}: {{description}}
{{/each}}

{{/each}}

---

## 3. Non-Functional Requirements

### 3.1 Performance
| Item | Standard |
|------|----------|
{{#each performance_standards}}
| {{item}} | {{standard}} |
{{/each}}

### 3.2 Accessibility
{{#each accessibility_requirements}}
- {{requirement}}
{{/each}}

### 3.3 Browser Support
{{#each browser_support}}
- {{browser}} {{version}}+
{{/each}}

### 3.4 Internationalization
{{#each languages}}
- {{language}}{{#if default}} (default){{/if}}
{{/each}}

### 3.5 Responsive Design
| Device | Breakpoint |
|--------|------------|
{{#each breakpoints}}
| {{device}} | {{breakpoint}} |
{{/each}}

---

## 4. Data Model

{{#each data_models}}
### 4.{{index}} {{model_name}} ({{model_local_name}})
```
{{model_definition}}
```

{{/each}}

---

## 5. Key Decisions

{{#each decisions}}
### 5.{{index}} {{decision_id}}: {{decision_title}}
**Decision**: {{decision_summary}}
{{#each decision_points}}
- {{point}}
{{/each}}

{{/each}}

---

## 6. Screen List

{{#each screen_sections}}
### 6.{{index}} {{mode_name}} ({{screen_count}} screens)
| Screen ID | Screen Name | Route | Phase | Priority | Notes |
|----------|-------------|-------|-------|----------|-------|
{{#each screens}}
| {{id}} | {{name}} | `{{route}}` | {{phase}} | {{priority}} | {{notes}} |
{{/each}}

{{/each}}

---

## 7. Component Configuration

{{#each component_phases}}
### 7.{{index}} {{phase_name}} Deployment ({{component_count}})
{{deployment_summary}}

{{/each}}

---

## 8. Extended Data Model Definitions

{{#each extended_models}}
### 8.{{index}} {{model_name}} ({{model_local_name}})
```
{{model_definition}}
```

{{/each}}

---

## 9. Constraints

### 9.1 Technical Constraints
| Constraint | Response |
|------------|----------|
{{#each technical_constraints}}
| {{constraint}} | {{response}} |
{{/each}}

### 9.2 Business Constraints
| Constraint | Impact |
|------------|--------|
{{#each business_constraints}}
| {{constraint}} | {{impact}} |
{{/each}}

---

## 10. Test Plan

### 10.1 {{first_phase}} Testing ({{coverage_target}}+ Coverage)
{{#each test_types}}
- {{type}}: {{count}} ({{coverage}})
{{/each}}
- **Total {{total_tests}} Test Cases**

### 10.2 Key Test Areas
{{#each test_areas}}
{{index}}. {{area}} ({{focus_items}})
{{/each}}

---

## 11. Release Roadmap

{{#each phases}}
### 11.{{index}} {{phase_name}} - {{timeline}}
{{phase_description}}

{{/each}}

---

## 12. Document Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
{{#each version_history}}
| {{version}} | {{date}} | {{author}} | {{changes}} |
{{/each}}
