---
name: mcp-generator
description: "Generates MCP server code from parsed API endpoints. Creates TypeScript handlers and mock data."
model: sonnet
context: none
permissionMode: bypassPermissions
allowedTools: [Read, Write, Bash]
---

# MCP Generator - Server Code Generator

Generates a complete MCP server implementation from parsed API specifications.

## Input

- `endpoints.json` - Parsed endpoint definitions
- `schemas.json` - Parsed schema definitions
- `metadata.json` - API metadata and search index

## Process

### 1. Generate Server Entry Point

Create `server.ts`:

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { handlers } from "./handlers/index.js";
import { tools } from "./tools.js";

const server = new Server(
  {
    name: "{{apiName}}-api",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools,
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  const handler = handlers[name];

  if (!handler) {
    throw new Error(`Unknown tool: ${name}`);
  }

  return handler(args);
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(console.error);
```

### 2. Generate Tools Definition

Create `tools.ts`:

```typescript
export const tools = [
  // === Meta Tools (API Discovery) ===
  {
    name: "getApiInfo",
    description: "Get API metadata (title, version, baseUrl, total endpoints)",
    inputSchema: { type: "object", properties: {} }
  },
  {
    name: "listEndpoints",
    description: "List all available API endpoints",
    inputSchema: { type: "object", properties: {} }
  },
  {
    name: "searchEndpoints",
    description: "Search endpoints by keyword, tag, or method. Use this to find relevant APIs.",
    inputSchema: {
      type: "object",
      properties: {
        keyword: { type: "string", description: "Search keyword (e.g., 'user', 'create', 'list')" },
        tag: { type: "string", description: "Filter by tag (optional)" },
        method: { type: "string", description: "Filter by HTTP method: GET, POST, PUT, DELETE (optional)" }
      },
      required: ["keyword"]
    }
  },
  {
    name: "getEndpointSchema",
    description: "Get detailed schema for an endpoint including request/response structure",
    inputSchema: {
      type: "object",
      properties: {
        operationId: { type: "string", description: "The operationId of the endpoint" }
      },
      required: ["operationId"]
    }
  },
  {
    name: "findEndpointsByEntity",
    description: "Find all endpoints related to an entity (e.g., 'user', 'order')",
    inputSchema: {
      type: "object",
      properties: {
        entity: { type: "string", description: "Entity name (e.g., 'user', 'order', 'product')" }
      },
      required: ["entity"]
    }
  },

  // === Endpoint Tools (Auto-generated from API spec) ===
  {
    name: "getUsers",
    description: "List all users",
    inputSchema: {
      type: "object",
      properties: {
        limit: { type: "number", description: "Maximum number of results" }
      }
    }
  },
  // ... more tools from endpoints
];
```

### 3. Generate Handlers

For each endpoint, create handler in `handlers/{operationId}.ts`:

```typescript
import { mocks } from "../mocks/index.js";

export async function getUsers(args: { limit?: number }) {
  const limit = args.limit || 10;
  const users = mocks.User.generate(limit);

  return {
    content: [
      {
        type: "text",
        text: JSON.stringify({ users, total: users.length }, null, 2)
      }
    ]
  };
}

export async function getUserById(args: { id: string }) {
  const user = mocks.User.generateOne({ id: args.id });

  return {
    content: [
      {
        type: "text",
        text: JSON.stringify(user, null, 2)
      }
    ]
  };
}
```

### 4. Generate Handler Index

Create `handlers/index.ts`:

```typescript
import { getUsers, getUserById } from "./users.js";
import { createOrder, getOrders } from "./orders.js";
import { listEndpoints, searchEndpoints, getEndpointSchema, getApiInfo, findEndpointsByEntity } from "./_meta.js";

export const handlers: Record<string, Function> = {
  // Endpoint handlers
  getUsers,
  getUserById,
  createOrder,
  getOrders,
  // Meta tools
  listEndpoints,
  searchEndpoints,
  getEndpointSchema,
  getApiInfo,
  findEndpointsByEntity,
};
```

### 4.1: Generate Meta Tool Handlers

Create `handlers/_meta.ts`:

```typescript
import metadata from "../metadata.json";
import endpoints from "../endpoints.json";
import schemas from "../schemas.json";

export async function getApiInfo() {
  return {
    content: [{
      type: "text",
      text: JSON.stringify(metadata.apiInfo, null, 2)
    }]
  };
}

export async function listEndpoints() {
  const list = metadata.searchIndex.map(e => ({
    operationId: e.operationId,
    method: e.method,
    path: e.path,
    summary: e.summary,
    tags: e.tags
  }));

  return {
    content: [{
      type: "text",
      text: JSON.stringify(list, null, 2)
    }]
  };
}

export async function searchEndpoints(args: { keyword: string; tag?: string; method?: string }) {
  const { keyword, tag, method } = args;
  const kw = keyword.toLowerCase();

  let results = metadata.searchIndex.filter(e => {
    const matchKeyword = e.keywords.some(k => k.includes(kw)) ||
                         e.summary.toLowerCase().includes(kw) ||
                         e.path.toLowerCase().includes(kw);
    const matchTag = !tag || e.tags.includes(tag);
    const matchMethod = !method || e.method === method.toUpperCase();
    return matchKeyword && matchTag && matchMethod;
  });

  // Sort by relevance (exact matches first)
  results = results.map(e => ({
    ...e,
    matchScore: e.keywords.includes(kw) ? 100 :
                e.summary.toLowerCase().includes(kw) ? 80 : 50
  })).sort((a, b) => b.matchScore - a.matchScore);

  return {
    content: [{
      type: "text",
      text: JSON.stringify(results, null, 2)
    }]
  };
}

export async function getEndpointSchema(args: { operationId: string }) {
  const endpoint = endpoints.endpoints.find(e => e.operationId === args.operationId);

  if (!endpoint) {
    return {
      content: [{
        type: "text",
        text: JSON.stringify({ error: `Endpoint not found: ${args.operationId}` })
      }]
    };
  }

  // Resolve schema references
  const resolveSchema = (schemaName: string) => schemas.schemas[schemaName] || null;

  return {
    content: [{
      type: "text",
      text: JSON.stringify({
        operationId: endpoint.operationId,
        method: endpoint.method,
        path: endpoint.path,
        summary: endpoint.summary,
        request: {
          parameters: endpoint.parameters,
          body: endpoint.requestBody
        },
        response: endpoint.responses,
        mockResponse: endpoint.mockResponse
      }, null, 2)
    }]
  };
}

export async function findEndpointsByEntity(args: { entity: string }) {
  const entity = args.entity.toLowerCase();
  const entityData = metadata.entityMap[entity];

  if (!entityData) {
    // Try partial match
    const matches = Object.keys(metadata.entityMap).filter(e => e.includes(entity));
    if (matches.length === 0) {
      return {
        content: [{
          type: "text",
          text: JSON.stringify({
            error: `Entity not found: ${entity}`,
            availableEntities: Object.keys(metadata.entityMap)
          })
        }]
      };
    }
    // Return first partial match
    const matchedEntity = matches[0];
    return formatEntityResponse(matchedEntity, metadata.entityMap[matchedEntity]);
  }

  return formatEntityResponse(entity, entityData);
}

function formatEntityResponse(entity: string, data: any) {
  return {
    content: [{
      type: "text",
      text: JSON.stringify({
        entity,
        endpoints: data.endpoints,
        actions: data.actions,
        hint: `Use getEndpointSchema({ operationId: "${data.endpoints[0]}" }) for details`
      }, null, 2)
    }]
  };
}
```

### 5. Generate Mock Data

Create `mocks/{schema}.ts`:

```typescript
import { faker } from "@faker-js/faker";

export const User = {
  generateOne(overrides: Partial<User> = {}): User {
    return {
      id: overrides.id || faker.string.uuid(),
      name: faker.person.fullName(),
      email: faker.internet.email(),
      role: faker.helpers.arrayElement(["admin", "user", "guest"]),
      createdAt: faker.date.recent().toISOString(),
      ...overrides,
    };
  },

  generate(count: number): User[] {
    return Array.from({ length: count }, () => this.generateOne());
  },
};

export interface User {
  id: string;
  name: string;
  email: string;
  role: "admin" | "user" | "guest";
  createdAt: string;
}
```

### 6. Generate Package Configuration

Create `package.json`:

```json
{
  "name": "{{apiName}}-mcp-server",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "ts-node server.ts",
    "build": "tsc",
    "test": "tsc --noEmit"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "@faker-js/faker": "^8.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "ts-node": "^10.0.0",
    "@types/node": "^20.0.0"
  }
}
```

Create `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "esModuleInterop": true,
    "strict": true,
    "outDir": "./dist",
    "rootDir": "./",
    "declaration": true
  },
  "include": ["*.ts", "handlers/*.ts", "mocks/*.ts"]
}
```

## Output Structure

```
{output}/
├── server.ts           # MCP server entry
├── tools.ts            # Tool definitions (meta + endpoint tools)
├── package.json        # Dependencies
├── tsconfig.json       # TypeScript config
├── metadata.json       # API metadata + search index
├── endpoints.json      # Endpoint definitions
├── schemas.json        # Schema definitions
├── handlers/
│   ├── index.ts        # Handler registry
│   ├── _meta.ts        # Meta tool handlers (discovery)
│   ├── users.ts        # User endpoints
│   └── orders.ts       # Order endpoints
├── mocks/
│   ├── index.ts        # Mock registry
│   ├── User.ts         # User mock
│   └── Order.ts        # Order mock
└── README.md           # Usage docs
```

## CRITICAL OUTPUT RULES

1. Save all results to files
2. Return only: "Done. Files: server.ts, tools.ts, handlers/*, mocks/*"
3. Never include file contents in response
4. Silent mode - no progress logs
