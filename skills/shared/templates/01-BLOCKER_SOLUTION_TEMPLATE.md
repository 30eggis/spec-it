# Blocker {{blocker_id}}: {{title}}

## 문서 정보
| 항목 | 내용 |
|------|------|
| 문서 ID | BLOCKER-{{blocker_id}} |
| 제목 | {{title}} |
| 작성일 | {{date}} |
| 버전 | {{version}} |
| 관련 페르소나 | {{related_personas}} |

---

## 1. 개요

### 1.1 목적
{{purpose}}

### 1.2 설계 원칙
{{#each design_principles}}
{{@index}}. **{{title}}**: {{description}}
{{/each}}

---

## 2. 정의

### 2.1 기본 프로필
| 항목 | 내용 |
|------|------|
{{#each profile_items}}
| {{label}} | {{value}} |
{{/each}}

### 2.2 특징
{{#each characteristics}}
- **{{title}}**: {{description}}
{{/each}}

---

## 3. 상세 명세

{{#each specification_sections}}
### 3.{{@index}} {{title}}

{{content}}

{{/each}}

---

## 4. 구현 가이드

### 4.1 코드 예시

```{{code_language}}
{{code_example}}
```

### 4.2 체크리스트

{{#each implementation_checklist}}
- [ ] {{this}}
{{/each}}

---

## 5. 예외 사례 및 해결 방안

{{#each exceptions}}
### 5.{{@index}} {{scenario}}

#### 시나리오
{{description}}

#### 해결 방안
{{solution}}

{{/each}}

---

## 6. 테스트 시나리오

| 테스트 ID | 테스트 시나리오 | 기대 결과 |
|----------|---------------|----------|
{{#each test_scenarios}}
| {{id}} | {{scenario}} | {{expected_result}} |
{{/each}}

---

## 7. FAQ

{{#each faqs}}
### Q{{@index}}. {{question}}
**A.** {{answer}}

{{/each}}

---

## 8. 관련 문서

| 문서명 | 경로 | 설명 |
|--------|------|------|
{{#each related_documents}}
| {{name}} | {{path}} | {{description}} |
{{/each}}

---

## 9. 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |

---

**문서 종료**
