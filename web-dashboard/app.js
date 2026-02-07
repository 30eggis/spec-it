const sessionList = document.querySelector("[data-session-list]");
const dropZone = document.querySelector("[data-drop-zone]");
const supportMessage = document.querySelector("[data-support-message]");

const sessions = new Map();
const sessionElements = new Map();
const STORAGE_DB = "spec-it-dashboard";
const STORAGE_STORE = "session-handles";
const CACHE_KEY = "spec-it-dashboard-cache";
let storagePromise = null;
let refreshTimer = null;
let refreshInFlight = false;

const supportsFilePicker = "showDirectoryPicker" in window;
const supportsDropHandle =
  typeof DataTransferItem !== "undefined" &&
  "getAsFileSystemHandle" in DataTransferItem.prototype;
let dragDepth = 0;

updateSupportMessage();
setupGlobalDragAndDrop();
restoreSessionsFromCache();
restoreSessionsFromStorage();
window.addEventListener("resize", updateGridColumns);

document.addEventListener("click", async (event) => {
  const actionTarget = event.target.closest("[data-action]");
  const action = actionTarget?.dataset.action;
  if (!action) return;

  if (action === "pick") {
    if (!supportsFilePicker) return;
    try {
      const handle = await window.showDirectoryPicker({
        mode: "read",
      });
      await addDirectoryHandle(handle);
    } catch (error) {
      if (error?.name !== "AbortError") {
        setSupportMessage("Failed to open directory picker.");
      }
    }
  }

  if (action === "clear") {
    sessions.clear();
    renderSessions();
    stopRefresh();
    await clearStoredHandles();
    clearCachedSessions();
  }

  if (action === "remove") {
    const sessionKey = actionTarget.dataset.session;
    const session = sessions.get(sessionKey);
    sessions.delete(sessionKey);
    renderSessions();
    if (sessions.size === 0) stopRefresh();
    if (session?.storageId) {
      await deleteStoredHandle(session.storageId);
    }
    if (session?.cacheId) {
      deleteCachedSession(session.cacheId);
    }
  }

  if (action === "toggle-telegram") {
    const panel = document.getElementById("telegram-panel");
    if (panel) panel.hidden = !panel.hidden;
  }

  if (action === "save-telegram") {
    const token = document.getElementById("tg-bot-token")?.value.trim() || "";
    const chatId = document.getElementById("tg-chat-id")?.value.trim() || "";
    localStorage.setItem(TG_TOKEN_KEY, token);
    localStorage.setItem(TG_CHAT_KEY, chatId);
    updateTelegramUI();
    const status = document.getElementById("tg-status");
    if (status) { status.textContent = "Saved"; setTimeout(() => updateTelegramUI(), 2000); }
  }

  if (action === "clear-telegram") {
    localStorage.removeItem(TG_TOKEN_KEY);
    localStorage.removeItem(TG_CHAT_KEY);
    const tokenInput = document.getElementById("tg-bot-token");
    const chatInput = document.getElementById("tg-chat-id");
    if (tokenInput) tokenInput.value = "";
    if (chatInput) chatInput.value = "";
    updateTelegramUI();
  }

  if (action === "test-telegram") {
    const status = document.getElementById("tg-status");
    if (!isTelegramConfigured()) {
      if (status) status.textContent = "Not configured";
      return;
    }
    sendTelegram("Spec-It Dashboard: Telegram test OK").then(() => {
      if (status) { status.textContent = "Test sent!"; setTimeout(() => updateTelegramUI(), 2000); }
    });
  }

  if (action === "authorize") {
    const sessionKey = actionTarget.dataset.session;
    const session = sessions.get(sessionKey);
    if (!session?.dirHandle) return;
    const permitted = await ensurePermission(session.dirHandle, { request: true });
    if (!permitted) {
      setSupportMessage("Access not granted. Drag & drop to re-authorize.");
      return;
    }
    session.locked = false;
    await refreshSession(session);
    renderSessions();
    startRefresh();
  }
});

function setupGlobalDragAndDrop() {
  document.addEventListener("dragenter", (event) => {
    if (!isFileDrag(event)) return;
    dragDepth += 1;
    event.preventDefault();
    setDragging(true);
  });

  document.addEventListener("dragover", (event) => {
    if (!isFileDrag(event)) return;
    event.preventDefault();
    if (event.dataTransfer) {
      event.dataTransfer.dropEffect = "copy";
    }
    setDragging(true);
  });

  document.addEventListener("dragleave", (event) => {
    if (!isFileDrag(event)) return;
    dragDepth = Math.max(0, dragDepth - 1);
    if (dragDepth === 0) {
      setDragging(false);
    }
  });

  document.addEventListener("drop", async (event) => {
    if (!isFileDrag(event)) return;
    event.preventDefault();
    dragDepth = 0;
    setDragging(false);
    await handleDrop(event);
  });
}

function setDragging(active) {
  dropZone.classList.toggle("dragover", active);
  document.body.classList.toggle("dragging", active);
}

function isFileDrag(event) {
  const dataTransfer = event.dataTransfer;
  if (!dataTransfer) return false;
  if (dataTransfer.types && Array.from(dataTransfer.types).includes("Files")) {
    return true;
  }
  if (dataTransfer.items) {
    return Array.from(dataTransfer.items).some((item) => item.kind === "file");
  }
  return false;
}

