# Component Spec: {{component_name}}

## Overview

{{description}}

## Props Interface

```typescript
interface {{component_name}}Props {
{{#each props}}
  /** {{description}} */
  {{name}}{{#unless required}}?{{/unless}}: {{type}};
{{/each}}
}
```

## Variants

| Variant | Description | Use Case |
|---------|-------------|----------|
{{#each variants}}
| {{name}} | {{description}} | {{use_case}} |
{{/each}}

## States

| State | Style | Condition |
|-------|-------|-----------|
| default | Default | Initial state |
| hover | Border highlight | Mouse over |
| focus | Focus ring | On focus |
| disabled | opacity 0.5 | disabled=true |
{{#each custom_states}}
| {{name}} | {{style}} | {{condition}} |
{{/each}}

## Component Structure (YAML)

### Default
```yaml
{{component_yaml_default}}
```

### Loading
```yaml
{{component_yaml_loading}}
```

### Error
```yaml
{{component_yaml_error}}
```

## Accessibility

- [ ] Keyboard navigation ({{keyboard_nav}})
- [ ] aria-label provided
- [ ] focus visible
- [ ] color contrast 4.5:1+
{{#each a11y_requirements}}
- [ ] {{requirement}}
{{/each}}

## Dependencies

{{#each dependencies}}
- `{{name}}` - {{purpose}}
{{/each}}

## Test Scenarios

### Unit Tests
{{#each unit_tests}}
- [ ] {{description}}
{{/each}}

### Integration Tests
{{#each integration_tests}}
- [ ] {{description}}
{{/each}}

### A11y Tests
{{#each a11y_tests}}
- [ ] {{description}}
{{/each}}

## Usage Example

```tsx
{{usage_example}}
```

## Related Components

{{#each related_components}}
- {{name}} - {{relationship}}
{{/each}}
