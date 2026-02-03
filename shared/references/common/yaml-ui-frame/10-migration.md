# Migration

ASCII art에서 YAML로 마이그레이션.

**Legacy Notice:** 기존 ASCII 문서 변환용이며 신규 ASCII 와이어프레임 생성은 금지.

## Element Mapping

### Containers

| ASCII art | YAML |
|-----------|------|
| `┌─────┐` | `type: "Card"` |
| `│ Box │` | `props: { content: "Box" }` |
| `└─────┘` | - |
| `╔═════╗` | `type: "Modal"` |
| `║     ║` | `props: { ... }` |
| `╚═════╝` | - |

### Inputs

| ASCII art | YAML |
|-----------|------|
| `[ Email ]` | `type: "Input", props: { placeholder: "Email" }` |
| `[Button]` | `type: "Button", props: { text: "Button" }` |
| `[x] Checked` | `type: "Checkbox", props: { checked: true }` |
| `[ ] Unchecked` | `type: "Checkbox", props: { checked: false }` |
| `(●) Selected` | `type: "Radio", props: { checked: true }` |
| `( ) Unselected` | `type: "Radio", props: { checked: false }` |
| `[Select ▼]` | `type: "Select", props: { ... }` |

### Layout

| ASCII art | YAML |
|-----------|------|
| `┌────┬────┐` | `grid.areas: "left right"` |
| `│ L  │ R  │` | `grid.columns: "1fr 1fr"` |
| `└────┴────┘` | - |

### Icons

| ASCII art | YAML |
|-----------|------|
| `[≡]` | `icon: "Menu"` |
| `[X]` | `icon: "X"` |
| `[+]` | `icon: "Plus"` |
| `[🔍]` | `icon: "Search"` |
| `[🔔]` | `icon: "Bell"` |
| `[⚙️]` | `icon: "Settings"` |
| `[👤]` | `icon: "User"` |

## Layout Conversion

### Before (ASCII)

```
┌─────────────────────────────────────────┐
│ [Logo]              [Nav] [Nav] [User]  │
├────────┬────────────────────────────────┤
│        │                                │
│ Side   │         Main Content           │
│ bar    │                                │
│        │                                │
└────────┴────────────────────────────────┘
```

### After (YAML)

```yaml
layout:
  type: "sidebar-main"
  header:
    height: "64px"
  sidebar:
    position: "left"
    width: "200px"

grid:
  desktop:
    columns: "200px 1fr"
    rows: "64px 1fr"
    areas: |
      "header header"
      "sidebar main"

components:
  - id: "header"
    type: "AppHeader"
    gridArea: "header"
    children:
      - { type: "Logo" }
      - { type: "Nav", items: ["Nav", "Nav"] }
      - { type: "UserMenu" }

  - id: "sidebar"
    type: "Sidebar"
    gridArea: "sidebar"

  - id: "main"
    type: "MainContent"
    gridArea: "main"
```

## Component Conversion

### Before (ASCII Card)

```
┌─────────────────────────┐
│ ┌───────┐               │
│ │ Image │  Title        │
│ └───────┘               │
│                         │
│ Description text here   │
│                         │
│              [Action]   │
└─────────────────────────┘
```

### After (YAML Card)

```yaml
- id: "product-card"
  type: "Card"
  props:
    variant: "elevated"
  children:
    - id: "card-image"
      type: "Image"
      props:
        src: "..."
        alt: "Product"

    - id: "card-title"
      type: "Heading"
      props:
        level: 3
        text: "Title"

    - id: "card-description"
      type: "Text"
      props:
        text: "Description text here"

    - id: "card-action"
      type: "Button"
      props:
        text: "Action"
        align: "right"
```

## Tips

1. **구조 먼저**: 전체 grid 구조를 먼저 정의
2. **영역 분리**: header, sidebar, main, footer 영역 명확히
3. **컴포넌트 분해**: 큰 영역을 작은 컴포넌트로 분해
4. **props 명시**: 각 컴포넌트의 props를 구체적으로
5. **testId 필수**: 모든 interactive element에 testId 추가
