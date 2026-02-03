# {{exception_category}} 예외 처리 명세

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 작성일 | {{date}} |
| 카테고리 | {{exception_category}} |
| 영향 범위 | {{affected_screens}} |

---

## 예외 처리 목록

{{#each exceptions}}
### EC-{{seq}}: {{title}}

#### 발생 조건
{{trigger_condition}}

#### 영향
- **화면**: {{affected_screens}}
- **컴포넌트**: {{affected_components}}
- **심각도**: {{severity}}

#### 처리 방법
{{handling_method}}

#### UI/UX
- **메시지**: "{{user_message}}"
- **액션**: {{available_actions}}
- **복구**: {{recovery_method}}

#### 테스트 케이스
| 입력 | 예상 결과 | Status |
|------|----------|--------|
{{#each test_cases}}
| {{input}} | {{expected}} | {{status}} |
{{/each}}

---

{{/each}}

## 공통 에러 처리

### 에러 코드
| 코드 | 설명 | 사용자 메시지 |
|------|------|--------------|
{{#each error_codes}}
| {{code}} | {{description}} | {{message}} |
{{/each}}

### 재시도 정책
| 에러 유형 | 재시도 횟수 | 대기 시간 | Backoff |
|----------|------------|----------|---------|
{{#each retry_policies}}
| {{error_type}} | {{max_retries}} | {{initial_delay}} | {{backoff}} |
{{/each}}

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
