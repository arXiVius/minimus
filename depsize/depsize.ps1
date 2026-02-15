<#
.SYNOPSIS
    minimus depsize - dependency size analyzer
.DESCRIPTION
    calculates the disk usage of dependencies in node_modules or venv.
.PARAMETER Help
    show this help message.
#>
param (
    [switch]$Help
)

if ($Help) {
    Write-Host "minimus depsize" -ForegroundColor Cyan
    Write-Host "usage: ./depsize.ps1"
    Write-Host ""
    Write-Host "shows size of dependencies in node_modules or venv."
    exit
}

# ASCII Art
Write-Host " _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ " -ForegroundColor DarkGray
Write-Host "| '_ `` _ \| | '_ \| | '_ `` _ \| | | / __|" -ForegroundColor Gray
Write-Host "| | | | | | | | | | | | | | | | |_| \__ \" -ForegroundColor White
Write-Host "|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/" -ForegroundColor Cyan
Write-Host "minimus depsize" -ForegroundColor Cyan
Write-Host ""

$currentDir = Get-Location
$targetDir = ""
$type = ""

if (Test-Path "$currentDir\node_modules") {
    $targetDir = "$currentDir\node_modules"
    $type = "node_modules"
} elseif (Test-Path "$currentDir\venv\Lib\site-packages") {
    $targetDir = "$currentDir\venv\Lib\site-packages"
    $type = "python venv"
} elseif (Test-Path "$currentDir\.venv\Lib\site-packages") {
    $targetDir = "$currentDir\.venv\Lib\site-packages"
    $type = "python .venv"
} else {
    Write-Host "  [?] no supported dependency directory found (node_modules, venv)" -ForegroundColor Yellow
    exit 0
}

Write-Host "  [>] analyzing $type..." -ForegroundColor DarkGray

$deps = Get-ChildItem -Directory -Path $targetDir
$results = @()

foreach ($dep in $deps) {
    if ($dep.Name.StartsWith(".")) { continue } # Skip hidden
    
    try {
        $size = (Get-ChildItem -Recurse -File -Path $dep.FullName -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $results += [PSCustomObject]@{
            Name = $dep.Name
            Size = $size
            FormatSize = "{0:N2} MB" -f ($size / 1MB)
        }
    } catch {}
}

$sorted = $results | Sort-Object Size -Descending | Select-Object -First 10

foreach ($item in $sorted) {
    # Color scale based on size
    $color = "Green"
    if ($item.Size -gt 50MB) { $color = "Red" }
    elseif ($item.Size -gt 10MB) { $color = "Yellow" }
    
    Write-Host "  $($item.Name): $($item.FormatSize)" -ForegroundColor $color
}

$total = ($results | Measure-Object -Property Size -Sum).Sum
Write-Host ""
Write-Host "  total: $(" {0:N2} MB" -f ($total / 1MB))" -ForegroundColor Cyan
Write-Host ""
