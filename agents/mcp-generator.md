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
  {
    name: "getUsers",
    description: "List all users",
    inputSchema: {
      type: "object",
      properties: {
        limit: {
          type: "number",
          description: "Maximum number of results"
        }
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

export const handlers: Record<string, Function> = {
  getUsers,
  getUserById,
  createOrder,
  getOrders,
};
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
├── tools.ts            # Tool definitions
├── package.json        # Dependencies
├── tsconfig.json       # TypeScript config
├── handlers/
│   ├── index.ts        # Handler registry
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
