# Execution Phases

## Phase 1: Source Extraction

Extract raw HTML, CSS, and assets from source.

### 1.1 Navigate and Capture

```javascript
// Chrome MCP: Navigate to source
navigate_page({ url: SOURCE_URL, type: 'url' })

// Capture full page snapshot
take_snapshot({ verbose: true })
take_screenshot({ fullPage: true })
```

### 1.2 Extract DOM Structure

```javascript
evaluate_script({
  function: `() => {
    const extractElement = (el, depth = 0) => ({
      tag: el.tagName?.toLowerCase(),
      classes: Array.from(el.classList || []),
      id: el.id || null,
      text: el.childNodes.length === 1 && el.childNodes[0].nodeType === 3
            ? el.textContent.trim().slice(0, 50) : null,
      styles: getComputedStyle(el),
      children: Array.from(el.children).map(c => extractElement(c, depth + 1)),
      depth
    });
    return extractElement(document.body);
  }`
})
```

### 1.3 Extract Assets

```javascript
evaluate_script({
  function: `() => {
    const assets = [];
    document.querySelectorAll('img, svg, [style*="background"]').forEach(el => {
      // extract src, paths
    });
    return assets;
  }`
})
```

---

## Phase 2: Pattern Analysis

Identify repeated patterns and potential components.

### 2.1 Detect Repeated Structures

```
Algorithm:
1. Hash each subtree by structure (tag + class pattern)
2. Group similar hashes
3. If count >= 2 → candidate component
4. Calculate similarity score for near-matches
```

### 2.2 Similarity Scoring

```json
{
  "pattern_id": "card-stat",
  "occurrences": 5,
  "similarity": 0.92,
  "variations": [
    { "field": "icon", "values": ["Home", "Clock", "Users"] },
    { "field": "color", "values": ["green", "amber", "red"] },
    { "field": "label", "values": ["출근", "지각", "미출근"] }
  ]
}
```

### 2.3 Component Classification

| Category | Criteria | Examples |
|----------|----------|----------|
| `ui` | Generic, 3+ uses | Button, Card, Modal, Input |
| `layout` | Page structure | Sidebar, Header, AppShell |
| `widget` | Dashboard specific | StatCard, TimeClock, Calendar |
| `icon` | SVG icons | All inline SVGs |

---

## Phase 3: Component Extraction

See [components.md](./components.md)

---

## Phase 4: App Shell Definition

See [app-shell.md](./app-shell.md)

---

## Phase 5: Design System Extraction

See [design-system.md](./design-system.md)

---

## Phase 6: Route Map Generation

See [route-map.md](./route-map.md)

---

## Execution Flow

```
Phase 1: Extract
  navigate_page → take_snapshot → extract DOM/CSS/Assets
                    ↓
Phase 2: Analyze
  detect patterns → calculate similarity → classify
                    ↓
Phase 3: Components
  for each pattern → extract props → generate file
                    ↓
Phase 4: App Shells
  detect personas → extract nav → generate AppShell
                    ↓
Phase 5: Design System
  extract tokens → create tokens.json → switcher
                    ↓
Phase 6: Route Map
  analyze routes → map shells/components → route_map.json
                    ↓
Verify
  npm run dev → compare → iterate if needed
```
