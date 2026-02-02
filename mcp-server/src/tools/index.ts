import { Tool } from "@modelcontextprotocol/sdk/types.js";
import { exec } from "child_process";
import { promisify } from "util";
import { readFile, readdir } from "fs/promises";
import { join } from "path";
import { existsSync } from "fs";
import {
  initSession,
  updateStatus,
  saveCheckpoint,
  loadSessionMeta,
  loadSessionStatus,
  listSessions,
  getSessionInfo,
} from "../utils/session.js";
import { SKILLS_DIR, getTmpDir } from "../utils/paths.js";

const execAsync = promisify(exec);

// Tool definitions
export const tools: Tool[] = [
  {
    name: "spec_generate",
    description:
      "Generate frontend specification from requirements. Creates wireframes, component specs, and test specs automatically.",
    inputSchema: {
      type: "object" as const,
      properties: {
        requirements: {
          type: "string",
          description: "The requirements or PRD to generate spec from",
        },
        mode: {
          type: "string",
          enum: ["automation", "complex", "stepbystep", "fast"],
          description:
            "Generation mode: automation (full auto), complex (4 milestones), stepbystep (chapter approvals), fast (prototype)",
          default: "automation",
        },
        designStyle: {
          type: "string",
          enum: ["Minimal", "Immersive", "Organic", "Custom"],
          description: "Design style to apply",
          default: "Minimal",
        },
        designTrends: {
          type: "array",
          items: { type: "string" },
          description:
            "Design trends to apply (for Custom style): Dark Mode+, Light Skeuomorphism, Glassmorphism, Micro-Animations, 3D Visuals, Gamification",
        },
        workDir: {
          type: "string",
          description:
            "Working directory for output (defaults to current directory)",
        },
        dashboard: {
          type: "boolean",
          description: "Enable web dashboard for progress tracking",
          default: true,
        },
      },
      required: ["requirements"],
    },
  },
  {
    name: "spec_execute",
    description:
      "Execute implementation from generated spec. Converts spec files into working code.",
    inputSchema: {
      type: "object" as const,
      properties: {
        specFolder: {
          type: "string",
          description: "Path to spec folder (usually tmp/)",
        },
        workDir: {
          type: "string",
          description: "Working directory",
        },
        designStyle: {
          type: "string",
          description: "Design style to apply",
        },
      },
      required: ["specFolder"],
    },
  },
  {
    name: "spec_change",
    description:
      "Apply changes to existing spec with validation (butterfly effect, conflicts, clarity checks)",
    inputSchema: {
      type: "object" as const,
      properties: {
        sessionId: {
          type: "string",
          description: "Session ID of existing spec",
        },
        changeRequest: {
          type: "string",
          description: "Description of the change to apply",
        },
        workDir: {
          type: "string",
          description: "Working directory",
        },
      },
      required: ["sessionId", "changeRequest"],
    },
  },
  {
    name: "spec_mirror",
    description: "Compare spec against implementation to detect drift",
    inputSchema: {
      type: "object" as const,
      properties: {
        sessionId: {
          type: "string",
          description: "Session ID to compare",
        },
        workDir: {
          type: "string",
          description: "Working directory",
        },
      },
      required: ["sessionId"],
    },
  },
  {
    name: "list_sessions",
    description: "List all spec-it sessions in the working directory",
    inputSchema: {
      type: "object" as const,
      properties: {
        workDir: {
          type: "string",
          description: "Working directory to search",
        },
      },
    },
  },
  {
    name: "get_session",
    description: "Get detailed information about a specific session",
    inputSchema: {
      type: "object" as const,
      properties: {
        sessionId: {
          type: "string",
          description: "Session ID to query",
        },
        workDir: {
          type: "string",
          description: "Working directory",
        },
      },
      required: ["sessionId"],
    },
  },
  {
    name: "resume_session",
    description: "Resume a paused or incomplete session",
    inputSchema: {
      type: "object" as const,
      properties: {
        sessionId: {
          type: "string",
          description: "Session ID to resume",
        },
        workDir: {
          type: "string",
          description: "Working directory",
        },
      },
      required: ["sessionId"],
    },
  },
  {
    name: "read_spec_file",
    description: "Read a specific spec output file",
    inputSchema: {
      type: "object" as const,
      properties: {
        path: {
          type: "string",
          description:
            "Relative path within spec folder (e.g., 06-final/final-spec.md)",
        },
        workDir: {
          type: "string",
          description: "Working directory",
        },
      },
      required: ["path"],
    },
  },
  {
    name: "list_spec_files",
    description: "List all files in spec output folder",
    inputSchema: {
      type: "object" as const,
      properties: {
        subFolder: {
          type: "string",
          description:
            "Subfolder to list (e.g., 02-wireframes, 06-final). Leave empty for root.",
        },
        workDir: {
          type: "string",
          description: "Working directory",
        },
      },
    },
  },
  {
    name: "get_agents",
    description: "Get list of available agents and their descriptions",
    inputSchema: {
      type: "object" as const,
      properties: {
        category: {
          type: "string",
          enum: ["design", "critic", "component", "review", "test", "execute", "all"],
          description: "Agent category to filter",
          default: "all",
        },
      },
    },
  },
];