async function handleDrop(event) {
  if (!supportsDropHandle) {
    setSupportMessage("Drag and drop requires Chromium browsers.");
    return;
  }

  const items = Array.from(event.dataTransfer?.items || []);
  const handles = [];

  for (const item of items) {
    if (item.kind !== "file") continue;
    if (typeof item.getAsFileSystemHandle !== "function") continue;
    const handle = await item.getAsFileSystemHandle();
    if (handle) handles.push(handle);
  }

  if (handles.length === 0) {
    setSupportMessage("No folders detected in the drop.");
    return;
  }

  for (const handle of handles) {
    if (handle.kind === "directory") {
      await addDirectoryHandle(handle);
    }
  }
}

async function addDirectoryHandle(handle) {
  const hasPermission = await ensurePermission(handle);
  if (!hasPermission) {
    setSupportMessage("Read permission denied for the dropped folder.");
    return;
  }

  const sessionDirs = await resolveSessionDirectories(handle);
  if (sessionDirs.length === 0) {
    setSupportMessage("No session files found in that folder.");
    return;
  }

  for (const dirHandle of sessionDirs) {
    if (await isHandleAlreadyAdded(dirHandle)) continue;
    const session = await createSession(dirHandle);
    session.storageId = await saveHandleIfNeeded(dirHandle);
    sessions.set(session.key, session);
  }

  renderSessions();
  startRefresh();
  await refreshAll();
}

async function resolveSessionDirectories(dirHandle) {
  if (await hasFile(dirHandle, "_status.json")) {
    return [dirHandle];
  }

  const matches = [];
  for (const name of ["plan", "execute"]) {
    try {
      const sub = await dirHandle.getDirectoryHandle(name);
      if (await hasFile(sub, "_status.json")) {
        matches.push(sub);
      }
    } catch (_) {
      continue;
    }
  }

  return matches;
}

async function createSession(dirHandle, options = {}) {
  const session = {
    key: typeof crypto?.randomUUID === "function"
      ? crypto.randomUUID()
      : `${Date.now()}-${Math.random().toString(16).slice(2)}`,
    dirHandle,
    data: {},
    error: "",
    name: options.name || dirHandle.name,
    locked: Boolean(options.locked),
  };
  if (!options.skipRefresh) {
    await refreshSession(session);
  }
  return session;
}

async function refreshAll() {
  if (refreshInFlight) return;
  refreshInFlight = true;

  for (const session of sessions.values()) {
    if (session.locked) continue;
    await refreshSession(session);
  }

  renderSessions();
  refreshInFlight = false;
}

async function refreshSession(session) {
  session.error = "";

  const statusResult = await readJson(session.dirHandle, "_status.json");
  const metaResult = await readJson(session.dirHandle, "_meta.json");

  if (!statusResult.ok && !metaResult.ok) {
    session.error =
      statusResult.error || metaResult.error || "Unable to read session files.";
    session.data = {};
    return;
  }

  const merged = mergeStatus(metaResult.value || {}, statusResult.value || {});

  const pilotResult = await readJson(session.dirHandle, "dev-pilot-state.json");
  if (pilotResult.ok && pilotResult.value?.active) {
    applyDevPilotProgress(merged, pilotResult.value);
  }

  const ultraqaResult = await readJson(session.dirHandle, "ultraqa-state.json");
  if (ultraqaResult.ok && ultraqaResult.value?.active) {
    applyUltraqaProgress(merged, ultraqaResult.value);
  }

  session.data = merged;
  session.locked = false;
  session.isCached = false;
  removeCachedSessionsBySessionId(merged.sessionId);
  cacheSessionSnapshot(session);
  notifyTelegramIfNeeded(session);
}

function applyDevPilotProgress(data, pilot) {
  const workers = Array.isArray(pilot.workers) ? pilot.workers : [];
  if (workers.length === 0) return;

  const completed = workers.filter((w) => w.status === "complete").length;
  const total = workers.length;

  // Update agents from dev-pilot workers
  const pilotAgents = workers.map((w) => {
    const agent = { name: `dev-pilot-${w.id}`, status: w.status === "complete" ? "completed" : w.status };
    if (w.filesCreated) agent.filesCreated = w.filesCreated;
    return agent;
  });
  data.agents = pilotAgents;

  // Update Phase 3 progress based on worker completion
  if (Number(data.currentPhase) === 3 && data.status !== "completed") {
    const workerProgress = total > 0 ? Math.round((completed / total) * 100) : 0;
    data.devPilotPhase3Progress = workerProgress;

    // Update overall progress: phases 0-2 done (33%) + phase 3 partial
    const phase3Weight = 100 / 9;
    const completedWeight = (2 / 9) * 100;
    data.progress = Math.round(completedWeight + (phase3Weight * workerProgress) / 100);
  }

  data.lastUpdate = new Date().toISOString();
}

