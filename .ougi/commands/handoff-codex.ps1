# handoff-codex.ps1 - Prepare Codex review handoff for Ougi Code CLI
$repoRoot = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$configPath = Join-Path $repoRoot "ougi.json"
$stackStatePath = Join-Path $repoRoot ".ougi\active-stack"

$config = Get-Content $configPath -Raw | ConvertFrom-Json
$activeStack = if (Test-Path $stackStatePath) { (Get-Content $stackStatePath -Raw).Trim() } else { "(unset)" }
$projectName = if ($config.name) { $config.name } else { "Ougi Code CLI" }
$description = if ($config.description) { $config.description } else { "Custom Ougi agent layer for this fork" }

$changes = ""
try {
    $gitDir = git rev-parse --git-dir 2>$null
    if ($gitDir) {
        $changes = git diff --name-only HEAD 2>$null
        if (-not $changes) { $changes = "(no uncommitted changes)" }
    } else {
        $changes = "(not a git repository)"
    }
} catch {
    $changes = "(git not available)"
}

$handoff = @"
## Codex Review Handoff

### Project Context
Repository: $projectName
Active stack: $activeStack
Purpose: $description

### Summary of Changes
$changes

### Key Files to Review
- (list files relevant to current change)

### Likely Risks
- (identify regression risks)
- (identify edge cases)

### Review Prompt
Review the above changes for:
- correctness
- edge cases
- security
- performance
- maintainability

Provide specific file:line references for any issues.
"@

Write-Host ""
Write-Host $handoff
Write-Host ""
