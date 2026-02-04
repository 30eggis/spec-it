# Progressive Generation Reference

hack-2-spec의 점진적 생성 방식에 대한 상세 참조 문서.

---

## 1. Core Concept

**매 화면을 읽을 때마다 병렬로 3가지 질문에 답하고 즉시 파일 작성:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FOR EACH SCREEN ANALYZED                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  화면 읽기 (Chrome snapshot 또는 Code analysis)                          │
│                           │                                              │
│                           ▼                                              │
│   ┌───────────────────────────────────────────────────────────────┐     │
│   │              PARALLEL GENERATION (3 Task Agents)               │     │
│   ├───────────────────┬───────────────────┬───────────────────────┤     │
│   │                   │                   │                       │     │
│   │  Q1: 어떤 서비스?  │  Q2: 누구를 위한? │  Q3: 어떻게 생김?     │     │
│   │    (Service)      │     (User)        │   (Wireframe)         │     │
│   │                   │                   │                       │     │
│   │  - 이 화면이       │  - 이 화면을      │  - 레이아웃 구조      │     │
│   │    제공하는 기능   │    사용하는 역할  │  - 그리드/플렉스      │     │
│   │  - 사용자 스토리   │  - 접근 권한      │  - 컴포넌트 배치      │     │
│   │  - 도메인 요구사항 │  - 주요 태스크    │  - 인터랙션 정의      │     │
│   │                   │                   │                       │     │
│   └─────────┬─────────┴─────────┬─────────┴───────────┬───────────┘     │
│             │                   │                     │                  │
│             ▼                   ▼                     ▼                  │
│   ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────────┐       │
│   │ requirements.md │ │  personas.md    │ │ {screen-id}.yaml    │       │
│   │    (APPEND)     │ │    (APPEND)     │ │    (CREATE)         │       │
│   └─────────────────┘ └─────────────────┘ └─────────────────────┘       │
│                                                                          │
│   ※ Context 압축/리프레쉬 대비: 즉시 파일 저장                           │
│   ※ 중단되어도 이미 작성된 파일은 유지됨                                 │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Why Progressive Generation?

1. **Context 압축 대비**: 화면별로 즉시 파일 저장 → 중단되어도 이미 작성된 파일 유지
2. **리프레쉬 대비**: 부분 완료 상태에서 재개 가능
3. **병렬 처리**: 3가지 질문을 동시에 처리하여 효율성 향상
4. **점진적 피드백**: 사용자가 진행 상황 실시간 확인 가능

---

## 3. Parallel Task Execution

**각 화면 분석 후 즉시 3개의 Task agent를 병렬 실행:**

```python
# Pseudocode - 실제로는 Task tool calls로 구현
for screen in discovered_screens:
    # 1. 화면 분석 (Chrome snapshot or Code read)
    screen_data = analyze_screen(screen)

    # 2. 병렬로 3가지 생성 (한번에 3개 Task tool call)
    Task(
        subagent_type="general-purpose",
        prompt=f"""
        Q1: 이 화면이 제공하는 서비스/기능은?
        Screen: {screen_data}
        → APPEND to requirements/requirements.md
        Template: shared/templates/common/00-REQUIREMENTS_TEMPLATE.md
        """
    )
    Task(
        subagent_type="general-purpose",
        prompt=f"""
        Q2: 이 화면은 누구를 위한 것인가?
        Screen: {screen_data}
        → APPEND to persona/personas.md
        Template: shared/templates/common/01-PERSONA_TEMPLATE.md
        """
    )
    Task(
        subagent_type="general-purpose",
        prompt=f"""
        Q3: 이 화면의 와이어프레임은?
        Screen: {screen_data}
        Design Context: {design_tokens}
        → CREATE wireframes/<user-type>/<domain>/wireframes/{screen.id}.yaml
        Template: shared/templates/common/02-WIREFRAME_YAML_TEMPLATE.yaml
        """
    )
    # 3개 Task 동시 실행 후 다음 화면으로
```

---

## 4. Q1: Requirements Extraction (APPEND)