function applyUltraqaProgress(data, ultraqa) {
  const currentPhase = Number(data.currentPhase);
  // ultraqa runs during Phase 6 (unit) or Phase 7 (e2e)
  if (currentPhase !== 6 && currentPhase !== 7) return;

  const mode = ultraqa.mode || "";
  const iteration = ultraqa.iteration || 1;
  const maxIterations = ultraqa.maxIterations || (mode === "e2e" ? 3 : 5);
  const results = ultraqa.results || {};
  const phase = ultraqa.phase || "";

  // Build agent entry from ultraqa state
  const agentName = mode === "e2e" ? "ultraqa-e2e" : "ultraqa-unit";
  const agentStatus = phase === "fix_cycle" ? "fixing" : "running";
  const ultraqaAgent = {
    name: `${agentName} (${iteration}/${maxIterations})`,
    status: agentStatus,
  };

  // Merge with existing agents or replace
  if (!Array.isArray(data.agents) || data.agents.length === 0) {
    data.agents = [ultraqaAgent];
  } else {
    const existing = data.agents.findIndex((a) => a.name.startsWith("ultraqa-"));
    if (existing >= 0) {
      data.agents[existing] = ultraqaAgent;
    } else {
      data.agents.push(ultraqaAgent);
    }
  }

  // Calculate phase progress based on iteration and test results
  let phaseProgress = 0;
  if (results.total > 0) {
    const passRate = results.passed / results.total;
    // Progress = base from iteration + bonus from pass rate
    const iterationBase = Math.round(((iteration - 1) / maxIterations) * 60);
    const passBonus = Math.round(passRate * 40);
    phaseProgress = Math.min(99, iterationBase + passBonus);
  } else {
    // No results yet, estimate from iteration
    phaseProgress = Math.round(((iteration - 1) / maxIterations) * 30) + 5;
  }

  data.ultraqaPhaseProgress = phaseProgress;

  // Update overall progress
  const completedPhases = Array.isArray(data.completedPhases) ? data.completedPhases.length : 0;
  const phaseWeight = 100 / 9;
  data.progress = Math.round(completedPhases * phaseWeight + (phaseWeight * phaseProgress) / 100);

  // Enrich current task display
  if (results.total > 0) {
    const coverage = results.coverage || "0%";
    data.currentTask = `${mode.toUpperCase()} ${iteration}/${maxIterations} | ${results.passed}/${results.total} passed | coverage ${coverage}`;
  } else {
    data.currentTask = `${mode.toUpperCase()} ${iteration}/${maxIterations} | ${phase}`;
  }

  data.lastUpdate = new Date().toISOString();
}

async function readJson(dirHandle, fileName) {
  try {
    const fileHandle = await dirHandle.getFileHandle(fileName, {
      create: false,
    });
    const file = await fileHandle.getFile();
    const text = await file.text();
    return { ok: true, value: text ? JSON.parse(text) : {} };
  } catch (error) {
    return { ok: false, error: `Missing or unreadable ${fileName}.` };
  }
}

async function hasFile(dirHandle, fileName) {
  try {
    await dirHandle.getFileHandle(fileName, { create: false });
    return true;
  } catch (_) {
    return false;
  }
}

async function ensurePermission(handle, options = {}) {
  const requestAccess = options.request !== false;
  if (typeof handle.queryPermission === "function") {
    const current = await handle.queryPermission({ mode: "read" });
    if (current === "granted") return true;
    if (!requestAccess) return false;
  }
  if (typeof handle.requestPermission === "function" && requestAccess) {
    const request = await handle.requestPermission({ mode: "read" });
    return request === "granted";
  }
  return requestAccess;
}

function restoreSessionsFromCache() {
  const cached = getCachedSessions();
  if (!cached || cached.length === 0) return;

  for (const entry of cached) {
    if (!entry?.cacheId || !entry?.data) continue;
    if (isCacheEntryActive(entry.cacheId)) continue;
    const session = {
      key:
        typeof crypto?.randomUUID === "function"
          ? crypto.randomUUID()
          : `${Date.now()}-${Math.random().toString(16).slice(2)}`,
      dirHandle: null,
      data: entry.data,
      error: "",
      name: entry.name || entry.data.sessionId || "cached-session",
      locked: true,
      isCached: true,
      cacheId: entry.cacheId,
      cachedAt: entry.cachedAt || "",
    };
    sessions.set(session.key, session);
  }

  if (sessions.size > 0) {
    renderSessions();
  }
}

async function restoreSessionsFromStorage() {
  const stored = await getAllStoredHandles();
  if (!stored || stored.length === 0) return;

  let restoredCount = 0;
  let lockedCount = 0;

  for (const entry of stored) {
    if (!entry?.handle) continue;
    if (await isHandleAlreadyAdded(entry.handle)) continue;
    const permitted = await ensurePermission(entry.handle, { request: false });
    if (!permitted) {
      const session = await createSession(entry.handle, {
        skipRefresh: true,
        locked: true,
        name: entry.name || entry.handle.name,
      });
      session.storageId = entry.id;
      sessions.set(session.key, session);
      lockedCount += 1;
      continue;
    }

    const session = await createSession(entry.handle, {
      name: entry.name || entry.handle.name,
    });
    session.storageId = entry.id;
    sessions.set(session.key, session);
    restoredCount += 1;
  }

  if (restoredCount > 0) {
    renderSessions();
    startRefresh();
    await refreshAll();
  }

  if (lockedCount > 0) {
    setSupportMessage(
      "Stored sessions found. Click Authorize to re-enable access."
    );
  }
}

