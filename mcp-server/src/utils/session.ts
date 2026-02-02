import { exec } from "child_process";
import { promisify } from "util";
import { readFile, readdir, stat } from "fs/promises";
import { join } from "path";
import { existsSync } from "fs";
import {
  SESSION_INIT_SCRIPT,
  STATUS_UPDATE_SCRIPT,
  META_CHECKPOINT_SCRIPT,
  getSessionPlanDir,
  getSessionExecuteDir,
} from "./paths.js";

const execAsync = promisify(exec);

export interface SessionMeta {
  sessionId: string;
  mode: "plan" | "execute";
  status: string;
  currentPhase: number;
  currentStep: string;
  completedSteps: string[];
  startedAt: string;
  lastCheckpoint: string;
  canResume: boolean;
  uiMode?: string;
  docsDir?: string;
  designStyle?: string;
  designTrends?: string[];
  dashboardEnabled?: string;
}

export interface SessionStatus {
  sessionId: string;
  phase: number;
  progress: number;
  currentAgent?: string;
  status: "running" | "paused" | "completed" | "error";
  agents: {
    name: string;
    status: "pending" | "running" | "completed" | "error";
  }[];
}

export async function initSession(
  workDir: string,
  uiMode: string = "pending"
): Promise<{ sessionId: string; sessionDir: string }> {
  const { stdout } = await execAsync(
    `${SESSION_INIT_SCRIPT} "" "${uiMode}" "${workDir}"`
  );

  // Parse output: SESSION_ID:xxx, SESSION_DIR:/path/to/xxx
  const sessionIdMatch = stdout.match(/SESSION_ID:(\S+)/);
  const sessionDirMatch = stdout.match(/SESSION_DIR:(\S+)/);

  if (!sessionIdMatch || !sessionDirMatch) {
    throw new Error("Failed to parse session init output");
  }

  return {
    sessionId: sessionIdMatch[1],
    sessionDir: sessionDirMatch[1],
  };
}

export async function updateStatus(
  sessionDir: string,
  action: string,
  ...args: string[]
): Promise<void> {
  await execAsync(
    `${STATUS_UPDATE_SCRIPT} "${sessionDir}" ${action} ${args.join(" ")}`
  );
}

export async function saveCheckpoint(
  sessionDir: string,
  step: string
): Promise<void> {
  await execAsync(`${META_CHECKPOINT_SCRIPT} "${sessionDir}" ${step}`);
}

export async function loadSessionMeta(
  workDir: string,
  sessionId: string,
  mode: "plan" | "execute" = "plan"
): Promise<SessionMeta | null> {
  const dir =
    mode === "plan"
      ? getSessionPlanDir(workDir, sessionId)
      : getSessionExecuteDir(workDir, sessionId);
  const metaPath = join(dir, "_meta.json");

  if (!existsSync(metaPath)) {
    return null;
  }

  const content = await readFile(metaPath, "utf-8");
  return JSON.parse(content);
}

export async function loadSessionStatus(
  workDir: string,
  sessionId: string,
  mode: "plan" | "execute" = "plan"
): Promise<SessionStatus | null> {
  const dir =
    mode === "plan"
      ? getSessionPlanDir(workDir, sessionId)
      : getSessionExecuteDir(workDir, sessionId);
  const statusPath = join(dir, "_status.json");

  if (!existsSync(statusPath)) {
    return null;
  }

  const content = await readFile(statusPath, "utf-8");
  return JSON.parse(content);
}

export async function listSessions(workDir: string): Promise<string[]> {
  const specItDir = join(workDir, ".spec-it");

  if (!existsSync(specItDir)) {
    return [];
  }

  const entries = await readdir(specItDir, { withFileTypes: true });
  return entries.filter((e) => e.isDirectory()).map((e) => e.name);
}

export async function getSessionInfo(
  workDir: string,
  sessionId: string
): Promise<{
  meta: SessionMeta | null;
  status: SessionStatus | null;
  mode: "plan" | "execute";
} | null> {
  // Check plan first, then execute
  let meta = await loadSessionMeta(workDir, sessionId, "plan");
  let status = await loadSessionStatus(workDir, sessionId, "plan");
  let mode: "plan" | "execute" = "plan";

  if (!meta) {
    meta = await loadSessionMeta(workDir, sessionId, "execute");
    status = await loadSessionStatus(workDir, sessionId, "execute");
    mode = "execute";
  }

  if (!meta) {
    return null;
  }

  return { meta, status, mode };
}
