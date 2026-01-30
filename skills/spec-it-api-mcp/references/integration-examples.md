# Integration Examples

How to use the generated MCP server with `spec-it-execute`.

---

## Meta Tools Usage

### 1. getApiInfo

Get basic API information.

```
mcp__api-petstore__getApiInfo()
→ {
    "title": "Pet Store API",
    "version": "1.0.0",
    "description": "A sample API",
    "baseUrl": "https://api.example.com/v1",
    "totalEndpoints": 15
  }
```

### 2. listEndpoints

List all available endpoints.

```
mcp__api-petstore__listEndpoints()
→ [
    { "operationId": "getUsers", "method": "GET", "path": "/users", "summary": "List users" },
    { "operationId": "getUserById", "method": "GET", "path": "/users/{id}", "summary": "Get user" },
    { "operationId": "createOrder", "method": "POST", "path": "/orders", "summary": "Create order" }
  ]
```

### 3. searchEndpoints

Search by keyword, tag, or method.

```
# Search by keyword
mcp__api-petstore__searchEndpoints({ keyword: "user" })
→ [
    { "operationId": "getUsers", "method": "GET", "path": "/users", "matchScore": 100 },
    { "operationId": "getUserById", "method": "GET", "path": "/users/{id}", "matchScore": 100 },
    { "operationId": "createUser", "method": "POST", "path": "/users", "matchScore": 80 }
  ]

# Filter by method
mcp__api-petstore__searchEndpoints({ keyword: "user", method: "POST" })
→ [
    { "operationId": "createUser", "method": "POST", "path": "/users", "matchScore": 100 }
  ]

# Filter by tag
mcp__api-petstore__searchEndpoints({ keyword: "list", tag: "orders" })
→ [
    { "operationId": "getOrders", "method": "GET", "path": "/orders", "matchScore": 80 }
  ]
```

### 4. getEndpointSchema

Get detailed request/response schema.

```
mcp__api-petstore__getEndpointSchema({ operationId: "getUsers" })
→ {
    "operationId": "getUsers",
    "method": "GET",
    "path": "/users",
    "summary": "List all users",
    "request": {
      "parameters": [
        { "name": "limit", "in": "query", "type": "integer", "default": 10 },
        { "name": "offset", "in": "query", "type": "integer", "default": 0 }
      ],
      "body": null
    },
    "response": {
      "200": {
        "schema": "UserList",
        "example": { "users": [...], "total": 10 }
      }
    },
    "mockResponse": {
      "users": [
        { "id": "1", "name": "John Doe", "email": "john@example.com" }
      ],
      "total": 1
    }
  }
```

### 5. findEndpointsByEntity

Find all endpoints for an entity.

```
mcp__api-petstore__findEndpointsByEntity({ entity: "user" })
→ {
    "entity": "user",
    "endpoints": ["getUsers", "getUserById", "createUser", "updateUser", "deleteUser"],
    "actions": {
      "list": "getUsers",
      "get": "getUserById",
      "create": "createUser",
      "update": "updateUser",
      "delete": "deleteUser"
    },
    "hint": "Use getEndpointSchema({ operationId: \"getUsers\" }) for details"
  }
```

---

## Workflow: Building a User List Component

Example of how `spec-it-execute` uses the MCP server during development.

### Step 1: Discover API

```
Claude: "사용자 목록을 표시하는 컴포넌트를 만들어야 해. 관련 API가 있나?"

→ mcp__api-petstore__searchEndpoints({ keyword: "user list" })
→ Found: GET /users (operationId: getUsers)
```

### Step 2: Understand Response Structure

```
Claude: "응답 형식이 어떻게 되지?"

→ mcp__api-petstore__getEndpointSchema({ operationId: "getUsers" })
→ Response: { users: User[], total: number }
→ User: { id, name, email, role, createdAt }
```

### Step 3: Implement with Type Safety

```typescript
// Claude generates this based on schema
interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
  createdAt: string;
}

interface UserListResponse {
  users: User[];
  total: number;
}

async function fetchUsers(limit = 10): Promise<UserListResponse> {
  const res = await fetch(`/api/users?limit=${limit}`);
  return res.json();
}
```

### Step 4: Test with Mock Data

```
Claude: "Mock 데이터로 테스트해볼게"

→ mcp__api-petstore__getUsers({ limit: 5 })
→ {
    "users": [
      { "id": "1", "name": "John Doe", "email": "john@example.com", "role": "user" },
      { "id": "2", "name": "Jane Smith", "email": "jane@example.com", "role": "admin" }
    ],
    "total": 2
  }
```

---

## Workflow: Adding a New Feature

When implementing a feature that might need multiple APIs.

### Step 1: Entity Discovery

```
Claude: "주문 관련 기능을 추가해야 해. 어떤 API들이 있지?"

→ mcp__api-petstore__findEndpointsByEntity({ entity: "order" })
→ {
    "entity": "order",
    "actions": {
      "list": "getOrders",
      "get": "getOrderById",
      "create": "createOrder",
      "cancel": "cancelOrder"
    }
  }
```

### Step 2: Understand Each Endpoint

```
# 주문 생성 API
→ mcp__api-petstore__getEndpointSchema({ operationId: "createOrder" })
→ Request body: { userId, items: [{ productId, quantity }] }
→ Response: { orderId, status, createdAt }

# 주문 취소 API
→ mcp__api-petstore__getEndpointSchema({ operationId: "cancelOrder" })
→ Request: DELETE /orders/{id}
→ Response: { success: boolean, message: string }
```

### Step 3: Implement Full Feature

```typescript
// Claude implements based on discovered APIs
class OrderService {
  async createOrder(userId: string, items: OrderItem[]): Promise<Order> { ... }
  async getOrders(userId: string): Promise<Order[]> { ... }
  async cancelOrder(orderId: string): Promise<void> { ... }
}
```
