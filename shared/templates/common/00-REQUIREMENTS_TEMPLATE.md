# {{system_name}} Requirements Document

## Document Information

| Item | Description |
|------|-------------|
| Version | {{version}} |
| Status | {{status}} |
| Created | {{created_date}} |
| Source | {{source_documents}} |

---

## 1. Project Overview

### 1.1 Background

{{background_description}}

**Current State:**
{{#each current_state_items}}
- {{item}}
{{/each}}

**Key Issues:**
{{#each key_issues}}
- {{issue}}
{{/each}}

### 1.2 Vision

{{vision_description}}

**Reference Benchmark:** {{benchmark_reference}}

### 1.3 Key Objectives

| # | Objective | Description |
|---|-----------|-------------|
{{#each objectives}}
| {{number}} | {{title}} | {{description}} |
{{/each}}

---

## 2. User Personas & Roles

### 2.1 Role Hierarchy

```
{{role_hierarchy_diagram}}
```

### 2.2 User Types

| Role | Local Term | Description |
|------|------------|-------------|
{{#each user_types}}
| **{{role}}** | {{local_term}} | {{description}} |
{{/each}}

### 2.3 User Stories by Role

{{#each roles}}
#### 2.3.{{index}} {{role_name}} ({{local_name}})

| ID | User Story | Priority |
|----|------------|----------|
{{#each stories}}
| {{id}} | {{story}} | {{priority}} |
{{/each}}
{{/each}}

---

## 3. Functional Requirements

{{#each functional_sections}}
### 3.{{index}} {{section_name}} ({{local_name}})

#### 3.{{index}}.1 {{subsection_name}}

| Requirement ID | Rule | Specification |
|----------------|------|---------------|
{{#each requirements}}
| {{id}} | {{rule}} | {{specification}} |
{{/each}}

{{/each}}

---

## 4. Non-Functional Requirements

### 4.1 Usability

| Requirement | Specification |
|-------------|---------------|
{{#each usability_requirements}}
| {{name}} | {{spec}} |
{{/each}}

### 4.2 Performance

| Metric | Target |
|--------|--------|
{{#each performance_metrics}}
| {{metric}} | {{target}} |
{{/each}}

### 4.3 Reliability

| Metric | Target |
|--------|--------|
{{#each reliability_metrics}}
| {{metric}} | {{target}} |
{{/each}}

### 4.4 Security

| Requirement | Description |
|-------------|-------------|
{{#each security_requirements}}
| {{name}} | {{description}} |
{{/each}}

---

## 5. Integration Requirements

{{#each integrations}}
### 5.{{index}} {{integration_name}}

| Function | Direction | Description | Priority |
|----------|-----------|-------------|----------|
{{#each functions}}
| {{name}} | {{direction}} | {{description}} | {{priority}} |
{{/each}}

**Integration Method:** {{method}}
{{/each}}

---

## 6. MVP Scope Definition

### 6.1 P0 - Must Have (MVP Core)

| Feature | Description |
|---------|-------------|
{{#each p0_features}}
| {{name}} | {{description}} |
{{/each}}

### 6.2 P1 - Should Have (Post-MVP Phase 1)

| Feature | Description |
|---------|-------------|
{{#each p1_features}}
| {{name}} | {{description}} |
{{/each}}

### 6.3 P2 - Nice to Have (Future)

| Feature | Description |
|---------|-------------|
{{#each p2_features}}
| {{name}} | {{description}} |
{{/each}}

---

## 7. Out of Scope

| Item | Reason |
|------|--------|
{{#each out_of_scope}}
| {{item}} | {{reason}} |
{{/each}}

---

## 8. Success Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
{{#each success_metrics}}
| {{metric}} | {{target}} | {{method}} |
{{/each}}

---

## 9. Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
{{#each risks}}
| {{risk}} | {{impact}} | {{likelihood}} | {{mitigation}} |
{{/each}}

---

## 10. Glossary

| Term | Local Term | Definition |
|------|------------|------------|
{{#each glossary}}
| {{term}} | {{local_term}} | {{definition}} |
{{/each}}

---

## 11. Reference Documents

| Document | Description |
|----------|-------------|
{{#each references}}
| {{document}} | {{description}} |
{{/each}}

---

_End of Requirements Document_
