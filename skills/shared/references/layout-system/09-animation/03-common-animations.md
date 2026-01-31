# Common Animations

공통 애니메이션 패턴.

## Button Press

```tsx
<button className="
  transition-all duration-150
  hover:-translate-y-0.5 hover:shadow-lg
  active:translate-y-0.5 active:shadow-sm
">
  Click Me
</button>
```

## Card Hover

```tsx
<div className="
  transition-all duration-200
  hover:-translate-y-1 hover:shadow-xl
">
  Card Content
</div>
```

## Modal Enter/Exit

```tsx
// Framer Motion
<motion.div
  initial={{ opacity: 0, scale: 0.95 }}
  animate={{ opacity: 1, scale: 1 }}
  exit={{ opacity: 0, scale: 0.95 }}
  transition={{ duration: 0.2 }}
>
  Modal Content
</motion.div>

// Backdrop
<motion.div
  initial={{ opacity: 0 }}
  animate={{ opacity: 1 }}
  exit={{ opacity: 0 }}
  className="fixed inset-0 bg-black/50"
/>
```

## Dropdown

```tsx
<motion.div
  initial={{ opacity: 0, y: -8 }}
  animate={{ opacity: 1, y: 0 }}
  exit={{ opacity: 0, y: -8 }}
  transition={{ duration: 0.15 }}
>
  Dropdown Content
</motion.div>
```

## Toast Notification

```tsx
<motion.div
  initial={{ opacity: 0, x: 100 }}
  animate={{ opacity: 1, x: 0 }}
  exit={{ opacity: 0, x: 100 }}
  transition={{ type: "spring", stiffness: 500, damping: 30 }}
>
  Toast Content
</motion.div>
```

## Skeleton Loading

```tsx
<div className="
  animate-pulse
  bg-gray-200 rounded
  h-4 w-3/4
" />
```

## Spinner

```tsx
<div className="
  animate-spin
  rounded-full
  h-8 w-8
  border-2 border-gray-300
  border-t-blue-600
" />
```

## YAML Reference

```yaml
designDirection:
  animations:
    buttonPress:
      hover:
        transform: "translateY(-2px)"
        shadow: "lg"
      active:
        transform: "translateY(2px)"
        shadow: "sm"
      duration: "150ms"

    cardHover:
      hover:
        transform: "translateY(-4px)"
        shadow: "xl"
      duration: "200ms"

    modal:
      enter:
        from: { opacity: 0, scale: 0.95 }
        to: { opacity: 1, scale: 1 }
      exit:
        from: { opacity: 1, scale: 1 }
        to: { opacity: 0, scale: 0.95 }
      duration: "200ms"

    dropdown:
      enter:
        from: { opacity: 0, y: -8 }
        to: { opacity: 1, y: 0 }
      duration: "150ms"
```
