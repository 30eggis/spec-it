# Mock Server Auto-Generation

## 트리거 조건

- `{specFolder}/dev-plan/api-map.md` 파일 존재 시 자동 활성화
- `_meta.mockServerEnabled = true`

## 병렬 라인 아키텍처

UI와 API는 독립 라인으로 병렬 실행, Phase 7에서 합류:

```
Phase 3~6:
  Line A (UI):  3A → 4A → 5A → 6A  (인라인 mock 데이터로 독립 동작)
  Line B (API): 3B → 4B → 6B       (api-map.md 기반 독립 구축)

Phase 7 (E2E): 합류
  - NEXT_PUBLIC_API_URL로 프론트→mock-server 연결
  - Playwright webServer 배열로 dual-server 기동
```

### Line A (UI) - 기존과 동일

- dev-pilot이 프론트엔드 페이지 구현
- 인라인 mock 데이터 또는 Next.js Route Handler 사용
- spec-mirror, unit test 독립 수행

### Line B (API) - 신규

- dev-pilot이 mock-server/ 구축
- api-map.md 기반 Fastify + SQLite 서버
- 5A (spec-mirror) 불필요 → 스킵
- 자체 typecheck + seed + health + unit test

## Tech Stack

| 항목 | 선택 | 이유 |
|------|------|------|
| Framework | Fastify 5 | 빠른 시작, 플러그인 아키텍처 |
| Database | better-sqlite3 + Drizzle ORM | SQL 필터/페이징, 파일 영속성, 리셋 용이 |
| Data Gen | @faker-js/faker + 커스텀 사전 | 로케일 맞춤 데이터 |

## 출력 경로

```
{projectWorkDir}/mock-server/
```

## 디렉토리 구조

```
mock-server/
  package.json
  tsconfig.json
  drizzle.config.ts
  data/              # .db 파일 (gitignored)
  src/
    index.ts         # 서버 진입점 (port 4000)
    app.ts           # Fastify 앱 팩토리
    db/
      schema.ts      # Drizzle 테이블 (api-map.md 기반)
      connection.ts
    seed/
      index.ts       # 시드 오케스트레이터
      dictionaries/  # 도메인 사전 (이름, 부서, 직급 등)
      generators/    # 엔티티별 생성기
    routes/          # api-map.md 도메인별 라우트
    middleware/       # auth mock, pagination
    utils/           # response wrapper, query helpers
```

## DB Schema 생성 규칙

- api-map.md의 Response 타입에서 엔티티 추출
- Common Types 섹션에서 공유 타입 추출
- 관계형 스키마로 변환 (1:N, N:M)
- `version`, `createdAt`, `updatedAt` 필드 자동 포함

## Seed Data 규칙

- `faker.seed(고정값)` → 결정적 시드 (E2E 안정성)
- 엔티티당 목표:
  - 마스터 데이터 (부서, 직급 등): 실제 수량
  - 사용자: ~50명
  - 트랜잭션 데이터: ~1000건 (페이징 테스트 가능)
- FK 무결성: 시드 순서 = 부모 → 자식
- 로케일: spec 언어에 맞춤 (한국어 spec → 한국어 데이터)

## API 라우트 생성 규칙

- api-map.md의 각 endpoint → Fastify 라우트로 1:1 매핑
- 프론트엔드 호환: 경로 차이 시 alias 등록
- 표준 응답 래퍼: `{ success, data, pagination?, meta? }`
- 페이징: `page`, `pageSize` 쿼리 파라미터 → SQL LIMIT/OFFSET
- 필터: 쿼리 파라미터 → SQL WHERE
- 정렬: `sortBy`, `sortOrder` → SQL ORDER BY

## Line B 검증 (Phase 4B)

1. `cd mock-server && npx tsc --noEmit` (typecheck)
2. `cd mock-server && npm run seed:reset` (DB 생성 + 시드)
3. 서버 기동 → `GET /api/health` → 200 확인
4. curl 기본 endpoint 스모크 테스트

## Line B 단위 테스트 (Phase 6B)

- 각 라우트 핸들러 단위 테스트
- 시드 데이터 무결성 테스트
- 페이징/필터 동작 테스트

## E2E 합류 (Phase 7)

```typescript
// playwright.config.ts
webServer: [
  {
    command: 'cd mock-server && npm run seed:reset && npm run dev',
    port: 4000,
    reuseExistingServer: !process.env.CI,
  },
  {
    command: 'npm run dev',
    port: 3000,
    reuseExistingServer: !process.env.CI,
    env: { NEXT_PUBLIC_API_URL: 'http://localhost:4000/api' },
  },
]
```

테스트 격리: `POST /api/__admin/reset-db` → beforeAll에서 DB 초기화

## 루트 package.json 스크립트 추가

```json
{
  "scripts": {
    "mock:dev": "cd mock-server && npm run dev",
    "mock:seed": "cd mock-server && npm run seed:reset",
    "dev:full": "concurrently \"npm run dev\" \"npm run mock:dev\""
  }
}
```

## Hard Gate 회귀

Line B 실패 시에도 Phase 3으로 회귀:

| 실패 Phase | 생성 파일 | 회귀 |
|-----------|----------|------|
| 4B | mock-server-fix-tasks.json | → dev-pilot fix mode (Line B only) |
| 6B | mock-server-test-fix-tasks.json | → dev-pilot fix mode (Line B only) |

Line A/B 각각 독립적으로 회귀 처리. 한 라인의 실패가 다른 라인에 영향 없음.