async function isHandleAlreadyAdded(handle) {
  for (const session of sessions.values()) {
    try {
      if (!session.dirHandle) continue;
      if (await session.dirHandle.isSameEntry(handle)) return true;
    } catch (_) {
      continue;
    }
  }
  return false;
}

function isCacheEntryActive(cacheId) {
  for (const session of sessions.values()) {
    if (session.cacheId === cacheId) return true;
  }
  return false;
}

function removeCachedSessionsBySessionId(sessionId) {
  if (!sessionId) return;
  for (const [key, session] of sessions.entries()) {
    if (!session.isCached) continue;
    if (session.data?.sessionId === sessionId) {
      sessions.delete(key);
    }
  }
}

async function openStorage() {
  if (!("indexedDB" in window)) return null;
  if (storagePromise) return storagePromise;

  storagePromise = new Promise((resolve) => {
    const request = indexedDB.open(STORAGE_DB, 1);
    request.onupgradeneeded = () => {
      const db = request.result;
      if (!db.objectStoreNames.contains(STORAGE_STORE)) {
        db.createObjectStore(STORAGE_STORE, { keyPath: "id", autoIncrement: true });
      }
    };
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => {
      setSupportMessage(
        "Folder access persistence is unavailable here. Cached snapshots will be used."
      );
      resolve(null);
    };
  });

  return storagePromise;
}

async function getAllStoredHandles() {
  const db = await openStorage();
  if (!db) return [];

  return new Promise((resolve) => {
    const tx = db.transaction(STORAGE_STORE, "readonly");
    const store = tx.objectStore(STORAGE_STORE);
    const request = store.getAll();
    request.onsuccess = () => resolve(request.result || []);
    request.onerror = () => resolve([]);
  });
}

async function saveHandleIfNeeded(handle) {
  const db = await openStorage();
  if (!db) return null;

  const existing = await getAllStoredHandles();
  for (const entry of existing) {
    if (!entry?.handle) continue;
    try {
      if (await entry.handle.isSameEntry(handle)) {
        return entry.id;
      }
    } catch (_) {
      continue;
    }
  }

  return new Promise((resolve) => {
    const tx = db.transaction(STORAGE_STORE, "readwrite");
    const store = tx.objectStore(STORAGE_STORE);
    const request = store.add({
      handle,
      name: handle.name,
      addedAt: new Date().toISOString(),
    });
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => {
      if (request.error?.name === "DataCloneError") {
        setSupportMessage(
          "Folder access can't be persisted on file://. Cached snapshots will be used."
        );
      }
      resolve(null);
    };
  });
}

async function deleteStoredHandle(id) {
  if (!id) return;
  const db = await openStorage();
  if (!db) return;

  return new Promise((resolve) => {
    const tx = db.transaction(STORAGE_STORE, "readwrite");
    const store = tx.objectStore(STORAGE_STORE);
    const request = store.delete(id);
    request.onsuccess = () => resolve();
    request.onerror = () => resolve();
  });
}

async function clearStoredHandles() {
  const db = await openStorage();
  if (!db) return;

  return new Promise((resolve) => {
    const tx = db.transaction(STORAGE_STORE, "readwrite");
    const store = tx.objectStore(STORAGE_STORE);
    const request = store.clear();
    request.onsuccess = () => resolve();
    request.onerror = () => resolve();
  });
}

function startRefresh() {
  if (refreshTimer) return;
  refreshTimer = setInterval(refreshAll, 1000);
}

function stopRefresh() {
  if (!refreshTimer) return;
  clearInterval(refreshTimer);
  refreshTimer = null;
}

function mergeStatus(meta, status) {
  const result = { ...meta, ...status };

  const arrayKeys = [
    "completedSteps",
    "completedPhases",
    "agents",
    "errors",
    "recentFiles",
    "completedTasks",
  ];

  for (const key of arrayKeys) {
    const values = [meta[key], status[key]].filter((value) => Array.isArray(value));
    if (values.length > 0) {
      result[key] = values.reduce((a, b) => (a.length >= b.length ? a : b));
    }
  }

  if (status?.progress && status.progress > 0) {
    result.progress = status.progress;
  }

  return result;
}

function buildSessionSignature(session) {
  return JSON.stringify({
    data: session.data || {},
    error: session.error || "",
    name: session.name || "",
    locked: Boolean(session.locked),
    cachedAt: session.cachedAt || "",
  });
}

function updateRuntimeDisplays() {
  for (const card of sessionElements.values()) {
    const runtimeEl = card.querySelector("[data-field='runtime']");
    if (!runtimeEl) continue;
    const startTime = runtimeEl.dataset.start || "";
    runtimeEl.textContent = formatRuntime(startTime);
  }
}

function updateGridColumns() {
  if (!sessionList) return;
  const count = sessions.size || 1;
  const maxColumns = getMaxColumnsForViewport();
  const columns = Math.max(1, Math.min(count, maxColumns, 4));
  sessionList.style.setProperty("--items-per-row", String(columns));
}

