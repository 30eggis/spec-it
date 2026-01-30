# SPEC-IT-{{HASH}}

## Page: {{page_name}}

### Feature Keywords

{{#each keywords}}
`{{keyword}}` {{/each}}

### Screen Features

{{#each features}}
- {{feature}}
{{/each}}

### URL

| Item | Value |
|------|-------|
| Path | `{{url_path}}` |
| Access Level | {{access_level}} |
| Parent Page | {{parent_page}} |

### Screen Layout

```
{{screen_layout}}
```

### Main Components

| Component | Role | SPEC-IT |
|-----------|------|---------|
{{#each main_components}}
| {{name}} | {{role}} | [{{spec_hash}}]({{spec_path}}) |
{{/each}}

### State Management

**Local State**:
{{#each local_states}}
- `{{name}}`: {{description}}
{{/each}}

**Global State Dependencies**:
{{#each global_states}}
- `{{name}}`: {{usage}}
{{/each}}

### API Integration

| Endpoint | Method | Trigger |
|----------|--------|---------|
{{#each apis}}
| {{endpoint}} | {{method}} | {{trigger}} |
{{/each}}

### Test Scenarios

{{#each test_scenarios}}
- [ ] {{scenario}}
{{/each}}

---

### Subfolder IA

```
{{url_path}}
{{#each subfolders}}
├── {{name}}/
{{#each children}}
│   └── {{name}}/ → [SPEC-IT-{{hash}}]({{path}})
{{/each}}
{{/each}}
```

---

### Related Documents

- **Parent**: [SPEC-IT-{{parent_hash}}]({{parent_path}})
{{#if related_pages}}
- **Related Pages**:
{{#each related_pages}}
  - [SPEC-IT-{{hash}}]({{path}}) ({{name}})
{{/each}}
{{/if}}
{{#if children}}
- **Child Components**:
{{#each children}}
  - [SPEC-IT-{{hash}}]({{path}}) ({{name}})
{{/each}}
{{/if}}

---

### Metadata

| Item | Value |
|------|-------|
| HASH | {{HASH}} |
| Type | {{type}} |
| Created | {{created_at}} |
| Updated | {{updated_at}} |
| File | {{file_path}} |
