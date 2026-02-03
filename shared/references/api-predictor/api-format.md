# API Map Format

> Referenced by: api-predictor (exclusive)

## Purpose

Defines the output format for predicted API endpoints based on spec analysis.

---

## Output: api-map.md

```markdown
# API Map: {{project_name}}

## Overview

| Metric | Value |
|--------|-------|
| Total Endpoints | {{count}} |
| Domains | {{domains}} |
| Auth Required | {{auth_count}} |
| Predicted Complexity | {{complexity}} |

---

## Quick Reference

### By Domain

| Domain | Endpoints | Priority |
|--------|-----------|----------|
| {{domain}} | {{count}} | P{{n}} |

### By HTTP Method

| Method | Count | Primary Use |
|--------|-------|-------------|
| GET | {{count}} | Read operations |
| POST | {{count}} | Create operations |
| PUT | {{count}} | Update/Actions |
| PATCH | {{count}} | Partial updates |
| DELETE | {{count}} | Delete operations |

---

## Endpoint Details

### {{domain_name}} Domain

#### GET /api/v1/{{resource}}

**Purpose:** {{description}}

**Evidence:**
- Screen: `{{screen_id}}` - {{reason}}
- Component: `{{component}}` - {{reason}}
- Scenario: `{{scenario_id}}` - {{reason}}

**Request:**
```
Query Parameters:
- page: number (optional, default: 0)
- size: number (optional, default: 20)
- {{filter}}: {{type}} (optional)
```

**Response:**
```typescript
interface {{Resource}}ListResponse {
  content: {{Resource}}[];
  page: number;
  size: number;
  totalElements: number;
}

interface {{Resource}} {
  id: string;
  {{field}}: {{type}};
  // Evidence: Used in {{screen_id}}
}
```

**Related Screens:** {{screen_ids}}

---

#### GET /api/v1/{{resource}}/{id}

**Purpose:** {{description}}

**Evidence:**
- Screen: `{{screen_id}}` - Detail view requires single item
- Component: `{{component}}` - Displays {{data}}

**Response:**
```typescript
interface {{Resource}}Response {
  id: string;
  {{field}}: {{type}};
  {{nested}}: {{NestedType}};
}
```

**Related Screens:** {{screen_ids}}

---

#### POST /api/v1/{{resource}}

**Purpose:** {{description}}

**Evidence:**
- Screen: `{{screen_id}}` - Create form
- Scenario: `{{scenario_id}}` - User creates new {{resource}}

**Request:**
```typescript
interface Create{{Resource}}Request {
  {{field}}: {{type}};  // Required - from form field {{field_name}}
  {{field}}?: {{type}}; // Optional
}
```

**Response:**
```typescript
// 201 Created
interface {{Resource}}Response {
  id: string;
  {{field}}: {{type}};
}
```

**Validation:**
| Field | Rule | Error Message |
|-------|------|---------------|
| {{field}} | {{rule}} | {{message}} |

**Related Screens:** {{screen_ids}}

---

#### PUT /api/v1/{{resource}}/{id}

**Purpose:** {{description}}

**Evidence:**
- Screen: `{{screen_id}}` - Edit form
- Scenario: `{{scenario_id}}` - User updates {{resource}}

**Request:**
```typescript
interface Update{{Resource}}Request {
  {{field}}: {{type}};
}
```

**Response:**
```typescript
// 200 OK
interface {{Resource}}Response { ... }
```

---

#### PUT /api/v1/{{resource}}/{id}/{{action}}

**Purpose:** State transition - {{description}}

**Evidence:**
- Screen: `{{screen_id}}` - {{action}} button
- Scenario: `{{scenario_id}}` - {{persona}} {{action}}s item
- Wireframe: `{{wireframe}}` - Action button present

**Request:**
```typescript
interface {{Action}}{{Resource}}Request {
  {{field}}?: {{type}};  // Optional action data
}
```

**Response:**
```typescript
// 200 OK
interface {{Resource}}Response {
  status: "{{new_status}}";
  {{field}}: {{type}};
}
```

**State Transition:**
```
{{current_state}} → {{action}} → {{new_state}}
```

---

#### DELETE /api/v1/{{resource}}/{id}

**Purpose:** {{description}}

**Evidence:**
- Screen: `{{screen_id}}` - Delete action
- Scenario: `{{scenario_id}}` - User deletes {{resource}}

**Response:**
```
// 204 No Content
```

**Soft Delete:** {{yes|no}}

---

## Cross-Domain Endpoints

### {{operation_name}}

**Endpoints Involved:**
1. `{{method}} {{endpoint_1}}`
2. `{{method}} {{endpoint_2}}`

**Flow:**
```
Screen → {{endpoint_1}} → {{endpoint_2}} → Response
```

**Evidence:**
- Cross-persona flow: `{{flow_id}}`
- Screens: {{screen_ids}}

---

## Authentication Requirements

| Endpoint Pattern | Auth | Roles |
|------------------|------|-------|
| `/api/v1/{{pattern}}` | Required | {{roles}} |
| `/api/v1/auth/*` | None | - |

---

## Common Response Types

### PagedResponse<T>

```typescript
interface PagedResponse<T> {
  content: T[];
  page: number;
  size: number;
  totalElements: number;
}
```

### ErrorResponse

```typescript
interface ErrorResponse {
  code: string;
  message: string;
  details?: string[];
  timestamp: string;
  traceId?: string;
}
```

---

## Evidence Index

### Screen → Endpoints

| Screen ID | Endpoints |
|-----------|-----------|
| {{screen}} | {{endpoints}} |

### Endpoint → Screens

| Endpoint | Used In Screens |
|----------|-----------------|
| {{endpoint}} | {{screens}} |

### Component → Endpoints

| Component | Data Source |
|-----------|-------------|
| {{component}} | {{endpoint}} |

---

## Notes

### Assumptions
- {{assumption_1}}
- {{assumption_2}}

### Requires Backend Clarification
| Endpoint | Question |
|----------|----------|
| {{endpoint}} | {{question}} |

### Design Principle References
- {{principle}}: Applied to {{endpoints}}
```

---

## Evidence Types

### Strong Evidence (High Confidence)
- Form with submit button → POST
- List with filters → GET with query params
- Detail view with ID in URL → GET /{id}
- Edit button/form → PUT
- Delete button → DELETE
- Status change button → PUT /{id}/{action}

### Medium Evidence (Likely)
- Loading state → Async API call
- Error display → Error response handling
- Pagination controls → Paged response

### Weak Evidence (Possible)
- Data displayed without clear source
- Derived calculations
- Aggregated views

---

## Validation Rules

1. Every endpoint must have:
   - At least one evidence reference
   - Request/response types
   - Related screens list

2. All screen references must exist in wireframes

3. State transitions must be documented

4. Error responses defined for mutating operations
