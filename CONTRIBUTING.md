# Contributing To Ougi Code

This repository is the working fork for Ougi Code. The goal is not only to rename OpenCode, but to evolve it into a coherent Ougi-first product with its own CLI, workflow layer, and contributor experience.

## Good Contributions

The most common changes that are a good fit:

- bug fixes
- improvements to the TUI or CLI experience
- provider integration fixes
- stack, agent, and workflow improvements
- Windows compatibility improvements
- build/install/release fixes
- documentation cleanup

Core product changes are welcome, but if they affect workflow, branding, GitHub automation, auth, or packaging, prefer opening an issue or design discussion first.

## Before You Start

- Check existing issues in `gidornelas/ougi-code`
- Keep PRs focused
- Explain how you verified the change
- Read [AGENTS.md](./AGENTS.md) before making structural or style-sensitive edits

## Developing Ougi

- Requirements: Bun 1.3+
- Install from the repo root:

```bash
bun install
```

- Run the development CLI:

```bash
bun dev
```

By default, `bun dev` runs the Ougi CLI from `packages/opencode`.

To run it against a specific directory:

```bash
bun dev <directory>
```

To run it against this repository itself:

```bash
bun dev .
```

## Building Ougi

To compile a standalone binary:

```bash
./packages/opencode/script/build.ts --single
```

The output binary is:

```bash
./packages/opencode/dist/ougi-<platform>/bin/ougi
```

Replace `<platform>` with your build target such as `darwin-arm64`, `linux-x64`, or `windows-x64`.

## Local Linking

To link the local fork globally through Bun:

```bash
bun run link:ougi
```

To remove that global link:

```bash
bun run unlink:ougi
```

Inside `packages/opencode`, the lower-level equivalents are:

```bash
bun run link:global
bun run unlink:global
```

## Key Packages

- `packages/opencode`: Ougi core runtime, CLI, server, and TUI
- `packages/opencode/src/cli/cmd/tui/`: terminal UI written with Solid and OpenTUI
- `packages/app`: shared web UI components
- `packages/desktop`: desktop shell for the web app
- `packages/plugin`: source for `@opencode-ai/plugin`

## bun dev vs ougi

During development, `bun dev` is the local equivalent of the built `ougi` command.

```bash
# Development
bun dev --help
bun dev serve
bun dev web
bun dev <directory>

# Built / linked CLI
ougi --help
ougi serve
ougi web
ougi <directory>
```

## Running The API Server

To start the Ougi headless API server:

```bash
bun dev serve
```

To use another port:

```bash
bun dev serve --port 8080
```

## Running The Web App

For UI work:

1. Start the Ougi server
2. Run the web app

```bash
bun run --cwd packages/app dev
```

## Running The Desktop App

To run the native desktop shell:

```bash
bun run --cwd packages/desktop tauri dev
```

If you only want the web dev server for desktop:

```bash
bun run --cwd packages/desktop dev
```

To build the desktop bundle:

```bash
bun run --cwd packages/desktop tauri build
```

## Type Checking And Tests

- Run type checks from package directories, never from the repo root:

```bash
cd packages/opencode
bun typecheck
```

- Do not run tests from the repo root. The repo intentionally blocks that.
- Prefer real implementation tests over mocks.

## Regenerating Generated Artifacts

- JS SDK:

```bash
./packages/sdk/js/script/build.ts
```

If you change API or SDK surfaces, regenerate the relevant artifacts before opening a PR.

## Debugging

The most reliable way to debug Ougi is to run Bun manually with `--inspect` and attach from your debugger.

Examples:

```bash
bun run --inspect=ws://localhost:6499/ dev
```

For server-only debugging:

```bash
bun run --inspect=ws://localhost:6499/ --cwd packages/opencode ./src/index.ts serve --port 4096
```

Then attach the TUI with:

```bash
ougi attach http://localhost:4096
```

## Pull Request Expectations

### Issue First

Open an issue before a feature PR whenever the change is product-level, workflow-level, or likely to alter fork direction.

### Keep PRs Small

- keep scope tight
- explain the problem clearly
- explain how you verified the fix

### UI Changes

Include screenshots or video when the change affects the TUI, dialogs, colors, layout, or interactive flows.

### No AI Slop

Do not submit long AI-generated walls of text in PR descriptions or issues. Keep them short, specific, and grounded in the actual change.

### PR Titles

Use conventional commit style:

- `feat:`
- `fix:`
- `docs:`
- `chore:`
- `refactor:`
- `test:`

Optional scopes are fine, for example:

- `feat(app):`
- `fix(desktop):`
- `chore(ougi):`

## Feature Requests

For net-new functionality, start with a design conversation. If the change affects branding, GitHub automation, auth, provider strategy, or the fork/upstream boundary, discuss it before implementation.

## Trust And Collaboration

Contributions should help move the fork toward a more coherent Ougi-first product. If a change keeps the old OpenCode behavior for compatibility, make that explicit in the PR so reviewers can tell whether it is intentional or accidental.
