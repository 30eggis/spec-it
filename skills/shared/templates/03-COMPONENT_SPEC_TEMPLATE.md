# Component Spec: {{component_name}}

## Component Information
| 항목 | 내용 |
|------|------|
| Component ID | {{component_id}} |
| Component Name | {{component_name}} |
| Category | {{category}} |
| Phase | {{phase}} |
| Framework | {{framework}} |

---

## Design Intent
- **Purpose**: {{purpose}}
- **Feeling**: {{feeling}}
- **Differentiator**: {{differentiator}}

---

## Framework
{{framework}} (detected from project context)

---

## Description (Korean)
{{description}}

{{#if reference_document}}
**Reference**: {{reference_document}}
{{/if}}

---

## Props Interface

```typescript
{{props_interface}}
```

---

## Design Tokens

### Typography
| Element | Font | Size | Weight | Line Height |
|---------|------|------|--------|-------------|
{{#each typography_tokens}}
| {{element}} | {{font}} | {{size}} | {{weight}} | {{line_height}} |
{{/each}}

### Colors
| State/Level | Color Code | Text Color | Background |
|-------------|------------|------------|------------|
{{#each color_tokens}}
| **{{state}}** | {{color}} | {{text_color}} | {{background}} |
{{/each}}

### Spacing
| Property | Value (lg) | Value (md) | Value (sm) |
|----------|------------|------------|------------|
{{#each spacing_tokens}}
| {{property}} | {{lg}} | {{md}} | {{sm}} |
{{/each}}

---

## Variants

{{#each variants}}
### {{name}}
{{description}}

**Visual Structure**
```
{{visual_structure}}
```

{{/each}}

---

## Component Structure (YAML)

{{#each yaml_examples}}
### {{title}}
```yaml
{{yaml_content}}
```

{{/each}}

---

## Interactions

| Trigger | Property | From | To | Duration | Easing |
|---------|----------|------|-----|----------|--------|
{{#each interactions}}
| {{trigger}} | {{property}} | {{from}} | {{to}} | {{duration}} | {{easing}} |
{{/each}}

---

## Accessibility

### ARIA Attributes
```html
{{aria_example}}
```

### Accessibility Requirements
{{#each accessibility_requirements}}
- [ ] {{this}}
{{/each}}

---

## Usage Examples

{{#each usage_examples}}
### {{title}}
```typescript
{{code}}
```

{{/each}}

---

## Test Scenarios

### Visual Tests
{{#each visual_tests}}
- [ ] {{this}}
{{/each}}

### Interaction Tests
{{#each interaction_tests}}
- [ ] {{this}}
{{/each}}

### Accessibility Tests
{{#each accessibility_tests}}
- [ ] {{this}}
{{/each}}

### Business Logic Tests
{{#each business_logic_tests}}
- [ ] {{this}}
{{/each}}

---

## Test IDs

| Element | Test ID Pattern | Example |
|---------|----------------|---------|
{{#each test_ids}}
| {{element}} | `{{pattern}}` | `{{example}}` |
{{/each}}

---

## Related Components
{{#each related_components}}
- **{{id}}**: {{name}} ({{relationship}})
{{/each}}

---

## Implementation Notes

{{implementation_notes}}

---

## 작성 정보
| 항목 | 내용 |
|------|------|
| 작성일 | {{date}} |
| 작성자 | {{author}} |
| 버전 | {{version}} |
{{#if reference_document}}
| 참조 문서 | {{reference_document}} |
{{/if}}
