# Layout Extraction Rules

HTML/CSS에서 레이아웃 정보를 정확히 추출하기 위한 규칙.

> **핵심 원칙**: 원본 레이아웃 구조를 그대로 보존한다. 12-column grid로 임의 변환하지 않는다.

---

## 1. Grid 레이아웃 추출

### 1.1 Grid Columns 보존 (CRITICAL)

| Tailwind Class | 추출 결과 | 비율 |
|----------------|-----------|------|
| `grid-cols-2` | `columns: 2` | **1:1** (균등) |
| `grid-cols-3` | `columns: 3` | **1:1:1** (균등) |
| `grid-cols-4` | `columns: 4` | **1:1:1:1** (균등) |
| `grid-cols-5` | `columns: 5` | **1:1:1:1:1** (균등) |

**❌ 잘못된 예:**
```yaml
# grid-cols-2를 12-column으로 변환 (X)
grid:
  columns: "repeat(12, 1fr)"
  areas: |
    "left left left left left left right right right right right right"
```

**✅ 올바른 예:**
```yaml
# grid-cols-2 그대로 보존 (O)
grid:
  columns: 2
  ratio: "1:1"  # 균등 분배
  areas: |
    "left right"
```

### 1.2 반응형 Grid 처리

Tailwind의 반응형 prefix를 각 breakpoint별로 분리:

```
lg:grid-cols-3  →  desktop: { columns: 3 }
md:grid-cols-2  →  tablet: { columns: 2 }
grid-cols-1     →  mobile: { columns: 1 }
```

**추출 예시:**
```yaml
grid:
  desktop:
    columns: 3
    source: "lg:grid-cols-3"
  tablet:
    columns: 2
    source: "md:grid-cols-2"
  mobile:
    columns: 1
    source: "grid-cols-1"
```

### 1.3 Col-span 비율 계산

`col-span-*`이 있는 경우 실제 비율 계산:

| 부모 Grid | 자식 Classes | 비율 |
|-----------|--------------|------|
| `grid-cols-12` | `col-span-4`, `col-span-8` | 4:8 = **1:2** |
| `grid-cols-12` | `col-span-6`, `col-span-6` | 6:6 = **1:1** |
| `grid-cols-12` | `col-span-4`, `col-span-4`, `col-span-4` | 4:4:4 = **1:1:1** |

**YAML 출력:**
```yaml
grid:
  columns: 2
  ratio: "1:2"
  children:
    - id: "left"
      span: 1
    - id: "right"
      span: 2
```

---

## 2. Flex 레이아웃 추출

### 2.1 Flex 정렬 속성 (CRITICAL)

| Tailwind Class | CSS Property | YAML Key |
|----------------|--------------|----------|
| `justify-start` | `justify-content: flex-start` | `justify: "start"` |
| `justify-center` | `justify-content: center` | `justify: "center"` |
| `justify-end` | `justify-content: flex-end` | `justify: "end"` |
| `justify-between` | `justify-content: space-between` | `justify: "between"` |
| `justify-around` | `justify-content: space-around` | `justify: "around"` |
| `items-start` | `align-items: flex-start` | `align: "start"` |
| `items-center` | `align-items: center` | `align: "center"` |
| `items-end` | `align-items: flex-end` | `align: "end"` |

**추출 예시:**
```yaml
layout:
  display: "flex"
  justify: "end"       # justify-end → 요소들이 오른쪽 정렬
  align: "center"      # items-center
```

### 2.2 Flex 방향 (CRITICAL)

| Tailwind Class | 결과 |
|----------------|------|
| `flex` (기본) | `direction: "row"` |
| `flex-row` | `direction: "row"` |
| `flex-col` | `direction: "column"` |
| `flex-row-reverse` | `direction: "row-reverse"` |
| `flex-col-reverse` | `direction: "column-reverse"` |

**Block vs Flex 구분:**
- `display: block` + 자식들이 수직 배치 → `direction: "column"` (암시적)
- `display: flex` + `flex-col` → `direction: "column"` (명시적)

### 2.3 Flex 예시

**원본 HTML:**
```html
<header class="flex items-center justify-end px-6">
  <div class="flex items-center gap-4">
    <button>직원</button>
    <button>HR 관리자</button>
  </div>
  <button>알림</button>
</header>
```

**추출 YAML:**
```yaml
- id: "header"
  type: "Header"
  layout:
    display: "flex"
    justify: "end"      # ← 핵심: 내용물이 오른쪽 정렬
    align: "center"
    padding: "0 24px"
```

---

## 3. Display 타입 구분

### 3.1 Display 속성 추출

| 상황 | Display 값 | 특징 |
|------|-----------|------|
| `display: block` | `display: "block"` | 자식들이 자동으로 수직 배치 |
| `display: flex` | `display: "flex"` | 정렬 속성 명시 필요 |
| `display: grid` | `display: "grid"` | columns/areas 필요 |
| `display: none` | 추출 제외 | - |

### 3.2 Block 레이아웃의 수직 배치

