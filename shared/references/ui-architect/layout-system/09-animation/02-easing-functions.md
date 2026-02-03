# Easing Functions

이징 함수 정의.

## Tailwind Easing

| Name | Cubic Bezier | Usage |
|------|--------------|-------|
| linear | linear | Progress bars |
| ease-in | cubic-bezier(0.4, 0, 1, 1) | Exit animations |
| ease-out | cubic-bezier(0, 0, 0.2, 1) | Enter animations |
| ease-in-out | cubic-bezier(0.4, 0, 0.2, 1) | Continuous animations |

## CSS Variables

```css
--ease-linear: linear;
--ease-in: cubic-bezier(0.4, 0, 1, 1);
--ease-out: cubic-bezier(0, 0, 0.2, 1);
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
```

## Usage Guidelines

| Animation Type | Easing | Why |
|----------------|--------|-----|
| Element appears | ease-out | Starts fast, slows down (feels responsive) |
| Element disappears | ease-in | Starts slow, speeds up (feels natural) |
| Element moves | ease-in-out | Smooth throughout |
| Progress indicator | linear | Constant rate |

## Examples

```tsx
// Button hover (ease-out)
<button className="transition-all duration-150 ease-out hover:bg-blue-600">
  Button
</button>

// Modal enter (ease-out)
<motion.div
  initial={{ opacity: 0, scale: 0.95 }}
  animate={{ opacity: 1, scale: 1 }}
  transition={{ duration: 0.2, ease: [0, 0, 0.2, 1] }}
>
  Modal
</motion.div>

// Modal exit (ease-in)
<motion.div
  exit={{ opacity: 0, scale: 0.95 }}
  transition={{ duration: 0.15, ease: [0.4, 0, 1, 1] }}
>
  Modal
</motion.div>
```

## YAML Reference

```yaml
designDirection:
  animation:
    easing:
      linear: "linear"
      easeIn: "cubic-bezier(0.4, 0, 1, 1)"
      easeOut: "cubic-bezier(0, 0, 0.2, 1)"
      easeInOut: "cubic-bezier(0.4, 0, 0.2, 1)"
    usage:
      enter: "easeOut"
      exit: "easeIn"
      continuous: "easeInOut"
      progress: "linear"
```
