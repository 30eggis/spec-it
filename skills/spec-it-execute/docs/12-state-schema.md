# State Schema

State is tracked via `_meta.json` and `_status.json` in `.spec-it/{sessionId}/execute/`.

Key fields:

- sessionId
- mode
- specSource
- currentPhase / currentStep
- qaAttempts / maxQaAttempts
- mirrorAttempts / maxMirrorAttempts
- scenarioAttempts / maxScenarioAttempts
- lastMirrorReport
