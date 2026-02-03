# DDD/EDA/MSA API Design Principles

> Referenced by: api-predictor (exclusive)
> Source: User-provided design principles document

## Overview

API prediction should follow these principles derived from DDD/EDA/MSA architecture patterns.

---

## 1. RESTful API Design Principles

### 1.1 URL Structure Rules

**Basic Pattern:**
```
/{context-path}/api/v{version}/{resource}
```

| Principle | DO | DON'T |
|-----------|-----|-------|
| Plural nouns | `/users`, `/org-units` | `/user`, `/org-unit` |
| Kebab case | `/leave-requests` | `/leaveRequests` |
| Hierarchy | `/org-units/{id}/members` | `/org-unit-members?orgUnitId={id}` |
| Actions via HTTP methods | `PUT /leave-requests/{id}/approve` | `POST /approve-leave-request` |
| Max 3 levels nesting | `/api/v1/workflows/instances/{id}/history` | Deeper nesting prohibited |

**Special Endpoints:**
```
/auth           # Authentication (no version)
/me             # Current user
/search         # Search operations
/{id}/approve   # State change actions
```

### 1.2 HTTP Method Usage

| Method | Purpose | Idempotent | Response Code |
|--------|---------|------------|---------------|
| `GET` | Read resource | Yes | 200 |
| `POST` | Create resource | No | 201, 202 |
| `PUT` | Full update / State change | Yes | 200 |
| `PATCH` | Partial update | No | 200 |
| `DELETE` | Delete resource | Yes | 204 |

### 1.3 Version Management

- URI Path style: `/api/v1/users`
- Version bump only for breaking changes
- Maintain previous version minimum 6 months

---

## 2. Request/Response Design

### 2.1 Header Conventions

| Header | Required | Description |
|--------|----------|-------------|
| `X-Tenant-Id` | Required | Tenant identifier |
| `X-User-Id` | Conditional | Current user ID |
| `Authorization` | Conditional | Bearer JWT token |
| `Content-Type` | Required | `application/json` |

### 2.2 Request DTO Rules

**Naming:** `{Action}{Domain}Request`

```typescript
interface CreateUserRequest {
  email: string;        // Required
  displayName: string;  // Required
  orgUnitId?: string;   // Optional
}
```

### 2.3 Response DTO Rules

**Naming:** `{Domain}Response`

```typescript
interface UserResponse {
  id: string;
  userId: string;
  email: string;
  displayName: string;
  status: string;
  orgUnitId?: string;
}
```

### 2.4 Pagination

```typescript
interface PagedResponse<T> {
  content: T[];
  page: number;           // 0-based
  size: number;           // Default: 20, Max: 100
  totalElements: number;
}
```

---

## 3. Error Handling Principles

### 3.1 HTTP Status Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| `200 OK` | Success | GET, PUT success |
| `201 Created` | Creation success | POST |
| `204 No Content` | Success (no body) | DELETE |
| `400 Bad Request` | Invalid request | Validation failure |
| `401 Unauthorized` | Auth failure | Token missing/expired |
| `403 Forbidden` | No permission | Insufficient role |
| `404 Not Found` | Resource not found | Query failure |
| `409 Conflict` | State conflict | Duplicate, invalid transition |

### 3.2 Error Response Format

```typescript
interface ErrorResponse {
  code: string;
  message: string;
  details: string[];
  timestamp: string;
  traceId?: string;
}
```

---

## 4. DDD Perspective

### 4.1 Bounded Context API Separation

| Context | Service | Responsibility |
|---------|---------|----------------|
| Identity | identity-service | Auth, users, roles |
| Organization | organization-service | Tenants, org units |
| Leave | leave-service | Leave types, balance, requests |
| TimeRecord | timerecord-service | Clock in/out records |
| Schedule | schedule-service | Work patterns, rosters |
| Audit | audit-service | Audit logs |

### 4.2 Aggregate-Based Resource Design

```
# DO: Aggregate Root centric API
POST   /api/v1/org-units              # Create aggregate
GET    /api/v1/org-units/{id}         # Read aggregate
PUT    /api/v1/org-units/{id}         # Update aggregate
GET    /api/v1/org-units/{id}/members # Read child entities

# DON'T: Ignore aggregate boundaries
PUT /api/v1/org-unit-members/{memberId}  # Direct child modification prohibited
```

### 4.3 Command vs Query Separation (CQRS)

```typescript
// Command operations
POST /api/v1/org-units
PUT /api/v1/org-units/{id}
DELETE /api/v1/org-units/{id}

// Query operations
GET /api/v1/org-units
GET /api/v1/org-units/{id}
GET /api/v1/org-units/{id}/members
GET /api/v1/org-units/search
```

---

## 5. EDA Perspective

### 5.1 Event Publishing Pattern (Outbox)

State changes should publish domain events:

```
User created → UserCreated event
Leave approved → LeaveApproved event
Status changed → StatusChanged event
```

### 5.2 Domain Event Structure

```typescript
interface DomainEvent {
  eventId: string;
  eventType: string;
  tenantId: string;
  eventVersion: string;
  occurredAt: string;
  payload: object;
}
```

### 5.3 Async Processing API Response

```typescript
// 202 Accepted for async operations
POST /api/v1/reports/generate → 202 Accepted
{
  id: "generation-id",
  status: "PENDING"
}

// Status check endpoint
GET /api/v1/reports/generated/{id}
{
  id: "generation-id",
  status: "COMPLETED",
  resultUrl: "/api/v1/reports/{id}"
}
```

---

## 6. MSA Perspective

### 6.1 Service Communication

**Event-based async communication:**
- Prefer events over direct calls
- Ensure idempotency
- Use outbox pattern

### 6.2 API Gateway Integration

- Gateway handles JWT validation
- Gateway injects `X-Tenant-Id`, `X-User-Id` headers
- Services extract auth info from headers

### 6.3 Health Check API

```
GET /actuator/health/liveness   # Kubernetes liveness probe
GET /actuator/health/readiness  # Kubernetes readiness probe
```

---

## 7. Security & Authentication

### 7.1 JWT Authentication Flow

```
1. POST /auth/login → JWT issued
2. Authorization: Bearer {token} header
3. Gateway validates JWT, injects headers
4. Service uses X-Tenant-Id, X-User-Id
```

### 7.2 Tenant Isolation

```typescript
// DO: Include tenantId in all queries
findByUserIdAndTenantId(userId: string, tenantId: string)

// DON'T: Query without tenantId (data exposure risk)
findByUserId(userId: string)

// Cache keys must include tenantId
cacheKey = `${tenantId}:${resourceType}:${id}`
```

---

## 8. API Design Checklist

### URL Design
- [ ] Resource-centric noun URLs
- [ ] Plural form
- [ ] Kebab case
- [ ] `/api/v1/` version prefix

### Request/Response
- [ ] Request/Response DTO separated
- [ ] Schema annotations applied
- [ ] PagedResponse for lists

### DDD
- [ ] Bounded Context separation
- [ ] Aggregate Root centric design

### EDA
- [ ] Outbox pattern applied
- [ ] Idempotency guaranteed

### Security
- [ ] X-Tenant-Id required check
- [ ] Tenant data isolation

---

## Application to Prediction

When predicting APIs from specs:

1. **Identify Resources** from wireframes/components
2. **Map CRUD Operations** from user actions
3. **Detect State Transitions** from workflow scenarios
4. **Find Aggregates** from data relationships
5. **Apply Naming Conventions** consistently
6. **Add Tenant Headers** to all endpoints
7. **Include Error Responses** for all mutations
