import { Prompt } from "@modelcontextprotocol/sdk/types.js";

export const prompts: Prompt[] = [
  {
    name: "generate_spec",
    description: "Generate a frontend specification from requirements",
    arguments: [
      {
        name: "requirements",
        description: "The requirements or PRD to convert to spec",
        required: true,
      },
      {
        name: "mode",
        description: "Generation mode: automation, complex, stepbystep, fast",
        required: false,
      },
      {
        name: "design_style",
        description: "Design style: Minimal, Immersive, Organic, Custom",
        required: false,
      },
    ],
  },
  {
    name: "execute_spec",
    description: "Execute implementation from a generated spec",
    arguments: [
      {
        name: "spec_folder",
        description: "Path to the spec folder (usually tmp/)",
        required: true,
      },
    ],
  },
  {
    name: "change_spec",
    description: "Apply a change to existing spec with validation",
    arguments: [
      {
        name: "session_id",
        description: "Session ID of the existing spec",
        required: true,
      },
      {
        name: "change_request",
        description: "Description of the change to apply",
        required: true,
      },
    ],
  },
  {
    name: "compare_spec",
    description: "Compare spec against implementation (spec-mirror)",
    arguments: [
      {
        name: "session_id",
        description: "Session ID to compare",
        required: true,
      },
    ],
  },
];

export function handleGetPrompt(
  name: string,
  args: Record<string, string>
): { messages: { role: "user"; content: { type: "text"; text: string } }[] } {
  switch (name) {
    case "generate_spec":
      return generateSpecPrompt(
        args.requirements || "",
        args.mode || "automation",
        args.design_style || "Minimal"
      );

    case "execute_spec":
      return executeSpecPrompt(args.spec_folder || "tmp");

    case "change_spec":
      return changeSpecPrompt(
        args.session_id || "",
        args.change_request || ""
      );

    case "compare_spec":
      return compareSpecPrompt(args.session_id || "");

    default:
      return {
        messages: [
          {
            role: "user",
            content: { type: "text", text: `Unknown prompt: ${name}` },
          },
        ],
      };
  }
}

function generateSpecPrompt(
  requirements: string,
  mode: string,
  designStyle: string
): { messages: { role: "user"; content: { type: "text"; text: string } }[] } {
  const modeDescriptions: Record<string, string> = {
    automation: "Full automation with minimal approvals. Auto-executes after spec generation.",
    complex: "4 milestone approvals with hybrid automation.",
    stepbystep: "Chapter-by-chapter approvals for maximum control.",
    fast: "Rapid prototype mode - skips brainstorm and tests.",
  };

  const text = `# Frontend Specification Generation Request

## Mode: ${mode}
${modeDescriptions[mode] || ""}

## Design Style: ${designStyle}

## Requirements
${requirements}

---

## Instructions

Please use the spec-it MCP server to generate a frontend specification:

1. Call \`spec_generate\` with:
   - requirements: (the requirements above)
   - mode: "${mode}"
   - designStyle: "${designStyle}"

2. Follow the orchestration workflow returned by the tool

3. The workflow will:
   - Phase 1: Design Brainstorming (requirements, alternatives, critique)
   - Phase 2: UI + Components (wireframes, component specs)
   - Phase 3: Critical Review (scenarios, ambiguities)
   - Phase 4: Test Specification (personas, test specs)
   - Phase 5: Final Assembly (final-spec.md, dev-tasks.md)
   ${mode === "automation" || mode === "fast" ? "- Phase 6: Auto-Execute (implementation)" : ""}

4. Output will be in tmp/ folder:
   - 00-requirements/
   - 01-chapters/
   - 02-wireframes/
   - 03-components/
   - 04-review/
   - 05-tests/
   - 06-final/
`;

  return {
    messages: [
      {
        role: "user",
        content: { type: "text", text },
      },
    ],
  };
}

function executeSpecPrompt(
  specFolder: string
): { messages: { role: "user"; content: { type: "text"; text: string } }[] } {
  const text = `# Spec Implementation Request

## Spec Folder: ${specFolder}

---

## Instructions

Please use the spec-it MCP server to implement the specification:

1. Call \`spec_execute\` with:
   - specFolder: "${specFolder}"

2. The execution will follow 9 phases:
   - Phase 0-2: Init & Load (load spec, generate execution plan)
   - Phase 3: Execute (implement code in batches)
   - Phase 4: QA (quality verification - HARD GATE)
   - Phase 5: Spec-Mirror (compare spec vs implementation)
   - Phase 6: Unit Tests (implement unit tests)
   - Phase 7: E2E Tests (implement integration tests)
   - Phase 8: Validate (final validation)
   - Phase 9: Complete

3. Critical rules:
   - No phase skipping
   - QA, Spec-Mirror, E2E are hard gates
   - Use status-update.sh for progress tracking
`;

  return {
    messages: [
      {
        role: "user",
        content: { type: "text", text },
      },
    ],
  };
}

function changeSpecPrompt(
  sessionId: string,
  changeRequest: string
): { messages: { role: "user"; content: { type: "text"; text: string } }[] } {
  const text = `# Spec Change Request

## Session: ${sessionId}
## Change Request: ${changeRequest}

---

## Instructions

Please use the spec-it MCP server to apply the change safely:

1. Call \`spec_change\` with:
   - sessionId: "${sessionId}"
   - changeRequest: "${changeRequest}"

2. The change will go through 6 validators:
   - spec-butterfly: Analyze ripple effects (impact analysis)
   - spec-doppelganger: Check for duplicate concepts
   - spec-conflict: Detect contradictions with existing spec
   - spec-clarity: QuARS clarity measurement
   - spec-consistency: Terminology consistency check
   - spec-coverage: Edge case analysis

3. Only after all validators pass will the change be applied

4. Affected documents will be updated automatically
`;

  return {
    messages: [
      {
        role: "user",
        content: { type: "text", text },
      },
    ],
  };
}

function compareSpecPrompt(
  sessionId: string
): { messages: { role: "user"; content: { type: "text"; text: string } }[] } {
  const text = `# Spec vs Implementation Comparison

## Session: ${sessionId}

---

## Instructions

Please use the spec-it MCP server to compare the spec against implementation:

1. Call \`spec_mirror\` with:
   - sessionId: "${sessionId}"

2. The comparison will check:
   - Wireframe vs actual UI
   - Component spec vs implementation
   - Test spec vs actual tests
   - API contracts vs usage

3. Output: Drift report with severity levels
   - Critical: Major divergence requiring immediate attention
   - Warning: Minor drift that should be addressed
   - Info: Documentation differences
`;

  return {
    messages: [
      {
        role: "user",
        content: { type: "text", text },
      },
    ],
  };
}
