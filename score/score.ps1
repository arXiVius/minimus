<#
.SYNOPSIS
    minimus score - project complexity scorer
.DESCRIPTION
    calculates a simple complexity score based on file count and lines of code.
.PARAMETER Help
    show this help message.
#>
param (
    [switch]$Help
)

if ($Help) {
    Write-Host "minimus score" -ForegroundColor Cyan
    Write-Host "usage: ./score.ps1"
    Write-Host ""
    Write-Host "calculates code health score based on file count and loc."
    exit
}

$currentDir = Get-Location
$excludedDirs = @("node_modules", "venv", ".venv", "target", "dist", "build", "coverage", ".git", ".idea", ".vscode")

# new ASCII Art
Write-Host " _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ " -ForegroundColor DarkGray
Write-Host "| '_ `` _ \| | '_ \| | '_ `` _ \| | | / __|" -ForegroundColor Gray
Write-Host "| | | | | | | | | | | | | | | | |_| \__ \" -ForegroundColor White
Write-Host "|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/" -ForegroundColor Cyan
Write-Host "minimus score: $currentDir" -ForegroundColor Cyan
Write-Host ""

Write-Host "  [>] analyzing project..." -ForegroundColor DarkGray

# get all files, excluding directories
$files = Get-ChildItem -Recurse -File -Path $currentDir | Where-Object {
    $path = $_.FullName
    $skip = $false
    foreach ($dir in $excludedDirs) {
        if ($path -match [regex]::Escape("\$dir\")) { $skip = $true; break }
    }
    return -not $skip
}

$fileCount = $files.Count
$lineCount = 0

foreach ($file in $files) {
    try {
        # Only count lines for text files
        $content = Get-Content $file.FullName -ErrorAction SilentlyContinue
        if ($content) {
            $lineCount += $content.Count
        }
    } catch {}
}

# Calculate Score
# Heuristic: 1 point per file, 1 point per 50 lines.
$score = $fileCount + [math]::Round($lineCount / 50)

# Rating
$rating = "Unknown"
$color = "White"

if ($score -lt 10) { $rating = "tiny (micro)"; $color = "Cyan" }
elseif ($score -lt 50) { $rating = "small (mini)"; $color = "Green" }
elseif ($score -lt 200) { $rating = "medium (midi)"; $color = "Yellow" }
elseif ($score -lt 500) { $rating = "large (maxi)"; $color = "Red" }
else { $rating = "huge (mega)"; $color = "DarkRed" }

Write-Host ""
Write-Host "  stat" -ForegroundColor Cyan
Write-Host "  ----"
Write-Host "  files: $fileCount"
Write-Host "  lines: $lineCount"
Write-Host ""
Write-Host "  score: $score" -ForegroundColor $color
Write-Host "  rating: $rating" -ForegroundColor $color
Write-Host ""
