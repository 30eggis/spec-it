# Grid Definition

CSS Grid 기반 레이아웃 정의.

## Grid Structure

```yaml
grid:
  desktop:
    display: "grid"
    columns: "256px 1fr"              # grid-template-columns
    rows: "64px 1fr"                  # grid-template-rows
    areas: |                          # grid-template-areas
      "header header"
      "sidebar main"
    gap: "0"                          # gap
    minHeight: "100vh"

  tablet:
    columns: "64px 1fr"
    rows: "64px 1fr"
    areas: |
      "header header"
      "sidebar main"

  mobile:
    columns: "1fr"
    rows: "64px 1fr 56px"
    areas: |
      "header"
      "main"
      "bottomNav"
```

## Grid Areas Examples

### Dashboard Layout
```yaml
areas: |
  "header header header"
  "sidebar main aside"
  "sidebar footer footer"
```

### Auth Layout
```yaml
areas: |
  "main"
```

### Split Layout
```yaml
areas: |
  "header header"
  "left right"
```

## Component Placement

```yaml
components:
  - id: "app-header"
    type: "AppHeader"
    gridArea: "header"    # grid-template-areas 참조

  - id: "sidebar"
    type: "Sidebar"
    gridArea: "sidebar"

  - id: "main-content"
    type: "MainContent"
    gridArea: "main"
```

## Gap & Spacing

```yaml
grid:
  gap: "gap-0"      # 영역 간 간격 없음 (레이아웃)

main:
  gap: "gap-4"      # 컨텐츠 내부 간격
  padding: "p-6"    # 컨텐츠 패딩
```
