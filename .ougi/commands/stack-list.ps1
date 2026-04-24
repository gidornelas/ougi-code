# stack-list.ps1 - List available presets
$repoRoot = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$stacksDir = Join-Path $repoRoot ".ougi\stacks"
$stackStatePath = Join-Path $repoRoot ".ougi\active-stack"

$activeStack = if (Test-Path $stackStatePath) {
    (Get-Content $stackStatePath -Raw).Trim()
} else {
    $null
}

Write-Host ""
Write-Host "Available Ougi Code CLI presets:" -ForegroundColor Cyan
Write-Host ""

$index = 1
Get-ChildItem $stacksDir -Filter "*.json" | ForEach-Object {
    $preset = Get-Content $_.FullName -Raw | ConvertFrom-Json
    $marker = if ($preset.name -eq $activeStack) { "> " } else { "  " }
    $line = "{0}[{1}] {2,-15} {3}" -f $marker, $index, $preset.name, $preset.description
    if ($preset.name -eq $activeStack) {
        $line += "  <-- active"
        Write-Host $line -ForegroundColor Green
    } else {
        Write-Host $line
    }
    $index++
}

Write-Host ""
Write-Host "Usage: .\.ougi\commands\stack.ps1 <preset-name>"
Write-Host "       .\.ougi\commands\stack.ps1 <number>"
Write-Host "       .\.ougi\commands\stack-status.ps1   # show current"
Write-Host ""
