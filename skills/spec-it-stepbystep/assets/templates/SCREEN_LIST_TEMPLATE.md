# Screen List

## Screen Overview

| # | Screen Name | URL | Description | Dependencies | Status |
|---|-------------|-----|-------------|--------------|--------|
{{#each screens}}
| {{@index}} | {{name}} | {{url}} | {{description}} | {{dependencies}} | {{status}} |
{{/each}}

## Screen Flow Diagram

```
{{flow_diagram}}
```

## URL Structure

```
{{url_structure}}
```

## Screen Classification

### Public (No Login Required)
{{#each public_screens}}
- {{name}} ({{url}})
{{/each}}

### Protected (Login Required)
{{#each protected_screens}}
- {{name}} ({{url}})
{{/each}}

### Admin (Administrator Only)
{{#each admin_screens}}
- {{name}} ({{url}})
{{/each}}

## Responsive Breakpoints

| Breakpoint | Width | Target |
|------------|-------|--------|
| Mobile | < 768px | Smartphones |
| Tablet | 768px - 1024px | Tablets |
| Desktop | > 1024px | Desktop |
