---
name: hack-2-nextjs
description: |
  Convert existing UI sources to NextJS applications.
  Chrome MCP-based direct TSX generation (no YAML intermediate step).
  Goal: Visual match (95%+) + Modifiable (design tokens).
  Supports: URLs, local codebases (HTML/React/Vue), screenshots.
  Arguments: --source (path or url), --scope (single or all)
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion, mcp__chrome-devtools__*, mcp__plugin_spec-it_chrome-devtools__*
bypassPermissions: true
---

# Hack 2 NextJS

Convert existing UI sources to NextJS applications through systematic extraction and aggregation.

---

## Core Principle

```
COLLECT, DON'T CREATE.

Extract → Organize → Aggregate → Substitute → Document
```

> Reference: [ref/extraction-rules.md](ref/extraction-rules.md)

---

## Forbidden Actions (CRITICAL)

| Action | Result |
|--------|--------|
| Speculation | SKILL FAILURE |
| Imagination | SKILL FAILURE |
| Arbitrary Changes | SKILL FAILURE |
| Code Generation | SKILL FAILURE |
| Prediction | SKILL FAILURE |
| Suggestion | SKILL FAILURE |

**You must NOT:**
- Write components from scratch
- "Improve" layouts or designs
- Change class names or values
- Add features not in original
- Suggest "better" approaches

---

## Allowed Actions

| Action | Description |
|--------|-------------|
| Component Aggregation | Extract props for external injection |
| Design Token Substitution | `bg-[#3b82f6]` → `bg-primary` |
| Route Substitution | `file://` → NextJS routes |
| HTML→JSX Conversion | `class` → `className` |

---

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `source` | Yes | - | URL, folder path, or file path |
| `scope` | No | `all` | `single` = one screen, `all` = all linked screens |

---

## Output Structure

```
hack-2-nextjs/
├── navigation-map.md           # Phase 0 output
├── candidates/                  # Phase 1-4 candidates
│   ├── design-tokens/          # Token candidates per page
│   ├── app-shells/             # Shell candidates
│   └── components/             # Component candidates
├── aggregated/                  # Aggregated results
│   ├── tokens.ts               # Global design tokens
│   ├── app-shells.md           # Shell decisions
│   └── components.md           # Component decisions
├── mock-data-list.md           # Phase 7 output
└── nextjs-app/
    ├── app/
    │   ├── layout.tsx
    │   ├── page.tsx
    │   └── (groups)/
    ├── components/
    │   ├── layout/             # App shells
    │   ├── ui/                 # Extracted components
    │   └── icons/              # Extracted SVGs
    ├── lib/
    │   └── tokens.ts           # Design tokens
    ├── public/
    └── package.json
```

---

## Workflow Overview

```
Phase 0: Route Discovery
    ↓
Phase 1: HTML Analysis (Extract As-Is)
    ↓
Phase 2: Design Token Candidates → Aggregate → tokens.ts
    ↓
Phase 3: App Shell Candidates → Aggregate → Persona/Function Shells
    ↓
Phase 4: Component Candidates → Aggregate → Reusable Components
    ↓
Phase 5: TSX Generation (Substitute Shell/Component/Tokens)
    ↓
Phase 6: Route Substitution (file:// → NextJS routes)
    ↓
Phase 7: Mock Data Identification → mock-data-list.md
```

---

## Phase 0: Route Discovery

**Goal:** Collect URLs and paths only (NO SNAPSHOTS!)

### 0.1 Source Detection

| Type | Detection | Method |
|------|-----------|--------|
| URL | `http://`, `https://`, `file://` | Chrome MCP |
| Local HTML | `*.html` file | Convert to `file://` |
| Local Code | Directory with `*.tsx` | File parsing |

### 0.2 Navigation Collection

```javascript
// Collect links without taking snapshots
evaluate_script({
  function: `() => {
    const links = [];
    document.querySelectorAll('a[href], [data-nav], button[onclick]').forEach(el => {
      links.push({
        href: el.href || el.getAttribute('data-nav'),
        text: el.textContent.trim(),
        type: el.tagName
      });
    });
    return { title: document.title, url: location.href, links };
  }`
})
```

### 0.3 Output: navigation-map.md

```markdown
# Navigation Map

## Pages
| ID | URL | Title | Suggested Route | Shell |
|----|-----|-------|-----------------|-------|
| P001 | file:///mockup/index.html | HR Dashboard | /(hr-admin) | hr-admin |
| P002 | file:///mockup/emp-index.html | Employee Dashboard | /(employee) | employee |

## Navigation Graph
P001 → P002 (click: "Employee Mode")

## Route Groups
(hr-admin): P001, P005, P006
(employee): P002, P003, P004
```

---

## Phase 1: HTML Analysis

**Goal:** Extract HTML exactly as-is. No modifications.

> Reference: [ref/phases.md](ref/phases.md)

### 1.1 Parallel Agent Spawning

