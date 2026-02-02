import { Resource } from "@modelcontextprotocol/sdk/types.js";
import { readFile, readdir } from "fs/promises";
import { join } from "path";
import { existsSync } from "fs";
import { listSessions, getSessionInfo } from "../utils/session.js";
import { getTmpDir, SKILLS_DIR, AGENTS_DIR } from "../utils/paths.js";

// Dynamic resource listing
export async function resources(): Promise<Resource[]> {
  const workDir = process.cwd();
  const baseResources: Resource[] = [
    {
      uri: "spec://skills",
      name: "Available Skills",
      description: "List of all spec-it skills",
      mimeType: "application/json",
    },
    {
      uri: "spec://agents",
      name: "Available Agents",
      description: "List of all spec-it agents",
      mimeType: "application/json",
    },
    {
      uri: "spec://design-trends",
      name: "Design Trends 2026",
      description: "Available design styles and trends",
      mimeType: "application/json",
    },
  ];

  // Add session resources
  try {
    const sessions = await listSessions(workDir);
    for (const sessionId of sessions) {
      baseResources.push({
        uri: `spec://sessions/${sessionId}`,
        name: `Session: ${sessionId}`,
        description: "Spec-it session details",
        mimeType: "application/json",
      });
    }
  } catch {
    // Ignore errors listing sessions
  }

  // Add spec output resources if tmp exists
  const tmpDir = getTmpDir(workDir);
  if (existsSync(tmpDir)) {
    const specFolders = [
      { path: "00-requirements", name: "Requirements" },
      { path: "01-chapters", name: "Design Chapters" },
      { path: "02-wireframes", name: "Wireframes" },
      { path: "03-components", name: "Component Specs" },
      { path: "04-review", name: "Reviews" },
      { path: "05-tests", name: "Test Specs" },
      { path: "06-final", name: "Final Spec" },
    ];

    for (const folder of specFolders) {
      if (existsSync(join(tmpDir, folder.path))) {
        baseResources.push({
          uri: `spec://output/${folder.path}`,
          name: folder.name,
          description: `Spec output: ${folder.name}`,
          mimeType: "application/json",
        });
      }
    }
  }

  return baseResources;
}

// Resource read handler
export async function handleResourceRead(
  uri: string
): Promise<{ contents: { uri: string; mimeType: string; text: string }[] }> {
  const workDir = process.cwd();

  if (uri === "spec://skills") {
    return getSkillsResource();
  }

  if (uri === "spec://agents") {
    return getAgentsResource();
  }

  if (uri === "spec://design-trends") {
    return getDesignTrendsResource();
  }

  if (uri.startsWith("spec://sessions/")) {
    const sessionId = uri.replace("spec://sessions/", "");
    return getSessionResource(sessionId, workDir);
  }

  if (uri.startsWith("spec://output/")) {
    const folder = uri.replace("spec://output/", "");
    return getOutputResource(folder, workDir);
  }

  return {
    contents: [
      {
        uri,
        mimeType: "text/plain",
        text: `Unknown resource: ${uri}`,
      },
    ],
  };
}

async function getSkillsResource(): Promise<{
  contents: { uri: string; mimeType: string; text: string }[];
}> {
  const skills = [
    {
      name: "spec-it",
      description: "Mode router - selects automation, complex, or step-by-step",
      modes: ["automation", "complex", "stepbystep", "fast"],
    },
    {
      name: "spec-it-automation",
      description: "Full-auto spec generator with minimal approvals",
      phases: 6,
      autoExecute: true,
    },
    {
      name: "spec-it-complex",
      description: "4 milestone approvals, hybrid automation",
      phases: 6,
      autoExecute: false,
    },
    {
      name: "spec-it-stepbystep",
      description: "Chapter-by-chapter approvals, maximum control",
      phases: 6,
      autoExecute: false,
    },
    {
      name: "spec-it-fast-launch",
      description: "Rapid prototype mode, skips brainstorm/tests",
      phases: 3,
      autoExecute: true,
    },
    {
      name: "spec-it-execute",
      description: "Implementation executor - 9 phases",
      phases: 9,
    },
    {
      name: "spec-change",
      description: "Apply changes with 6-validator safety net",
      validators: [
        "butterfly",
        "doppelganger",
        "conflict",
        "clarity",
        "consistency",
        "coverage",
      ],
    },
    {
      name: "spec-mirror",
      description: "Compare spec vs implementation",
    },
    {
      name: "spec-wireframe-edit",
      description: "Edit wireframes",
    },
    {
      name: "hack-2-spec",
      description: "Reverse engineer code to spec",
    },
    {
      name: "init-spec-md",
      description: "Initialize SPEC-IT files for existing code",
    },
  ];

  return {
    contents: [
      {
        uri: "spec://skills",
        mimeType: "application/json",
        text: JSON.stringify({ skills }, null, 2),
      },
    ],
  };
}

