# stack-status.ps1 - Show current active stack and agent models
$repoRoot = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$stacksDir = Join-Path $repoRoot ".ougi\stacks"
$agentsDir = Join-Path $repoRoot ".ougi\agents"
$configPath = Join-Path $repoRoot "ougi.json"
$stackStatePath = Join-Path $repoRoot ".ougi\active-stack"

# Load active stack
$activeStack = if (Test-Path $stackStatePath) {
    (Get-Content $stackStatePath -Raw).Trim()
} else {
    "(none)"
}

# Load config
$config = if (Test-Path $configPath) {
    Get-Content $configPath -Raw | ConvertFrom-Json
} else {
    $null
}

Write-Host ""
Write-Host "Current Ougi Code CLI Stack" -ForegroundColor Cyan
Write-Host ("=" * 50)
Write-Host ""

# Active stack name
if ($activeStack -ne "(none)") {
    Write-Host "Active stack: " -NoNewline
    Write-Host $activeStack -ForegroundColor Green
} else {
    Write-Host "Active stack: " -NoNewline
    Write-Host "(none)" -ForegroundColor Yellow
}
Write-Host ""

# Global models
Write-Host "Global models:" -ForegroundColor Cyan
if ($config) {
    Write-Host ("  model:       {0}" -f $config.model)
    Write-Host ("  small_model: {0}" -f $config.small_model)
} else {
    Write-Host "  (config not found)" -ForegroundColor Yellow
}
Write-Host ""

# Agent models
Write-Host "Agent models:" -ForegroundColor Cyan
$agentFiles = Get-ChildItem $agentsDir -Filter "*.md" | Sort-Object Name
if ($agentFiles.Count -eq 0) {
    Write-Host "  (no agent files found)" -ForegroundColor Yellow
} else {
    $maxNameLen = ($agentFiles | ForEach-Object { $_.BaseName.Length } | Measure-Object -Maximum).Maximum
    foreach ($file in $agentFiles) {
        $content = Get-Content $file.FullName -Raw
        $model = if ($content -match '(?m)^model:\s*(.*)$') { $Matches[1].Trim() } else { "N/A" }
        Write-Host ("  {0,-$maxNameLen}  {1}" -f $file.BaseName, $model)
    }
}
Write-Host ""

# Show stack description if available
if ($activeStack -ne "(none)") {
    $presetPath = Join-Path $stacksDir "$activeStack.json"
    if (Test-Path $presetPath) {
        $preset = Get-Content $presetPath -Raw | ConvertFrom-Json
        Write-Host "Description: " -NoNewline -ForegroundColor Cyan
        Write-Host $preset.description
        if ($preset.external_lanes) {
            Write-Host ""
            Write-Host "External lanes:" -ForegroundColor Cyan
            foreach ($lane in $preset.external_lanes.PSObject.Properties) {
                Write-Host ("  {0,-12} {1}" -f $lane.Name, $lane.Value)
            }
        }
    }
}

Write-Host ""
Write-Host ("=" * 50)
Write-Host ""
Write-Host "To switch stack:  .\.ougi\commands\stack.ps1 <name-or-number>" -ForegroundColor DarkGray
Write-Host ""
