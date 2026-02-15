<#
.SYNOPSIS
    installs minimus suite globally on windows.
#>

$ErrorActionPreference = "Stop"

$installDir = Join-Path $HOME ".minimus\bin"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

$tools = @("bootstrap", "cleanall", "score", "readme", "guard", "doctor", "depsize")
$baseDir = $PSScriptRoot

# new ASCII Art
Write-Host " _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ " -ForegroundColor DarkGray
Write-Host "| '_ `` _ \| | '_ \| | '_ `` _ \| | | / __|" -ForegroundColor Gray
Write-Host "| | | | | | | | | | | | | | | | |_| \__ \" -ForegroundColor White
Write-Host "|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/" -ForegroundColor Cyan
Write-Host "installing minimus to $installDir..." -ForegroundColor Cyan

foreach ($tool in $tools) {
    # Determine source path (handle different folder structures)
    $sourcePath = Join-Path $baseDir "$tool.ps1"
    if (-not (Test-Path $sourcePath)) {
        $sourcePath = Join-Path $baseDir "$tool\$tool.ps1"
    }

    if (Test-Path $sourcePath) {
        $destPath = Join-Path $installDir "$tool.ps1"
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        
        # Create CMD wrapper
        $cmdPath = Join-Path $installDir "$tool.cmd"
        $cmdContent = '@powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0' + "$tool.ps1" + '" %*'
        Set-Content -Path $cmdPath -Value $cmdContent
        Write-Host "  [+] installed $tool" -ForegroundColor Green
    } else {
        Write-Host "  [!] could not find $tool.ps1 at $sourcePath" -ForegroundColor Red
    }
}

# Add to PATH if not present
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$installDir*") {
    Write-Host "adding to path..." -ForegroundColor Yellow
    $newPath = "$currentPath;$installDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "success! please restart your terminal to use minimus tools." -ForegroundColor Green
} else {
    Write-Host "already in path" -ForegroundColor Green
}

Write-Host "installation complete!" -ForegroundColor Cyan
