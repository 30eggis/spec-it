# Button Affordances

버튼 상태별 Neumorphic 처리.

## States

| State | Shadow | Transform | Opacity |
|-------|--------|-----------|---------|
| Default | raised-md | none | 1 |
| Hover | raised-md (brighter) | translateY(-1px) | 1 |
| Active | pressed-md | translateY(1px) | 1 |
| Disabled | none | none | 0.5 |

## Implementation

```tsx
<button className="
  bg-[#F0F0F0] rounded-xl px-6 py-3
  shadow-[6px_6px_12px_#d1d1d1,-6px_-6px_12px_#ffffff]
  hover:shadow-[4px_4px_8px_#d1d1d1,-4px_-4px_8px_#ffffff]
  hover:-translate-y-0.5
  active:shadow-[inset_4px_4px_8px_#d1d1d1,inset_-4px_-4px_8px_#ffffff]
  active:translate-y-0.5
  disabled:shadow-none disabled:opacity-50
  transition-all duration-150
">
  Button
</button>
```

## YAML Reference

```yaml
components:
  - type: button
    props:
      variant: neumorphic
    styles:
      background: "#F0F0F0"
      borderRadius: "12px"
      padding: "12px 24px"
    states:
      default:
        shadow: "6px 6px 12px #d1d1d1, -6px -6px 12px #ffffff"
      hover:
        shadow: "4px 4px 8px #d1d1d1, -4px -4px 8px #ffffff"
        transform: "translateY(-2px)"
      active:
        shadow: "inset 4px 4px 8px #d1d1d1, inset -4px -4px 8px #ffffff"
        transform: "translateY(2px)"
      disabled:
        shadow: "none"
        opacity: 0.5
    transitions:
      all: "150ms ease-out"
```

## Variants

### Primary Button

```tsx
<button className="
  bg-blue-600 text-white rounded-xl px-6 py-3
  shadow-[0_4px_14px_rgba(37,99,235,0.4)]
  hover:shadow-[0_6px_20px_rgba(37,99,235,0.5)]
  hover:-translate-y-0.5
  active:shadow-[0_2px_8px_rgba(37,99,235,0.4)]
  active:translate-y-0.5
  transition-all duration-150
">
  Primary
</button>
```

### Ghost Button

```tsx
<button className="
  bg-transparent rounded-xl px-6 py-3
  hover:bg-gray-100
  active:bg-gray-200
  transition-all duration-150
">
  Ghost
</button>
```
