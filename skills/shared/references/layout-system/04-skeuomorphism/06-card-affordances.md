# Card Affordances

카드 컴포넌트 변형.

## Variants

### 1. Flat Card (Default)

```tsx
<div className="
  bg-white rounded-2xl p-6
  border border-gray-100
  shadow-sm
">
  Content
</div>
```

### 2. Elevated Card (Hover/Focus)

```tsx
<div className="
  bg-white rounded-2xl p-6
  border border-gray-100
  shadow-md
  hover:shadow-lg hover:-translate-y-1
  transition-all duration-200
">
  Content
</div>
```

### 3. Neumorphic Card (Special)

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
components:
  - type: card
    props:
      variant: flat  # flat | elevated | neumorphic
    variants:
      flat:
        background: "white"
        borderRadius: "16px"
        padding: "24px"
        border: "1px solid var(--gray-100)"
        shadow: "var(--shadow-sm)"

      elevated:
        background: "white"
        borderRadius: "16px"
        padding: "24px"
        border: "1px solid var(--gray-100)"
        shadow: "var(--shadow-md)"
        hover:
          shadow: "var(--shadow-lg)"
          transform: "translateY(-4px)"
        transition: "all 200ms ease-out"

      neumorphic:
        background: "#F0F0F0"
        borderRadius: "16px"
        padding: "24px"
        shadow: "8px 8px 16px #d1d1d1, -8px -8px 16px #ffffff"
```

## Usage Examples

### Stats Card

```tsx
<Card variant="flat" className="flex items-center gap-4">
  <div className="p-3 bg-blue-100 rounded-xl">
    <ClockIcon className="w-6 h-6 text-blue-600" />
  </div>
  <div>
    <p className="text-sm text-gray-500">Today</p>
    <p className="text-2xl font-semibold">8h 30m</p>
  </div>
</Card>
```

### Interactive Card

```tsx
<Card
  variant="elevated"
  className="cursor-pointer"
  onClick={handleClick}
>
  <h3 className="font-semibold">Request Leave</h3>
  <p className="text-gray-500 text-sm mt-1">
    Submit a new leave request
  </p>
</Card>
```

### Neumorphic Feature Card

```tsx
<Card variant="neumorphic" className="text-center">
  <div className="mx-auto w-16 h-16 bg-blue-500 rounded-2xl flex items-center justify-center mb-4">
    <Icon className="w-8 h-8 text-white" />
  </div>
  <h3 className="font-semibold">Feature Title</h3>
  <p className="text-gray-500 text-sm mt-2">Description</p>
</Card>
```
