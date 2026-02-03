# Grid Definition

CSS Grid 기반 레이아웃 정의.

> **핵심 원칙**: 원본 grid 구조를 그대로 보존. 12-column으로 임의 변환 금지.

## Grid Structure

```yaml
grid:
  desktop:
    display: "grid"
    columns: 2                        # grid-cols-2 → 2 (숫자로 보존)
    ratio: "1:1"                      # 균등 분배 명시
    rows: "64px 1fr"                  # grid-template-rows
    areas: |                          # grid-template-areas
      "header header"
      "sidebar main"
    gap: 24                           # gap-6 = 24px
    source: "lg:grid-cols-2 gap-6"    # 원본 Tailwind 클래스

  tablet:
    columns: 2
    ratio: "1:1"
    rows: "64px 1fr"
    areas: |
      "header header"
      "sidebar main"
    source: "md:grid-cols-2"

  mobile:
    columns: 1
    ratio: "1"
    rows: "64px 1fr 56px"
    areas: |
      "header"
      "main"
      "bottomNav"
    source: "grid-cols-1"
```

## Grid Ratio 규칙 (CRITICAL)

| Tailwind Class | columns | ratio | 설명 |
|----------------|---------|-------|------|
| `grid-cols-2` | 2 | "1:1" | 2열 균등 |
| `grid-cols-3` | 3 | "1:1:1" | 3열 균등 |
| `grid-cols-4` | 4 | "1:1:1:1" | 4열 균등 |
| `grid-cols-5` | 5 | "1:1:1:1:1" | 5열 균등 |

### Col-span이 있는 경우

```yaml
# 원본: grid-cols-12 with col-span-4 + col-span-8
grid:
  columns: 2          # 실제 자식 요소 개수
  ratio: "1:2"        # col-span 비율 계산 (4:8 = 1:2)
  source: "grid-cols-12 [col-span-4, col-span-8]"
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
  gap: 0            # 영역 간 간격 없음 (레이아웃)

main:
  gap: 16           # gap-4 = 16px
  padding: 24       # p-6 = 24px
```

---

## Flex Layout 추출 (CRITICAL)

### Justify 속성

| Tailwind | YAML | 설명 |
|----------|------|------|
| `justify-start` | `justify: "start"` | 왼쪽 정렬 |
| `justify-center` | `justify: "center"` | 중앙 정렬 |
| `justify-end` | `justify: "end"` | **오른쪽 정렬** |
| `justify-between` | `justify: "between"` | 양쪽 분산 |

### Align 속성

| Tailwind | YAML | 설명 |
|----------|------|------|
| `items-start` | `align: "start"` | 상단 정렬 |
| `items-center` | `align: "center"` | 중앙 정렬 |
| `items-end` | `align: "end"` | 하단 정렬 |

### Direction 속성

| Tailwind | YAML | 설명 |
|----------|------|------|
| `flex` (기본) | `direction: "row"` | 수평 배치 |
| `flex-col` | `direction: "column"` | 수직 배치 |
| `display: block` | `direction: "column"` | 암시적 수직 |

### 예시

```yaml
# 원본: <header class="flex items-center justify-end px-6">
layout:
  display: "flex"
  direction: "row"
  justify: "end"        # ← 요소들이 오른쪽에 배치
  align: "center"
  padding: "0 24px"
  source: "flex items-center justify-end px-6"

# 원본: <div class="sticky-filter-bar"> (block, 자식들 수직)
layout:
  display: "block"
  direction: "column"   # ← 자식들이 수직으로 쌓임
  source: "sticky-filter-bar (block)"
```
