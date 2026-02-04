---
name: hack-2-nextjs
description: |
  Convert existing UI sources to NextJS applications.
  Supports URLs, local codebases (HTML/React/Vue), and screenshots.
  4-phase pipeline: YAML wireframe → NextJS code → routing → dev server.
  Use when user wants to clone or convert existing UI to NextJS.
  Arguments: --source (path or url), --scope (single or all), --designSystem (path)
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion, mcp__chrome-devtools__take_snapshot, mcp__chrome-devtools__navigate_page, mcp__chrome-devtools__evaluate_script, mcp__chrome-devtools__take_screenshot
---

# Hack 2 NextJS

Convert existing UI sources to fully functional NextJS applications.

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `source` | ✓ | Target to convert: URL, folder, or file path |
| `scope` | ✓ | `single` = one screen only, `all` = all linked/dependent screens |
| `designSystem` | ✓ | Path to design-tokens.yaml or design system folder |

## Output

**Fixed output folder:** `hack-2-nextjs/`

```
hack-2-nextjs/
├── wireframes/           # Phase 1 output
│   ├── screen-list.md
│   └── screens/*.yaml
└── nextjs-app/           # Phase 2-4 output
    ├── app/
    ├── components/
    └── ...
```

---

## Workflow

```
[Phase 1: YAML Wireframe] → [Phase 2: NextJS Code] → [Phase 3: Routing] → [Phase 4: Dev Server]
```

---

## Phase 1: Generate YAML Wireframe

> Reference: `shared/references/hack-2-spec/progressive-generation.md` (Q3 section only)
> Template: `shared/templates/common/02-WIREFRAME_YAML_TEMPLATE.yaml`
> Layout Rules: `shared/references/common/rules/07-layout-extraction-rules.md`

### 1.1 Source Type Detection

| Type | Detection | Method |
|------|-----------|--------|
| **URL** | Starts with `http://` or `https://` | Chrome MCP |
| **Local Code** | Directory with `*.html`, `*.tsx`, `*.vue` | File parsing |
| **Screenshot** | Image file (`.png`, `.jpg`, `.webp`) | Vision analysis |

### 1.2 Screen Discovery (scope=all)

```
IF scope == "all":
  1. Start from source
  2. Extract all internal links (<a href>, onClick → navigate)
  3. Queue linked screens
  4. Recursively process until all screens discovered
```

### 1.3 Per-Screen Wireframe Generation

**For Website (Chrome MCP):**
```
1. navigate_page(url)
2. take_snapshot() → a11y tree
3. evaluate_script() → CSS layout extraction (CRITICAL!)
4. Merge a11y + CSS → screen_data
5. Generate {screen-id}.yaml
```

**CSS Extraction Script (evaluate_script):**
```javascript
() => {
  const elements = document.querySelectorAll('[class]');
  const layouts = [];
  elements.forEach(el => {
    const computed = getComputedStyle(el);
    if (computed.display === 'grid' || computed.display === 'flex') {
      layouts.push({
        selector: el.className,
        display: computed.display,
        gridTemplateColumns: computed.gridTemplateColumns,
        flexDirection: computed.flexDirection,
        justifyContent: computed.justifyContent,
        alignItems: computed.alignItems,
        gap: computed.gap
      });
    }
  });
  return layouts;
}
```

**For Local Code:**
```
1. Read file content
2. Parse JSX/HTML structure
3. Extract Tailwind/CSS layout patterns
4. Generate {screen-id}.yaml
```

**For Screenshot:**
```
1. Read image file (vision)
2. Identify UI components and layout
3. Infer grid/flex structure
4. Generate {screen-id}.yaml
```

### 1.4 Output Structure

```
hack-2-nextjs/wireframes/
├── screen-list.md
└── screens/
    ├── {screen-1}.yaml
    ├── {screen-2}.yaml
    └── ...
```

---

## Phase 2: Generate NextJS Code

Convert wireframes to NextJS components using design system tokens.

### 2.1 Technology Stack

| Category | Choice |
|----------|--------|
| Framework | Next.js 14+ (App Router) |
| Styling | Tailwind CSS |
| Components | Design system from `designSystem` path |
| Icons | lucide-react |

### 2.2 Generation Rules

**Per Wireframe → NextJS Page:**
```
1. Read {screen-id}.yaml
2. Read design-tokens.yaml
3. Map wireframe components → React components
4. Apply design tokens for styling
5. Generate app/{route}/page.tsx
```

**Component Mapping:**
```yaml
# wireframe → nextjs
StatCard → components/ui/stat-card.tsx
FilterBar → components/ui/filter-bar.tsx
DataTable → components/ui/data-table.tsx
PageHeader → components/layout/page-header.tsx
```

### 2.3 Output Structure

```
hack-2-nextjs/nextjs-app/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── {routes}/
│       └── page.tsx
├── components/
│   ├── layout/
│   └── ui/
├── lib/
│   └── utils.ts
├── styles/
│   └── globals.css
├── tailwind.config.ts
├── package.json
└── tsconfig.json
```

---

## Phase 3: Implement Routing

Wire up navigation based on wireframe interactions.

### 3.1 Extract Navigation

```
FOR each wireframe:
  1. Find interactions with action: "navigate"
  2. Map trigger element → target route
  3. Generate Link components or onClick handlers
```

### 3.2 Navigation Types

| Type | Implementation |
|------|----------------|
| Link click | `<Link href="/target">` |
| Button click | `router.push('/target')` |
| Programmatic | `useRouter().push()` |

### 3.3 Update Components

```
1. Import next/link and next/navigation
2. Replace static elements with Link components
3. Add onClick handlers for button navigation
```

---

## Phase 4: Start Dev Server

### 4.1 Install Dependencies

```bash
cd hack-2-nextjs/nextjs-app
npm install
```

### 4.2 Run Development Server

```bash
npm run dev
```

### 4.3 Verify

```
1. Open http://localhost:3000
2. Check all pages render correctly
3. Verify navigation works
4. Report any errors
```

---

## Verification Checklist

| Phase | Check | Required |
|-------|-------|----------|
| **Phase 1** |||
| Wireframes | All screens have .yaml files | ✓ |
| Wireframes | Layout extracted correctly | ✓ |
| Wireframes | Components identified | ✓ |
| **Phase 2** |||
| NextJS | package.json created | ✓ |
| NextJS | All pages generated | ✓ |
| NextJS | Design tokens applied | ✓ |
| **Phase 3** |||
| Routing | All links work | ✓ |
| Routing | Navigation consistent | ✓ |
| **Phase 4** |||
| Server | npm install succeeds | ✓ |
| Server | npm run dev starts | ✓ |
| Server | No console errors | ✓ |

---

## Final Response Format

```
Done. Generated NextJS application:

📁 hack-2-nextjs/

Phase 1 - Wireframes:
└── wireframes/ [N screens]

Phase 2 - NextJS Code:
└── nextjs-app/
    ├── app/ [M pages]
    ├── components/ [K components]
    └── ...

Phase 3 - Routing:
└── [X navigation links wired]

Phase 4 - Dev Server:
└── Running at http://localhost:3000

Total: N screens → M pages, K components
```
