# Screen Spec: {{screen_name}}

## Basic Information

| Item | Value |
|------|-------|
| URL | {{url}} |
| Screen Type | {{screen_type}} |
| Access Level | {{access_level}} |
| Parent Screen | {{parent_screen}} |

## Feature Summary

{{description}}

## Main Features

{{#each features}}
### {{@index}}. {{name}}
- **Description**: {{description}}
- **Trigger**: {{trigger}}
- **Result**: {{result}}
{{/each}}

## Component Composition

| Component | Props | Role |
|-----------|-------|------|
{{#each components}}
| {{name}} | {{props}} | {{role}} |
{{/each}}

## State Management

### Local State
```typescript
{{local_state}}
```

### Global State Dependencies
{{#each global_state_deps}}
- {{name}}: {{usage}}
{{/each}}

## API Integration

| API | Method | Purpose | Trigger |
|-----|--------|---------|---------|
{{#each apis}}
| {{endpoint}} | {{method}} | {{purpose}} | {{trigger}} |
{{/each}}

## Error Handling

| Error Situation | Handling | UI Feedback |
|-----------------|----------|-------------|
{{#each errors}}
| {{situation}} | {{handling}} | {{ui_feedback}} |
{{/each}}

## Accessibility

- [ ] Keyboard navigation
- [ ] Screen reader support
- [ ] Color contrast 4.5:1+
- [ ] Focus indicator

## Test Scenarios

{{#each test_scenarios}}
- [ ] {{description}}
{{/each}}
