# State Schema

State is tracked via `_meta.json` and `_status.json` in `.spec-it/{sessionId}/execute/`.

## Core Fields

- sessionId
- mode
- specSource
- currentPhase / currentStep
- qaAttempts / maxQaAttempts
- mirrorAttempts / maxMirrorAttempts
- scenarioAttempts / maxScenarioAttempts
- lastMirrorReport

## Execute Mode Fields

- `executeMode` - "wireframe" | "baseproject". 작업 유형. wireframe은 신규 개발, baseproject는 기존 프로젝트 리팩토링.
- `specFolder` - spec 산출물 폴더 경로. spec-map.md가 위치한 디렉토리.
- `specTopics` - spec-map.md의 Cross-References 테이블에서 추출한 토픽 디렉토리 맵. 예: `{"analysis": "00-analysis/", "wireframes": "02-wireframes/", ...}`
- `projectSourcePath` - 기존 프로젝트 원본 경로 (baseproject 모드에서만 사용, wireframe이면 빈 문자열)
- `projectWorkDir` - 실제 코드 작업 디렉토리. `{workDir}/spec-it-execute/` 경로.
- `dashboardEnabled` - 항상 true. Dashboard는 자동 활성화.
