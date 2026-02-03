# Responsive

반응형 breakpoints 및 변경사항 정의.

## Breakpoint Definition

```yaml
responsive:
  desktop:
    minWidth: "1024px"
    layout: "Full sidebar, multi-column content"

  tablet:
    minWidth: "768px"
    maxWidth: "1023px"
    layout: "Collapsed sidebar, 2-column content"

  mobile:
    maxWidth: "767px"
    layout: "Hidden sidebar, single column, drawer menu"
```

## Change Specification

```yaml
responsive:
  desktop:
    minWidth: "1024px"
    # 기본 상태 (변경사항 명시 불필요)

  tablet:
    minWidth: "768px"
    maxWidth: "1023px"
    changes:
      - sidebar: "collapsed"         # 사이드바 축소
      - grid.columns: "64px 1fr"     # 그리드 변경
      - statsGrid.columns: 2         # 컴포넌트 prop 변경

  mobile:
    maxWidth: "767px"
    changes:
      - sidebar: "hidden"            # 사이드바 숨김
      - navigation: "drawer"         # 네비게이션 방식 변경
      - header: "compact"            # 헤더 축소
      - grid.columns: "1fr"          # 단일 컬럼
      - bottomNav: "visible"         # 하단 탭 표시
```

## Component Visibility

```yaml
components:
  - id: "desktop-sidebar"
    type: "Sidebar"
    visibility:
      desktop: true
      tablet: "collapsed"
      mobile: false

  - id: "mobile-drawer"
    type: "Drawer"
    visibility:
      desktop: false
      tablet: false
      mobile: true

  - id: "bottom-nav"
    type: "BottomNavigation"
    visibility:
      desktop: false
      tablet: false
      mobile: true
```

## Responsive Props

```yaml
components:
  - id: "stats-grid"
    type: "StatsGrid"
    props:
      columns:
        desktop: 4
        tablet: 2
        mobile: 1
      gap:
        desktop: "gap-6"
        tablet: "gap-4"
        mobile: "gap-3"
```

## Mobile Navigation Options

```yaml
mobileNav:
  type: "drawer"              # drawer | bottomTabs | hamburger

  drawer:
    position: "left"
    width: "80vw"
    maxWidth: "320px"
    overlay: true

  bottomTabs:
    items:
      - { icon: "Home", label: "홈", route: "/" }
      - { icon: "Search", label: "검색", route: "/search" }
      - { icon: "User", label: "프로필", route: "/profile" }
    maxVisible: 5
```
