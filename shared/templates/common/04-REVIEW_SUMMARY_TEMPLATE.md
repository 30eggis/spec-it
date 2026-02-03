# {{system_name}} Spec Review Summary

## Document Information
| Item | Content |
|------|---------|
| Session | {{session_id}} |
| Created Date | {{created_date}} |
| Reviewer | {{reviewer}} |
| Input Documents | {{input_documents}} |

---

## 1. Review Artifacts

### 1.1 Scenario Reviews
| File | Role | Critical Issues |
|------|------|-----------------|
{{#each scenario_reviews}}
| [{{file_name}}]({{file_path}}) | {{role}} | {{issue_count}} |
{{/each}}

### 1.2 IA Review
| File | Scope | Issues |
|------|-------|--------|
{{#each ia_reviews}}
| [{{file_name}}]({{file_path}}) | {{scope}} | {{issue_count}} |
{{/each}}

### 1.3 Exception Handling Review
| File | Scope | Critical Issues |
|------|-------|-----------------|
{{#each exception_reviews}}
| [{{file_name}}]({{file_path}}) | {{scope}} | {{issue_count}} |
{{/each}}

---

## 2. Critical Issues Summary

### 2.1 Immediate Resolution Required (Before {{first_phase}})

| ID | Area | Issue | Recommended Action | Reference Document |
|----|------|-------|-------------------|-------------------|
{{#each critical_issues}}
| **{{id}}** | {{area}} | {{issue}} | {{action}} | {{reference}} |
{{/each}}

### 2.2 Resolve During {{first_phase}} Development

| ID | Area | Issue | Recommended Action |
|----|------|-------|-------------------|
{{#each dev_issues}}
| {{id}} | {{area}} | {{issue}} | {{action}} |
{{/each}}

---

## 3. Key Decision Items

### 3.1 Business Policy Decisions

| Item | Options | Recommendation |
|------|---------|---------------|
{{#each business_decisions}}
| {{item}} | {{options}} | {{recommendation}} |
{{/each}}

### 3.2 Technical Decisions

| Item | Options | Recommendation |
|------|---------|---------------|
{{#each technical_decisions}}
| {{item}} | {{options}} | {{recommendation}} |
{{/each}}

---

## 4. Issue Priority Matrix

```
{{priority_matrix}}
```

**Immediate Action (High Impact, Low Effort)**:
{{#each immediate_actions}}
- {{id}}: {{description}}
{{/each}}

**Requires Planning (High Impact, High Effort)**:
{{#each planning_required}}
- {{id}}: {{description}}
{{/each}}

---

## 5. Existing Issue Mapping

### {{source_document}} Issue Mapping

| Source Issue | Review Result | Status |
|--------------|--------------|--------|
{{#each issue_mapping}}
| {{source_issue}} | {{review_result}} | {{status}} |
{{/each}}

---

## 6. Next Steps Recommendations

### 6.1 Document Updates
{{#each document_updates}}
{{index}}. {{description}}
{{/each}}

### 6.2 Design Supplements
{{#each design_supplements}}
{{index}}. {{description}}
{{/each}}

### 6.3 Business Confirmation
{{#each business_confirmations}}
{{index}}. {{description}}
{{/each}}

---

## Change History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
{{#each change_history}}
| {{version}} | {{date}} | {{author}} | {{changes}} |
{{/each}}
