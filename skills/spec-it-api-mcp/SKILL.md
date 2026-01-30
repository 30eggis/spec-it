---
name: spec-it-api-mcp
description: "Generate local MCP server from OpenAPI/Swagger spec. Creates mock API endpoints for spec-it-executor development. Use when user provides API documentation."
allowed-tools: Read, Write, Edit, Bash, Task, WebFetch, Glob
argument-hint: "<api-doc-path> [--output <dir>] [--port <port>]"
permissionMode: bypassPermissions
---

# spec-it-api-mcp: API → MCP Server Generator

Convert OpenAPI/Swagger specs to local MCP server for development.

## Workflow

```
[API Doc] → [Parse] → [Generate MCP] → [Register] → [Ready]
```

---

## Phase 0: Input Validation

### Step 0.1: Detect API Document

```
IF api-doc-path provided:
  SET apiDocPath = args.api-doc-path
ELSE:
  # Search for API docs in common locations
  Glob: **/openapi.{yaml,json}, **/swagger.{yaml,json}, **/api-spec.{yaml,json}

  IF multiple found:
    AskUserQuestion: "Which API document should I use?"
    Options: [list of found files]
  ELSE IF none found:
    AskUserQuestion: "Please provide the path to your API document"

SET apiDocPath = selected file
```

### Step 0.2: Validate Format

```
Read: {apiDocPath}

VALIDATE:
  - OpenAPI 3.x format
  - OR Swagger 2.x format

IF invalid:
  Output: "ERROR: Unsupported format."
  Output: "Supported formats: OpenAPI 3.0+, Swagger 2.0"
  Output: "Example: /spec-it-api-mcp ./api/openapi.yaml"
  STOP

EXTRACT:
  - title: API name
  - version: API version
  - servers: Base URLs
  - paths: All endpoints
  - components/schemas: Data models
```

---

## Phase 1: Parse & Generate

### Step 1.1: Parse API Structure

```
Task(api-parser, sonnet):
  Input: apiDocPath content
  Output:
    - tmp/_api-mcp/{project-name}/endpoints.json
    - tmp/_api-mcp/{project-name}/schemas.json

  endpoints.json structure:
    {
      "endpoints": [
        {
          "path": "/users/{id}",
          "method": "GET",
          "operationId": "getUser",
          "parameters": [...],
          "responses": {...},
          "mockResponse": {...}
        }
      ]
    }

  schemas.json structure:
    {
      "schemas": {
        "User": {
          "type": "object",
          "properties": {...},
          "mockData": {...}
        }
      }
    }
```

### Step 1.2: Generate MCP Server

```
Task(mcp-generator, sonnet):
  Input: endpoints.json, schemas.json
  Output: tmp/_api-mcp/{project-name}/

  Generated files:
    server.ts        # MCP server implementation
    package.json     # Dependencies
    tsconfig.json    # TypeScript config
    handlers/
      {endpoint}.ts  # Handler per endpoint
    mocks/
      {schema}.ts    # Mock data generators
```

### Step 1.3: Generate Mock Data

```
FOR each schema in schemas.json:
  Generate realistic mock data using:
    - faker.js patterns
    - Schema constraints (min, max, pattern)
    - Enum values
    - Referenced schemas
```

---

## Phase 2: Build & Test

### Step 2.1: Install Dependencies

```
Bash: cd tmp/_api-mcp/{project-name} && npm install
```

### Step 2.2: Test Server

```
Bash: cd tmp/_api-mcp/{project-name} && npm run test

IF test fails:
  Output: "Build failed. Attempting fix..."
  Task(api-fixer, haiku):
    Fix compilation errors
  RETRY build
```

---

## Phase 3: MCP Registration

### Step 3.1: Generate MCP Config

```
Read: ~/.claude/claude_desktop_config.json OR create if not exists

project-name = sanitize(API title from spec)
port = args.port OR 3100

APPEND to mcpServers:
  "api-{project-name}": {
    "command": "npx",
    "args": ["ts-node", "{absolute-path}/server.ts"],
    "env": {
      "PORT": "{port}",
      "NODE_ENV": "development"
    }
  }

Write: ~/.claude/claude_desktop_config.json
```

### Step 3.2: Generate Usage Guide

```
Write: tmp/_api-mcp/{project-name}/README.md

Contents:
  # {API Title} MCP Server

  ## Quick Start

  1. Restart Claude Code to load the MCP server
  2. Available tools will be prefixed with `mcp__api-{project-name}__`

  ## Available Endpoints

  | Tool | Method | Path | Description |
  |------|--------|------|-------------|
  | mcp__api-{name}__getUser | GET | /users/{id} | Get user by ID |
  ...

  ## Mock Data

  Mock responses are generated based on schema definitions.
  Customize in: mocks/{schema}.ts

  ## Manual Testing

  ```bash
  cd tmp/_api-mcp/{project-name}
  npm run dev
  curl http://localhost:{port}/users/1
  ```
```

---

## Phase 4: Completion

### Step 4.1: Output Summary

```
Output: "✓ MCP Server generated successfully!"
Output: ""
Output: "📁 Location: tmp/_api-mcp/{project-name}/"
Output: "🔌 MCP Name: api-{project-name}"
Output: "🌐 Port: {port}"
Output: ""
Output: "Next steps:"
Output: "1. Restart Claude Code to load the MCP server"
Output: "2. Use tools like: mcp__api-{project-name}__getUser"
Output: ""
Output: "For manual testing:"
Output: "  cd tmp/_api-mcp/{project-name} && npm run dev"
```

---

## Output Structure

```
tmp/_api-mcp/{project-name}/
├── server.ts           # MCP server entry point
├── package.json        # Dependencies
├── tsconfig.json       # TypeScript config
├── endpoints.json      # Parsed endpoint definitions
├── schemas.json        # Parsed schema definitions
├── handlers/
│   ├── index.ts        # Handler registry
│   └── {endpoint}.ts   # Individual handlers
├── mocks/
│   ├── index.ts        # Mock data registry
│   └── {schema}.ts     # Schema-specific mocks
└── README.md           # Usage documentation
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| api-parser | sonnet | Parse OpenAPI/Swagger to JSON |
| mcp-generator | sonnet | Generate MCP server code |
| api-fixer | haiku | Fix build errors |

---

## Arguments

| Arg | Required | Description |
|-----|----------|-------------|
| api-doc-path | No | Path to OpenAPI/Swagger file (auto-detected) |
| --output | No | Output directory (default: tmp/_api-mcp/) |
| --port | No | Server port (default: 3100) |
| --no-register | No | Generate without MCP registration |

---

## Supported Formats

| Format | Version | Support |
|--------|---------|---------|
| OpenAPI | 3.0.x | ✓ Full |
| OpenAPI | 3.1.x | ✓ Full |
| Swagger | 2.0 | ✓ Full |
| Postman Collection | 2.x | △ Basic |
| GraphQL Schema | * | ✗ Not yet |

---

## Examples

```bash
# Auto-detect API doc
/spec-it-api-mcp

# Specific file
/spec-it-api-mcp ./api/openapi.yaml

# Custom port
/spec-it-api-mcp ./api/swagger.json --port 3200

# Custom output location
/spec-it-api-mcp ./api/spec.yaml --output ./mcp-servers/my-api
```

---

## Integration with spec-it-execute

Once registered, the MCP server can be used in spec-it-execute:

```
# In spec-it-execute, Claude can call:
mcp__api-{project-name}__getUser(id: "123")
mcp__api-{project-name}__createOrder(data: {...})

# Mock responses are returned based on schema definitions
```
