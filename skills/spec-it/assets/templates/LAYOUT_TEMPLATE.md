# Layout System

## Layout Types

### {{layout_name}} Layout

**사용 화면**: {{screens_using_this_layout}}

#### Desktop (1440px+)

```
{{desktop_layout}}
```

#### Tablet (768px - 1024px)

```
{{tablet_layout}}
```

#### Mobile (< 768px)

```
{{mobile_layout}}
```

---

## Common Components

### Header

```
{{header_wireframe}}
```

**구성요소**:
- Logo: {{logo_position}}
- Navigation: {{nav_items}}
- User Menu: {{user_menu_items}}

### Sidebar

```
{{sidebar_wireframe}}
```

**구성요소**:
- Menu Groups: {{menu_groups}}
- Collapse: {{collapse_behavior}}

### Footer

```
{{footer_wireframe}}
```

### Drawer (Mobile)

```
{{drawer_wireframe}}
```

---

## Breakpoints

| Name | Range | Layout Changes |
|------|-------|----------------|
| Desktop | 1440px+ | Full sidebar, multi-column |
| Laptop | 1024px - 1439px | Compact sidebar |
| Tablet | 768px - 1023px | Collapsible sidebar |
| Mobile | < 768px | Bottom nav or drawer |

---

## Usage Guide

페이지 와이어프레임 생성 시 이 Layout을 참조하여:
1. Layout 구조를 복사
2. `{{MAIN_CONTENT}}` 영역에 페이지 고유 컨텐츠 삽입
3. 필요시 Header/Sidebar 상태 변경 (active menu 등)
