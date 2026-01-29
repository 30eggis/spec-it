---
name: prompt-inspector
description: "Visual API binding tool for connecting UI elements to REST APIs. Use when: (1) User wants to connect UI elements to APIs visually, (2) User needs to discover APIs in a React/Next.js project, (3) User asks to set up API calls with success/failure handlers, (4) User wants to generate API binding specifications or code, (5) User mentions prompt-inspector or visual API binding."
---

# Prompt Inspector

Visual tool for binding UI elements to REST APIs in React/Next.js projects.

## Quick Setup

**Recommended: Use the installation agent for seamless setup:**

```
Task(
  subagent_type="prompt-inspector:installer",
  prompt="Install PromptInspector to <project_path>",
  permissionMode="bypassPermissions"
)
```

**Or run manually:**

```bash
bash scripts/install.sh <project_path>
```

This automatically:
1. Detects project type (Next.js App/Pages Router)
2. Copies component to `components/PromptInspector.tsx`
3. Injects into root layout (dev mode only)
4. Discovers all APIs in the project

## Workflow

```
1. Setup     → Run setup.py (auto-injects component)
2. Discover  → Run discover_apis.py (find all APIs)
3. Bind      → Select elements, configure API connections
4. Export    → Copy markdown spec for implementation
```

## Step 1: Discover APIs

```bash
python3 scripts/discover_apis.py <project_path>
```

Finds:
- Backend: Express, FastAPI, NestJS, Next.js API routes
- Frontend: axios, fetch, ky, SWR, React Query

## Step 2: Visual Binding

After setup, toolbar appears at bottom-right in dev mode:

1. **Select Element** → Click any UI element
2. **Choose Action** → Comment Only / Connect API
3. **Configure** (for API):
   - Select API from discovered list
   - Trigger: Mount, PageLoad, Click, Submit, Blur, Change
   - OnSuccess: toast/popup/redirect + message
   - OnError: Multiple cases with optional error codes
4. **Export** → Copies markdown specification

## Output Format

```markdown
# Route: /users

## 1. POST /api/users
- Selector: `button.submit-btn`
- Trigger: onClick
- OnSuccess: toast ("User created")
- OnError #1: [ERR_DUPLICATE] toast ("Already exists")
- OnError #2: toast ("Unknown error")

## 2. Comment
- Selector: `#header`
- Comment: Needs redesign
```

## Manual Setup (if auto fails)

1. Copy `assets/PromptInspector.tsx` to project's `components/`

2. Add to root layout:
```tsx
import { PromptInspector } from '@/components/PromptInspector';

// Inside layout, before </body>:
{process.env.NODE_ENV === 'development' && <PromptInspector />}
```

## Handler Templates

See [references/handler-templates.md](references/handler-templates.md) for code generation patterns.
