# Persona: {{persona_name}} ({{real_name}})

## Basic Information

| Item | Value |
|------|-------|
| Age | {{age}} |
| Occupation | {{occupation}} |
| Location | {{location}} |

## Demographics

- **Education Level**: {{education}}
- **Income Level**: {{income_level}}
- **Family**: {{family}}
- **Tech Proficiency**: {{tech_proficiency}}

## Devices & Environment

| Device | Model | Usage Frequency |
|--------|-------|-----------------|
{{#each devices}}
| {{type}} | {{model}} | {{frequency}} |
{{/each}}

### Internet Environment
{{#each internet_environments}}
- {{location}}: {{connection_type}} ({{speed}})
{{/each}}

## Behavior Patterns

### Daily Routine
{{#each daily_routine}}
- **{{time}}**: {{activity}} ({{device}})
{{/each}}

### Service Usage Patterns
{{#each usage_patterns}}
- {{pattern}}
{{/each}}

## Goals

{{#each goals}}
### {{priority}}. {{goal}}
- **Motivation**: {{motivation}}
- **Metric**: {{metric}}
{{/each}}

## Frustrations

{{#each frustrations}}
### {{icon}} {{frustration}}
- **Situation**: {{situation}}
- **Impact**: {{impact}}
- **Expectation**: {{expectation}}
{{/each}}

## Motivations

{{#each motivations}}
- {{motivation}}
{{/each}}

## Quotes

> "{{quote1}}"

> "{{quote2}}"

## Test Scenarios for This Persona

### Required Verification
{{#each required_tests}}
- [ ] {{description}}
{{/each}}

### Recommended Verification
{{#each recommended_tests}}
- [ ] {{description}}
{{/each}}

## Persona-Based Requirements

| Requirement | Priority | Related Feature |
|-------------|----------|-----------------|
{{#each requirements}}
| {{requirement}} | {{priority}} | {{related_feature}} |
{{/each}}

## Related Personas

{{#each related_personas}}
- **{{name}}**: {{relationship}}
{{/each}}
