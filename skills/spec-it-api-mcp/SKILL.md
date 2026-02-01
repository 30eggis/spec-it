---
name: spec-it-api-mcp
description: "Generate local MCP server from OpenAPI/Swagger for frontend development."
allowed-tools: Read, Write, Edit, Bash, Task, WebFetch, Glob
argument-hint: "<api-doc-path> [--output <dir>] [--port <port>]"
permissionMode: bypassPermissions
---

# spec-it-api-mcp: API → MCP Server Generator

Convert OpenAPI/Swagger specs to local MCP server for development.

## References

- [Output Schemas](references/output-schemas.md) - JSON structure details
- [Integration Examples](references/integration-examples.md) - Usage with spec-it-execute

---

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
  Glob: **/openapi.{yaml,json}, **/swagger.{yaml,json}
  IF multiple: AskUserQuestion to select
  IF none: AskUserQuestion for path
```

### Step 0.2: Validate Format

```
Read: {apiDocPath}
VALIDATE: OpenAPI 3.x OR Swagger 2.x
EXTRACT: title, version, servers, paths, schemas
```

---

## Phase 1: Parse & Generate

### Step 1.1: Parse API Structure

```
Task(api-parser, sonnet):
  Output:
    - endpoints.json   # Endpoint definitions
    - schemas.json     # Data models
    - metadata.json    # Search index for meta tools
```

See [Output Schemas](references/output-schemas.md) for JSON structure details.

### Step 1.2: Generate MCP Server

```
Task(mcp-generator, sonnet):
  Output:
    - server.ts, package.json, tsconfig.json
    - handlers/{endpoint}.ts
    - handlers/_meta.ts    # Meta tool handlers
    - mocks/{schema}.ts
```

### Step 1.3: Meta Tools (Auto-generated)

| Tool | Purpose |
|------|---------|
| `listEndpoints` | List all API endpoints |
| `searchEndpoints` | Search by keyword/tag/method |
| `getEndpointSchema` | Get request/response schema |
| `getApiInfo` | Get API metadata |
| `findEndpointsByEntity` | Find endpoints by entity |

---

## Phase 2: Build & Test

```
Bash: npm install && npm run test
IF fail: Task(api-fixer, haiku) → RETRY
```

---

## Phase 3: MCP Registration

```
APPEND to ~/.claude/claude_desktop_config.json:
  "api-{project-name}": {
    "command": "npx",
    "args": ["ts-node", "{path}/server.ts"]
  }
```

---

## Output Structure

```
tmp/_api-mcp/{project-name}/
├── server.ts, package.json, tsconfig.json
├── endpoints.json, schemas.json, metadata.json
├── handlers/
│   ├── index.ts, _meta.ts, {endpoint}.ts
├── mocks/
│   └── {schema}.ts
└── README.md
```

---

## Arguments

| Arg | Required | Default | Description |
|-----|----------|---------|-------------|
| api-doc-path | No | auto-detect | OpenAPI/Swagger file |
| --output | No | tmp/_api-mcp/ | Output directory |
| --port | No | 3100 | Server port |
| --no-register | No | - | Skip MCP registration |

---

## Supported Formats

| Format | Support |
|--------|---------|
| OpenAPI 3.x | ✓ Full |
| Swagger 2.0 | ✓ Full |
| Postman 2.x | △ Basic |

---

## Examples

```bash
/spec-it-api-mcp                              # Auto-detect
/spec-it-api-mcp ./api/openapi.yaml           # Specific file
/spec-it-api-mcp ./api/spec.yaml --port 3200  # Custom port
```

---

## Integration with spec-it-execute

```
# Discovery
mcp__api-petstore__searchEndpoints({ keyword: "user" })

# Schema lookup
mcp__api-petstore__getEndpointSchema({ operationId: "getUsers" })

# Mock call
mcp__api-petstore__getUsers({ limit: 10 })
```

See [Integration Examples](references/integration-examples.md) for detailed workflows.
