# Domain Map

## Document Information
| Item | Content |
|------|---------|
| System Name | {{system_name}} |
| Created Date | {{created_date}} |
| Version | {{version}} |

---

## 1. Domain List

| Domain | Description | Screen Count | User Types |
|--------|-------------|--------------|------------|
{{#each domains}}
| {{name}} | {{description}} | {{screen_count}} | {{user_types}} |
{{/each}}
| **Total** | **{{total_domains}} domains** | **{{total_screens}} unique screens** | **{{total_user_types}} user types** |

---

## 2. User Type Definitions

| User Type | Slug | Description | Access Level |
|-----------|------|-------------|--------------|
{{#each user_types}}
| {{name}} | `{{slug}}` | {{description}} | {{access_level}} |
{{/each}}

---

## 3. Domain Details

{{#each domains_detail}}
### 3.{{index}} {{domain_name}} ({{domain_local_name}})

**Purpose:** {{purpose}}

| Screen ID | Title | User Type | Route | Priority |
|-----------|-------|-----------|-------|----------|
{{#each screens}}
| {{id}} | {{title}} | {{user_type}} | `{{route}}` | {{priority}} |
{{/each}}

**Key Features:**
{{#each key_features}}
- {{user_type}}: {{features}}
{{/each}}

**Data Scope:**
{{#each data_scope}}
- {{user_type}}: {{scope}}
{{/each}}

{{#if navigation_flow}}
**Navigation Flow:**
```
{{navigation_flow}}
```
{{/if}}

---

{{/each}}

## 4. User Type Screen Mapping

{{#each user_type_mapping}}
### 4.{{index}} {{user_type_name}} ({{slug}})

| Domain | Screens | Access Level |
|--------|---------|--------------|
{{#each domain_access}}
| {{domain}} | {{screens}} | {{access}} |
{{/each}}

**Total Screens:** {{total_screens}}

{{#if notes}}
**Note:** {{notes}}
{{/if}}

---

{{/each}}

## 5. Inter-Screen Navigation Flow

{{#each navigation_flows}}
### 5.{{index}} {{flow_name}}

```
{{flow_diagram}}
```

{{/each}}

---

## 6. Common Navigation Patterns

{{#each common_patterns}}
### 6.{{index}} {{pattern_name}}

```
{{pattern_diagram}}
```

{{#if condition}}
**Condition:** {{condition}}
{{/if}}

---

{{/each}}

## 7. Domain Dependencies

```
{{dependency_diagram}}
```

---

## 8. URL Routing Structure

{{#each route_sections}}
### 8.{{index}} {{section_name}} Routes

| Domain | Route | Screen ID |
|--------|-------|-----------|
{{#each routes}}
| {{domain}} | `{{route}}` | {{screen_id}} |
{{/each}}

{{/each}}

---

## 9. Domain Priority

| Priority | Domain | Reason |
|----------|--------|--------|
{{#each domain_priorities}}
| {{priority}} | {{domain}} | {{reason}} |
{{/each}}

---

## 10. Domain Data Scope

| Domain | {{#each user_types}}{{name}} | {{/each}}
|--------|{{#each user_types}}------|{{/each}}
{{#each domain_scopes}}
| {{domain}} | {{#each scopes}}{{scope}} | {{/each}}
{{/each}}

---

## 11. Next Steps

{{#each next_steps}}
{{index}}. **{{step_title}}**: {{description}}
   - `{{path_pattern}}`
{{/each}}

---

## 12. Notes

{{#each notes}}
- {{note}}
{{/each}}
