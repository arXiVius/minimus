<#
.SYNOPSIS
    minimus doctor - system and project health check
.DESCRIPTION
    checks for core tools and project consistency.
.PARAMETER Help
    show this help message.
#>
param (
    [switch]$Help
)

if ($Help) {
    Write-Host "minimus doctor" -ForegroundColor Cyan
    Write-Host "usage: ./doctor.ps1"
    Write-Host ""
    Write-Host "checks system tools and project health."
    exit
}

# ASCII Art
Write-Host " _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ " -ForegroundColor DarkGray
Write-Host "| '_ `` _ \| | '_ \| | '_ `` _ \| | | / __|" -ForegroundColor Gray
Write-Host "| | | | | | | | | | | | | | | | |_| \__ \" -ForegroundColor White
Write-Host "|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/" -ForegroundColor Cyan
Write-Host "minimus doctor" -ForegroundColor Cyan
Write-Host ""

Write-Host "  [>] checking system tools..." -ForegroundColor DarkGray

$tools = @("git", "node", "npm", "python", "pip", "docker", "cargo", "go", "code")

foreach ($tool in $tools) {
    try {
        if (Get-Command $tool -ErrorAction SilentlyContinue) {
            $version = & $tool --version 2>&1
            if ($version -is [array]) { $version = $version[0] }
            if ($version.Length -gt 50) { $version = $version.Substring(0, 50) + "..." }
            # Clean up version string
            $version = $version -replace "Start-Process.*", ""
            Write-Host "  [+] $tool found ($version)" -ForegroundColor Green
        } else {
            Write-Host "  [!] $tool not found" -ForegroundColor Red
        }
    } catch {
        Write-Host "  [?] $tool found but version check failed" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "  [>] checking project health..." -ForegroundColor DarkGray

$currentDir = Get-Location

if (Test-Path "$currentDir\package.json") {
    if (-not (Test-Path "$currentDir\node_modules")) {
        Write-Host "  [?] package.json detected but no node_modules found. run 'minimus bootstrap' or 'npm install'." -ForegroundColor Yellow
    } else {
        Write-Host "  [+] node project seems healthy" -ForegroundColor Green
    }
}

if (Test-Path "$currentDir\requirements.txt") {
    if (-not ((Test-Path "$currentDir\venv") -or (Test-Path "$currentDir\.venv"))) {
        Write-Host "  [?] requirements.txt detected but no venv found. run 'minimus bootstrap'." -ForegroundColor Yellow
    } else {
        Write-Host "  [+] python project seems healthy" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "  [+] diagnosis complete" -ForegroundColor Cyan