// Tool handlers
export async function handleToolCall(
  name: string,
  args: Record<string, unknown>
): Promise<{ content: { type: "text"; text: string }[] }> {
  const workDir = (args.workDir as string) || process.cwd();

  switch (name) {
    case "spec_generate":
      return handleSpecGenerate(
        args.requirements as string,
        args.mode as string,
        args.designStyle as string,
        args.designTrends as string[],
        workDir,
        args.dashboard as boolean
      );

    case "spec_execute":
      return handleSpecExecute(
        args.specFolder as string,
        workDir,
        args.designStyle as string
      );

    case "spec_change":
      return handleSpecChange(
        args.sessionId as string,
        args.changeRequest as string,
        workDir
      );

    case "spec_mirror":
      return handleSpecMirror(args.sessionId as string, workDir);

    case "list_sessions":
      return handleListSessions(workDir);

    case "get_session":
      return handleGetSession(args.sessionId as string, workDir);

    case "resume_session":
      return handleResumeSession(args.sessionId as string, workDir);

    case "read_spec_file":
      return handleReadSpecFile(args.path as string, workDir);

    case "list_spec_files":
      return handleListSpecFiles(args.subFolder as string, workDir);

    case "get_agents":
      return handleGetAgents(args.category as string);

    default:
      return {
        content: [{ type: "text", text: `Unknown tool: ${name}` }],
      };
  }
}

async function handleSpecGenerate(
  requirements: string,
  mode: string = "automation",
  designStyle: string = "Minimal",
  designTrends: string[] = [],
  workDir: string,
  dashboard: boolean = true
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    // Initialize session
    const { sessionId, sessionDir } = await initSession(
      workDir,
      dashboard ? "Enable" : "Skip"
    );

    // Build the orchestration prompt
    const skillName = `spec-it-${mode}`;
    const skillPath = join(SKILLS_DIR, skillName, "SKILL.md");

    if (!existsSync(skillPath)) {
      return {
        content: [
          {
            type: "text",
            text: `Error: Skill ${skillName} not found. Valid modes: automation, complex, stepbystep, fast`,
          },
        ],
      };
    }

    const skillContent = await readFile(skillPath, "utf-8");

    // Return orchestration instructions
    const result = {
      sessionId,
      sessionDir,
      mode,
      designStyle,
      designTrends,
      dashboard,
      requirements,
      status: "initialized",
      orchestration: {
        skill: skillName,
        skillContent: skillContent.substring(0, 2000) + "...", // Truncate for response
        nextSteps: [
          "1. Read full skill file for workflow",
          "2. Execute Phase 0 (Init)",
          "3. Progress through phases as defined",
          "4. Update status with status-update.sh",
          "5. Save checkpoints with meta-checkpoint.sh",
        ],
      },
      outputDir: getTmpDir(workDir),
      dashboardUrl: dashboard
        ? `file://${join(
            process.env.HOME || "",
            ".claude/plugins/marketplaces/claude-frontend-skills/web-dashboard/index.html"
          )}`
        : null,
    };

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error initializing spec generation: ${error}`,
        },
      ],
    };
  }
}

async function handleSpecExecute(
  specFolder: string,
  workDir: string,
  designStyle?: string
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    const skillPath = join(SKILLS_DIR, "spec-it-execute", "SKILL.md");
    const skillContent = await readFile(skillPath, "utf-8");

    // Verify spec folder exists
    const fullSpecPath = specFolder.startsWith("/")
      ? specFolder
      : join(workDir, specFolder);

    if (!existsSync(fullSpecPath)) {
      return {
        content: [
          {
            type: "text",
            text: `Error: Spec folder not found: ${fullSpecPath}`,
          },
        ],
      };
    }

    // Check for final spec
    const finalSpecPath = join(fullSpecPath, "06-final/final-spec.md");
    const hasFinalSpec = existsSync(finalSpecPath);

    const result = {
      specFolder: fullSpecPath,
      hasFinalSpec,
      designStyle: designStyle || "Minimal",
      status: "ready",
      orchestration: {
        skill: "spec-it-execute",
        docIndex: [
          "00-overview.md",
          "01-rules.md",
          "02-phase-0-2-init-load-plan.md",
          "03-phase-3-execute.md",
          "04-phase-4-qa.md",
          "05-phase-5-mirror.md",
          "06-phase-6-unit-tests.md",
          "07-phase-7-e2e.md",
          "08-phase-8-validate.md",
          "09-phase-9-complete.md",
        ],
        nextSteps: [
          "1. Initialize execute session",
          "2. Load spec from plan phase",
          "3. Generate execution plan",
          "4. Execute in batches",
          "5. Run QA (hard gate)",
          "6. Run spec-mirror",
          "7. Implement tests",
          "8. Final validation",
        ],
      },
    };

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error initializing execution: ${error}`,
        },
      ],
    };
  }
}

