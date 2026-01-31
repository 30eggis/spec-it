# Components

컴포넌트 정의 및 배치.

## Component Structure

```yaml
components:
  - id: "stats-grid"           # 고유 ID
    type: "StatsGrid"          # 컴포넌트 타입
    zone: "main"               # 배치 영역
    gridArea: "stats"          # CSS Grid area (선택)
    props:                     # 컴포넌트 props
      columns: 4
      items:
        - { label: "사용자", value: "1,234", icon: "Users" }
        - { label: "세션", value: "89", icon: "Activity" }
    styles: "grid grid-cols-4 gap-4"   # Tailwind 클래스
    testId: "dashboard-stats"          # 테스트 ID (필수)
```

## Zone Types

| Zone | 위치 | 용도 |
|------|------|------|
| `header` | 상단 | AppHeader, Breadcrumb |
| `sidebar` | 좌측/우측 | Navigation, Menu |
| `main` | 중앙 | 주요 컨텐츠 |
| `aside` | 우측 | 보조 정보 |
| `footer` | 하단 | Footer, Copyright |
| `bottomNav` | 하단 (모바일) | 탭 네비게이션 |

## Nested Components

```yaml
components:
  - id: "login-card"
    type: "Card"
    zone: "main"
    props:
      variant: "elevated"
      padding: "p-8"
    children:                  # 중첩 컴포넌트
      - id: "logo"
        type: "Logo"
        props: { size: "lg" }

      - id: "email-input"
        type: "Input"
        props:
          type: "email"
          label: "Email"
        testId: "login-email"

      - id: "submit-button"
        type: "Button"
        props:
          text: "Sign In"
          variant: "primary"
        testId: "login-submit"
```

## Common Component Types

| Type | 용도 | 주요 Props |
|------|------|-----------|
| `Card` | 카드 컨테이너 | variant, padding |
| `Button` | 버튼 | text, variant, icon, fullWidth |
| `Input` | 입력 필드 | type, label, placeholder |
| `Checkbox` | 체크박스 | label, checked |
| `Select` | 드롭다운 | options, placeholder |
| `Table` | 테이블 | columns, data |
| `List` | 목록 | items, renderItem |
| `Modal` | 모달 | title, size, onClose |
| `Drawer` | 서랍 | position, size |

## testId Convention

```yaml
# 형식: {screen}-{component}[-{action}]
testId: "login-email"
testId: "dashboard-stats-card"
testId: "user-list-delete-btn"
```
