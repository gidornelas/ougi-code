# compress-memory.ps1 - Compress a prose file into lower-token form
# Usage: .\.ougi\commands\compress-memory.ps1 <file-path>
param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

$repoRoot = Split-Path -Parent $PSScriptRoot | Split-Path -Parent
$target = Join-Path $repoRoot $FilePath

if (-not (Test-Path $target)) {
    Write-Error "File not found: $target"
    exit 1
}

$backupPath = "$target.bak"
if (-not (Test-Path $backupPath)) {
    Copy-Item $target $backupPath
    Write-Host "Backup created: $backupPath"
}

$content = Get-Content $target -Raw
$lines = $content -split "`r?`n"
$result = @()
$inCodeBlock = $false

foreach ($line in $lines) {
    if ($line -match '^```') {
        $inCodeBlock = -not $inCodeBlock
        $result += $line
        continue
    }
    if ($inCodeBlock) {
        $result += $line
        continue
    }

    if ($line -match '[\w\-]+\.[a-zA-Z0-9]{2,6}(\s|$)') {
        $result += $line
        continue
    }
    if ($line -match 'https?://') {
        $result += $line
        continue
    }
    if ($line -match '\d{4}-\d{2}-\d{2}') {
        $result += $line
        continue
    }
    if ($line -match 'v?\d+\.\d+\.\d+') {
        $result += $line
        continue
    }
    if ($line -match '^[A-Z_]+=\d') {
        $result += $line
        continue
    }

    $compressed = $line `
        -replace '\bjust\b', '' `
        -replace '\breally\b', '' `
        -replace '\bbasically\b', '' `
        -replace '\bactually\b', '' `
        -replace '\bsimply\b', '' `
        -replace '\bvery\b', '' `
        -replace '\bquite\b', '' `
        -replace '\bthat is\b', 'i.e.' `
        -replace '\bfor example\b', 'e.g.' `
        -replace '\s+', ' ' `
        -replace '^\s+', '' `
        -replace '\s+$', ''

    if ($compressed -ne '') {
        $result += $compressed
    }
}

$compressedContent = $result -join "`n"
Set-Content $target $compressedContent -Encoding UTF8

Write-Host ""
Write-Host "Compressed: $target"
Write-Host "Backup: $backupPath"
Write-Host ""