async function handleSpecChange(
  sessionId: string,
  changeRequest: string,
  workDir: string
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    const info = await getSessionInfo(workDir, sessionId);

    if (!info) {
      return {
        content: [
          {
            type: "text",
            text: `Session not found: ${sessionId}`,
          },
        ],
      };
    }

    const skillPath = join(SKILLS_DIR, "spec-change", "SKILL.md");
    const skillContent = await readFile(skillPath, "utf-8");

    const result = {
      sessionId,
      changeRequest,
      currentStatus: info.meta?.status,
      mode: info.mode,
      validation: {
        steps: [
          "1. spec-butterfly: Analyze impact (ripple effects)",
          "2. spec-doppelganger: Check for duplicates",
          "3. spec-conflict: Detect contradictions",
          "4. spec-clarity: QuARS clarity check",
          "5. spec-consistency: Terminology consistency",
          "6. spec-coverage: Edge case analysis",
        ],
      },
      orchestration: {
        skill: "spec-change",
        nextSteps: [
          "Run all 6 validators",
          "Generate change plan",
          "Apply changes with approval",
          "Update affected documents",
        ],
      },
    };

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error processing change request: ${error}`,
        },
      ],
    };
  }
}

async function handleSpecMirror(
  sessionId: string,
  workDir: string
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    const info = await getSessionInfo(workDir, sessionId);

    if (!info) {
      return {
        content: [
          {
            type: "text",
            text: `Session not found: ${sessionId}`,
          },
        ],
      };
    }

    const result = {
      sessionId,
      description: "Compare spec against implementation to detect drift",
      checks: [
        "Wireframe vs actual UI",
        "Component spec vs implementation",
        "Test spec vs actual tests",
        "API contracts vs usage",
      ],
      orchestration: {
        skill: "spec-mirror",
        output: "Drift report with severity levels",
      },
    };

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error running spec-mirror: ${error}`,
        },
      ],
    };
  }
}

async function handleListSessions(
  workDir: string
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    const sessions = await listSessions(workDir);

    if (sessions.length === 0) {
      return {
        content: [
          {
            type: "text",
            text: "No sessions found in " + workDir,
          },
        ],
      };
    }

    const sessionDetails = await Promise.all(
      sessions.map(async (id) => {
        const info = await getSessionInfo(workDir, id);
        return {
          sessionId: id,
          mode: info?.mode || "unknown",
          status: info?.meta?.status || "unknown",
          currentPhase: info?.meta?.currentPhase || 0,
          canResume: info?.meta?.canResume || false,
        };
      })
    );

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify({ sessions: sessionDetails }, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error listing sessions: ${error}`,
        },
      ],
    };
  }
}

async function handleGetSession(
  sessionId: string,
  workDir: string
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    const info = await getSessionInfo(workDir, sessionId);

    if (!info) {
      return {
        content: [
          {
            type: "text",
            text: `Session not found: ${sessionId}`,
          },
        ],
      };
    }

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(info, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error getting session: ${error}`,
        },
      ],
    };
  }
}

