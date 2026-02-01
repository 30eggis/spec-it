---
name: spec-component-loader
description: "Progressive component spec loader with category and dependency filters."
allowed-tools: Read, Glob, Grep
argument-hint: "<spec-folder> [--list] [--category <layout|display|cards|forms|...>] [--name <ComponentName>] [--with-deps] [--gap]"
permissionMode: bypassPermissions
---

# spec-component-loader

컴포넌트 스펙을 점진적으로 로딩하여 Agent의 컨텍스트를 효율적으로 관리합니다.

## 사용 목적

- 컴포넌트 스펙이 많으면 Agent 호출 시 컨텍스트 초과 위험
- 필요한 컴포넌트만 점진적으로 로딩
- 의존성 그래프를 고려한 효율적인 구현 순서 제공

## 사용법

### 전체 컴포넌트 목록

```
/spec-component-loader {spec-folder} --list
```

**출력:** 카테고리별 목록 + 의존성 요약 테이블

### 카테고리별 로딩

```
/spec-component-loader {spec-folder} --category layout
/spec-component-loader {spec-folder} --category cards
/spec-component-loader {spec-folder} --category display
/spec-component-loader {spec-folder} --category forms
```

**출력:** 해당 카테고리의 모든 컴포넌트 스펙 전체 내용

### 특정 컴포넌트 로딩

```
/spec-component-loader {spec-folder} --name StockCard
/spec-component-loader {spec-folder} --name PriceDisplay
```

**출력:** 해당 컴포넌트의 스펙 전체 내용

### 의존성 포함 로딩

```
/spec-component-loader {spec-folder} --name StockCard --with-deps
```

**출력:** 의존성 트리 + 의존성 우선 순서로 스펙 출력

### Gap Analysis (미구현 컴포넌트)

```
/spec-component-loader {spec-folder} --gap
```

**출력:** 미구현 컴포넌트 목록 + 우선순위/의존성 기반 구현 순서

## Spec 폴더 구조

- `{spec-folder}/03-components/component-inventory.md`
- `{spec-folder}/03-components/gap-analysis.md`
- `{spec-folder}/03-components/specs/{category}/{Component}.{yaml|md}`

## Format Detection

The loader auto-detects spec format by file extension:

| Extension | Format | Priority |
|-----------|--------|----------|
| `.yaml` | YAML (structured) | **Preferred** |
| `.md` | Markdown (legacy) | Fallback |

When both formats exist for a component, YAML takes precedence.

## 로딩 로직

### --list 모드

```
1. Read: {spec-folder}/03-components/component-inventory.md
2. Glob: {spec-folder}/03-components/specs/**/*.{yaml,md}
3. 각 파일에서 메타데이터 추출 (YAML: direct parse, MD: regex)
4. 카테고리별, 의존성 요약 생성
```

### --category 모드

```
1. Glob: {spec-folder}/03-components/specs/{category}/*.{yaml,md}
2. YAML 파일 우선, MD fallback
3. 모든 파일 내용 Read
4. 통합 출력
```

### --name 모드

```
1. Glob: {spec-folder}/03-components/specs/**/{name}.yaml (preferred)
2. Fallback: Glob: {spec-folder}/03-components/specs/**/{name}.md
3. Read 해당 파일
4. 출력
```

### --with-deps 모드

```
1. --name으로 대상 컴포넌트 로딩
2. 스펙에서 의존성 파싱:
   - YAML: dependencies.internal[].name
   - MD: "Dependencies:" 섹션
3. 각 의존성 재귀적으로 로딩 (순환 참조 방지)
4. 토폴로지 정렬하여 출력 (의존성 먼저)
```

### --gap 모드

```
1. Read: {spec-folder}/03-components/gap-analysis.md
2. 또는 동적 분석:
   - 스펙에 정의된 컴포넌트 목록 (*.yaml + *.md)
   - 실제 구현된 컴포넌트 (src/components/**/*.tsx)
   - 차집합 계산
3. 구현 순서 권장 (의존성 고려)
```

## Output Notes

- YAML 우선, MD fallback
- 로딩 결과는 Markdown으로 반환

## 관련 Skill

- `spec-test-loader`: 테스트 계획서 로딩
- `spec-scenario-loader`: 시나리오 계획서 로딩
- `spec-it-execute`: Phase 3, 5에서 이 skill 사용