function getMaxColumnsForViewport() {
  if (window.matchMedia("(max-width: 720px)").matches) return 1;
  if (window.matchMedia("(max-width: 1050px)").matches) return 2;
  if (window.matchMedia("(max-width: 1400px)").matches) return 3;
  return 4;
}

function renderLocked(session) {
  const cachedAt = session.cachedAt ? formatTimestamp(session.cachedAt) : "-";
  const message = session.isCached
    ? `Cached snapshot from ${cachedAt}. Drag & drop to resume live updates.`
    : "Saved session needs permission to load.";
  const button = session.dirHandle
    ? `<button class="mini-btn" data-action="authorize" data-session="${escapeAttribute(
        session.key
      )}">Authorize</button>`
    : "";

  return `
    <div class="block warning">
      <div class="block-title">Access Required</div>
      <div class="list">${escapeHtml(message)}</div>
      ${button}
    </div>
  `;
}

function renderSessions() {
  if (sessions.size === 0) {
    sessionList.innerHTML = "";
    sessionElements.clear();
    updateGridColumns();
    return;
  }

  const activeKeys = new Set();

  for (const session of sessions.values()) {
    activeKeys.add(session.key);
    let card = sessionElements.get(session.key);
    if (!card) {
      card = document.createElement("article");
      card.className = "session-card";
      sessionElements.set(session.key, card);
      sessionList.appendChild(card);
    }

    const signature = buildSessionSignature(session);
    if (card.dataset.signature !== signature) {
      card.dataset.signature = signature;
      card.innerHTML = renderSessionCardInner(session);
    }
  }

  for (const [key, card] of sessionElements.entries()) {
    if (!activeKeys.has(key)) {
      card.remove();
      sessionElements.delete(key);
    }
  }

  updateGridColumns();
  updateRuntimeDisplays();
}

function renderSessionCardInner(session) {
  const data = session.data || {};
  const isLocked = session.locked;
  const mode = isLocked ? "locked" : resolveMode(data);
  const sessionId = data.sessionId || session.name || "unknown";
  const status = isLocked ? "locked" : data.status || "waiting";
  const startTime = data.startTime || data.startedAt || "";
  const runtime = formatRuntime(startTime);
  const lastUpdate = data.lastUpdate || data.lastCheckpoint || "";
  const modeLabel =
    mode === "execute" ? "EXECUTE" : mode === "locked" ? "LOCKED" : "SPEC-IT";
  const pillClass =
    mode === "execute" ? "execute" : mode === "locked" ? "error" : "plan";
  const statusLine = isLocked
    ? "LOCKED | permission required"
    : `${modeLabel} | ${escapeHtml(status)} | runtime <span data-field="runtime" data-start="${escapeAttribute(
        startTime
      )}">${runtime}</span>`;
  const errorBlock = session.error
    ? `<div class="block"><div class="block-title">Status</div><div class="pill error">${escapeHtml(
        session.error
      )}</div></div>`
    : "";

  const body = isLocked
    ? renderLocked(session)
    : mode === "execute"
      ? renderExecute(data)
      : renderSpecIt(data);
  const errors = Array.isArray(data.errors) ? data.errors : [];
  const errorList =
    errors.length > 0
      ? `<div class="block"><div class="block-title">Errors</div><div class="list">${errors
          .slice(0, 4)
          .map((item) => `<div>${escapeHtml(item)}</div>`)
          .join("")}</div></div>`
      : "";

  const waiting = data.waitingForUser
    ? `<div class="overlay">
        <div class="overlay-inner">
          <div class="overlay-icon" aria-hidden="true">!</div>
          <div class="overlay-text">${escapeHtml(
            data.waitingMessage || "Waiting for user input"
          )}</div>
        </div>
      </div>`
    : "";

  return `
    <div class="session-header">
      <div>
        <div class="session-id">${escapeHtml(sessionId)}</div>
        <div class="session-meta">${statusLine}</div>
      </div>
      <div class="session-actions">
        <span class="pill ${pillClass}">${modeLabel}</span>
        <button class="session-remove" data-action="remove" data-session="${escapeAttribute(
          session.key
        )}" aria-label="Remove session" title="Remove session">
          <span aria-hidden="true">&#128465;</span>
        </button>
      </div>
    </div>
    ${errorBlock}
    ${body}
    ${errorList}
    <div class="session-footer">
      <div>Last update: ${escapeHtml(formatTimestamp(lastUpdate))}</div>
      <div>${escapeHtml(data.sessionId || "")}</div>
    </div>
    ${waiting}
  `;
}

