import { homedir } from "os";
import { join } from "path";

// Base paths
export const SPEC_IT_ROOT = join(homedir(), ".claude/plugins/marketplaces/claude-frontend-skills");
export const SKILLS_DIR = join(SPEC_IT_ROOT, "skills");
export const SCRIPTS_DIR = join(SPEC_IT_ROOT, "scripts");
export const AGENTS_DIR = join(SPEC_IT_ROOT, "agents");

// Script paths
export const SESSION_INIT_SCRIPT = join(SCRIPTS_DIR, "core/session-init.sh");
export const STATUS_UPDATE_SCRIPT = join(SCRIPTS_DIR, "core/status-update.sh");
export const META_CHECKPOINT_SCRIPT = join(SCRIPTS_DIR, "core/meta-checkpoint.sh");

// Session directory
export function getSessionDir(workDir: string, sessionId: string): string {
  return join(workDir, ".spec-it", sessionId);
}

export function getSessionPlanDir(workDir: string, sessionId: string): string {
  return join(getSessionDir(workDir, sessionId), "plan");
}

export function getSessionExecuteDir(workDir: string, sessionId: string): string {
  return join(getSessionDir(workDir, sessionId), "execute");
}

// Output directories
export function getTmpDir(workDir: string): string {
  return join(workDir, "tmp");
}
