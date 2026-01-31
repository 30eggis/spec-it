# Surface Elevation

Z-index 계층 및 배경색 정의.

## Z-index Hierarchy

| Layer | Z-Index | Usage |
|-------|---------|-------|
| Base | 0 | Page background |
| Surface | 1 | Cards, panels |
| Sticky | 10 | Sticky headers |
| Dropdown | 20 | Dropdowns, popovers |
| Overlay | 30 | Modal backdrops |
| Modal | 40 | Modals, dialogs |
| Tooltip | 50 | Tooltips, toast |

## Background Colors by Elevation

### Light Theme

| Level | Color | Usage |
|-------|-------|-------|
| 0 | #F5F7FA | Page background |
| 1 | #FFFFFF | Cards, panels |
| 2 | #FFFFFF | Raised elements |
| 3 | #FFFFFF | Dropdowns |
| 4 | #FFFFFF | Modals |

### Dark Theme (Future)

| Level | Color | Tailwind |
|-------|-------|----------|
| 0 | #111827 | gray-900 |
| 1 | #1F2937 | gray-800 |
| 2 | #374151 | gray-700 |
| 3 | #4B5563 | gray-600 |
| 4 | #6B7280 | gray-500 |

## CSS Variables

```css
:root {
  /* Z-index */
  --z-base: 0;
  --z-surface: 1;
  --z-sticky: 10;
  --z-dropdown: 20;
  --z-overlay: 30;
  --z-modal: 40;
  --z-tooltip: 50;

  /* Light theme backgrounds */
  --bg-page: #F5F7FA;
  --bg-surface: #FFFFFF;
  --bg-elevated: #FFFFFF;
}
```

## YAML Reference

```yaml
designDirection:
  elevation:
    zIndex:
      base: 0
      surface: 1
      sticky: 10
      dropdown: 20
      overlay: 30
      modal: 40
      tooltip: 50
    backgrounds:
      light:
        page: "#F5F7FA"
        surface: "#FFFFFF"
      dark:
        page: "#111827"
        surface: "#1F2937"
```

## Tailwind Config

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      zIndex: {
        'base': '0',
        'surface': '1',
        'sticky': '10',
        'dropdown': '20',
        'overlay': '30',
        'modal': '40',
        'tooltip': '50',
      },
    },
  },
}
```