```python
for page in navigation_map.pages:
    Task(
        subagent_type="general-purpose",
        prompt=f"""
        Extract page: {page.url}
        Page ID: {page.id}

        CRITICAL: Extract exactly as-is. Do not modify anything.

        Steps:
        1. navigate_page(url)
        2. Extract outerHTML (preserve all classes!)
        3. Extract computed styles
        4. Extract assets
        5. Save to: candidates/{page.id}/

        Output files:
        - source.html (original HTML)
        - source.tsx (JSX syntax conversion only)
        - computed.json (style frequencies)
        - assets.json (images, fonts, SVGs)
        """,
        run_in_background=True
    )
```

### 1.2 Output per Page

```
candidates/{page-id}/
├── source.html      # Original HTML
├── source.tsx       # JSX syntax converted (classes unchanged!)
├── computed.json    # Style frequencies
└── assets.json      # Asset manifest
```

---

## Phase 2: Design Token Candidates

**Goal:** Collect token candidates from all pages, then aggregate.

> Reference: [ref/design-system.md](ref/design-system.md)

### 2.1 Candidate Collection

From each `computed.json`, extract:
- Colors (with frequency counts)
- Typography (font-family, size, weight, line-height)
- Spacing (padding, margin, gap)
- Shadows
- Border radius

### 2.2 Aggregation

```python
# Merge all computed.json files
all_colors = merge_frequencies(all_pages, 'colors')
all_typography = merge_frequencies(all_pages, 'typography')
all_spacing = merge_frequencies(all_pages, 'spacing')

# Map to semantic tokens by frequency
tokens = {
    'primary': highest_frequency_blue,
    'textPrimary': highest_frequency_dark_text,
    'background': highest_frequency_light_bg,
    ...
}
```

### 2.3 Output: lib/tokens.ts

```typescript
export const tokens = {
  colors: {
    primary: '#3b82f6',
    primaryHover: '#2563eb',
    background: '#f8fafc',
    surface: '#ffffff',
    textPrimary: '#1e293b',
    textSecondary: '#64748b',
    border: '#e2e8f0',
  },
  // ...
} as const;
```

---

## Phase 3: App Shell Candidates

**Goal:** Identify shell patterns, then aggregate into persona/function-based shells.

> Reference: [ref/app-shell.md](ref/app-shell.md)

### 3.1 Candidate Identification

Look for repeated layout structures:
- Headers (found across multiple pages)
- Sidebars (navigation patterns)
- Footers
- Page wrappers

### 3.2 Aggregation Criteria

| Criterion | Action |
|-----------|--------|
| Same structure, same pages group | Single shell |
| Same structure, different personas | Persona-specific shells |
| Different structure | Separate shells |

### 3.3 Output: Aggregated Shells

```
components/layout/
├── HRAdminShell.tsx        # Shell for hr-admin persona
├── EmployeeShell.tsx       # Shell for employee persona
├── Header.tsx              # Shared header (if identical)
├── Sidebar.tsx             # With persona-based nav items
└── index.ts
```

---

## Phase 4: Component Candidates

**Goal:** Identify reusable patterns, then aggregate with props extraction.

> Reference: [ref/components.md](ref/components.md)

### 4.1 Pattern Detection

Analyze all `source.tsx` for:
- Same className combination (3+ occurrences)
- Same DOM structure across pages
- Variations with different content only

### 4.2 Scoring System

| Criterion | Points |
|-----------|--------|
| Found in 3+ pages | +3 |
| 2+ instances same page | +2 |
| Clear semantic role | +2 |
| Independent styling | +1 |
| Props extractable | +1 |

**Threshold: Score >= 5 → Extract as component**

### 4.3 Aggregation with Props Extraction

```tsx
// FOUND: Same pattern in P001, P002, P005
// AGGREGATED: Extract variable parts as props
interface StatCardProps {
  title: string;      // Extracted: "This Week", "Remaining Leave"
  value: string;      // Extracted: "32h", "7 days"
  subtitle?: string;  // Extracted from some instances
  icon?: ReactNode;   // Extracted from some instances
}

export function StatCard({ title, value, subtitle, icon }: StatCardProps) {
  return (
    // EXACT classes from original - NOT modified
    <div className="rounded-2xl p-6 shadow-sm border border-slate-100">
      // EXACT structure from original
    </div>
  );
}
```

---

## Phase 5: TSX Generation

**Goal:** Generate page TSX by substituting shells, components, and tokens.

### 5.1 Substitution Process

```
Original source.tsx
    ↓
Replace shell markup → <HRAdminShell>
    ↓
Replace component patterns → <StatCard {...} />
    ↓
Replace hardcoded colors → Token classes
    ↓
Final page.tsx
```

### 5.2 Substitution Rules

| Original | Substituted |
|----------|-------------|
| `<header>...<sidebar>...<main>` | `<HRAdminShell>{content}</HRAdminShell>` |
| Repeated card pattern | `<StatCard title="..." value="..." />` |
| `bg-[#3b82f6]` | `bg-primary` |
| `text-[#1e293b]` | `text-textPrimary` |

