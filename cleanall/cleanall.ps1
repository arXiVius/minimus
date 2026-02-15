<#
.SYNOPSIS
    minimus cleanall - universal project cleaner
.DESCRIPTION
    recursively removes build artifacts (node_modules, venv, target, dist, build, coverage, __pycache__).
.PARAMETER Force
    skip confirmation prompt.
.PARAMETER Help
    show this help message.
#>
param (
    [switch]$Force,
    [switch]$Help
)

if ($Help) {
    Write-Host "minimus cleanall" -ForegroundColor Cyan
    Write-Host "usage: ./cleanall.ps1 [-Force]"
    Write-Host ""
    Write-Host "removes: node_modules, venv, target, dist, build, coverage, __pycache__, .DS_Store"
    exit
}

$targets = @("node_modules", "venv", ".venv", "target", "dist", "build", "coverage", "__pycache__", ".DS_Store")
$found = @()
$currentDir = Get-Location

# new ASCII Art
Write-Host " _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ " -ForegroundColor DarkGray
Write-Host "| '_ `` _ \| | '_ \| | '_ `` _ \| | | / __|" -ForegroundColor Gray
Write-Host "| | | | | | | | | | | | | | | | |_| \__ \" -ForegroundColor White
Write-Host "|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/" -ForegroundColor Cyan
Write-Host "minimus cleanall: $currentDir" -ForegroundColor Cyan
Write-Host ""

# scan for targets
foreach ($target in $targets) {
    if (Test-Path "$currentDir\$target") {
        $found += $target
    }
}

if ($found.Count -eq 0) {
    Write-Host "  [+] nothing to clean" -ForegroundColor Green
    exit
}

Write-Host "  [?] found items to remove:" -ForegroundColor Yellow
foreach ($item in $found) {
    Write-Host "    - $item" -ForegroundColor Red
}
Write-Host ""

if (-not $Force) {
    $confirmation = Read-Host "  are you sure you want to PERMANENTLY delete these items? (y/N)"
    if ($confirmation -ne "y") {
        Write-Host "  [!] aborted" -ForegroundColor Yellow
        exit
    }
}

foreach ($item in $found) {
    Write-Host "  [>] removing $item..." -NoNewline
    Remove-Item -Recurse -Force "$currentDir\$item" -ErrorAction SilentlyContinue
    Write-Host " done" -ForegroundColor Green
}

Write-Host ""
Write-Host "  [+] clean complete" -ForegroundColor Cyan
