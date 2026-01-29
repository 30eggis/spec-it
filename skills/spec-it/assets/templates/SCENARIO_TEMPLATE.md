# Scenario: {{scenario_name}}

## Scenario Information

| Item | Value |
|------|-------|
| Feature | {{feature}} |
| Type | {{scenario_type}} |
| Priority | {{priority}} |
| Persona | {{persona}} |

## Given (Preconditions)

{{#each preconditions}}
- {{condition}}
{{/each}}

## When (Actions)

{{#each actions}}
{{@index}}. {{action}}
{{/each}}

## Then (Expected Results)

{{#each expected_results}}
- {{result}}
{{/each}}

## Edge Cases

{{#each edge_cases}}
### {{name}}
- **Situation**: {{situation}}
- **Expected Result**: {{expected}}
- **Tested**: {{#if tested}}✓{{else}}☐{{/if}}
{{/each}}

## Error Cases

{{#each error_cases}}
### {{name}}
- **Trigger**: {{trigger}}
- **Error Type**: {{error_type}}
- **UI Feedback**: {{ui_feedback}}
- **Recovery Method**: {{recovery}}
{{/each}}

## Related Screens

{{#each related_screens}}
- {{name}} ({{url}})
{{/each}}

## Test Code

```typescript
describe('{{scenario_name}}', () => {
  {{#each test_cases}}
  it('{{description}}', async () => {
    // Given
    {{given}}

    // When
    {{when}}

    // Then
    {{then}}
  });
  {{/each}}
});
```

## Notes

{{notes}}
