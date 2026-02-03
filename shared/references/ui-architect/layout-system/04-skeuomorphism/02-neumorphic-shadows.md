# Neumorphic Shadows

Light Theme Neumorphic 그림자 정의.

## CSS Variables

```css
/* Raised (default state) */
--neo-raised-sm: 4px 4px 8px #d1d1d1, -4px -4px 8px #ffffff;
--neo-raised-md: 6px 6px 12px #d1d1d1, -6px -6px 12px #ffffff;
--neo-raised-lg: 8px 8px 16px #d1d1d1, -8px -8px 16px #ffffff;

/* Pressed (active state) */
--neo-pressed-sm: inset 2px 2px 4px #d1d1d1, inset -2px -2px 4px #ffffff;
--neo-pressed-md: inset 4px 4px 8px #d1d1d1, inset -4px -4px 8px #ffffff;
--neo-pressed-lg: inset 6px 6px 12px #d1d1d1, inset -6px -6px 12px #ffffff;

/* Input (inset state) */
--neo-inset-sm: inset 2px 2px 4px #d1d1d1, inset -2px -2px 4px #ffffff;
--neo-inset-md: inset 3px 3px 6px #d1d1d1, inset -3px -3px 6px #ffffff;
--neo-inset-lg: inset 4px 4px 8px #d1d1d1, inset -4px -4px 8px #ffffff;
```

## Background Color

```css
/* CRITICAL: Must use this specific gray for neumorphic effect */
--neo-bg: #F0F0F0; /* Gray-100 equivalent */
```

## Component Examples

### Neumorphic Button (Raised)

```tsx
<button className="
  bg-[#F0F0F0] rounded-xl px-6 py-3
  shadow-[6px_6px_12px_#d1d1d1,-6px_-6px_12px_#ffffff]
  active:shadow-[inset_4px_4px_8px_#d1d1d1,inset_-4px_-4px_8px_#ffffff]
  transition-shadow duration-150
">
  Click Me
</button>
```

### Neumorphic Input (Inset)

```tsx
<input className="
  bg-[#F0F0F0] rounded-lg px-4 py-2
  shadow-[inset_3px_3px_6px_#d1d1d1,inset_-3px_-3px_6px_#ffffff]
  focus:shadow-[inset_4px_4px_8px_#d1d1d1,inset_-4px_-4px_8px_#ffffff]
  border-none outline-none
" />
```

### Neumorphic Card (Subtle Raised)

```tsx
<div className="
  bg-[#F0F0F0] rounded-2xl p-6
  shadow-[8px_8px_16px_#d1d1d1,-8px_-8px_16px_#ffffff]
">
  Content
</div>
```

## YAML Reference

```yaml
designDirection:
  neumorphic:
    background: "#F0F0F0"
    raised:
      sm: "4px 4px 8px #d1d1d1, -4px -4px 8px #ffffff"
      md: "6px 6px 12px #d1d1d1, -6px -6px 12px #ffffff"
      lg: "8px 8px 16px #d1d1d1, -8px -8px 16px #ffffff"
    pressed:
      sm: "inset 2px 2px 4px #d1d1d1, inset -2px -2px 4px #ffffff"
      md: "inset 4px 4px 8px #d1d1d1, inset -4px -4px 8px #ffffff"
    inset:
      sm: "inset 2px 2px 4px #d1d1d1, inset -2px -2px 4px #ffffff"
      md: "inset 3px 3px 6px #d1d1d1, inset -3px -3px 6px #ffffff"
```
