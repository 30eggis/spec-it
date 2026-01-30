# Ambiguity Report

## Review Date

{{review_date}}

## Summary

| Category | Count |
|----------|-------|
| 🔴 Must Resolve | {{must_resolve_count}} |
| 🟡 Recommended | {{recommended_count}} |
| 🟢 Optional | {{optional_count}} |

---

## 🔴 Must Resolve (Required before implementation)

{{#each must_resolve}}
### AMB-{{id}}: {{title}}

- **Location**: {{location}}
- **Related Chapter**: {{chapter}}
- **Ambiguous Content**: {{ambiguous_content}}

**Question**: {{question}}

**Options**:
{{#each options}}
- {{letter}}) {{description}}
{{/each}}

**Default Recommendation**: {{default_recommendation}}

**Impact Scope**:
{{#each impact}}
- {{item}}
{{/each}}

---
{{/each}}

## 🟡 Recommended

{{#each recommended}}
### AMB-{{id}}: {{title}}

- **Location**: {{location}}
- **Ambiguous Content**: {{ambiguous_content}}

**Question**: {{question}}

**Options**:
{{#each options}}
- {{letter}}) {{description}}
{{/each}}

**Default Value Available**: {{default_value}}

---
{{/each}}

## 🟢 Optional

{{#each optional}}
### AMB-{{id}}: {{title}}

- **Location**: {{location}}
- **Question**: {{question}}
- **Default Value**: {{default_value}}

---
{{/each}}

## User Question Format

```
Ambiguous items found:

{{#each must_resolve}}
{{@index}}. AMB-{{id}}: {{title}}
{{#each options}}
   - {{letter}}) {{short_description}}
{{/each}}

{{/each}}

Please select.
```

## Decision Log

| AMB ID | Question | Decision | Decided At |
|--------|----------|----------|------------|
{{#each decisions}}
| AMB-{{id}} | {{question}} | {{decision}} | {{decided_at}} |
{{/each}}