async function getAgentsResource(): Promise<{
  contents: { uri: string; mimeType: string; text: string }[];
}> {
  const agents = {
    design: [
      { name: "design-interviewer", model: "opus", role: "Requirements collection" },
      { name: "divergent-thinker", model: "sonnet", role: "Alternative exploration" },
      { name: "chapter-planner", model: "opus", role: "Structure planning" },
      { name: "ui-architect", model: "sonnet", role: "Wireframe design" },
    ],
    critic: [
      { name: "critic-logic", model: "sonnet", role: "Logical consistency" },
      { name: "critic-feasibility", model: "sonnet", role: "Technical feasibility" },
      { name: "critic-frontend", model: "sonnet", role: "Frontend best practices" },
      { name: "critic-moderator", model: "opus", role: "Critique synthesis" },
    ],
    component: [
      { name: "component-auditor", model: "haiku", role: "Component scanning" },
      { name: "component-builder", model: "sonnet", role: "New component specs" },
      { name: "component-migrator", model: "sonnet", role: "Migration planning" },
    ],
    review: [
      { name: "critical-reviewer", model: "opus", role: "Scenario/IA/Exception review" },
      { name: "ambiguity-detector", model: "opus", role: "Ambiguity detection" },
      { name: "spec-critic", model: "opus", role: "4 pillars validation" },
    ],
    test: [
      { name: "persona-architect", model: "sonnet", role: "User persona definition" },
      { name: "test-spec-writer", model: "sonnet", role: "TDD specification" },
    ],
    execute: [
      { name: "spec-executor", model: "opus", role: "Code implementation" },
      { name: "code-reviewer", model: "opus", role: "Code review" },
      { name: "security-reviewer", model: "opus", role: "OWASP Top 10" },
    ],
    validation: [
      { name: "spec-butterfly", model: "opus", role: "Impact analysis" },
      { name: "spec-doppelganger", model: "sonnet", role: "Duplicate detection" },
      { name: "spec-conflict", model: "sonnet", role: "Contradiction detection" },
      { name: "spec-clarity", model: "sonnet", role: "QuARS clarity check" },
      { name: "spec-consistency", model: "haiku", role: "Terminology consistency" },
      { name: "spec-coverage", model: "sonnet", role: "Edge case analysis" },
    ],
    utility: [
      { name: "spec-assembler", model: "haiku", role: "Document assembly" },
      { name: "spec-md-generator", model: "haiku", role: "SPEC-IT file generation" },
    ],
  };

  return {
    contents: [
      {
        uri: "spec://agents",
        mimeType: "application/json",
        text: JSON.stringify({ agents, totalCount: 23 }, null, 2),
      },
    ],
  };
}

async function getDesignTrendsResource(): Promise<{
  contents: { uri: string; mimeType: string; text: string }[];
}> {
  const designTrends = {
    styles: [
      {
        name: "Minimal",
        description: "Clean SaaS: Light theme, minimal cards",
        recommended: true,
      },
      {
        name: "Immersive",
        description: "Dark theme: Gradient cards, neon accents",
      },
      {
        name: "Organic",
        description: "Organic: Glassmorphism, soft curves",
      },
      {
        name: "Custom",
        description: "Select individual trends",
      },
    ],
    trends: [
      { name: "Dark Mode+", description: "Dark theme + adaptive colors" },
      { name: "Light Skeuomorphism", description: "Soft shadows, Neumorphic" },
      { name: "Glassmorphism", description: "Translucent backgrounds + blur" },
      { name: "Micro-Animations", description: "Meaningful motion" },
      { name: "3D Visuals", description: "3D icons, WebGL" },
      { name: "Gamification", description: "Progress rings, badges" },
    ],
    layoutSystem: {
      gridTypes: ["12-column", "auto-fit", "masonry"],
      spacingScale: [4, 8, 12, 16, 24, 32, 48, 64],
      breakpoints: {
        mobile: 320,
        tablet: 768,
        desktop: 1024,
        wide: 1440,
      },
    },
  };

  return {
    contents: [
      {
        uri: "spec://design-trends",
        mimeType: "application/json",
        text: JSON.stringify(designTrends, null, 2),
      },
    ],
  };
}

async function getSessionResource(
  sessionId: string,
  workDir: string
): Promise<{ contents: { uri: string; mimeType: string; text: string }[] }> {
  const info = await getSessionInfo(workDir, sessionId);

  if (!info) {
    return {
      contents: [
        {
          uri: `spec://sessions/${sessionId}`,
          mimeType: "application/json",
          text: JSON.stringify({ error: "Session not found" }),
        },
      ],
    };
  }

  return {
    contents: [
      {
        uri: `spec://sessions/${sessionId}`,
        mimeType: "application/json",
        text: JSON.stringify(info, null, 2),
      },
    ],
  };
}

async function getOutputResource(
  folder: string,
  workDir: string
): Promise<{ contents: { uri: string; mimeType: string; text: string }[] }> {
  const tmpDir = getTmpDir(workDir);
  const folderPath = join(tmpDir, folder);

  if (!existsSync(folderPath)) {
    return {
      contents: [
        {
          uri: `spec://output/${folder}`,
          mimeType: "application/json",
          text: JSON.stringify({ error: "Folder not found" }),
        },
      ],
    };
  }

  const files = await listFilesInFolder(folderPath);

  return {
    contents: [
      {
        uri: `spec://output/${folder}`,
        mimeType: "application/json",
        text: JSON.stringify({ folder, files }, null, 2),
      },
    ],
  };
}

async function listFilesInFolder(folderPath: string): Promise<string[]> {
  const entries = await readdir(folderPath, { withFileTypes: true });
  const files: string[] = [];

  for (const entry of entries) {
    if (entry.isDirectory()) {
      const subFiles = await listFilesInFolder(join(folderPath, entry.name));
      files.push(...subFiles.map((f) => `${entry.name}/${f}`));
    } else {
      files.push(entry.name);
    }
  }

  return files;
}