**File:** `requirements/requirements.md`
**Template:** `shared/templates/common/00-REQUIREMENTS_TEMPLATE.md`

화면별로 추출하여 append:
- [ ] 화면 제목에서 기능 목적 추출
- [ ] 컴포넌트에서 사용자 스토리 유추 (US-{ROLE}-###)
- [ ] 인터랙션에서 기능 요구사항 추출 (REQ-{DOMAIN}-###)
- [ ] 폼/입력에서 데이터 요구사항 파악

**APPEND 형식:**
```markdown
<!-- Screen: {screen-id} -->
### {domain-name}

#### User Stories
- US-{ROLE}-001: As a {role}, I want to {action} so that {benefit}

#### Requirements
- REQ-{DOMAIN}-001: {requirement description}
<!-- End: {screen-id} -->
```

---

## 5. Q2: Persona Identification (APPEND)

**File:** `persona/personas.md`
**Template:** `shared/templates/common/01-PERSONA_TEMPLATE.md`

화면별로 추출하여 append:
- [ ] 접근 레벨에서 역할 식별
- [ ] 화면 기능에서 주요 태스크 추출
- [ ] 네비게이션에서 접근 패턴 파악

**APPEND 형식:**
```markdown
<!-- Screen: {screen-id} -->
### {user-type} Tasks (from {screen-name})
- Task: {task description}
- Access: {access level}
<!-- End: {screen-id} -->
```

---

## 6. Q3: Wireframe Generation (CREATE)

**Location:** `wireframes/<user-type>/<domain>/wireframes/{screen-id}.yaml`
**Template:** `shared/templates/common/02-WIREFRAME_YAML_TEMPLATE.yaml`

화면별로 새 파일 생성:

```yaml
# Example: wireframes/hr-admin/dashboard/wireframes/SCR-HR-001.yaml
id: "SCR-HR-001"
name: "HR Dashboard"
route: "/dashboard"
type: "page"
priority: "P0"
accessLevel: "hr-admin"

layout:
  type: "dashboard-with-sidebar"

grid:
  desktop:
    columns: 2
    ratio: "1:1"

components:
  - id: "stat-cards"
    type: "StatCardGrid"

interactions:
  # ... interaction details

states:
  # ... state definitions
```

---

## 7. Finalize Phase (After All Screens)

모든 화면 처리 완료 후 요약 파일들 생성:

### 7.1 Consolidate Appended Files

화면별로 append된 내용을 정리:
1. 중복 제거
2. ID 정규화 (순차 번호 부여)
3. 우선순위 정렬 (P0 > P1 > P2)
4. 프로젝트 개요 추가

### 7.2 Generate Summary Files

| File | Description |
|------|-------------|
| `chapters/chapter-plan.md` | 전체 화면 분석 후 생성 |
| `wireframes/domain-map.md` | 전체 도메인 매핑 |
| `wireframes/screen-list.md` | 전체 화면 목록 |
| `wireframes/layouts/layout-system.yaml` | 공통 레이아웃 추출 |
| `components/inventory.md` | 컴포넌트 인벤토리 |
| `components/specs/*.yaml` | 컴포넌트 스펙 |

---

## 8. File Generation Timing

| Category | File | When | Method |
|----------|------|------|--------|
| **즉시 생성 (Per Screen)** ||||
| Wireframes | `wireframes/**/wireframes/*.yaml` | Step 3 | CREATE |
| Requirements | `requirements/requirements.md` | Step 3 | APPEND |
| Persona | `persona/personas.md` | Step 3 | APPEND |
| **후처리 (After All)** ||||
| Chapters | `chapters/chapter-plan.md` | Step 4 | CREATE |
| Wireframes | `wireframes/layouts/*.yaml` | Step 4 | CREATE |
| Wireframes | `wireframes/domain-map.md` | Step 4 | CREATE |
| Wireframes | `wireframes/screen-list.md` | Step 4 | CREATE |
| Components | `components/inventory.md` | Step 4 | CREATE |
| Components | `components/specs/*.yaml` | Step 4 | CREATE |
