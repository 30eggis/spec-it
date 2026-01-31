# Shadow Levels

5단계 Elevation 그림자 시스템.

## CSS Variables

```css
/* Level 1: Subtle (inputs, flat cards) */
--shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);

/* Level 2: Default (cards, buttons) */
--shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.06);

/* Level 3: Raised (hover cards, focused inputs) */
--shadow-md: 0 4px 8px rgba(0, 0, 0, 0.08);

/* Level 4: Floating (dropdowns, popovers) */
--shadow-lg: 0 8px 16px rgba(0, 0, 0, 0.10);

/* Level 5: Modal (modals, dialogs) */
--shadow-xl: 0 16px 32px rgba(0, 0, 0, 0.12);
```

## Usage Map

| Component | Level | Shadow | Tailwind |
|-----------|-------|--------|----------|
| Input (default) | 1 | xs | `shadow-xs` |
| Button (default) | 2 | sm | `shadow-sm` |
| Card (default) | 2 | sm | `shadow-sm` |
| Card (hover) | 3 | md | `shadow-md` |
| Dropdown | 4 | lg | `shadow-lg` |
| Modal | 5 | xl | `shadow-xl` |

## YAML Reference

```yaml
designDirection:
  shadows:
    - level: xs
      value: "0 1px 2px rgba(0,0,0,0.04)"
      usage: "inputs, flat cards"
    - level: sm
      value: "0 2px 4px rgba(0,0,0,0.06)"
      usage: "cards, buttons"
    - level: md
      value: "0 4px 8px rgba(0,0,0,0.08)"
      usage: "hover cards, focused inputs"
    - level: lg
      value: "0 8px 16px rgba(0,0,0,0.10)"
      usage: "dropdowns, popovers"
    - level: xl
      value: "0 16px 32px rgba(0,0,0,0.12)"
      usage: "modals, dialogs"
```

## Tailwind Config

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      boxShadow: {
        'xs': '0 1px 2px rgba(0, 0, 0, 0.04)',
        'sm': '0 2px 4px rgba(0, 0, 0, 0.06)',
        'md': '0 4px 8px rgba(0, 0, 0, 0.08)',
        'lg': '0 8px 16px rgba(0, 0, 0, 0.10)',
        'xl': '0 16px 32px rgba(0, 0, 0, 0.12)',
      },
    },
  },
}
```