function renderSpecIt(data) {
  const phases = buildSpecItPhases(data);
  const overall = getOverallProgress(phases, data.progress);
  const currentPhase = Number(data.currentPhase) || 1;
  const currentStep = data.currentStep || "";
  const status = data.status || "in_progress";
  const stats = data.stats || {};
  const filesCreated = stats.filesCreated ?? 0;
  const linesWritten = stats.linesWritten ?? 0;
  const agents = Array.isArray(data.agents) ? data.agents : [];
  const recent = Array.isArray(data.recentFiles) ? data.recentFiles : [];

  const phaseRows = phases
    .map(
      (phase) => `
      <div class="phase-row">
        <div>${phase.num}. ${escapeHtml(phase.name)}</div>
        <div class="progress"><span style="width:${phase.progress}%"></span></div>
        <div>${phase.progress}%</div>
      </div>
    `
    )
    .join("");

  const currentLine =
    status === "completed"
      ? "All phases completed"
      : `Phase ${currentPhase} - Step ${currentStep}`;

  return `
    <div class="block">
      <div class="block-title">Phases</div>
      ${phaseRows}
    </div>
    <div class="block">
      <div class="block-title">Overall</div>
      <div class="overall">
        <div class="progress"><span style="width:${overall}%"></span></div>
        <div>${overall}%</div>
      </div>
    </div>
    <div class="block">
      <div class="block-title">Current</div>
      <div>${escapeHtml(currentLine)}</div>
    </div>
    <div class="block">
      <div class="block-title">Stats</div>
      <div class="stat-row">
        <div><strong>${filesCreated}</strong> files created</div>
        <div><strong>${linesWritten}</strong> lines written</div>
      </div>
    </div>
    ${renderAgents(agents)}
    ${renderRecentFiles(recent)}
  `;
}

function renderExecute(data) {
  const phases = buildExecutePhases(data);
  const overall = getOverallProgress(phases, data.progress);
  const status = data.status || "in_progress";
  const currentPhase = Number(data.currentPhase) || 1;
  const currentStep = data.currentStep || "";
  const currentTask = data.currentTask || "";
  const completedTasks = Array.isArray(data.completedTasks) && data.completedTasks.length > 0
    ? data.completedTasks.length
    : agents.filter((a) => a.status === "completed" || a.status === "complete").length;
  const qaAttempts = data.qaAttempts ?? 0;
  const maxQa = data.maxQaAttempts ?? 0;
  const agents = Array.isArray(data.agents) ? data.agents : [];
  const recent = Array.isArray(data.recentFiles) ? data.recentFiles : [];

  const phaseRows = phases
    .map(
      (phase) => `
      <div class="phase-row">
        <div>${phase.num}. ${escapeHtml(phase.name)}</div>
        <div class="progress"><span style="width:${phase.progress}%"></span></div>
        <div>${phase.progress}%</div>
      </div>
    `
    )
    .join("");

  const devPilotProgress = data.devPilotPhase3Progress;
  const currentLine = currentTask
    ? currentTask
    : status === "completed"
      ? "All tasks completed"
      : devPilotProgress !== undefined
        ? `Phase 3 - EXECUTE (workers ${devPilotProgress}%)`
        : `Phase ${currentPhase} - Step ${currentStep}`;

  return `
    <div class="block">
      <div class="block-title">Phases</div>
      ${phaseRows}
    </div>
    <div class="block">
      <div class="block-title">Overall</div>
      <div class="overall">
        <div class="progress"><span style="width:${overall}%"></span></div>
        <div>${overall}%</div>
      </div>
    </div>
    <div class="block">
      <div class="block-title">Current Task</div>
      <div>${escapeHtml(currentLine)}</div>
    </div>
    <div class="block">
      <div class="block-title">Stats</div>
      <div class="stat-row">
        <div><strong>${completedTasks}</strong> tasks completed</div>
        <div><strong>${qaAttempts}/${maxQa}</strong> QA attempts</div>
      </div>
    </div>
    ${renderAgents(agents)}
    ${renderRecentFiles(recent)}
  `;
}

function renderAgents(agents) {
  if (!agents || agents.length === 0) {
    return `
      <div class="block">
        <div class="block-title">Agents</div>
        <div class="list">No agents tracked yet</div>
      </div>
    `;
  }

  const chips = agents
    .slice(0, 6)
    .map((agent) => {
      const status = agent.status || "pending";
      return `<div class="agent-chip ${escapeHtml(status)}">${escapeHtml(
        agent.name || "agent"
      )} - ${escapeHtml(status)}</div>`;
    })
    .join("");

  return `
    <div class="block">
      <div class="block-title">Agents</div>
      <div class="agent-list">${chips}</div>
    </div>
  `;
}

function renderRecentFiles(files) {
  if (!files || files.length === 0) return "";
  const items = files
    .slice(0, 4)
    .map((file) => `<div>${escapeHtml(file)}</div>`)
    .join("");

  return `
    <div class="block">
      <div class="block-title">Recent Files</div>
      <div class="list">${items}</div>
    </div>
  `;
}

function buildSpecItPhases(data) {
  const phases = [
    { num: 1, name: "BRAINSTORM", steps: ["1.1", "1.2", "1.3", "1.4"] },
    { num: 2, name: "UI-ARCH", steps: ["2.1", "2.2"] },
    { num: 3, name: "REVIEW", steps: ["3.1", "3.2"] },
    { num: 4, name: "TEST-SPEC", steps: ["4.1"] },
    { num: 5, name: "ASSEMBLY", steps: ["5.1"] },
    { num: 6, name: "APPROVAL", steps: ["6.1"] },
  ];

  return fillPhaseProgress(phases, data, 6);
}

