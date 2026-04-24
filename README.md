<p align="center">
  <a href="https://github.com/gidornelas/ougi-code">
    <picture>
      <source srcset="packages/console/app/src/asset/logo-ornate-dark.svg" media="(prefers-color-scheme: dark)">
      <source srcset="packages/console/app/src/asset/logo-ornate-light.svg" media="(prefers-color-scheme: light)">
      <img src="packages/console/app/src/asset/logo-ornate-light.svg" alt="Ougi Code logo">
    </picture>
  </a>
</p>
<p align="center">Designer-engineer coding agent.</p>
<p align="center">
  <a href="https://github.com/gidornelas/ougi-code"><img alt="GitHub" src="https://img.shields.io/badge/github-gidornelas%2Fougi--code-111111?style=flat-square" /></a>
  <a href="https://github.com/gidornelas/ougi-code/actions/workflows/publish.yml"><img alt="Build status" src="https://img.shields.io/github/actions/workflow/status/gidornelas/ougi-code/publish.yml?style=flat-square&branch=dev" /></a>
</p>

[![Ougi Code Terminal UI](packages/web/src/assets/lander/screenshot.png)](https://github.com/gidornelas/ougi-code)

---

## What Is Ougi?

Ougi Code is a fork of OpenCode focused on a designer-engineer workflow, custom agents, stack presets, and a Windows-friendly CLI/TUI setup.

This repository already includes:

- the `ougi` CLI branding and binary flow
- the `.ougi` workspace layer with custom agents, commands, prompts, skills, and stacks
- interactive stack switching inside the TUI
- a local Windows build pipeline for `ougi.exe`

## Installation

### Install From The Repo Script

```bash
curl -fsSL https://raw.githubusercontent.com/gidornelas/ougi-code/dev/install | bash
```

### Local Development Install

```bash
bun install
bun run link:ougi
ougi --help
```

This links the local fork globally through Bun, so your terminal uses this repository's `ougi` command.

### Build A Standalone Binary

```bash
cd packages/opencode
bun run script/build.ts --single --skip-install --skip-embed-web-ui
```

The built binary is generated under:

```bash
packages/opencode/dist/ougi-<platform>/bin/ougi
```

On Windows, the binary path is typically:

```powershell
packages\opencode\dist\ougi-windows-x64\bin\ougi.exe
```

## Configuration

Ougi supports its own config layout:

- `ougi.json`
- `.ougi/`
- global config under `~/.config/ougi` or `~/.ougi` depending on platform and launcher flow

The fork still preserves compatibility with legacy OpenCode config paths where needed, but the preferred user-facing layout is the Ougi one.

## Agents And Stacks

This fork is centered around the Ougi workflow layer in `.ougi/`.

Key pieces:

- `preset`: stack-first workflow agent
- `build`: implementation-focused agent
- `plan`: analysis-focused agent
- `.ougi/stacks`: reusable stack presets
- `.ougi/commands`: custom prompt commands
- `.ougi/skills`: custom workflow helpers

Inside the TUI:

- `Tab` cycles the active agent
- `Ctrl+X`, then `P` opens the command palette
- stack selection is available when the active agent is `preset`

## Documentation

Current repo docs:

- [Contributing](./CONTRIBUTING.md)
- [Ougi Improvements Report](./OUGI-IMPROVEMENTS-REPORT.md)
- [VS Code MCP + Extension Implementation Plan](./OUGI-VSCODE-MCP-IMPLEMENTATION.md)
- [CLI Rename Plan](./OUGI-CLI-RENAME-PLAN.md)

## Compatibility Note

Ougi is already a real fork, not just a launcher alias, but some lower-level compatibility layers still inherit upstream behavior from OpenCode.

That currently includes parts of:

- provider IDs
- auth/service endpoints
- GitHub automation plumbing
- some internal package names and paths

The user-facing direction of the project is Ougi-first, while compatibility shims remain where they are still useful.

## Contributing

If you want to work on the fork, start with [CONTRIBUTING.md](./CONTRIBUTING.md) and the repo instructions in [AGENTS.md](./AGENTS.md).

## Repository

- Main branch: `dev`
- Repository: `https://github.com/gidornelas/ougi-code`

