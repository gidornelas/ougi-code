export const product = {
  name: "Ougi Code",
  shortName: "Ougi",
  cliName: "ougi",
  tagline: "Designer-engineer coding agent",
} as const

export const agent = {
  labels: {
    build: "build",
    plan: "plan",
    uxEngineer: "ux-engineer",
    reviewer: "reviewer",
    release: "release",
  },
} as const

export const stack = {
  labels: {
    default: "default",
    lean: "lean",
    hybridPro: "hybrid-pro",
  },
} as const

export const copy = {
  startup: {
    loading: "loading...",
    finishing: "finishing...",
  },
  status: {
    inspecting: "inspecting repository",
    planning: "planning task",
    applyingStack: "applying stack preset",
    reviewing: "reviewing diff",
    preparingRelease: "preparing release summary",
    buildCompleted: "build completed",
    filesChanged: (n: number) => `${n} file${n === 1 ? "" : "s"} changed`,
    next: (step: string) => `next: ${step}`,
    interrupted: "interrupted",
    queued: "queued",
  },
  toast: {
    copied: "copied",
    copiedToClipboard: "copied to clipboard",
    shareCopied: "share link copied",
    shareFailed: "share failed",
    unshared: "unshared",
    unshareFailed: "unshare failed",
    exportFailed: "export failed",
    sessionDeleted: "session deleted",
    updateFailed: "update failed",
    updateComplete: "update complete",
    forkFailed: "fork failed",
    connectProvider: "connect a provider to send prompts",
    noAssistantMessages: "no assistant messages",
    noTextParts: "no text found",
    providerAdded: "provider connected",
  },
  prompt: {
    agents: "agents",
    commands: "commands",
    shellMode: "shell mode",
    exitShell: "exit shell mode",
    interrupt: "interrupt",
    connect: "connect",
  },
  help: {
    title: "Help",
    close: "esc/enter",
    commandPaletteHint: (key: string) =>
      `Press ${key} to see all available actions and commands in any context.`,
    ok: "ok",
  },
  dialog: {
    status: {
      title: "Status",
      close: "esc",
      noMcp: "No MCP Servers",
      noFormatters: "No Formatters",
      noPlugins: "No Plugins",
    },
  },
  sidebar: {
    gettingStarted: "Getting started",
    gettingStartedDismiss: "dismiss",
    ready: "ready to use with your own providers and models.",
    connectProvider: "connect provider",
  },
  footer: {
    lsp: (n: number) => `${n} LSP`,
    mcp: (n: number) => `${n} MCP`,
    permission: (n: number) => `${n} permission${n === 1 ? "" : "s"}`,
  },
} as const

export * as Branding from "./branding"