function buildExecutePhases(data) {
  const phases = [
    { num: 1, name: "LOAD", steps: ["1.1", "1.2", "1.3"] },
    { num: 2, name: "PLAN", steps: ["2.1", "2.2"] },
    { num: 3, name: "EXECUTE", steps: ["3.0", "3.1"] },
    { num: 4, name: "QA", steps: ["4.1"] },
    { num: 5, name: "MIRROR", steps: ["5.1", "5.2"] },
    { num: 6, name: "UNIT", steps: ["6.1", "6.2", "6.3"] },
    { num: 7, name: "E2E", steps: ["7.1", "7.2", "7.3"] },
    { num: 8, name: "REVIEW", steps: ["8.1", "8.2"] },
    { num: 9, name: "DONE", steps: ["9.1"] },
  ];

  return fillPhaseProgress(phases, data, 9);
}

function fillPhaseProgress(phases, data, totalPhases) {
  const currentPhase = Number(data.currentPhase) || 1;
  const currentStep = data.currentStep || "";
  const status = data.status || "in_progress";
  const completedPhases = Array.isArray(data.completedPhases)
    ? data.completedPhases.map((phase) => Number(phase))
    : [];

  return phases.map((phase) => {
    const isComplete =
      completedPhases.includes(phase.num) ||
      (status === "completed" && phase.num <= totalPhases);
    const isCurrent = phase.num === currentPhase && !isComplete;

    let progress = 0;
    if (isComplete) {
      progress = 100;
    } else if (isCurrent) {
      // Use agent-reported progress for phases with background state files
      if (phase.num === 3 && data.devPilotPhase3Progress !== undefined) {
        progress = data.devPilotPhase3Progress;
      } else if ((phase.num === 6 || phase.num === 7) && data.ultraqaPhaseProgress !== undefined) {
        progress = data.ultraqaPhaseProgress;
      } else if (currentStep) {
        const stepIndex = phase.steps.indexOf(currentStep);
        if (stepIndex >= 0 && phase.steps.length > 0) {
          progress = Math.round(
            (stepIndex / phase.steps.length) * 100 +
              50 / phase.steps.length
          );
        } else {
          progress = 10;
        }
      }
    }

    return {
      ...phase,
      progress: Math.min(100, Math.max(0, progress)),
    };
  });
}

function getOverallProgress(phases, fallback) {
  if (fallback && fallback > 0) return Math.round(fallback);
  if (!phases || phases.length === 0) return 0;
  const total = phases.reduce((sum, phase) => sum + phase.progress, 0);
  return Math.round(total / phases.length);
}

function resolveMode(data) {
  if (data.mode === "execute") return "execute";
  if (data.mode === "plan") return "spec-it";
  if (data.specSource || data.qaAttempts !== undefined) return "execute";
  return "spec-it";
}

function formatRuntime(startTime) {
  if (!startTime) return "00:00:00";
  const start = new Date(startTime);
  if (Number.isNaN(start.getTime())) return "00:00:00";
  const seconds = Math.max(0, Math.floor((Date.now() - start.getTime()) / 1000));
  const hours = String(Math.floor(seconds / 3600)).padStart(2, "0");
  const minutes = String(Math.floor((seconds % 3600) / 60)).padStart(2, "0");
  const secs = String(seconds % 60).padStart(2, "0");
  return `${hours}:${minutes}:${secs}`;
}

