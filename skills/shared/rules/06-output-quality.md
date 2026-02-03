# Output Quality Standards

All spec-it output MUST follow these quality standards to ensure consistent, high-quality documentation.

## Mandatory Templates

**CRITICAL:** Always use templates from `skills/shared/templates/` for output generation.

| Output File | Template |
|------------|----------|
| requirements.md | `00-REQUIREMENTS_TEMPLATE.md` |
| chapter-plan-final.md | `01-CHAPTER_PLAN_TEMPLATE.md` |
| screen-list.md | `02-SCREEN_LIST_TEMPLATE.md` |
| domain-map.md | `02-DOMAIN_MAP_TEMPLATE.md` |
| {screen-id}.yaml | `02-WIREFRAME_YAML_TEMPLATE.yaml` |
| component-inventory.md | `03-COMPONENT_INVENTORY_TEMPLATE.md` |
| review-summary.md | `04-REVIEW_SUMMARY_TEMPLATE.md` |
| test-specifications.md | `05-TEST_SPECIFICATIONS_TEMPLATE.md` |
| final-spec.md | `06-FINAL_SPEC_TEMPLATE.md` |
| dev-tasks.md | `06-DEV_TASKS_TEMPLATE.md` |
| SPEC-SUMMARY.md | `06-SPEC_SUMMARY_TEMPLATE.md` |
| PHASE-*.md | `PHASE_TEMPLATE.md` |

## Document Structure Requirements

### 1. Document Information Table (MANDATORY)
Every document MUST start with a metadata table:

```markdown
## Document Information
| Item | Content |
|------|---------|
| System Name | {{system_name}} |
| Created Date | {{date}} |
| Version | {{version}} |
```

### 2. Section Numbering
- Use hierarchical numbering: 1, 1.1, 1.1.1
- Each major section gets a horizontal rule (`---`)
- Sub-sections use ### for level 3, #### for level 4

### 3. ID Formats

| Entity | Format | Example |
|--------|--------|---------|
| Requirement | REQ-{DOMAIN}-{SEQ} | REQ-DASH-001 |
| Screen | SCR-{MODE}-{SEQ} | SCR-HR-001 |
| Component | COMP-{SEQ} | COMP-010 |
| Test | {TYPE}-{CATEGORY}-{SEQ} | UT-COMP-001-01 |
| Task | TASK-P{PHASE}-{SEQ} | TASK-P2-001 |
| Feature | P{PHASE}-{SEQ} | P1-001 |

### 4. Table Formatting
- Always use proper alignment
- Header row with `|---|` separator
- Consistent column widths

```markdown
| ID | Name | Description |
|----|------|-------------|
| 01 | Test | Sample row |
```

### 5. Code Blocks
- Use appropriate language hints
- Diagram code blocks use ``` without language
- YAML uses ```yaml
- TypeScript uses ```typescript

## Wireframe YAML Standards

### Required Sections
1. `meta` - Screen metadata
2. `layout` - Layout type and references
3. `grid` - Responsive grid definition (desktop, tablet, mobile)
4. `sections` - Component hierarchy with props
5. `interactions` - User interaction definitions
6. `responsive` - Responsive behavior
7. `accessibility` - A11y requirements
8. `data_api` - API endpoint specifications
9. `notes` - Implementation notes

### Props Reference Format
```yaml
background: "_ref:colors.surface"
padding: "_ref:spacing.24"
```

### TestId Convention
```yaml
testId: "{component}-{action}"
# Example: "filter-period", "stat-present"
```

## Component Spec Standards

### Required Props Table
```markdown
| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
```

### State Documentation
All components MUST document:
- Loading state
- Empty state
- Error state
- Interactive states (hover, focus, disabled)

## Test Specification Standards

### Test Categories
1. **Unit Tests (UT)**: Component isolation tests
2. **Integration Tests (IT)**: Page and workflow tests
3. **E2E Tests (E2E)**: User scenario tests
4. **Performance Tests (PERF)**: Load and response times
5. **Accessibility Tests (A11Y)**: WCAG compliance
6. **Browser Tests (BROWSER)**: Cross-browser compatibility
7. **Responsive Tests (RESP)**: Multi-device support

### Test ID Format
```
{TYPE}-{CATEGORY}-{SEQ}-{SUBSEQ}
Example: UT-COMP-001-01
```

## Review Document Standards

### Critical Issues Format
```markdown
| ID | Area | Issue | Recommended Action | Reference |
|----|------|-------|-------------------|-----------|
| **CRIT-001** | Area | Issue description | Action | REF-001 |
```

### Decision Documentation
```markdown
### AMB-001: Decision Title
**Decision**: Summary of the decision
- Point 1
- Point 2
```

## Phase/Task Standards

### Phase Structure
1. Document Information
2. Phase Overview (Goal, Scope, Out of Scope)
3. Feature List with dependencies
4. Deliverables (Screens, Components)
5. Completion Criteria (checklist)

### Task Structure
1. Task ID and metadata table
2. Description
3. Acceptance Criteria (checkboxes)

## Quality Checklist

Before finalizing any output, verify:

- [ ] Document Information table present
- [ ] All sections properly numbered
- [ ] IDs follow standard format
- [ ] Tables properly formatted
- [ ] Code blocks have language hints
- [ ] Wireframe YAML has all required sections
- [ ] Component specs include state documentation
- [ ] Tests cover all categories
- [ ] Reviews document decisions clearly
