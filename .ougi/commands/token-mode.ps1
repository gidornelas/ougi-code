# token-mode.ps1 - Switch operational language mode
# Usage: .\.ougi\commands\token-mode.ps1 lean|normal
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("lean","normal")]
    [string]$Mode
)

$repoRoot = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$modeFile = Join-Path $repoRoot ".ougi\mode"

Set-Content $modeFile $Mode -Encoding UTF8

Write-Host ""
if ($Mode -eq "lean") {
    Write-Host "Token mode: LEAN" -ForegroundColor Yellow
    Write-Host "Marker set at $modeFile"
    Write-Host "Use this to inform agents/skills to apply compact language."
    Write-Host "Filler removed. Fragments OK. Technical tokens preserved."
} else {
    Write-Host "Token mode: NORMAL" -ForegroundColor Green
    Write-Host "Marker set at $modeFile"
    Write-Host "Standard operational language restored."
}
Write-Host ""
