# Interactions

사용자 인터랙션 정의.

## Click Events

```yaml
interactions:
  clicks:
    - element: "[data-testid='stats-card-users']"
      action: "navigate"
      target: "/users"
      description: "사용자 목록으로 이동"

    - element: "[data-testid='create-btn']"
      action: "modal"
      target: "create-modal"
      description: "생성 모달 열기"

    - element: "[data-testid='sidebar-toggle']"
      action: "toggle"
      target: "sidebar.collapsed"
      description: "사이드바 접기/펴기"
```

## Action Types

| Action | 설명 | target 형식 |
|--------|------|------------|
| `navigate` | 페이지 이동 | URL path |
| `modal` | 모달 열기 | modal ID |
| `drawer` | 드로어 열기 | drawer ID |
| `toggle` | 상태 토글 | state key |
| `submit` | 폼 제출 | form ID |
| `custom` | 커스텀 핸들러 | handler name |

## Form Submissions

```yaml
interactions:
  forms:
    - formId: "login-form"
      endpoint: "/api/auth/login"
      method: "POST"
      validation:
        - field: "email"
          rules: ["required", "email"]
        - field: "password"
          rules: ["required", "minLength:8"]
      onSuccess:
        action: "navigate"
        target: "/dashboard"
      onError:
        action: "showError"
        shake: "login-card"

    - formId: "search-form"
      endpoint: "/api/search"
      method: "GET"
      debounce: 300
      onSuccess:
        action: "updateState"
        target: "searchResults"
```

## State Changes

```yaml
interactions:
  stateChanges:
    - trigger: "sidebar-toggle"
      stateBefore: "expanded"
      stateAfter: "collapsed"
      animation: "slide"
      duration: "200ms"

    - trigger: "tab-click"
      stateBefore: { activeTab: "tab1" }
      stateAfter: { activeTab: "clicked" }
      animation: "fade"
```

## Keyboard Shortcuts

```yaml
interactions:
  keyboard:
    - key: "Escape"
      action: "closeModal"
      condition: "modalOpen"

    - key: "Ctrl+K"
      action: "openSearch"
      global: true

    - key: "Enter"
      element: "[data-testid='search-input']"
      action: "submitSearch"
```

## Hover Effects

```yaml
interactions:
  hover:
    - element: "[data-testid='card']"
      effect: "elevate"
      styles: "shadow-lg scale-[1.02]"
      duration: "200ms"
```
