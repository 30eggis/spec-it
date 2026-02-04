# CSS Layout Extraction Reference

Chrome MCP를 통한 CSS 레이아웃 정보 추출 방법.

> **관련 문서**: Layout 해석 규칙은 `shared/references/common/rules/07-layout-extraction-rules.md` 참조

---

## 1. CSS Layout Extraction Script (MANDATORY)

**CRITICAL**: a11y tree does NOT contain CSS layout info. You MUST run this script:

```javascript
// evaluate_script() - Extract Grid/Flex Layout
() => {
  const layouts = [];
  document.querySelectorAll('*').forEach(el => {
    const style = window.getComputedStyle(el);
    const display = style.display;

    if (display === 'grid' || display === 'flex') {
      const classes = el.className;
      layouts.push({
        // Element identification
        tag: el.tagName,
        id: el.id,
        classes: typeof classes === 'string' ? classes : '',
        textPreview: el.textContent?.slice(0, 30)?.trim(),
        childCount: el.children.length,

        // Grid properties
        display: display,
        gridTemplateColumns: style.gridTemplateColumns,
        gridTemplateRows: style.gridTemplateRows,

        // Flex properties
        flexDirection: style.flexDirection,
        justifyContent: style.justifyContent,
        alignItems: style.alignItems,

        // Spacing
        gap: style.gap,
        padding: style.padding,
        margin: style.margin
      });
    }
  });
  return layouts;
}
```

---

## 2. Interpreting Script Results

From the script output, extract:

| CSS Property | Tailwind Source | YAML Output |
|--------------|-----------------|-------------|
| `gridTemplateColumns: "Xpx Xpx"` (equal) | `grid-cols-2` | `columns: 2, ratio: "1:1"` |
| `gridTemplateColumns: "Xpx Xpx Xpx"` (equal) | `grid-cols-3` | `columns: 3, ratio: "1:1:1"` |
| `justifyContent: "flex-end"` | `justify-end` | `justify: "end"` |
| `justifyContent: "space-between"` | `justify-between` | `justify: "between"` |
| `flexDirection: "column"` | `flex-col` | `direction: "column"` |
| `display: "block"` | (default) | `direction: "column"` (implicit) |

**Example interpretation:**
```
# Script output:
{ gridTemplateColumns: "594px 594px", childCount: 2, textPreview: "휴가 현황..." }

# Interpretation:
- 2 equal columns (594px each) → grid-cols-2
- YAML: columns: 2, ratio: "1:1"
```

---

## 3. Website Analysis Flow

```
FOR each HTML file:
  1. navigate_page(url)
  2. take_snapshot() → collect a11y tree (component structure)
  3. evaluate_script() → extract CSS layout info (CRITICAL!)
  4. Extract:
     - Screen title, route
     - Layout structure (sidebar, header, main)
     - All components (buttons, inputs, tables, cards, charts)
     - Interactions (clicks, filters, forms)
     - Status indicators (badges, tags, progress)
  5. Merge a11y tree + CSS layout → Save analysis to JSON
```

---

## 4. Codebase Analysis Flow (Fallback)

Use this when:
- Website analysis fails
- User provides local project path
- Source is a code repository

```
1. Identify project type:
   - Next.js: app/, pages/ directory
   - React: src/components/, src/pages/
   - Vue: src/views/, src/components/
   - HTML: *.html files

2. Glob for pages/routes:
   - pages/**/*.{tsx,jsx,vue,html}
   - app/**/page.{tsx,jsx}

3. For each page file:
   - Read file content
   - Extract component imports
   - Parse JSX/HTML structure
   - Identify layout patterns (grid, flex)
   - Extract props, states, events
   - Map component dependencies

4. Build screen inventory from discovered pages

5. If HTML files found:
   - Parse DOM structure directly
   - Extract class names for styling info
   - Map to component patterns
```

---

## 5. Fallback Logic

```
Website Analysis (Primary)
         │
         ▼
    ┌─────────┐
    │ Chrome  │──── Success ───▶ Continue
    │   MCP   │
    └────┬────┘
         │
      Failure
         │
         ▼
    ┌─────────┐
    │  Code   │──── Success ───▶ Continue
    │ Analysis│
    └────┬────┘
         │
      Failure
         │
         ▼
    ┌─────────┐
    │  ERROR  │──── Ask user for alternative source
    └─────────┘
```

**If Chrome MCP fails:**
1. Check if local HTML/code files exist at the source path
2. If yes, switch to Code Analysis mode
3. If no, report error and ask user for valid source

---

## 6. Design Context Integration

```
IF design context provided:
  1. Load design tokens from provided path
  2. Build token-to-CSS mapping
  3. During component extraction:
     - Match colors to color tokens
     - Match spacing to spacing tokens
     - Match typography to font tokens
     - Match borders/shadows to effect tokens
  4. Store token references for wireframe generation
```

**Example with design context:**
```yaml
# Without design context
styles:
  background: "bg-blue-600"
  padding: "p-6"

# With design context (more accurate)
styles:
  background: "_ref:color.semantic.bg.brand.primary"
  padding: "_ref:spacing.24"
```
