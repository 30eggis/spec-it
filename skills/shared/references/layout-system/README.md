# Layout System Reference

레이아웃 시스템 참조 문서 - 점진적 컨텍스트 로딩용

## 파일 구조

```
layout-system/
├── README.md                          ← 현재 문서 (중앙 인덱스)
├── 01-layout-templates/
│   ├── 01-auth-centered.md
│   └── 02-dashboard-with-sidebar.md
├── 02-layout-components/
│   ├── 01-header.md
│   ├── 02-sidebar.md
│   └── 03-mobile-bottom-nav.md
├── 03-grid-system/
│   ├── 01-responsive-grid.md
│   └── 02-dashboard-grid-patterns.md
├── 04-skeuomorphism/
│   ├── 01-shadow-levels.md
│   ├── 02-neumorphic-shadows.md
│   ├── 03-surface-elevation.md
│   ├── 04-button-affordances.md
│   ├── 05-input-affordances.md
│   └── 06-card-affordances.md
├── 05-color-palette/
│   ├── 01-semantic-colors.md
│   └── 02-usage-guidelines.md
├── 06-typography/
│   ├── 01-heading-scale.md
│   ├── 02-body-scale.md
│   └── 03-font-families.md
├── 07-spacing/
│   ├── 01-spacing-scale.md
│   └── 02-layout-spacing.md
├── 08-responsive/
│   ├── 01-breakpoint-values.md
│   └── 02-breakpoint-strategy.md
├── 09-animation/
│   ├── 01-transition-durations.md
│   ├── 02-easing-functions.md
│   └── 03-common-animations.md
├── 10-accessibility/
│   ├── 01-focus-states.md
│   ├── 02-color-contrast.md
│   ├── 03-keyboard-navigation.md
│   └── 04-screen-reader.md
└── 11-examples/
    ├── 01-complete-page.md
    └── 02-file-structure.md
```

## 로딩 가이드

### 기본 로딩 (필수)
```
Read: layout-system/README.md
```

### 레이아웃 구현 시
```
Read: layout-system/01-layout-templates/{template}.md
Read: layout-system/02-layout-components/{component}.md
```

### 스타일링 구현 시
```
Read: layout-system/04-skeuomorphism/01-shadow-levels.md
Read: layout-system/05-color-palette/01-semantic-colors.md
Read: layout-system/06-typography/01-heading-scale.md
```

### 반응형 구현 시
```
Read: layout-system/03-grid-system/01-responsive-grid.md
Read: layout-system/08-responsive/02-breakpoint-strategy.md
```

### 접근성 검토 시
```
Read: layout-system/10-accessibility/01-focus-states.md
Read: layout-system/10-accessibility/02-color-contrast.md
```

---

## 1. Layout Templates

레이아웃 템플릿 정의

| File | Description | Usage |
|------|-------------|-------|
| [01-auth-centered.md](01-layout-templates/01-auth-centered.md) | 인증 화면 레이아웃 | Login, Password Reset |
| [02-dashboard-with-sidebar.md](01-layout-templates/02-dashboard-with-sidebar.md) | 대시보드 레이아웃 | All authenticated screens |

---

## 2. Layout Components

공통 레이아웃 컴포넌트

| File | Description |
|------|-------------|
| [01-header.md](02-layout-components/01-header.md) | 글로벌 헤더 |
| [02-sidebar.md](02-layout-components/02-sidebar.md) | 사이드바 네비게이션 |
| [03-mobile-bottom-nav.md](02-layout-components/03-mobile-bottom-nav.md) | 모바일 하단 네비게이션 |

---

## 3. Grid System

그리드 시스템

| File | Description |
|------|-------------|
| [01-responsive-grid.md](03-grid-system/01-responsive-grid.md) | 반응형 그리드 정의 |
| [02-dashboard-grid-patterns.md](03-grid-system/02-dashboard-grid-patterns.md) | 대시보드 그리드 패턴 |

---

## 4. Skeuomorphism Guidelines

Light Skeuomorphism 디자인 가이드

| File | Description |
|------|-------------|
| [01-shadow-levels.md](04-skeuomorphism/01-shadow-levels.md) | 5단계 그림자 시스템 |
| [02-neumorphic-shadows.md](04-skeuomorphism/02-neumorphic-shadows.md) | Neumorphic 그림자 |
| [03-surface-elevation.md](04-skeuomorphism/03-surface-elevation.md) | Z-index 계층 |
| [04-button-affordances.md](04-skeuomorphism/04-button-affordances.md) | 버튼 어포던스 |
| [05-input-affordances.md](04-skeuomorphism/05-input-affordances.md) | 입력 어포던스 |
| [06-card-affordances.md](04-skeuomorphism/06-card-affordances.md) | 카드 어포던스 |

---

## 5. Color Palette

컬러 팔레트

| File | Description |
|------|-------------|
| [01-semantic-colors.md](05-color-palette/01-semantic-colors.md) | 시맨틱 컬러 정의 |
| [02-usage-guidelines.md](05-color-palette/02-usage-guidelines.md) | 컬러 사용 가이드 |

---

## 6. Typography

타이포그래피 시스템

| File | Description |
|------|-------------|
| [01-heading-scale.md](06-typography/01-heading-scale.md) | 제목 스케일 |
| [02-body-scale.md](06-typography/02-body-scale.md) | 본문 스케일 |
| [03-font-families.md](06-typography/03-font-families.md) | 폰트 패밀리 |

---

## 7. Spacing

간격 시스템

| File | Description |
|------|-------------|
| [01-spacing-scale.md](07-spacing/01-spacing-scale.md) | 간격 스케일 |
| [02-layout-spacing.md](07-spacing/02-layout-spacing.md) | 레이아웃 간격 |

---

## 8. Responsive

반응형 브레이크포인트

| File | Description |
|------|-------------|
| [01-breakpoint-values.md](08-responsive/01-breakpoint-values.md) | 브레이크포인트 값 |
| [02-breakpoint-strategy.md](08-responsive/02-breakpoint-strategy.md) | 브레이크포인트 전략 |

---

## 9. Animation

애니메이션 & 트랜지션

| File | Description |
|------|-------------|
| [01-transition-durations.md](09-animation/01-transition-durations.md) | 트랜지션 지속 시간 |
| [02-easing-functions.md](09-animation/02-easing-functions.md) | 이징 함수 |
| [03-common-animations.md](09-animation/03-common-animations.md) | 공통 애니메이션 |

---

## 10. Accessibility

접근성 가이드라인

| File | Description |
|------|-------------|
| [01-focus-states.md](10-accessibility/01-focus-states.md) | 포커스 상태 |
| [02-color-contrast.md](10-accessibility/02-color-contrast.md) | 색상 대비 |
| [03-keyboard-navigation.md](10-accessibility/03-keyboard-navigation.md) | 키보드 네비게이션 |
| [04-screen-reader.md](10-accessibility/04-screen-reader.md) | 스크린 리더 지원 |

---

## 11. Examples

구현 예제

| File | Description |
|------|-------------|
| [01-complete-page.md](11-examples/01-complete-page.md) | 전체 페이지 예제 |
| [02-file-structure.md](11-examples/02-file-structure.md) | 파일 구조 |
