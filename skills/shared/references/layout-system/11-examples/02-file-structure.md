# File Structure

프로젝트 파일 구조.

## App Router Structure

```
app/
├── (auth)/
│   ├── login/
│   │   └── page.tsx
│   ├── forgot-password/
│   │   └── page.tsx
│   └── layout.tsx          # auth-centered layout
│
├── (dashboard)/
│   ├── dashboard/
│   │   └── page.tsx
│   ├── attendance/
│   │   ├── clock/
│   │   │   └── page.tsx
│   │   ├── status/
│   │   │   └── page.tsx
│   │   └── timesheet/
│   │       └── page.tsx
│   ├── requests/
│   │   ├── page.tsx
│   │   ├── [id]/
│   │   │   └── page.tsx
│   │   ├── leave/
│   │   │   └── new/
│   │   │       └── page.tsx
│   │   ├── overtime/
│   │   │   └── new/
│   │   │       └── page.tsx
│   │   └── holiday/
│   │       └── new/
│   │           └── page.tsx
│   ├── approvals/
│   │   ├── pending/
│   │   │   └── page.tsx
│   │   └── [id]/
│   │       └── page.tsx
│   ├── profile/
│   │   └── page.tsx
│   └── layout.tsx          # dashboard-with-sidebar layout
│
├── layout.tsx              # Root layout
├── globals.css
└── providers.tsx
```

## Components Structure

```
components/
├── layout/
│   ├── header.tsx
│   ├── sidebar.tsx
│   ├── mobile-bottom-nav.tsx
│   ├── nav-item.tsx
│   ├── nav-section.tsx
│   └── user-menu.tsx
│
├── ui/
│   ├── neo-card.tsx
│   ├── neo-button.tsx
│   ├── neo-input.tsx
│   ├── glass-card.tsx
│   ├── stat-card.tsx
│   ├── badge.tsx
│   ├── avatar.tsx
│   ├── table.tsx
│   ├── modal.tsx
│   ├── dropdown.tsx
│   ├── toast.tsx
│   ├── skeleton.tsx
│   └── spinner.tsx
│
├── forms/
│   ├── login-form.tsx
│   ├── leave-request-form.tsx
│   ├── overtime-request-form.tsx
│   └── form-field.tsx
│
├── dashboard/
│   ├── today-timeline.tsx
│   ├── quick-actions.tsx
│   ├── recent-requests.tsx
│   └── stats-overview.tsx
│
└── attendance/
    ├── clock-widget.tsx
    ├── status-calendar.tsx
    └── timesheet-table.tsx
```

## Layouts Structure

```
layouts/
├── auth-centered.tsx
└── dashboard-with-sidebar.tsx
```

## Lib Structure

```
lib/
├── api/
│   ├── auth.ts
│   ├── attendance.ts
│   ├── requests.ts
│   └── approvals.ts
│
├── hooks/
│   ├── use-auth.ts
│   ├── use-attendance.ts
│   └── use-requests.ts
│
├── stores/
│   ├── auth-store.ts
│   └── ui-store.ts
│
├── utils/
│   ├── cn.ts             # classnames utility
│   ├── date.ts
│   └── format.ts
│
└── types/
    ├── auth.ts
    ├── attendance.ts
    └── requests.ts
```

## Config Files

```
├── tailwind.config.js
├── tsconfig.json
├── next.config.js
├── .env.local
└── .env.example
```
