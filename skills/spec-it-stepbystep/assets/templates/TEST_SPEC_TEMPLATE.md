# Test Spec: {{test_name}}

## Test Information

| Item | Value |
|------|-------|
| Target | {{target}} |
| Type | {{test_type}} |
| Persona | {{persona}} |
| Priority | {{priority}} |

## Test Suite

```typescript
describe('{{suite_name}}', () => {
  {{#if setup}}
  beforeEach(() => {
    {{setup}}
  });
  {{/if}}

  {{#if teardown}}
  afterEach(() => {
    {{teardown}}
  });
  {{/if}}

  {{#each test_cases}}
  {{#if describe}}
  describe('{{describe}}', () => {
    {{#each tests}}
    it('{{description}}', {{#if async}}async {{/if}}() => {
      // Given
      {{given}}

      // When
      {{when}}

      // Then
      {{then}}
    });
    {{/each}}
  });
  {{else}}
  it('{{description}}', {{#if async}}async {{/if}}() => {
    // Given
    {{given}}

    // When
    {{when}}

    // Then
    {{then}}
  });
  {{/if}}
  {{/each}}
});
```

## Detailed Test Cases

{{#each detailed_cases}}
### {{id}}: {{name}}

**Purpose**: {{purpose}}

**Preconditions**:
{{#each preconditions}}
- {{condition}}
{{/each}}

**Test Steps**:
{{#each steps}}
{{@index}}. {{step}}
{{/each}}

**Expected Results**:
{{#each expected}}
- {{result}}
{{/each}}

**Priority**: {{priority}}

---
{{/each}}

## Edge Cases

{{#each edge_cases}}
### {{name}}
- **Situation**: {{situation}}
- **Test Code**:
```typescript
{{test_code}}
```
{{/each}}

## Error Cases

{{#each error_cases}}
### {{name}}
- **Trigger**: {{trigger}}
- **Expected Error**: {{expected_error}}
- **Test Code**:
```typescript
{{test_code}}
```
{{/each}}

## Coverage Target

| Item | Target | Current |
|------|--------|---------|
| Statements | {{target_statements}}% | {{current_statements}}% |
| Branches | {{target_branches}}% | {{current_branches}}% |
| Functions | {{target_functions}}% | {{current_functions}}% |
| Lines | {{target_lines}}% | {{current_lines}}% |

## Dependencies

### Mocks
{{#each mocks}}
- `{{name}}`: {{purpose}}
{{/each}}

### Fixtures
{{#each fixtures}}
- `{{name}}`: {{description}}
{{/each}}

## Run Command

```bash
{{run_command}}
```