function formatTimestamp(value) {
  if (!value) return "-";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;
  return date.toLocaleString();
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function escapeAttribute(value) {
  return escapeHtml(value);
}

function getCachedSessions() {
  try {
    const raw = localStorage.getItem(CACHE_KEY);
    const parsed = raw ? JSON.parse(raw) : [];
    return Array.isArray(parsed) ? parsed : [];
  } catch (_) {
    return [];
  }
}

function saveCachedSessions(list) {
  try {
    localStorage.setItem(CACHE_KEY, JSON.stringify(list));
  } catch (_) {
    return;
  }
}

function cacheSessionSnapshot(session) {
  if (!session?.data || session.locked) return;
  const cacheId = buildCacheId(session);
  if (!cacheId) return;

  const cachedAt = new Date().toISOString();
  const entry = {
    cacheId,
    name: session.name || session.data.sessionId || "session",
    data: session.data,
    cachedAt,
  };

  const list = getCachedSessions();
  const index = list.findIndex((item) => item.cacheId === cacheId);
  if (index >= 0) {
    list[index] = entry;
  } else {
    list.push(entry);
  }

  session.cacheId = cacheId;
  session.cachedAt = cachedAt;
  saveCachedSessions(list);
}

function buildCacheId(session) {
  const data = session.data || {};
  const sessionId = data.sessionId || session.name;
  if (!sessionId) return "";
  const mode = resolveMode(data);
  const startTime = data.startTime || data.startedAt || "";
  return `${sessionId}|${mode}|${startTime}`;
}

function deleteCachedSession(cacheId) {
  if (!cacheId) return;
  const list = getCachedSessions();
  const next = list.filter((item) => item.cacheId !== cacheId);
  saveCachedSessions(next);
}

function clearCachedSessions() {
  try {
    localStorage.removeItem(CACHE_KEY);
  } catch (_) {
    return;
  }
}

function updateSupportMessage() {
  if (!supportsFilePicker && !supportsDropHandle) {
    setSupportMessage(
      "This browser cannot access folders. Use a Chromium browser."
    );
    return;
  }

  if (!supportsDropHandle) {
    setSupportMessage(
      "Drag and drop needs Chromium. Use Add Session instead."
    );
    return;
  }

  setSupportMessage(
    "Tip: dropping .spec-it/{sessionId} will auto-add plan and execute if present."
  );
}

function setSupportMessage(message) {
  supportMessage.textContent = message;
}

// ── Telegram Notifications ──

const TG_TOKEN_KEY = "spec-it-tg-token";
const TG_CHAT_KEY = "spec-it-tg-chat";
const prevSessionStates = new Map();

// Try to load config file as fallback defaults
(function loadTelegramConfigFile() {
  window.__TELEGRAM__ = window.__TELEGRAM__ || {};

  const path = location.pathname;
  let configPath = null;

  const claudeIdx = path.indexOf("/.claude/");
  if (claudeIdx > 0) {
    configPath = path.substring(0, claudeIdx) + "/.claude/hooks/spec-it/telegram-config.js";
  } else {
    const homeMatch = path.match(/^(\/Users\/[^/]+|\/home\/[^/]+)/);
    if (homeMatch) {
      configPath = homeMatch[1] + "/.claude/hooks/spec-it/telegram-config.js";
    }
  }

  if (!configPath) {
    initTelegramUI();
    return;
  }

  const script = document.createElement("script");
  script.src = configPath;
  script.onload = () => initTelegramUI();
  script.onerror = () => initTelegramUI();
  document.head.appendChild(script);
})();

function getTelegramCredentials() {
  const storedToken = localStorage.getItem(TG_TOKEN_KEY);
  const storedChat = localStorage.getItem(TG_CHAT_KEY);
  const fileCfg = window.__TELEGRAM__ || {};

  return {
    botToken: storedToken || fileCfg.botToken || "",
    chatId: storedChat || fileCfg.chatId || "",
  };
}

function isTelegramConfigured() {
  const { botToken, chatId } = getTelegramCredentials();
  return Boolean(botToken && chatId);
}

function initTelegramUI() {
  const { botToken, chatId } = getTelegramCredentials();
  const tokenInput = document.getElementById("tg-bot-token");
  const chatInput = document.getElementById("tg-chat-id");
  if (tokenInput && botToken) tokenInput.value = botToken;
  if (chatInput && chatId) chatInput.value = chatId;
  updateTelegramUI();
}

function updateTelegramUI() {
  const toggle = document.getElementById("telegram-toggle");
  const status = document.getElementById("tg-status");
  if (!toggle) return;

  const configured = isTelegramConfigured();
  toggle.textContent = configured ? "Telegram ON" : "Telegram";

  if (status) {
    status.textContent = configured ? "Active" : "Enter Bot Token and Chat ID, then Save";
    status.style.color = configured ? "var(--ok)" : "var(--muted)";
  }
}

async function sendTelegram(text) {
  const { botToken, chatId } = getTelegramCredentials();
  if (!botToken || !chatId) return;

  try {
    await fetch(`https://api.telegram.org/bot${botToken}/sendMessage`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        chat_id: chatId,
        text,
        disable_notification: false,
      }),
    });
  } catch (_) {
    // silently fail
  }
}

function detectSessionChanges(prev, curr) {
  const changes = [];
  if (!prev || Object.keys(prev).length === 0) return changes;

  if (Number(prev.currentPhase) !== Number(curr.currentPhase)) {
    changes.push({ type: "phase", from: prev.currentPhase, to: curr.currentPhase });
  }

  if (prev.status !== curr.status && curr.status) {
    changes.push({ type: "status", to: curr.status });
  }

  if (!prev.waitingForUser && curr.waitingForUser) {
    changes.push({ type: "waiting", message: curr.waitingMessage });
  }

  const pe = Array.isArray(prev.errors) ? prev.errors.length : 0;
  const ce = Array.isArray(curr.errors) ? curr.errors.length : 0;
  if (ce > pe) {
    changes.push({ type: "error", message: curr.errors[ce - 1] });
  }

  return changes;
}

function notifyTelegramIfNeeded(session) {
  if (!isTelegramConfigured()) return;

  const data = session.data || {};
  const prev = prevSessionStates.get(session.key);
  prevSessionStates.set(session.key, { ...data });

  const changes = detectSessionChanges(prev, data);
  if (changes.length === 0) return;

  const sessionId = data.sessionId || session.name || "unknown";
  const mode = resolveMode(data);
  const label = mode === "execute" ? "EXECUTE" : "SPEC-IT";
  const lines = [`[${label}] ${sessionId}`];

  for (const c of changes) {
    switch (c.type) {
      case "phase":
        lines.push(`Phase ${c.from || "?"} → ${c.to}`);
        break;
      case "status":
        lines.push(`Status: ${c.to}`);
        break;
      case "waiting":
        lines.push(`Waiting: ${c.message || "User input needed"}`);
        break;
      case "error":
        lines.push(`Error: ${c.message || "Error occurred"}`);
        break;
    }
  }

  lines.push(`Progress: ${data.progress || 0}%`);
  sendTelegram(lines.join("\n"));
}
