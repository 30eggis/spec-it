# {{ProjectName}} - PRD (Product Requirements Document)

**최종 수정일**: {{YYYY-MM-DD}}
**버전**: {{Version}}
**문서 소유자**: {{Owner}}
**승인자**: {{Approver}}

---

## 1. 문서 목적
- 이 문서의 목적: {{Purpose}}
- 의사결정 범위: {{DecisionScope}}

## 2. 배경 및 문제 정의
- 배경: {{Background}}
- 문제(현재 상태): {{ProblemStatement}}
- 왜 지금인가: {{WhyNow}}
- 영향을 받는 사용자/조직: {{ImpactedUsersOrTeams}}

## 3. 목표와 비목표
### 3.1 목표(Goals)
- {{Goal1}}
- {{Goal2}}

### 3.2 비목표(Non-Goals)
- {{NonGoal1}}
- {{NonGoal2}}

## 4. 대상 사용자 및 니즈
- Primary 사용자: {{PrimaryPersona}}
  - 니즈: {{Needs}}
- Secondary 사용자: {{SecondaryPersona}}
  - 니즈: {{Needs}}

## 5. 성공 기준 (Success Metrics)
| 지표 | 정의 | 목표치 | 측정 주기 | 비고 |
|---|---|---:|---|---|
| {{Metric}} | {{Definition}} | {{Target}} | {{Cadence}} | {{Notes}} |

## 6. 범위 (Scope)
### 6.1 포함(In Scope)
- {{InScope1}}
- {{InScope2}}

### 6.2 제외(Out of Scope)
- {{OutScope1}}
- {{OutScope2}}

## 7. 요구사항 (Requirements)
> 모든 요구사항은 식별자(REQ-###)를 부여합니다.

### 7.1 기능 요구사항
- **REQ-001**: {{RequirementTitle}}
  - 설명: {{Description}}
  - 우선순위: {{P0/P1/P2}}
  - 수용 기준(AC):
    - [ ] {{AC1}}
    - [ ] {{AC2}}

- **REQ-002**: {{RequirementTitle}}
  - 설명: {{Description}}
  - 우선순위: {{P0/P1/P2}}
  - 수용 기준(AC):
    - [ ] {{AC1}}

### 7.2 비기능 요구사항 (NFR)
- 성능/반응성 요구: {{NFR_Performance}}
- 신뢰성/가용성 요구: {{NFR_Reliability}}
- 보안/프라이버시 요구: {{NFR_SecurityPrivacy}}
- 접근성/사용성 요구: {{NFR_AccessibilityUsability}}
- 운영/모니터링 요구(툴/구현 명시 금지): {{NFR_Observability}}

## 8. 사용자 시나리오 및 여정
- 시나리오 1: {{Scenario1}}
  - 기대 결과: {{ExpectedOutcome}}
- 시나리오 2: {{Scenario2}}
  - 기대 결과: {{ExpectedOutcome}}
- 엣지/예외 시나리오:
  - {{EdgeCase1}}

## 9. 정책/권한/규정 준수
- 역할/권한(개념 수준): {{RolesAndPermissions}}
- 데이터 취급 원칙: {{DataHandlingPrinciples}}
- 준수 필요 사항: {{ComplianceNotes}}

## 10. 콘텐츠/문구(필요 시)
- 주요 화면/기능 문구: {{KeyCopy}}
- 알림/에러 메시지 톤: {{ToneGuideline}}

## 11. 리스크 및 오픈 이슈
- 리스크: {{Risk}} / 대응: {{Mitigation}}
- 오픈 이슈(결정 필요): {{OpenQuestion}}

## 12. 문서 간 매핑 (Traceability)
- 관련 SPEC:
  - [ ] SPEC-01: {{SpecTitle}}
- 관련 Phase:
  - [ ] PHASE-01: {{PhaseTitle}}
- 비고: {{Notes}}
