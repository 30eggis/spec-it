# Test Coverage Map

## Overall Summary

| Item | Value |
|------|-------|
| Total Tests | {{total_tests}} |
| Passed | {{passed_tests}} |
| Coverage | {{overall_coverage}}% |
| Last Updated | {{last_updated}} |

## By Component

| Component | Unit | Integration | E2E | Total | Coverage |
|-----------|------|-------------|-----|-------|----------|
{{#each component_coverage}}
| {{name}} | {{unit}} | {{integration}} | {{e2e}} | {{total}} | {{coverage}}% |
{{/each}}
| **Total** | **{{unit_total}}** | **{{integration_total}}** | **{{e2e_total}}** | **{{total_total}}** | **{{avg_coverage}}%** |

## By Page

| Page | Scenarios | Tests | Coverage | Status |
|------|-----------|-------|----------|--------|
{{#each page_coverage}}
| {{name}} | {{scenarios}} | {{tests}} | {{coverage}}% | {{status}} |
{{/each}}

## By Feature

| Feature | Scenarios | Covered | Missing |
|---------|-----------|---------|---------|
{{#each feature_coverage}}
| {{name}} | {{scenarios}} | {{covered}} | {{missing}} |
{{/each}}

## By Persona

| Persona | Scenarios | Covered | Coverage |
|---------|-----------|---------|----------|
{{#each persona_coverage}}
| {{name}} | {{scenarios}} | {{covered}} | {{coverage}}% |
{{/each}}

## Uncovered Paths

### Critical (Must Add)
{{#each critical_uncovered}}
- [ ] **{{path}}**
  - Reason: {{reason}}
  - Impact: {{impact}}
{{/each}}

### Warning (Recommended)
{{#each warning_uncovered}}
- [ ] {{path}}
  - Reason: {{reason}}
{{/each}}

## Test Distribution

```
Unit Tests:        {{unit_percentage}}% [{{unit_bar}}]
Integration Tests: {{integration_percentage}}% [{{integration_bar}}]
E2E Tests:         {{e2e_percentage}}% [{{e2e_bar}}]
```

## Coverage Trend

| Date | Coverage | Change |
|------|----------|--------|
{{#each coverage_trend}}
| {{date}} | {{coverage}}% | {{change}} |
{{/each}}

## Next Steps

### High Priority
{{#each high_priority_tasks}}
1. {{task}}
{{/each}}

### Medium Priority
{{#each medium_priority_tasks}}
1. {{task}}
{{/each}}

## Test Commands

```bash
# All tests
{{run_all_command}}

# Coverage report
{{coverage_command}}

# Specific component
{{specific_command}}
```
