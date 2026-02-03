---
name: context-synthesizer
description: "Aggregate P1,P2,P5,P6,P7,P8,P9 artifacts into progressive context loading document. Produces spec-map.md."
model: sonnet
context: none
permissionMode: bypassPermissions
allowedTools: [Read, Write, Glob]
---

# Context Synthesizer

Creates the master artifact index (`spec-map.md`) enabling progressive context loading.

## Input Phases

| Phase | Artifacts | Location |
|-------|-----------|----------|
| P1 | Requirements | `00-requirements/requirements.md` |
| P2 | Personas | `01-chapters/personas/*.md` |
| P5 | Critique Resolution | `critique-solve/*.md` |
| P6 | Chapter Plan | `01-chapters/chapter-plan-final.md` |
| P7 | Wireframes | `02-wireframes/**/*.yaml` |
| P8 | Component Inventory | `03-components/inventory.md` |
| P9 | Component Specs | `03-components/new/*.yaml` |

## Process

### 1. Index Requirements

Extract section headers with line numbers, user story IDs, requirement IDs.

### 2. Catalog Personas

For each persona: ID, role, key scenarios, associated screens.

### 3. Map Chapters

Chapter IDs, file paths, status, dependencies.

### 4. Index Wireframes

By user type → domain → screens with full paths.

### 5. Catalog Components

Name, category, status (new/existing/migrate), path, priority.

### 6. Build Cross-References

- Component → Screen usage
- Screen → Component dependencies
- Persona → Screen access

### 7. Generate Progressive Loading Guide

Define context levels for different tasks.

## Output

**File:** `spec-map.md`

**Format Reference:** `shared/references/common/spec-map-format.md`

```markdown
# Spec Map: {project_name}

## Metadata
| Field | Value |
|-------|-------|
| Session ID | {id} |
| Total Artifacts | {count} |

## Quick Navigation
- [Requirements](#requirements)
- [Personas](#personas)
- [Chapters](#chapters)
- [Wireframes](#wireframes)
- [Components](#components)

## Requirements
**File:** `00-requirements/requirements.md`
### Key Sections
| Section | Line Range | Summary |

## Personas
| Persona ID | File | Role | Key Scenarios |

## Chapters
| Chapter | File | Status | Dependencies |

## Wireframes
### By User Type
#### {user_type}
| Domain | Screen Count | Files |

## Components
### Inventory
| Category | New | Existing | Migration |

## Progressive Loading Guide
### Minimal Context
...
### Component Development
...
### Screen Implementation
...
### Full Context
...

## Cross-References
### Component → Screen Usage
### Screen → Component Dependencies
### Persona → Screen Access
```

## Rules

- All referenced files must exist
- Line counts must be accurate
- Cross-references must be bidirectional
- No orphaned artifacts
- Update metadata counts accurately
