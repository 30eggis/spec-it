# SPEC-IT-{{HASH}}

## Component: {{component_name}}

### Description

{{description}}

### Props

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
{{#each props}}
| {{name}} | `{{type}}` | {{#if required}}✓{{else}}-{{/if}} | {{default}} | {{description}} |
{{/each}}

### Variants

{{#each variants}}
- **{{name}}**: {{description}}
{{/each}}

### States

| State | Condition | Style Change |
|-------|-----------|--------------|
{{#each states}}
| {{name}} | {{condition}} | {{style}} |
{{/each}}

### Component Structure (YAML)

```yaml
{{component_yaml}}
```

### Usage Example

```tsx
{{usage_example}}
```

### Test Scenarios

{{#each test_scenarios}}
- [ ] {{scenario}}
{{/each}}

### Accessibility

{{#each accessibility}}
- [{{#if checked}}x{{else}} {{/if}}] {{requirement}}
{{/each}}

---

### Related Documents

- **Parent**: [SPEC-IT-{{parent_hash}}]({{parent_path}})
{{#if siblings}}
- **Same Level**:
{{#each siblings}}
  - [SPEC-IT-{{hash}}]({{path}}) ({{name}})
{{/each}}
{{/if}}
{{#if children}}
- **Children**:
{{#each children}}
  - [SPEC-IT-{{hash}}]({{path}}) ({{name}})
{{/each}}
{{/if}}

---

### Metadata

| Item | Value |
|------|-------|
| HASH | {{HASH}} |
| Created | {{created_at}} |
| Updated | {{updated_at}} |
| File | {{file_path}} |
