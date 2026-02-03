# Design Direction

디자인 트렌드, 색상, 모션 정의.

## Style Selection

```yaml
designDirection:
  style: "minimal"    # minimal | immersive | organic
```

| Style | 특징 |
|-------|------|
| `minimal` | 밝은 테마, 깔끔한 카드, 미니멀 |
| `immersive` | 다크 테마, 그라데이션, 네온 포인트 |
| `organic` | Glassmorphism, 부드러운 곡선, 3D |

## Applied Trends

```yaml
designDirection:
  appliedTrends:
    primary:
      name: "Light Skeuomorphism"
      application: "Card shadows, input inset styles"

    secondary:
      name: "Micro-Animations"
      application: "Button hover, page transitions"
```

### Available Trends

| Trend | 설명 |
|-------|------|
| `Light Skeuomorphism` | Neumorphic 그림자, 입체감 |
| `Dark Mode+` | 어두운 테마 + 적응형 색상 |
| `Glassmorphism` | 반투명 배경 + blur |
| `Micro-Animations` | 의미있는 모션 |
| `3D Visuals` | 3D 아이콘, WebGL |
| `Gamification` | Progress rings, 배지 |

## Component Patterns

```yaml
designDirection:
  componentPatterns:
    - component: "StatsCard"
      pattern: "neo-card"
      templateRef: "design-trends-2026/templates/card-templates.md#neo-card"

    - component: "LoginForm"
      pattern: "glass-form"
      templateRef: "design-trends-2026/templates/form-templates.md#glass-form"
```

## Color Tokens

```yaml
designDirection:
  colorTokens:
    - token: "primary"
      value: "#2563EB"
      usage: "Primary buttons, links, focus rings"

    - token: "surface"
      value: "#FFFFFF"
      usage: "Card backgrounds, modals"

    - token: "background"
      value: "#F5F7FA"
      usage: "Page background"

    - token: "text"
      value: "#1F2937"
      usage: "Primary text"

    - token: "muted"
      value: "#6B7280"
      usage: "Secondary text, placeholders"
```

## Motion Guidelines

```yaml
designDirection:
  motionGuidelines:
    - interaction: "pageLoad"
      animation: "fadeInUp"
      duration: "300ms"
      easing: "ease-out"

    - interaction: "buttonHover"
      animation: "scale"
      scale: 1.02
      duration: "150ms"
      easing: "ease-in-out"

    - interaction: "modalOpen"
      animation: "fadeIn + scaleUp"
      duration: "200ms"
      backdrop: "blur(4px)"

    - interaction: "success"
      animation: "bounceIn"
      duration: "400ms"
      icon: "CheckCircle"
```

## Design Tokens Reference

```yaml
styles:
  _ref: "../design-tokens.yaml"

  overrides:
    card: "shadow-lg rounded-xl"
    button: "font-semibold tracking-wide"
```
