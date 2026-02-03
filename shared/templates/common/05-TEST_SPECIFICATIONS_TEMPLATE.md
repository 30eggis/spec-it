# {{system_name}} - Test Specifications

## Document Information
| Item | Content |
|------|---------|
| System Name | {{system_name}} |
| Created Date | {{created_date}} |
| Version | {{version}} |

---

## 1. Unit Tests

### 1.1 Component Tests

{{#each component_tests}}
#### {{test_id}}: {{component_name}} Component
| Test ID | Description | Expected Result |
|---------|-------------|-----------------|
{{#each tests}}
| {{id}} | {{description}} | {{expected}} |
{{/each}}

{{/each}}

---

### 1.2 Utility Function Tests

{{#each utility_tests}}
#### {{test_id}}: {{utility_name}}
| Test ID | Description | Expected Result |
|---------|-------------|-----------------|
{{#each tests}}
| {{id}} | {{description}} | {{expected}} |
{{/each}}

{{/each}}

---

## 2. Integration Tests

### 2.1 Page Integration Tests

{{#each page_integration_tests}}
#### {{test_id}}: {{page_name}}
| Test ID | Description | Expected Result |
|---------|-------------|-----------------|
{{#each tests}}
| {{id}} | {{description}} | {{expected}} |
{{/each}}

{{/each}}

---

### 2.2 Workflow Integration Tests

{{#each workflow_tests}}
#### {{test_id}}: {{workflow_name}}
| Test ID | Description | Expected Result |
|---------|-------------|-----------------|
{{#each tests}}
| {{id}} | {{description}} | {{expected}} |
{{/each}}

{{/each}}

---

## 3. E2E Tests

### 3.1 User Scenario E2E Tests

{{#each e2e_scenarios}}
#### {{test_id}}: {{scenario_name}}
```
{{scenario_steps}}
```

| Step | Verification Item |
|------|-------------------|
{{#each verifications}}
| {{step}} | {{verification}} |
{{/each}}

{{/each}}

---

## 4. Performance Tests

### 4.1 Load Time Tests
| Test ID | Page | Target | Metrics |
|---------|------|--------|---------|
{{#each load_time_tests}}
| {{id}} | {{page}} | {{target}} | {{metrics}} |
{{/each}}

### 4.2 Data Load Tests
| Test ID | Scenario | Target |
|---------|----------|--------|
{{#each data_load_tests}}
| {{id}} | {{scenario}} | {{target}} |
{{/each}}

---

## 5. Accessibility Tests

### 5.1 WCAG 2.1 AA Standard Tests
| Test ID | Item | Verification Content |
|---------|------|----------------------|
{{#each a11y_tests}}
| {{id}} | {{item}} | {{verification}} |
{{/each}}

---

## 6. Browser Compatibility Tests

### 6.1 Supported Browsers
| Browser | Version | Priority |
|---------|---------|----------|
{{#each browsers}}
| {{browser}} | {{version}} | {{priority}} |
{{/each}}

### 6.2 Browser Test Items
| Test ID | Item |
|---------|------|
{{#each browser_tests}}
| {{id}} | {{item}} |
{{/each}}

---

## 7. Responsive Tests

### 7.1 Test Resolutions
| Device | Resolution | Priority |
|--------|------------|----------|
{{#each resolutions}}
| {{device}} | {{resolution}} | {{priority}} |
{{/each}}

### 7.2 Responsive Test Items
| Test ID | Item |
|---------|------|
{{#each responsive_tests}}
| {{id}} | {{item}} |
{{/each}}

---

## Test Coverage Goals

| Test Type | Coverage Goal |
|-----------|---------------|
{{#each coverage_goals}}
| {{type}} | {{goal}} |
{{/each}}

## Test Execution Environment

| Environment | Purpose |
|-------------|---------|
{{#each environments}}
| {{environment}} | {{purpose}} |
{{/each}}