---

## Phase 6: Route Substitution

**Goal:** Convert all file:// paths to NextJS routes.

> Reference: [ref/route-map.md](ref/route-map.md)

### 6.1 Build Route Map

From navigation-map.md:
```json
{
  "file:///mockup/index.html": "/",
  "file:///mockup/leave.html": "/leave",
  "file:///mockup/emp-index.html": "/employee"
}
```

### 6.2 Replace in All Files

```tsx
// Before
<a href="file:///mockup/leave.html">Leave Management</a>

// After
<Link href="/leave">Leave Management</Link>
```

---

## Phase 7: Mock Data Identification

**Goal:** Find all hardcoded data in pages AND components. Document for future server integration.

### 7.1 Scan Targets

Scan ALL files:
- `app/**/page.tsx` (all pages)
- `components/**/*.tsx` (all components)

### 7.2 Detection Patterns

| Pattern | Example | Type |
|---------|---------|------|
| Hardcoded strings | `"김호준"`, `"32h 45m"` | User data |
| Hardcoded arrays | `['월', '화', '수']` | Static data |
| Hardcoded objects | `{ day: 3, label: '연차' }` | Entity data |
| Hardcoded numbers | `value={7}`, `hours={8.5}` | Metric data |
| Date strings | `"2026년 2월"`, `"01/27"` | Temporal data |

### 7.3 Output: mock-data-list.md

```markdown
# Mock Data List

## Overview
| Category | Count | Files Affected |
|----------|-------|----------------|
| User Data | 5 | 3 |
| Metrics | 12 | 5 |
| Lists | 8 | 4 |

## User Data

### Current User
- **Location:** `app/page.tsx:17`, `components/layout/Header.tsx:24`
- **Current Value:** `"김호준"`
- **Suggested API:** `GET /api/users/me`
- **Type:** `User.name`

## Component Props to Wire

| Component | Prop | Current | Wire To |
|-----------|------|---------|---------|
| StatCard | value | hardcoded | API response |
| MiniCalendar | events | hardcoded array | API response |
| TimeClock | initialStatus | `"working"` | API response |

## Integration Priority

1. **High:** User data (affects personalization)
2. **High:** Metrics (affects dashboard accuracy)
3. **Medium:** Lists (affects data display)
4. **Low:** Static labels (rarely change)
```

---

## Reference Docs

| Topic | File |
|-------|------|
| Extraction Rules | [ref/extraction-rules.md](ref/extraction-rules.md) |
| Phase Details | [ref/phases.md](ref/phases.md) |
| Component Extraction | [ref/components.md](ref/components.md) |
| App Shell Pattern | [ref/app-shell.md](ref/app-shell.md) |
| Design System | [ref/design-system.md](ref/design-system.md) |
| Route Map | [ref/route-map.md](ref/route-map.md) |
| Output Structure | [ref/output-structure.md](ref/output-structure.md) |

---

## Verification Checklist

| Phase | Check | Required |
|-------|-------|----------|
| **Phase 0** | navigation-map.md created | YES |
| **Phase 1** | Classes unchanged from source | YES |
| **Phase 1** | No arbitrary modifications | YES |
| **Phase 2** | tokens.ts generated | YES |
| **Phase 3** | Shells use exact source classes | YES |
| **Phase 4** | Components from actual patterns | YES |
| **Phase 4** | No imagined components | YES |
| **Phase 5** | Structure matches source | YES |
| **Phase 6** | All routes substituted | YES |
| **Phase 7** | Pages scanned for mock data | YES |
| **Phase 7** | Components scanned for mock data | YES |
| **Final** | npm run dev succeeds | YES |
| **Final** | Visual match 95%+ | YES |

---

## Final Response Format

```
Done. Generated NextJS application:

Phase 0 - Route Discovery:
└── [N pages discovered]

Phase 1 - HTML Analysis:
└── All classes preserved from source

Phase 2 - Design Tokens:
└── [X colors, Y typography, Z spacing]

Phase 3 - App Shells:
└── [N shells for M personas]

Phase 4 - Components:
└── [K components from actual patterns]

Phase 5 - TSX Generation:
└── Substitutions applied

Phase 6 - Route Substitution:
└── [M links converted]

Phase 7 - Mock Data:
└── [X mock data items identified]

Running at http://localhost:3000

Verification:
- No speculation: PASS
- No imagination: PASS
- No code generation: PASS
- Classes match source: PASS
- Visual match: 95%+
```

---

## Error Handling

| Error | Recovery |
|-------|----------|
| Chrome MCP not available | Use file:// URL |
| Navigation fails (SPA) | Use evaluate_script |
| Assets 404 | Log warning, skip |
| Pattern not found | Do not create imaginary component |
| Ambiguous pattern | Document in candidates.md, do not guess |
