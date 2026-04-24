# Ougi Code CLI - Agent Setup

## Architecture

Ougi Code CLI is a designer-engineer coding agent built on an explicit model split.
It is maintained as a separate custom-agent fork alongside OpenCode.
This fork now uses `.ougi/` and `ougi.json` as its custom workspace layer.

| Phase | Model | Responsibility |
|---|---|---|
| Plan | GLM-5.1 | Investigation, decomposition, risk analysis |
| Build | Kimi K2.6 | Implementation, frontend execution, safe diffs |

Supporting agents:

| Agent | Model | Role |
|---|---|---|
| ux-engineer | Kimi K2.6 | UI/UX quality review |
| reviewer | minimax-m2.7 | Regression and safety |
| release | GLM-5.1 | Final validation and handoff |

External lanes:
- **Codex**: Premium review, audit, second opinion (`/handoff-codex`)
- **GPT-5.4**: Architecture and broad decisions (manual trigger)

Primary and supporting agents live in `.ougi\agents\`. Stack presets update the `model:` frontmatter in those files directly.

## Commands

Each command has a PowerShell script in `.ougi\commands\`:

```powershell
.\.ougi\commands\stack.ps1 <preset>
.\.ougi\commands\stack-list.ps1
.\.ougi\commands\handoff-codex.ps1
.\.ougi\commands\token-mode.ps1 lean|normal
.\.ougi\commands\compress-memory.ps1 <file>
```

| Command | Description |
|---|---|
| `stack` | Switch active model stack |
| `stack-list` | List available presets |
| `handoff-codex` | Prepare Codex review handoff for Ougi Code CLI |
| `token-mode` | Set lean/normal operational marker |
| `compress-memory` | Compress prose file, preserve backup |

## Presets

| Preset | Plan | Build | Reviewer | Release |
|---|---|---|---|---|
| go-balanced | GLM-5.1 | Kimi K2.6 | minimax-m2.7 | GLM-5.1 |
| go-throughput | qwen3.6-plus | Kimi K2.6 | Kimi K2.6 | qwen3.6-plus |
| hybrid-pro | GLM-5.1 | Kimi K2.6 | minimax-m2.7 | GLM-5.1 |
| go-minimal | qwen3.5-plus | Kimi K2.6 | qwen3.5-plus | qwen3.5-plus |

`hybrid-pro` is default. It includes external lanes (Codex, GPT-5.4).

## Fork Identity

- Public name: `Ougi Code CLI`
- Runtime layer: `.ougi/`, `ougi.json`, `.ougi/active-stack`, `.ougi/mode`
- Model/provider compatibility kept for now: `opencode-go/*`

## Token Efficiency

### RTK-Style Output Compression

For shell-heavy workflows, wrap noisy commands with a compact-output filter. Spec documented in `token-economy` skill. Preserves errors, file paths, versions, identifiers.

### Caveman Compression

For memory and rules files, use `caveman-compress` skill. Removes filler, uses fragments, preserves exact technical tokens. Always keeps a `.bak` backup.

## Adding a Preset

1. Create `.ougi/stacks/<name>.json` with `model`, `small_model`, and agent models.
2. Run `.\.ougi\commands\stack.ps1 <name>` to activate.