async function handleResumeSession(
  sessionId: string,
  workDir: string
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    const info = await getSessionInfo(workDir, sessionId);

    if (!info) {
      return {
        content: [
          {
            type: "text",
            text: `Session not found: ${sessionId}`,
          },
        ],
      };
    }

    if (!info.meta?.canResume) {
      return {
        content: [
          {
            type: "text",
            text: `Session ${sessionId} cannot be resumed (status: ${info.meta?.status})`,
          },
        ],
      };
    }

    const skillName =
      info.mode === "execute" ? "spec-it-execute" : "spec-it-automation";

    const result = {
      sessionId,
      mode: info.mode,
      resumeFrom: info.meta.currentStep,
      completedSteps: info.meta.completedSteps,
      orchestration: {
        skill: skillName,
        command: `--resume ${sessionId}`,
        nextSteps: [
          `Resume from step ${info.meta.currentStep}`,
          "Continue workflow from checkpoint",
        ],
      },
    };

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error resuming session: ${error}`,
        },
      ],
    };
  }
}

async function handleReadSpecFile(
  path: string,
  workDir: string
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    const tmpDir = getTmpDir(workDir);
    const fullPath = join(tmpDir, path);

    if (!existsSync(fullPath)) {
      return {
        content: [
          {
            type: "text",
            text: `File not found: ${path}`,
          },
        ],
      };
    }

    const content = await readFile(fullPath, "utf-8");

    return {
      content: [
        {
          type: "text",
          text: content,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error reading file: ${error}`,
        },
      ],
    };
  }
}

async function handleListSpecFiles(
  subFolder: string | undefined,
  workDir: string
): Promise<{ content: { type: "text"; text: string }[] }> {
  try {
    const tmpDir = getTmpDir(workDir);
    const targetDir = subFolder ? join(tmpDir, subFolder) : tmpDir;

    if (!existsSync(targetDir)) {
      return {
        content: [
          {
            type: "text",
            text: `Directory not found: ${subFolder || "tmp"}`,
          },
        ],
      };
    }

    const files = await listFilesRecursive(targetDir, targetDir);

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify({ files }, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error listing files: ${error}`,
        },
      ],
    };
  }
}

async function listFilesRecursive(
  dir: string,
  baseDir: string
): Promise<string[]> {
  const entries = await readdir(dir, { withFileTypes: true });
  const files: string[] = [];

  for (const entry of entries) {
    const fullPath = join(dir, entry.name);
    const relativePath = fullPath.replace(baseDir + "/", "");

    if (entry.isDirectory()) {
      const subFiles = await listFilesRecursive(fullPath, baseDir);
      files.push(...subFiles);
    } else {
      files.push(relativePath);
    }
  }

  return files;
}

async function handleGetAgents(
  category: string = "all"
): Promise<{ content: { type: "text"; text: string }[] }> {
  const agents = {
    design: [
      {
        name: "design-interviewer",
        model: "opus",
        description: "Collects requirements through structured interview",
      },
      {
        name: "divergent-thinker",
        model: "sonnet",
        description: "Explores alternative approaches",
      },
      {
        name: "chapter-planner",
        model: "opus",
        description: "Plans document structure",
      },
      {
        name: "ui-architect",
        model: "sonnet",
        description: "Creates YAML wireframes",
      },
    ],
    critic: [
      {
        name: "critic-logic",
        model: "sonnet",
        description: "Reviews logical consistency",
      },
      {
        name: "critic-feasibility",
        model: "sonnet",
        description: "Checks technical feasibility",
      },
      {
        name: "critic-frontend",
        model: "sonnet",
        description: "Reviews frontend best practices",
      },
      {
        name: "critic-moderator",
        model: "opus",
        description: "Synthesizes critiques, resolves conflicts",
      },
    ],
    component: [
      {
        name: "component-auditor",
        model: "haiku",
        description: "Scans existing components",
      },
      {
        name: "component-builder",
        model: "sonnet",
        description: "Creates new component specs",
      },
      {
        name: "component-migrator",
        model: "sonnet",
        description: "Plans component migrations",
      },
    ],
    review: [
      {
        name: "critical-reviewer",
        model: "opus",
        description: "Reviews scenarios, IA, exceptions",
      },
      {
        name: "ambiguity-detector",
        model: "opus",
        description: "Finds ambiguities in spec",
      },
      {
        name: "spec-critic",
        model: "opus",
        description: "Validates 4 core pillars",
      },
    ],
    test: [
      {
        name: "persona-architect",
        model: "sonnet",
        description: "Defines user personas",
      },
      {
        name: "test-spec-writer",
        model: "sonnet",
        description: "Writes TDD specs",
      },
    ],
    execute: [
      {
        name: "spec-executor",
        model: "opus",
        description: "Implements code from spec",
      },
      {
        name: "code-reviewer",
        model: "opus",
        description: "Reviews generated code",
      },
      {
        name: "security-reviewer",
        model: "opus",
        description: "OWASP Top 10 review",
      },
    ],
  };

  const result =
    category === "all"
      ? agents
      : { [category]: agents[category as keyof typeof agents] || [] };

  return {
    content: [
      {
        type: "text",
        text: JSON.stringify(result, null, 2),
      },
    ],
  };
}
