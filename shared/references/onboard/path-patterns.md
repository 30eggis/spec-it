# Path Pattern Reference

Reference document for `path-architect` agent.

## Standard Pattern

```
/{persona}/{service}/{id|action}
```

### Examples

| Pattern | Example | Description |
|---------|---------|-------------|
| `/{persona}` | `/hr`, `/employee` | Persona root (dashboard) |
| `/{persona}/{service}` | `/hr/attendance` | Service list |
| `/{persona}/{service}/new` | `/employee/leave/new` | Create/request form |
| `/{persona}/{service}/[id]` | `/hr/leave/123` | Detail view |
| `/{persona}/{service}/[id]/edit` | `/hr/leave/123/edit` | Edit form |

---

## Common Services

| Service | Description | HR | Employee |
|---------|-------------|-----|----------|
| `attendance` | 출퇴근 기록 | ✅ view all | ✅ view own |
| `leave` | 휴가 | ✅ approve | ✅ request |
| `overtime` | 연장/휴일근무 | ✅ approve | ✅ request |
| `trip` | 출장 | ✅ approve | ✅ request |
| `requests` | 요청 관리 | ✅ | ❌ |
| `rules` | 근무 규칙 | ✅ | ❌ |
| `company` | 회사 설정 | ✅ | ❌ |
| `team` | 팀 관리 | ❌ | ✅ (team lead) |
| `reports` | 리포트 | ✅ all | ✅ own/team |
| `settings` | 설정 | ✅ system | ✅ personal |

---

## Common Path Problems

### Problem 1: Mixed Personas at Root

```
❌ Bad:
/                     # HR dashboard
/employee             # Employee dashboard
/attendance-records   # HR attendance (but no prefix!)
```

```
✅ Good:
/hr                   # HR dashboard
/employee             # Employee dashboard
/hr/attendance        # HR attendance
```

### Problem 2: Inconsistent Naming

```
❌ Bad:
/leave-management     # uses -management
/overtime-request     # uses -request
/attendance-records   # uses -records
```

```
✅ Good:
/hr/leave             # consistent service name
/hr/overtime
/hr/attendance
```

### Problem 3: Query Params Instead of Paths

```
❌ Bad:
/reports?mode=hr
/settings?mode=employee
```

```
✅ Good:
/hr/reports
/employee/settings
```

### Problem 4: Missing Dynamic Routes

```
❌ Bad:
/leave-detail?id=123
/leave-edit?id=123
```

```
✅ Good:
/hr/leave/123
/hr/leave/123/edit
```

---

## Migration Table Template

| Current | Proposed | Change Type | Priority |
|---------|----------|-------------|----------|
| `/` | `/hr` | prefix | HIGH |
| `/attendance-records` | `/hr/attendance` | rename | HIGH |
| `/leave-management` | `/hr/leave` | rename | MEDIUM |
| `/reports?mode=hr` | `/hr/reports` | param→path | MEDIUM |
| `/management/edit` | `/hr/rules/[id]/edit` | pattern | LOW |

### Change Types

- `prefix`: Add persona prefix
- `rename`: Change service name
- `param→path`: Convert query param to path segment
- `pattern`: Add RESTful pattern (new, [id], edit)
- `merge`: Combine multiple paths into one

---

## Next.js Implementation

### Redirects (next.config.js)

```javascript
module.exports = {
  async redirects() {
    return [
      // Permanent redirects for old paths
      {
        source: '/',
        destination: '/hr',
        permanent: true,
      },
      {
        source: '/attendance-records',
        destination: '/hr/attendance',
        permanent: true,
      },
      {
        source: '/leave-management',
        destination: '/hr/leave',
        permanent: true,
      },
      // Handle query param redirects
      {
        source: '/reports',
        has: [{ type: 'query', key: 'mode', value: 'hr' }],
        destination: '/hr/reports',
        permanent: true,
      },
    ];
  },
};
```

### Folder Structure (App Router)

```
app/
├── hr/
│   ├── page.tsx                 # /hr (dashboard)
│   ├── attendance/
│   │   └── page.tsx             # /hr/attendance
│   ├── leave/
│   │   ├── page.tsx             # /hr/leave (list)
│   │   ├── [id]/
│   │   │   ├── page.tsx         # /hr/leave/[id] (detail)
│   │   │   └── edit/
│   │   │       └── page.tsx     # /hr/leave/[id]/edit
│   │   └── new/
│   │       └── page.tsx         # /hr/leave/new
│   └── ...
├── employee/
│   ├── page.tsx                 # /employee (dashboard)
│   ├── leave/
│   │   ├── page.tsx             # /employee/leave
│   │   └── new/
│   │       └── page.tsx         # /employee/leave/new
│   └── ...
└── layout.tsx
```

---

## Verification Checklist

- [ ] All paths have persona prefix
- [ ] Service names are consistent (no -management, -records, -request suffix)
- [ ] Query params converted to path segments
- [ ] Dynamic routes follow [id] pattern
- [ ] Edit routes use [id]/edit pattern
- [ ] New/create routes use /new pattern
- [ ] Redirects configured for old paths
- [ ] All internal links updated
