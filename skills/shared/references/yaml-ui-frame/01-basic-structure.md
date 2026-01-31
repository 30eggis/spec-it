# Basic Structure

화면 와이어프레임의 기본 구조.

## Screen Metadata

```yaml
id: "SCR-001"
name: "Dashboard"
route: "/dashboard"
type: "page"           # page | modal | drawer | panel
priority: "P0"         # P0 | P1 | P2
accessLevel: "authenticated"  # public | authenticated | admin
```

## Layout Definition

```yaml
layout:
  type: "sidebar-main"    # sidebar-main | header-main | full-width | split | auth-centered

  sidebar:
    position: "left"      # left | right | none
    width: "256px"        # 64px | 200px | 256px | 320px
    collapsed: "64px"     # 축소 시 너비
    collapsible: true

  header:
    height: "64px"        # 64px | 80px | auto
    sticky: true

  main:
    padding: "p-6"        # p-4 | p-6 | p-8
    maxWidth: "full"      # max-w-4xl | max-w-6xl | full
    overflow: "auto"      # auto | scroll | hidden

  footer:
    enabled: false
    height: "48px"
    sticky: false
```

## Layout Types

| Type | 설명 | 용도 |
|------|------|------|
| `sidebar-main` | 사이드바 + 메인 | 대시보드, 관리자 |
| `header-main` | 헤더 + 메인 | 랜딩, 마케팅 |
| `full-width` | 전체 너비 | 데이터 테이블 |
| `split` | 좌우 분할 | 비교, 메시지 |
| `auth-centered` | 중앙 정렬 | 로그인, 회원가입 |

## File Output

```yaml
# 출력 위치
wireframes/scr-001-dashboard.yaml
layouts/layout-system.yaml
```
