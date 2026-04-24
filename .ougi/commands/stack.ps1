# stack.ps1 - Apply a preset to the Ougi Code CLI config
# Usage: .\.ougi\commands\stack.ps1 [<preset-name>|<number>]
param(
    [Parameter(Mandatory=$false)]
    [string]$Preset
)

$repoRoot = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$stacksDir = Join-Path $repoRoot ".ougi\stacks"
$configPath = Join-Path $repoRoot "ougi.json"
$stackStatePath = Join-Path $repoRoot ".ougi\active-stack"

$available = Get-ChildItem $stacksDir -Filter "*.json" | ForEach-Object { $_.BaseName } | Sort-Object

function Show-StaticMenu {
    param([int]$HighlightIndex = -1)
    Write-Host ""
    Write-Host "Available Ougi Code CLI presets:" -ForegroundColor Cyan
    Write-Host ""
    for ($i = 0; $i -lt $available.Count; $i++) {
        $presetFile = Get-Content (Join-Path $stacksDir "$($available[$i]).json") -Raw | ConvertFrom-Json
        if ($i -eq $HighlightIndex) {
            Write-Host ("> [{0}] {1,-15} {2}" -f ($i + 1), $available[$i], $presetFile.description) -ForegroundColor Cyan
        } else {
            Write-Host ("  [{0}] {1,-15} {2}" -f ($i + 1), $available[$i], $presetFile.description)
        }
    }
    Write-Host ""
}

function Show-Instructions {
    Write-Host "Select a stack by passing its name or number as an argument:" -ForegroundColor Yellow
    Write-Host ""
    for ($i = 0; $i -lt $available.Count; $i++) {
        Write-Host ("  .\.ougi\commands\stack.ps1 {0,-15}  # or: .\.ougi\commands\stack.ps1 {1}" -f $available[$i], ($i + 1))
    }
    Write-Host ""
}

function Invoke-ArrowMenu {
    param([array]$Items)

    Clear-Host
    Write-Host ""
    Write-Host "  Select a stack (use arrow keys, Enter to confirm, Esc to cancel):" -ForegroundColor Cyan
    Write-Host ""

    $selected = 0
    $menuStartRow = [Console]::CursorTop

    function Draw-MenuLine($index) {
        $presetFile = Get-Content (Join-Path $stacksDir "$($Items[$index]).json") -Raw | ConvertFrom-Json
        $prefix = if ($index -eq $selected) { "> " } else { "  " }
        $nameColor = if ($index -eq $selected) { "Cyan" } else { "White" }
        $num = $index + 1

        $clear = " " * ([Console]::WindowWidth - 1)
        [Console]::SetCursorPosition(0, $menuStartRow + $index)
        [Console]::Write($clear)
        [Console]::SetCursorPosition(0, $menuStartRow + $index)

        Write-Host $prefix -NoNewline
        Write-Host "[$num] $($Items[$index])" -NoNewline -ForegroundColor $nameColor
        Write-Host "   $($presetFile.description)"
    }

    for ($i = 0; $i -lt $Items.Count; $i++) {
        Draw-MenuLine $i
    }

    $instrRow = $menuStartRow + $Items.Count + 1
    [Console]::SetCursorPosition(0, $instrRow)
    Write-Host "  [Up/Down] Navigate   [Enter] Confirm   [Esc] Cancel" -ForegroundColor DarkGray

    while ($true) {
        try {
            $key = [Console]::ReadKey($true)
        } catch {
            return $null
        }

        $old = $selected

        switch ($key.Key) {
            "UpArrow"    { if ($selected -gt 0) { $selected-- } }
            "DownArrow"  { if ($selected -lt $Items.Count - 1) { $selected++ } }
            "Enter"      { return $Items[$selected] }
            "Escape"     { return $null }
            "D1"         { if ($Items.Count -ge 1) { return $Items[0] } }
            "D2"         { if ($Items.Count -ge 2) { return $Items[1] } }
            "D3"         { if ($Items.Count -ge 3) { return $Items[2] } }
            "D4"         { if ($Items.Count -ge 4) { return $Items[3] } }
            "D5"         { if ($Items.Count -ge 5) { return $Items[4] } }
            "D6"         { if ($Items.Count -ge 6) { return $Items[5] } }
            "D7"         { if ($Items.Count -ge 7) { return $Items[6] } }
            "D8"         { if ($Items.Count -ge 8) { return $Items[7] } }
            "D9"         { if ($Items.Count -ge 9) { return $Items[8] } }
        }

        if ($old -ne $selected) {
            Draw-MenuLine $old
            Draw-MenuLine $selected
        }
    }
}

