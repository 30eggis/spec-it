# Wireframe: {{screen_name}}

## Screen Information

- **URL**: {{url}}
- **Screen Type**: {{screen_type}}
- **Access Level**: {{access_level}}

## Desktop (1440px+)

```
{{desktop_wireframe}}
```

## Tablet (768px - 1024px)

```
{{tablet_wireframe}}
```

## Mobile (< 768px)

```
{{mobile_wireframe}}
```

## Component Identification

| Component | Location | Required | Status |
|-----------|----------|----------|--------|
{{#each components}}
| {{name}} | {{location}} | {{required}} | {{status}} |
{{/each}}

## Interactions

### Click Events
{{#each click_events}}
- **{{element}}**: {{action}}
{{/each}}

### Form Submissions
{{#each form_submissions}}
- **{{form_name}}**: {{endpoint}} ({{method}})
{{/each}}

### State Changes
{{#each state_changes}}
- **{{trigger}}**: {{before_state}} → {{after_state}}
{{/each}}

## Loading State

```
{{loading_wireframe}}
```

## Error State

```
{{error_wireframe}}
```

## Notes

{{notes}}
