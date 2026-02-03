# {{system_name}} - 페르소나 정의서

## 문서 정보
| 항목 | 내용 |
|------|------|
| 시스템명 | {{system_name}} |
| 작성일 | {{date}} |
| 버전 | {{version}} |

---

## PER-001: {{persona_name}} ({{persona_role}})

### 프로필
| 항목 | 내용 |
|------|------|
| 역할 | {{role_description}} |
| 주요 권한 | {{permissions}} |
| 사용 빈도 | {{usage_frequency}} |
| 기술 수준 | {{tech_level}} |

### 목표 (Goals)
1. {{goal_1}}
2. {{goal_2}}
3. {{goal_3}}

### 불편점 (Pain Points)
- {{pain_point_1}}
- {{pain_point_2}}
- {{pain_point_3}}

### 주요 사용 화면
- {{screen_1}} ({{screen_1_file}})
- {{screen_2}} ({{screen_2_file}})
- {{screen_3}} ({{screen_3_file}})

---

{{#each additional_personas}}
## PER-{{seq}}: {{name}} ({{role}})

### 프로필
| 항목 | 내용 |
|------|------|
| 역할 | {{role_description}} |
| 주요 권한 | {{permissions}} |
| 사용 빈도 | {{usage_frequency}} |
| 기술 수준 | {{tech_level}} |

### 목표 (Goals)
{{#each goals}}
{{@index}}. {{this}}
{{/each}}

### 불편점 (Pain Points)
{{#each pain_points}}
- {{this}}
{{/each}}

### 주요 사용 화면
{{#each screens}}
- {{name}} ({{file}})
{{/each}}

---
{{/each}}

## 페르소나 우선순위 매트릭스

| 순위 | 페르소나 | 사용자 수 | 사용 빈도 | 비즈니스 영향 |
|------|----------|-----------|-----------|---------------|
| 1 | PER-{{top_priority_id}}: {{top_priority_name}} | {{user_count}} | {{frequency}} | {{impact}} |
{{#each priority_matrix}}
| {{rank}} | PER-{{id}}: {{name}} | {{user_count}} | {{frequency}} | {{impact}} |
{{/each}}

---

## 기능별 페르소나 매핑

| 기능 | {{persona_1_name}} | {{persona_2_name}} | {{persona_3_name}} |
|------|-----------|------|-----------|
| {{feature_1}} | {{p1_access}} | {{p2_access}} | {{p3_access}} |
| {{feature_2}} | {{p1_access}} | {{p2_access}} | {{p3_access}} |
| {{feature_3}} | {{p1_access}} | {{p2_access}} | {{p3_access}} |

**범례:** ● 주요 기능 / ○ 보조 기능 / - 접근 불가
