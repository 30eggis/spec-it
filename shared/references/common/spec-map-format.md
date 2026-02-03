# Spec Map Format

> Referenced by: context-synthesizer, spec-assembler, spec-it-execute

## Purpose

`spec-map.md` serves as the central index for all spec artifacts, enabling:
- Progressive context loading
- Cross-reference navigation
- Dependency tracking
- Execution planning

---

## spec-map.md Structure

```markdown
# Spec Map: {{project_name}}

## Metadata

| Field | Value |
|-------|-------|
| Session ID | {{session_id}} |
| Created | {{timestamp}} |
| Version | {{version}} |
| Total Artifacts | {{count}} |

---

## Quick Navigation

- [Requirements](#requirements)
- [Personas](#personas)
- [Chapters](#chapters)
- [Wireframes](#wireframes)
- [Components](#components)
- [Test Scenarios](#test-scenarios)
- [Dev Plan](#dev-plan)

---

## Requirements

**File:** `00-requirements/requirements.md`
**Lines:** {{line_count}}

### Key Sections
| Section | Line Range | Summary |
|---------|------------|---------|
| User Stories | L{{start}}-L{{end}} | {{summary}} |
| Functional Reqs | L{{start}}-L{{end}} | {{summary}} |
| Non-Functional | L{{start}}-L{{end}} | {{summary}} |

---

## Personas

**Directory:** `01-chapters/personas/`

| Persona ID | File | Role | Key Scenarios |
|------------|------|------|---------------|
| {{id}} | {{file}} | {{role}} | {{scenarios}} |

---

## Chapters

**Directory:** `01-chapters/`

| Chapter | File | Status | Dependencies |
|---------|------|--------|--------------|
| CH-00 | decisions/decision-ch00.md | {{status}} | - |
| CH-01 | decisions/decision-ch01.md | {{status}} | CH-00 |
| ... | ... | ... | ... |

### Chapter Plan
**File:** `01-chapters/chapter-plan-final.md`

---

## Wireframes

**Directory:** `02-wireframes/`

### By User Type

#### {{user_type}}

| Domain | Screen Count | Files |
|--------|--------------|-------|
| {{domain}} | {{count}} | `{{path}}/*.yaml` |

### Screen Index

| Screen ID | Title | User Type | Domain | File |
|-----------|-------|-----------|--------|------|
| {{id}} | {{title}} | {{user}} | {{domain}} | {{path}} |

---

## Components

**Directory:** `03-components/`

### Inventory
**File:** `inventory.md`

| Category | New | Existing | Migration |
|----------|-----|----------|-----------|
| {{category}} | {{new}} | {{existing}} | {{migrate}} |

### Component Specs

| Component | File | Priority | Dependencies |
|-----------|------|----------|--------------|
| {{name}} | {{path}} | {{priority}} | {{deps}} |

---

## Test Scenarios

**Directory:** `05-tests/test-scenarios/`

### By Persona

| Persona | Happy | Sad | Edge | Coverage |
|---------|-------|-----|------|----------|
| {{persona}} | {{happy}} | {{sad}} | {{edge}} | {{pct}}% |

### Cross-Persona Flows

| Flow ID | Personas Involved | File |
|---------|-------------------|------|
| {{flow}} | {{personas}} | {{path}} |

---

## Dev Plan

**Directory:** `dev-plan/`

### Overview
**File:** `development-map.md`

### Phase Summary

| Phase | Tasks | Components | Screens |
|-------|-------|------------|---------|
| Phase-0 | {{tasks}} | Shared infra | - |
| Phase-1 | {{tasks}} | {{components}} | {{screens}} |

### API Map
**File:** `api-map.md`

---

## Progressive Loading Guide

### Minimal Context (Quick Reference)
```
Read: spec-map.md (this file)
```

### Component Development
```
Read: spec-map.md#components
Read: 03-components/inventory.md
Read: 03-components/new/{{component}}.yaml
```

### Screen Implementation
```
Read: spec-map.md#wireframes
Read: 02-wireframes/{{user}}/{{domain}}/screen-list.md
Read: 02-wireframes/{{user}}/{{domain}}/wireframes/{{screen}}.yaml
```

### Full Context (Deep Work)
```
Read: 00-requirements/requirements.md
Read: 01-chapters/chapter-plan-final.md
Read: spec-map.md (full)
```

---

## Cross-References

### Component → Screen Usage

| Component | Used In Screens |
|-----------|-----------------|
| {{component}} | {{screen_ids}} |

### Screen → Component Dependencies

| Screen | Required Components |
|--------|---------------------|
| {{screen}} | {{components}} |

### Persona → Screen Access

| Persona | Accessible Screens |
|---------|-------------------|
| {{persona}} | {{screens}} |
```

---

## Validation Rules

1. All files referenced must exist
2. Line counts must be accurate
3. Cross-references must be bidirectional
4. No orphaned artifacts
