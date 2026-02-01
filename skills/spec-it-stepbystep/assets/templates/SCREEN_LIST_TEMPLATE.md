# Screen List

domain: {{domain}}
user_type: {{user_type}}

## Screens

| id | title | flow | priority | notes | depends_on |
|----|-------|------|----------|-------|------------|
{{#each screens}}
| {{id}} | {{title}} | {{flow}} | {{priority}} | {{notes}} | {{depends_on}} |
{{/each}}