# If no preset provided, try interactive menu
if ([string]::IsNullOrWhiteSpace($Preset)) {
    # Detect non-interactive session (e.g., AI agent terminals, CI, piped input)
    $isNonInteractive = -not [Environment]::UserInteractive -or
                        ($Host.Name -eq "ServerRemoteHost") -or
                        ($Host.Name -eq "Visual Studio Code Host" -and -not $env:TERM_PROGRAM) -or
                        ($Host.Name -match "EditorServices") -or
                        ($null -eq $Host.UI.RawUI.KeyAvailable -and [Console]::IsInputRedirected)

    # Extra safety: try console APIs; if they throw, we have no real console
    if (-not $isNonInteractive) {
        try {
            [void][Console]::CursorTop
            [void][Console]::WindowWidth
        } catch {
            $isNonInteractive = $true
        }
    }

    if ($isNonInteractive) {
        Show-StaticMenu
        Write-Host "Non-interactive session detected." -ForegroundColor Yellow
        Show-Instructions
        exit 0
    }

    $result = Invoke-ArrowMenu -Items $available

    if ($result) {
        $Preset = $result
    } else {
        Write-Host ""
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Resolve numeric argument to preset name
if ($Preset -match '^\d+$') {
    $index = [int]$Preset - 1
    if ($index -ge 0 -and $index -lt $available.Count) {
        $Preset = $available[$index]
    } else {
        Write-Error "Invalid selection '$Preset'. Valid range: 1-$($available.Count)"
        exit 1
    }
}

$presetPath = Join-Path $stacksDir "$Preset.json"

if (-not (Test-Path $presetPath)) {
    Write-Error "Preset not found: $Preset"
    Write-Host "Available Ougi Code CLI presets: $($available -join ', ')"
    exit 1
}

if (-not (Test-Path $configPath)) {
    Write-Error "Config not found: $configPath"
    exit 1
}

$presetData = Get-Content $presetPath -Raw | ConvertFrom-Json
$config = Get-Content $configPath -Raw | ConvertFrom-Json

$config.model = $presetData.model
$config.small_model = $presetData.small_model

foreach ($agentKey in $presetData.agents.PSObject.Properties.Name) {
    $agentPath = Join-Path $repoRoot ".ougi\agents\$agentKey.md"
    if (-not (Test-Path $agentPath)) { continue }
    $agentText = Get-Content $agentPath -Raw
    $nextAgentText = [regex]::Replace($agentText, '(?m)^model:\s*.*$', "model: $($presetData.agents.$agentKey)")
    Set-Content $agentPath $nextAgentText -Encoding UTF8
}

$config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
Set-Content $stackStatePath $Preset -Encoding UTF8

Write-Host ""
Write-Host "Stack: $Preset" -ForegroundColor Cyan
Write-Host "- build: $($presetData.agents.build)"
Write-Host "- plan: $($presetData.agents.plan)"
Write-Host "- ux-engineer: $($presetData.agents.'ux-engineer')"
Write-Host "- reviewer: $($presetData.agents.reviewer)"
Write-Host "- release: $($presetData.agents.release)"
Write-Host "- small_model: $($config.small_model)"
if ($presetData.external_lanes) {
    Write-Host "- external: $($presetData.external_lanes.PSObject.Properties.Name -join ', ')"
}
Write-Host ""
Write-Host "Ougi Code CLI config updated: $configPath"
Write-Host "Active stack marker updated: $stackStatePath"
