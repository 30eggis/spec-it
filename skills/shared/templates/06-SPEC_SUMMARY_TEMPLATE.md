# {{system_name}} - Specification Summary

## Quick Reference

| Item | Value |
|------|-------|
| System Name | {{system_name}} |
| Session ID | {{session_id}} |
| Total Screens | {{total_screens}} |
| Total Components | {{total_components}} |
| Total Test Cases | {{total_tests}} |
| Phase Count | {{phase_count}} |

---

## Document Map

| Document | Path | Description |
|----------|------|-------------|
{{#each documents}}
| {{name}} | `{{path}}` | {{description}} |
{{/each}}

---

## Screen Summary

| Mode | Screen Count | Route Prefix |
|------|--------------|--------------|
{{#each mode_summary}}
| {{mode}} | {{screen_count}} | `{{route_prefix}}` |
{{/each}}

---

## Component Summary

| Category | Count | Phase |
|----------|-------|-------|
{{#each component_summary}}
| {{category}} | {{count}} | {{phase}} |
{{/each}}

---

## Phase Overview

| Phase | Scope | Status |
|-------|-------|--------|
{{#each phases}}
| {{name}} | {{scope}} | {{status}} |
{{/each}}

---

## Key Decisions Summary

| ID | Decision | Impact |
|----|----------|--------|
{{#each key_decisions}}
| {{id}} | {{decision}} | {{impact}} |
{{/each}}

---

## Test Coverage

| Test Type | Count | Coverage |
|-----------|-------|----------|
{{#each test_coverage}}
| {{type}} | {{count}} | {{coverage}} |
{{/each}}

---

## Getting Started

### For Developers
1. Read `06-final/final-spec.md` for complete specifications
2. Check `06-final/dev-tasks.md` for task breakdown
3. Reference `03-components/` for component specifications
4. Use `02-wireframes/` for screen layouts

### For Designers
1. Check `02-wireframes/domain-map.md` for screen structure
2. Review `02-wireframes/layouts/` for layout system
3. Reference screen YAML files for detailed layouts

### For QA
1. Review `05-tests/test-specifications.md` for test cases
2. Check `05-tests/coverage-map.md` for coverage requirements
3. Reference `04-review/scenarios/` for user scenarios

---

## Session Info

| Item | Value |
|------|-------|
| Created | {{created_date}} |
| Mode | {{mode}} |
| Design Style | {{design_style}} |
| Output Directory | `{{output_directory}}` |
