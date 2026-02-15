<#
.SYNOPSIS
    minimus guard - pre-commit safety check
.DESCRIPTION
    scans staged git files for secrets, large files, and forbidden paths.
.PARAMETER Help
    show this help message.
#>
param (
    [switch]$Help
)

if ($Help) {
    Write-Host "minimus guard" -ForegroundColor Cyan
    Write-Host "usage: ./guard.ps1"
    Write-Host ""
    Write-Host "scans staged files for common mistakes (keys, large files)."
    exit
}

$currentDir = Get-Location
$issues = 0

# ASCII Art
Write-Host " _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ " -ForegroundColor DarkGray
Write-Host "| '_ `` _ \| | '_ \| | '_ `` _ \| | | / __|" -ForegroundColor Gray
Write-Host "| | | | | | | | | | | | | | | | |_| \__ \" -ForegroundColor White
Write-Host "|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/" -ForegroundColor Cyan
Write-Host "minimus guard: $currentDir" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  [!] git not found" -ForegroundColor Red
    exit 1
}

Write-Host "  [>] scanning staged files..." -ForegroundColor DarkGray

$stagedFiles = git diff --cached --name-only
if (-not $stagedFiles) {
    Write-Host "  [+] no staged files" -ForegroundColor Green
    exit 0
}

$forbiddenFiles = @(".env", "node_modules", "venv", ".DS_Store", "id_rsa", "id_ed25519")
$maxFileSize = 50MB
$secretPatterns = @(
    "AKIA[0-9A-Z]{16}", # AWS Access Key
    "-----BEGIN PRIVATE KEY-----", # Generic Private Key
    "-----BEGIN RSA PRIVATE KEY-----", # RSA Private Key
    "sk_live_[0-9a-zA-Z]{24}", # Stripe Live Key
    "ghp_[0-9a-zA-Z]{36}" # GitHub Personal Access Token
)

foreach ($file in $stagedFiles) {
    $fullPath = Join-Path $currentDir $file
    if (-not (Test-Path $fullPath)) { continue }

    # 1. Check Forbidden Files
    foreach ($forbidden in $forbiddenFiles) {
        if ($file -match $forbidden) {
            Write-Host "  [!] forbidden file: $file" -ForegroundColor Red
            $issues++
        }
    }

    # 2. Check File Size
    try {
        $item = Get-Item $fullPath
        if ($item.Length -gt $maxFileSize) {
            Write-Host "  [!] large file ($([math]::Round($item.Length/1MB, 2)) MB): $file" -ForegroundColor Red
            $issues++
        }
    } catch {}

    # 3. Scan Content for Secrets (only text files < 1MB)
    try {
        if ($item.Length -lt 1MB) {
            $content = Get-Content $fullPath -Raw -ErrorAction SilentlyContinue
            foreach ($pattern in $secretPatterns) {
                if ($content -match $pattern) {
                    Write-Host "  [!] potential secret detected in: $file" -ForegroundColor Red
                    $issues++
                    break 
                }
            }
        }
    } catch {}
}

if ($issues -gt 0) {
    Write-Host ""
    Write-Host "  [!] $issues issues found. fix before committing." -ForegroundColor Red
    exit 1
} else {
    Write-Host "  [+] all clear" -ForegroundColor Green
    exit 0
}
