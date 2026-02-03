# hack-2-spec Output Structure

Output structure for spec-it integration.

## Output Folder

**Location:** `{output}/hack-2-spec/`

번호 prefix 없이 간결한 폴더명 사용 (spec-it에서 재사용 용이).

## Standard Output Structure

```
{output}/hack-2-spec/
├── requirements/
│   └── requirements.md              # 요구사항 정의서
│
├── chapters/
│   └── chapter-plan.md              # 챕터 계획
│
├── wireframes/
│   ├── layouts/
│   │   └── layout-system.yaml       # 레이아웃 시스템
│   ├── domain-map.md                # 도메인 → 사용자 유형 매핑
│   ├── screen-list.md               # 전체 화면 목록 (점진적 로딩용)
│   └── <user-type>/<domain>/
│       └── wireframes/
│           └── {screen-id}.yaml     # 개별 화면 와이어프레임
│
├── persona/
│   └── personas.md                  # 사용자 페르소나 정의
│
└── components/
    ├── inventory.md                 # 컴포넌트 인벤토리
    └── specs/
        └── {ComponentName}.yaml     # 개별 컴포넌트 스펙
```

## Template References

| Output File | Template |
|-------------|----------|
| requirements.md | `shared/templates/common/00-REQUIREMENTS_TEMPLATE.md` |
| chapter-plan.md | `shared/templates/common/01-CHAPTER_PLAN_TEMPLATE.md` |
| personas.md | `shared/templates/common/01-PERSONA_TEMPLATE.md` |
| layout-system.yaml | `shared/templates/common/02-LAYOUT_SYSTEM_TEMPLATE.yaml` |
| domain-map.md | `shared/templates/common/02-DOMAIN_MAP_TEMPLATE.md` |
| screen-list.md | `shared/templates/common/02-SCREEN_LIST_TEMPLATE.md` |
| wireframes/*.yaml | `shared/templates/common/02-WIREFRAME_YAML_TEMPLATE.yaml` |
| inventory.md | `shared/templates/common/03-COMPONENT_INVENTORY_TEMPLATE.md` |
| specs/*.yaml | `shared/templates/common/02-COMPONENTS_YAML_TEMPLATE.yaml` |

## File Details

### requirements/requirements.md

요구사항 정의서 (REQ-### 형식).

```markdown
## REQ-DASH-001: Dashboard Overview
- REQ-DASH-001-01: Display real-time attendance stats
- REQ-DASH-001-02: Filter by date range
- REQ-DASH-001-03: Filter by organization
```

### persona/personas.md

사용자 유형 정의.

```markdown
| Role | Local Term | Description | Access Level |
|------|------------|-------------|--------------|
| HR Admin | HR 관리자 | 전사 근태 관리 | Full |
| Employee | 직원 | 개인 근태 조회 | Limited |
```

### wireframes/screen-list.md

전체 화면 목록 (점진적 로딩을 위한 인덱스).

```markdown
| ID | Screen Name | Route | User Type | Domain |
|----|-------------|-------|-----------|--------|
| SCR-HR-001 | HR Dashboard | /dashboard | hr-admin | dashboard |
| SCR-EMP-001 | Employee Dashboard | /emp/dashboard | employee | dashboard |
```

### wireframes/<user-type>/<domain>/wireframes/{screen-id}.yaml

개별 화면 와이어프레임.

```yaml
id: "SCR-HR-001"
name: "HR Dashboard"
route: "/dashboard"
type: "page"
priority: "P0"
accessLevel: "hr-admin"

layout:
  type: "dashboard-with-sidebar"
  main:
    padding: "p-6"
    maxWidth: "max-w-7xl"

grid:
  desktop:
    areas: |
      "header header header"
      "stats stats stats"
      "widget1 widget2 widget3"
    columns: "1fr 1fr 1fr"
    gap: "gap-6"

components:
  - id: "stat-cards"
    type: "StatCardGrid"
    zone: "stats"
    props:
      items:
        - label: "출근 인원"
          icon: "Users"
          color: "blue"
        - label: "지각 인원"
          icon: "Clock"
          color: "amber"

interactions:
  clicks:
    - element: "stat-card"
      action: "navigate"
      target: "/attendance-records"

states:
  loading:
    type: "skeleton"
  error:
    showAlert: true
```

### components/specs/{ComponentName}.yaml

개별 컴포넌트 스펙.

```yaml
id: "CMP-DATA-002"
name: "DataTable"
category: "data-display"
description: "데이터 테이블 (정렬, 선택, 페이지네이션)"

props:
  - name: "columns"
    type: "Column[]"
    required: true
  - name: "data"
    type: "any[]"
    required: true
  - name: "selectable"
    type: "boolean"
    default: false
  - name: "pagination"
    type: "PaginationConfig"

variants:
  - name: "default"
  - name: "selectable"
  - name: "compact"

states:
  - name: "loading"
  - name: "empty"
  - name: "error"

styles:
  container: "overflow-x-auto"
  header: "bg-slate-50 sticky top-0"
  cell: "px-4 py-3 text-sm"
```

## Minimum File Count

| Category | Minimum Files |
|----------|---------------|
| requirements/ | 1 |
| chapters/ | 1 |
| persona/ | 1 |
| wireframes/ (base) | 3 (layouts, domain-map, screen-list) |
| wireframes/ (screens) | N (one per screen) |
| components/ | 1 + M (inventory + specs) |

**Total minimum:** 7 + N + M files

## Integration with spec-it

```
hack-2-spec output → {project}/hack-2-spec/
                            ↓
                     spec-it --source hack-2-spec/
                            ↓
                     Continues from existing specs
```