**원본 (display: block):**
```html
<div class="sticky-filter-bar">
  <h1>2026년 2월 3일</h1>           <!-- 1행 -->
  <div class="flex">오늘/이번주</div> <!-- 2행 -->
  <div class="flex">조직/직급</div>   <!-- 3행 -->
</div>
```

**추출 YAML:**
```yaml
- id: "filter-bar"
  layout:
    display: "block"        # 또는 생략 (block이 기본)
    direction: "column"     # 자식들이 수직으로 배치됨
  children:
    - id: "date-title"
      row: 1
    - id: "date-tabs"
      row: 2
    - id: "filters"
      row: 3
```

---

## 4. 컴포넌트 내부 레이아웃

### 4.1 컨테이너 레이아웃 속성

각 컴포넌트의 내부 배치도 추출:

```yaml
components:
  - id: "stat-card"
    type: "StatCard"
    layout:
      display: "flex"
      direction: "column"
      align: "center"       # 중앙 정렬
      gap: 12
    children:
      - id: "icon-badge"
      - id: "value"
      - id: "label"
```

### 4.2 카드 그리드 내부 배치

```yaml
- id: "card-grid"
  layout:
    display: "grid"
    columns: 3              # lg:grid-cols-3
    gap: 24
  children:
    - id: "card-1"
      gridArea: "auto"      # 순서대로 배치
    - id: "card-2"
    - id: "card-3"
```

---

## 5. Gap & Spacing 추출

### 5.1 Gap 클래스 매핑

| Tailwind Class | 값 |
|----------------|-----|
| `gap-1` | 4px |
| `gap-2` | 8px |
| `gap-3` | 12px |
| `gap-4` | 16px |
| `gap-6` | 24px |
| `gap-8` | 32px |

### 5.2 방향별 Gap

```yaml
layout:
  gap: 16           # gap-4
  gapX: 24          # gap-x-6
  gapY: 16          # gap-y-4
```

---

## 6. 추출 우선순위

레이아웃 속성 추출 시 우선순위:

1. **Grid 구조** (columns, areas, gap)
2. **Flex 정렬** (justify, align, direction)
3. **Display 타입** (grid, flex, block)
4. **Spacing** (gap, padding, margin)
5. **반응형** (breakpoint별 변화)

---

## 7. 실전 예시: 대시보드 레이아웃

### 원본 HTML 구조:
```html
<main class="ml-64 pt-16 px-6 pb-6">
  <!-- Filter Bar -->
  <div class="sticky top-16">
    <h1>2026년 2월 3일</h1>
    <div class="flex">오늘/이번주/이번달</div>
    <div class="flex items-center gap-4">조직/직급</div>
  </div>

  <!-- Stats Grid -->
  <div class="grid grid-cols-5 gap-4">...</div>

  <!-- Cards Row 1 -->
  <div class="grid lg:grid-cols-3 gap-6">...</div>

  <!-- Cards Row 2 -->
  <div class="grid lg:grid-cols-2 gap-6">...</div>
</main>
```

### 추출된 YAML:
```yaml
layout:
  type: "dashboard-with-sidebar"

grid:
  desktop:
    mainContent:
      rows:
        - id: "filter"
          layout:
            direction: "column"  # block 레이아웃 → 수직 배치
        - id: "stats"
          columns: 5             # grid-cols-5 그대로
          gap: 16
        - id: "cards-row-1"
          columns: 3             # lg:grid-cols-3 → 1:1:1
          gap: 24
        - id: "cards-row-2"
          columns: 2             # lg:grid-cols-2 → 1:1
          gap: 24

components:
  - id: "filter-bar"
    layout:
      direction: "column"
    children:
      - id: "date-title"
        row: 1
      - id: "date-tabs"
        row: 2
      - id: "filters"
        row: 3
        layout:
          display: "flex"
          align: "center"
          gap: 16
```

---

## 8. 검증 체크리스트

레이아웃 추출 후 확인:

- [ ] Grid columns 수가 원본과 일치하는가?
- [ ] Flex justify 속성이 추출되었는가?
- [ ] Flex direction이 올바른가? (row vs column)
- [ ] 각 행의 비율이 정확한가? (1:1, 1:2 등)
- [ ] 반응형 breakpoint별로 분리되었는가?
- [ ] Gap/spacing 값이 정확한가?
- [ ] Block 레이아웃의 수직 배치가 명시되었는가?

---

## 9. 흔한 실수 방지

| 실수 | 올바른 처리 |
|------|------------|
| `grid-cols-2`를 `col-span-4:col-span-8`로 변환 | `columns: 2, ratio: "1:1"` 유지 |
| `justify-end` 누락 | 반드시 추출하여 `justify: "end"` 기록 |
| `flex-col` 무시 | `direction: "column"` 명시 |
| Block 레이아웃을 flex로 변환 | `display: "block"` + `direction: "column"` |
| 반응형 prefix 무시 | breakpoint별 분리 저장 |
