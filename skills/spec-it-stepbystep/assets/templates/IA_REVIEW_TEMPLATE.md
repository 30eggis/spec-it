# Information Architecture Review

## Review Date

{{review_date}}

## Navigation Structure

### Global Navigation
```
{{global_nav_structure}}
```

### Breadcrumb Patterns
| Screen | Breadcrumb |
|--------|------------|
{{#each breadcrumb_patterns}}
| {{screen}} | {{breadcrumb}} |
{{/each}}

## Page Hierarchy

| Page | Parent | Children | Depth | Issues |
|------|--------|----------|-------|--------|
{{#each page_hierarchy}}
| {{page}} | {{parent}} | {{children}} | {{depth}} | {{issue}} |
{{/each}}

## URL Structure

### Pattern Analysis
| Pattern | Example | Purpose |
|---------|---------|---------|
{{#each url_patterns}}
| {{pattern}} | {{example}} | {{purpose}} |
{{/each}}

### URL Consistency Check
{{#each url_consistency}}
- [{{#if passed}}✓{{else}}✗{{/if}}] {{check}}
{{/each}}

## Data Flow

### Inter-Page State Transfer
| From | To | Data | Method |
|------|-----|------|--------|
{{#each data_flows}}
| {{from}} | {{to}} | {{data}} | {{method}} |
{{/each}}

### Data Persistence on Refresh
| Data | Persisted | Method |
|------|-----------|--------|
{{#each refresh_persistence}}
| {{data}} | {{persisted}} | {{method}} |
{{/each}}

## Issues Found

### Critical
{{#each critical_issues}}
{{@index}}. **{{title}}**
   - Location: {{location}}
   - Description: {{description}}
   - Recommendation: {{recommendation}}
{{/each}}

### Warning
{{#each warning_issues}}
{{@index}}. **{{title}}**
   - Location: {{location}}
   - Description: {{description}}
   - Recommendation: {{recommendation}}
{{/each}}

### Suggestion
{{#each suggestions}}
{{@index}}. {{description}}
{{/each}}

## Review Results

- Critical Issues: {{critical_count}}
- Warnings: {{warning_count}}
- Suggestions: {{suggestion_count}}

**Conclusion**: {{conclusion}}
