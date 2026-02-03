# {{role_name}} 페르소나

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 작성일 | {{date}} |
| 대상 역할 | {{role_name}} ({{role_name_en}}) |

---

{{#each personas}}
## Persona {{@index}}: {{persona_title}} ({{name}})

### 기본 정보
- **이름**: {{name}}
- **나이**: {{age}}세
- **직책**: {{title}}
- **경력**: {{experience}}
- **근무 환경**: {{work_environment}}
- **디바이스**: {{devices}}
- **기술 수준**: {{tech_level}}

### 업무 패턴
- **주요 업무**:
{{#each main_tasks}}
  - {{this}}
{{/each}}

- **사용 빈도**: {{usage_frequency}}
- **주요 사용 시간대**:
{{#each peak_times}}
  - {{time}} ({{activity}})
{{/each}}

- **사용 화면**:
{{#each screens}}
  - {{name}} ({{note}})
{{/each}}

### 행동 특성
{{#each behaviors}}
- {{this}}
{{/each}}

### 핵심 니즈
{{#each needs}}
{{@index}}. **{{title}}**: {{description}}
{{/each}}

### 불만 사항
{{#each complaints}}
- {{this}}
{{/each}}

### 목표 달성 시나리오
{{#each goal_scenarios}}
- "{{this}}"
{{/each}}

### 테스트 시나리오 연관성
| 시나리오 ID | 연관도 | 비고 |
|------------|-------|------|
{{#each test_scenarios}}
| {{id}} | {{relevance}} | {{note}} |
{{/each}}

### 특이 사항
{{#each special_notes}}
- {{this}}
{{/each}}

---
{{/each}}

## 페르소나별 테스트 우선순위

{{#each personas}}
### {{persona_title}} ({{name}})
{{#each test_priorities}}
{{@index}}. {{this}}
{{/each}}

{{/each}}

---

## 공통 테스트 체크리스트

### 모든 {{role_name}}에게 필수
{{#each common_checklist}}
- [ ] {{this}}
{{/each}}

{{#if advanced_checklist}}
### 고급 사용자 전용
{{#each advanced_checklist}}
- [ ] {{this}}
{{/each}}
{{/if}}

{{#if executive_checklist}}
### 임원 전용
{{#each executive_checklist}}
- [ ] {{this}}
{{/each}}
{{/if}}

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
