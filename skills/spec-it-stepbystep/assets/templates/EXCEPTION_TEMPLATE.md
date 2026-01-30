# Exception Review: {{feature_name}}

## Feature Overview

{{feature_description}}

## Exception Matrix

| Exception | Condition | Handling | UI Feedback | Recovery | Priority |
|-----------|-----------|----------|-------------|----------|----------|
{{#each exceptions}}
| {{situation}} | {{condition}} | {{handling}} | {{ui_feedback}} | {{recovery}} | {{priority}} |
{{/each}}

## Detailed Exception Cases

{{#each detailed_exceptions}}
### {{name}}

**Condition**
{{condition}}

**Handling Logic**
```typescript
{{handling_code}}
```

**UI Feedback**
- Type: {{ui_type}}
- Message: "{{message}}"
- Actions: {{action_buttons}}

**Recovery Method**
{{recovery_steps}}

**Test Scenario**
```typescript
it('{{test_description}}', async () => {
  {{test_code}}
});
```
{{/each}}

## Global Exceptions

### Network Error
- **Handling**: {{network_error_handling}}
- **UI**: {{network_error_ui}}
- **Retry Policy**: {{network_retry_policy}}

### Authentication Expired
- **Handling**: {{auth_error_handling}}
- **UI**: {{auth_error_ui}}
- **Redirect**: {{auth_redirect}}

### Insufficient Permissions
- **Handling**: {{permission_error_handling}}
- **UI**: {{permission_error_ui}}

## Unhandled Cases (Review Required)

{{#each unhandled_cases}}
- [ ] {{description}}
  - Likelihood: {{likelihood}}
  - Impact: {{impact}}
  - Recommended Handling: {{recommendation}}
{{/each}}

## Error Logging

| Error Type | Log Level | Included Info |
|------------|-----------|---------------|
{{#each error_logging}}
| {{type}} | {{level}} | {{info}} |
{{/each}}

## User Feedback Guide

| Situation | Message Tone | Example |
|-----------|--------------|---------|
| User Error | Friendly guidance | "Please check the email format" |
| System Error | Apology + Alternative | "A temporary error occurred. Please try again later" |
| Network | Situation explanation | "Please check your internet connection" |
