# {{system_name}} - Chapter Plan

## Document Information
| Item | Content |
|------|---------|
| System Name | {{system_name}} |
| Created Date | {{created_date}} |
| Base Documents | {{base_documents}} |
| Mode | {{mode}} |

---

## Chapter Structure

{{#each chapters}}
### CH-{{number}}: {{title}}
- **Source**: {{source_documents}}
- **Content**: {{content_summary}}
- **Status**: {{status}}

{{/each}}

---

## Phase Mapping

| Phase | Scope | Reference Document |
|-------|-------|-------------------|
{{#each phases}}
| {{name}} | {{scope}} | {{document}} |
{{/each}}

---

## Document Analysis Results

### Completeness
{{#each completeness}}
- **{{item}}**: {{percentage}} ({{details}})
{{/each}}

### Items Requiring Supplement
{{#each supplement_items}}
{{index}}. **{{title}}**: {{description}}
{{/each}}

---

## Next Steps

{{#each next_steps}}
{{index}}. **{{milestone}}**: {{description}}
{{/each}}

---

## Approval Request

**{{chapter_count}} Chapters have been planned based on {{base_type}} documents.**

{{approval_summary}}
