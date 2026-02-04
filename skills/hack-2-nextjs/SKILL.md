---
name: hack-2-nextjs
description: |
  Copy existing UI to NextJS. LITERAL COPY - no interpretation.
  Extract exact HTML/CSS/Assets and convert to NextJS project.
  Arguments: --source (path or url), --scope (single or all)
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion, mcp__chrome-devtools__*, mcp__plugin_spec-it_chrome-devtools__*
bypassPermissions: true
---

# Hack 2 NextJS

LITERAL COPY of existing UI to NextJS. No interpretation. No improvement. Just copy.

## CRITICAL RULES

```
❌ NEVER:
- Interpret or "improve" the design
- Change layout structure
- Add components that don't exist
- Remove components that exist
- Change colors, spacing, typography
- Reorganize sections
- "Optimize" anything

✅ ONLY:
- Copy outerHTML exactly
- Convert HTML syntax to JSX syntax
- Download assets preserving paths
- Extract CSS as-is
```

## Allowed JSX Conversions (ONLY THESE)

| HTML | JSX |
|------|-----|
| `class=""` | `className=""` |
| `for=""` | `htmlFor=""` |
| `<img>` | `<img />` |
| `<input>` | `<input />` |
| `<br>` | `<br />` |
| `onclick=""` | Remove (add later) |
| `style="a:b"` | `style={{a:'b'}}` |
| `tabindex` | `tabIndex` |
| `colspan` | `colSpan` |

**NOTHING ELSE CHANGES.**

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| source | Yes | URL or local HTML file path |
| scope | No | `single` or `all` (default: all) |

## Output

```
hack-2-nextjs/
├── pages/
│   ├── {page-id}.tsx      # Exact copy of each page
│   └── ...
├── assets/                 # All assets, paths preserved
├── styles/
│   └── globals.css         # Extracted CSS as-is
└── nextjs-app/
    ├── app/
    │   ├── page.tsx
    │   └── globals.css
    ├── public/             # Assets copied
    └── package.json
```

## Phase 1: Extract Exact HTML

```javascript
// Get EXACT outerHTML - no modifications
evaluate_script({
  function: `() => {
    return {
      html: document.documentElement.outerHTML,
      title: document.title
    };
  }`
})
```

Save raw HTML to `pages/{page-id}.html`.

## Phase 2: Extract Exact CSS

```javascript
// Get ALL stylesheets exactly as-is
evaluate_script({
  function: `() => {
    const css = [];

    // Embedded styles
    document.querySelectorAll('style').forEach(s => {
      css.push(s.textContent);
    });

    return css.join('\\n');
  }`
})
```

For external CSS files, download them directly:
```bash
curl -o styles/{filename}.css {css_url}
```

## Phase 3: Download All Assets

```javascript
evaluate_script({
  function: `() => {
    const assets = [];

    // Images
    document.querySelectorAll('img').forEach(img => {
      if (img.src) assets.push({ type: 'image', src: img.src, path: new URL(img.src).pathname });
    });

    // Background images
    document.querySelectorAll('*').forEach(el => {
      const bg = getComputedStyle(el).backgroundImage;
      if (bg && bg.includes('url(')) {
        const match = bg.match(/url\\(["']?([^"')]+)["']?\\)/);
        if (match) assets.push({ type: 'image', src: match[1], path: new URL(match[1], location.href).pathname });
      }
    });

    // SVGs, fonts, etc.
    document.querySelectorAll('img[src$=".svg"]').forEach(el => {
      assets.push({ type: 'svg', src: el.src, path: new URL(el.src).pathname });
    });

    return assets;
  }`
})
```

Download preserving exact paths:
```bash
# Original: /images/logo.png
# Save to: assets/images/logo.png
mkdir -p "assets$(dirname $path)"
curl -o "assets$path" "$src"
```

## Phase 4: Convert to JSX (Syntax Only)

Use simple regex replacements:

```bash
# class → className
sed 's/class="/className="/g'

# Self-closing tags
sed 's/<img([^>]*)>/<img\1 \/>/g'
sed 's/<input([^>]*)>/<input\1 \/>/g'
sed 's/<br>/<br \/>/g'

# for → htmlFor
sed 's/ for="/ htmlFor="/g'

# Remove onclick (will wire navigation later)
sed 's/ onclick="[^"]*"//g'
```

**DO NOT change any class names, structure, or content.**

## Phase 5: Create NextJS Project

```bash
mkdir -p nextjs-app/{app,public}

# Copy assets to public (preserving paths)
cp -r assets/* nextjs-app/public/

# Copy CSS
cp styles/*.css nextjs-app/app/

# Create page.tsx from converted JSX
# Just wrap in export default function
```

**page.tsx template:**
```tsx
import './globals.css';

export default function Page() {
  return (
    <>
      {/* PASTE EXACT JSX HERE - NO CHANGES */}
    </>
  );
}
```

## Verification

After `npm run dev`:

1. Open original and generated side by side
2. They MUST look identical
3. If ANY difference exists → FIX IT by copying more exactly

| Check | Required |
|-------|----------|
| Same layout | ✓ |
| Same colors | ✓ |
| Same spacing | ✓ |
| Same fonts | ✓ |
| Same components | ✓ |
| Same content | ✓ |
| All images load | ✓ |

## Error Recovery

| Issue | Fix |
|-------|-----|
| Asset 404 | Check path, copy from source |
| Style missing | Copy more CSS |
| Layout different | You changed something - revert |
| Component missing | Copy from original |
