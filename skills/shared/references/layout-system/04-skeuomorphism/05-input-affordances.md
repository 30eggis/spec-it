# Input Affordances

입력 필드 상태별 Neumorphic 처리.

## States

| State | Shadow | Border | Background |
|-------|--------|--------|------------|
| Default | inset-md | none | #F0F0F0 |
| Focus | inset-md (deeper) | 2px blue-400 | #F0F0F0 |
| Error | inset-md | 2px red-400 | #F0F0F0 |
| Disabled | none | none | #E5E7EB |

## Implementation

```tsx
<input className="
  w-full bg-[#F0F0F0] rounded-xl px-4 py-3
  shadow-[inset_3px_3px_6px_#d1d1d1,inset_-3px_-3px_6px_#ffffff]
  focus:shadow-[inset_4px_4px_8px_#d1d1d1,inset_-4px_-4px_8px_#ffffff]
  focus:ring-2 focus:ring-blue-400
  border-none outline-none
  disabled:bg-gray-200 disabled:shadow-none
  transition-shadow duration-150
" />
```

## YAML Reference

```yaml
components:
  - type: input
    props:
      variant: neumorphic
    styles:
      background: "#F0F0F0"
      borderRadius: "12px"
      padding: "12px 16px"
      border: "none"
    states:
      default:
        shadow: "inset 3px 3px 6px #d1d1d1, inset -3px -3px 6px #ffffff"
      focus:
        shadow: "inset 4px 4px 8px #d1d1d1, inset -4px -4px 8px #ffffff"
        ring: "2px solid var(--blue-400)"
      error:
        shadow: "inset 3px 3px 6px #d1d1d1, inset -3px -3px 6px #ffffff"
        ring: "2px solid var(--red-400)"
      disabled:
        background: "#E5E7EB"
        shadow: "none"
    transitions:
      shadow: "150ms ease-out"
```

## Variants

### Text Input with Label

```tsx
<div className="space-y-2">
  <label className="text-sm font-medium text-gray-700">
    Email
  </label>
  <input
    type="email"
    className="
      w-full bg-[#F0F0F0] rounded-xl px-4 py-3
      shadow-[inset_3px_3px_6px_#d1d1d1,inset_-3px_-3px_6px_#ffffff]
      focus:shadow-[inset_4px_4px_8px_#d1d1d1,inset_-4px_-4px_8px_#ffffff]
      focus:ring-2 focus:ring-blue-400
      border-none outline-none
    "
    placeholder="Enter email"
  />
</div>
```

### Textarea

```tsx
<textarea className="
  w-full bg-[#F0F0F0] rounded-xl px-4 py-3
  shadow-[inset_3px_3px_6px_#d1d1d1,inset_-3px_-3px_6px_#ffffff]
  focus:shadow-[inset_4px_4px_8px_#d1d1d1,inset_-4px_-4px_8px_#ffffff]
  focus:ring-2 focus:ring-blue-400
  border-none outline-none resize-none
  min-h-[120px]
" />
```
