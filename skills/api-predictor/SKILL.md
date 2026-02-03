---
name: api-predictor
description: "Predicts required API endpoints from spec artifacts based on DDD/EDA/MSA design principles."
allowed-tools: Read, Write, Glob
argument-hint: "[spec-map-path]"
permissionMode: bypassPermissions
---

# API Predictor

Predicts required API endpoints by analyzing spec artifacts against design principles.

## Purpose

Analyze wireframes, components, and scenarios to predict:
- Required API endpoints
- Request/response structures
- State transitions
- Integration points

## Rules

See [shared/references/api-predictor/design-principles.md](../../shared/references/api-predictor/design-principles.md).
See [shared/references/api-predictor/api-format.md](../../shared/references/api-predictor/api-format.md).

## Input

- `spec-map.md` - Artifact index
- `02-wireframes/**/*.yaml` - Wireframes with interactions
- `03-components/**/*.yaml` - Component specs with data requirements
- `05-tests/test-scenarios/**/*.md` - User flows
- `01-chapters/personas/*.md` - User roles

## Workflow

```
[Read spec-map.md for navigation]
      ↓
[Scan wireframes for data sources]
      ↓
[Identify CRUD operations from interactions]
      ↓
[Detect state transitions from scenarios]
      ↓
[Map to DDD aggregates]
      ↓
[Apply API design principles]
      ↓
[Generate api-map.md]
```

---

## Step 1: Identify Resources

Scan wireframes and components for:

```
FOR each wireframe:
  Extract:
    - Data displayed (lists, details)
    - Forms (create, edit)
    - Actions (buttons, state changes)
    - Filters and search

Resource detection:
  - List view → Collection resource (/api/v1/{resources})
  - Detail view → Individual resource (/api/v1/{resources}/{id})
  - Create form → POST endpoint
  - Edit form → PUT/PATCH endpoint
  - Delete action → DELETE endpoint
```

---

## Step 2: Map CRUD Operations

```
FOR each identified resource:

  IF list_view_exists:
    endpoints.push({
      method: "GET",
      path: "/api/v1/{resource}",
      purpose: "List {resource}",
      evidence: [screen_ids]
    })

  IF detail_view_exists:
    endpoints.push({
      method: "GET",
      path: "/api/v1/{resource}/{id}",
      purpose: "Get single {resource}",
      evidence: [screen_ids]
    })

  IF create_form_exists:
    endpoints.push({
      method: "POST",
      path: "/api/v1/{resource}",
      purpose: "Create {resource}",
      evidence: [screen_ids, form_fields]
    })

  # ... similar for PUT, DELETE
```

---

## Step 3: Detect State Transitions

```
FOR each scenario:
  IF scenario contains status_change:
    Extract:
      - Current state
      - Action (approve, reject, cancel, etc.)
      - New state

    endpoints.push({
      method: "PUT",
      path: "/api/v1/{resource}/{id}/{action}",
      purpose: "State transition: {action}",
      stateTransition: {
        from: current_state,
        to: new_state
      },
      evidence: [scenario_ids]
    })
```

---

## Step 4: Identify Aggregates

Apply DDD aggregate patterns:

```
FOR each resource:
  Check for parent-child relationships:
    - /org-units/{id}/members (child under parent)
    - NOT /org-unit-members/{id} (direct child access)

  Check for aggregate boundaries:
    - Transactions within aggregate
    - References across aggregates
```

---

## Step 5: Apply Design Principles

Reference: `shared/references/api-predictor/design-principles.md`

### Validation Checklist

- [ ] Plural nouns for resources
- [ ] Kebab-case URLs
- [ ] Max 3 levels nesting
- [ ] HTTP methods match operations
- [ ] State transitions use PUT /{id}/{action}
- [ ] Pagination for collections
- [ ] Error responses defined

---

## Step 6: Generate Output

### api-map.md

```markdown
# API Map: {project_name}

## Overview

| Metric | Value |
|--------|-------|
| Total Endpoints | {count} |
| Domains | {list} |

## By Domain

### {domain_name}

#### GET /api/v1/{resource}

**Purpose:** {description}

**Evidence:**
- Screen: `{screen_id}` - {reason}
- Component: `{component}` - {reason}

**Request:**
```
Query: page, size, {filters}
```

**Response:**
```typescript
interface {Resource}ListResponse {
  content: {Resource}[];
  page: number;
  size: number;
  totalElements: number;
}
```

**Related Screens:** {screen_ids}

---

#### POST /api/v1/{resource}

**Purpose:** Create {resource}

**Evidence:**
- Screen: `{screen_id}` - Create form
- Scenario: `{scenario_id}` - User creates

**Request:**
```typescript
interface Create{Resource}Request {
  {field}: {type};
}
```

**Validation:**
| Field | Rule | Error |
|-------|------|-------|

---

## State Transitions

| Resource | Action | From | To | Endpoint |
|----------|--------|------|----|---------|

## Evidence Index

### Screen → Endpoints
| Screen | Endpoints |

### Endpoint → Screens
| Endpoint | Screens |

## Notes

### Assumptions
- {assumption}

### Backend Clarification Needed
| Endpoint | Question |
```

---

## Output

**File:** `dev-plan/api-map.md`

---

## Evidence Confidence

| Evidence Type | Confidence |
|---------------|------------|
| Form with submit | HIGH |
| List with filters | HIGH |
| Detail view with ID | HIGH |
| Status change button | HIGH |
| Loading state | MEDIUM |
| Data display without clear source | LOW |

---

## Integration

### Called By
- dev-planner (P14) - Uses api-map.md for task planning

### Timing
- Run during P14, before dev-planner
- Can be re-run if wireframes change
