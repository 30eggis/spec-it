# Transition Durations

트랜지션 지속 시간 정의.

## Standard Durations

| Name | Duration | Usage |
|------|----------|-------|
| fast | 150ms | Micro-interactions (hover, focus) |
| base | 200ms | Standard transitions |
| slow | 300ms | Complex animations |
| slower | 500ms | Page transitions |

## CSS Variables

```css
--duration-fast: 150ms;
--duration-base: 200ms;
--duration-slow: 300ms;
--duration-slower: 500ms;
```

## Tailwind Classes

| Class | Duration |
|-------|----------|
| `duration-150` | 150ms |
| `duration-200` | 200ms |
| `duration-300` | 300ms |
| `duration-500` | 500ms |

## Usage Guidelines

| Interaction | Duration | Example |
|-------------|----------|---------|
| Button hover | 150ms | Color change |
| Input focus | 150ms | Border/shadow |
| Card hover | 200ms | Shadow + lift |
| Dropdown open | 200ms | Scale + opacity |
| Modal open | 300ms | Scale + fade |
| Page transition | 500ms | Route change |

## YAML Reference

```yaml
designDirection:
  animation:
    durations:
      fast: "150ms"
      base: "200ms"
      slow: "300ms"
      slower: "500ms"
    usage:
      hover: "fast"
      focus: "fast"
      cardHover: "base"
      dropdown: "base"
      modal: "slow"
      page: "slower"
```
