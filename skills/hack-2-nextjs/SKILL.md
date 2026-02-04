---
name: hack-2-nextjs
description: |
  Extract design tokens, assets, and components from existing React-based UI.
  Goal: Code reuse + design system standardization.
  Supports: URLs, local HTML files (React/Next.js based)
  Arguments: --source (path or url), --scope (single or all)
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion, mcp__chrome-devtools__*, mcp__plugin_spec-it_chrome-devtools__*
bypassPermissions: true
---

# Hack 2 NextJS

Extract design tokens, assets, and components from existing React-based UI for reuse.

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| source | Yes | - | URL or local HTML file path |
| scope | No | all | `single` = one screen, `all` = all linked screens |

## Output Structure

```
hack-2-nextjs/
├── navigation-map.md
├── extracted/{page-id}/
│   ├── source.tsx
│   ├── styles.css
│   ├── computed.json
│   ├── assets.json
│   └── metadata.json
├── assets/
│   ├── images/
│   ├── fonts/
│   ├── icons/
│   └── asset-manifest.json
├── design-system/
│   ├── tokens.ts
│   ├── tokens.css
│   ├── tailwind.config.ts
│   └── design-tokens.md
├── components/
│   ├── layout/
│   └── ui/
├── component-catalog.md
└── nextjs-scaffold/
    ├── app/
    ├── public/
    ├── components/
    └── package.json
```

## Phase 1: Extraction

> Reference: `shared/references/hack-2-nextjs/extraction.md`

### 1.1 Source Detection

```javascript
evaluate_script({
  function: `() => ({
    isReact: !!window.__REACT_DEVTOOLS_GLOBAL_HOOK__,
    isNextJS: !!window.__NEXT_DATA__
  })`
})
```

### 1.2 Style Extraction

Extract computed styles from all elements. Collect colors, typography, spacing, shadows, border-radius with frequency counts.

### 1.3 Asset Extraction

Extract all referenced assets preserving original paths:
- Images: `<img src>`, `background-image`
- SVGs: inline and external
- Fonts: from `@font-face` rules
- Other: video, audio sources

Save to `assets/` maintaining directory structure. Generate `asset-manifest.json`.

### 1.4 Output

Per page: `source.tsx`, `styles.css`, `computed.json`, `assets.json`, `metadata.json`

## Phase 2: Design Tokens

> Reference: `shared/references/hack-2-nextjs/tokens.md`

Aggregate all `computed.json` files. Map to semantic tokens by frequency.

Output files:
- `tokens.ts` - TypeScript constants
- `tokens.css` - CSS variables
- `tailwind.config.ts` - Tailwind extension
- `design-tokens.md` - Documentation

## Phase 3: Component Analysis

> Reference: `shared/references/hack-2-nextjs/components.md`

Analyze `source.tsx` files for repeating patterns. Score candidates:
- 3+ pages: +3
- 2+ same page: +2
- Clear role: +2
- Independent styling: +1
- Props extractable: +1

Score >= 5: Extract as component.

## Phase 4: Component Catalog

Create components with token classes applied. Generate `component-catalog.md` with replacement map.

## Phase 5: NextJS Scaffold

Create project with:
- Design tokens globally applied via `globals.css`
- Assets copied to `public/` preserving paths
- Components linked
- Ready to run with `npm install && npm run dev`

## Verification

| Phase | Check |
|-------|-------|
| 1 | All pages extracted |
| 1 | All assets downloaded with paths preserved |
| 1 | asset-manifest.json generated |
| 2 | tokens.ts, tokens.css, tailwind.config.ts generated |
| 3 | Component candidates scored |
| 4 | Components use token classes |
| 5 | Assets in public/ work without code changes |
| 5 | npm install succeeds |

## Error Handling

| Error | Recovery |
|-------|----------|
| Not React-based | Fallback to HTML parsing |
| Chrome MCP unavailable | Use file:// URL |
| CSS CORS error | Parse inline styles only |
| Asset 404/CORS | Log warning, skip |
| Large asset (>5MB) | Skip, record URL only |
