# Complete Example

전체 와이어프레임 예시.

## Login Screen

```yaml
# wireframes/scr-001-login.yaml

id: "SCR-001"
name: "Login"
route: "/login"
type: "page"
priority: "P0"
accessLevel: "public"

layout:
  type: "auth-centered"
  main:
    padding: "p-8"
    maxWidth: "max-w-md"

grid:
  desktop:
    columns: "1fr"
    areas: |
      "main"
    minHeight: "100vh"
    justifyContent: "center"
    alignItems: "center"

  mobile:
    columns: "1fr"
    areas: |
      "main"
    padding: "p-4"

components:
  - id: "login-card"
    type: "Card"
    zone: "main"
    props:
      variant: "elevated"
      padding: "p-8"
    styles: "bg-white rounded-2xl shadow-xl"
    children:
      - id: "logo"
        type: "Logo"
        props:
          size: "lg"
          withText: true
        styles: "mb-6"

      - id: "title"
        type: "Heading"
        props:
          level: 1
          text: "Welcome Back"
        styles: "text-2xl font-bold text-center mb-2"

      - id: "subtitle"
        type: "Text"
        props:
          text: "Sign in to continue"
        styles: "text-gray-500 text-center mb-8"

      - id: "email-input"
        type: "Input"
        props:
          type: "email"
          label: "Email"
          placeholder: "name@company.com"
          required: true
        styles: "mb-4"
        testId: "login-email"

      - id: "password-input"
        type: "Input"
        props:
          type: "password"
          label: "Password"
          showToggle: true
          required: true
        styles: "mb-4"
        testId: "login-password"

      - id: "remember-row"
        type: "Flex"
        props:
          justify: "between"
          align: "center"
        styles: "mb-6"
        children:
          - id: "remember-checkbox"
            type: "Checkbox"
            props:
              label: "Remember me"
            testId: "login-remember"
          - id: "forgot-link"
            type: "Link"
            props:
              text: "Forgot password?"
              href: "/forgot-password"
              variant: "subtle"

      - id: "submit-button"
        type: "Button"
        props:
          variant: "primary"
          fullWidth: true
          text: "Sign In"
          size: "lg"
        styles: "mb-4"
        testId: "login-submit"

      - id: "divider"
        type: "Divider"
        props:
          text: "or"
        styles: "my-4"

      - id: "sso-button"
        type: "Button"
        props:
          variant: "outline"
          fullWidth: true
          icon: "Google"
          text: "Continue with Google"
        testId: "login-sso"

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
        shake: "login-card"
        showError: true

  clicks:
    - element: "[data-testid='login-sso']"
      action: "custom"
      handler: "initiateSSOFlow"

states:
  loading:
    element: "login-card"
    type: "overlay"
    spinner: true

  error:
    element: "login-card"
    showAlert: true
    position: "top"

responsive:
  desktop:
    minWidth: "1024px"
    cardWidth: "400px"
    background: "gradient-blob"

  tablet:
    minWidth: "768px"
    cardWidth: "380px"

  mobile:
    maxWidth: "767px"
    cardWidth: "100%"
    padding: "p-4"

designDirection:
  style: "minimal"

  appliedTrends:
    primary:
      name: "Light Skeuomorphism"
      application: "Card elevation, input inset"

  colorTokens:
    - token: "primary"
      value: "#2563EB"
    - token: "surface"
      value: "#FFFFFF"
    - token: "background"
      value: "#F5F7FA"

  motionGuidelines:
    - interaction: "pageLoad"
      animation: "fadeInUp"
      duration: "300ms"
    - interaction: "inputFocus"
      animation: "labelFloat"
      duration: "150ms"
    - interaction: "buttonClick"
      animation: "press"
      duration: "100ms"
    - interaction: "error"
      animation: "shake"
      duration: "400ms"

accessibility:
  landmarks:
    - role: "main"
      element: "main"

  focusOrder:
    - "email-input"
    - "password-input"
    - "remember-checkbox"
    - "forgot-link"
    - "submit-button"
    - "sso-button"

  ariaLabels:
    - element: "password-toggle"
      label: "Show/hide password"

styles:
  _ref: "../design-tokens.yaml"

notes: |
  - First-time users should be redirected to onboarding
  - SSO button only appears if org has SSO enabled
  - Remember me sets 30-day session token
```
