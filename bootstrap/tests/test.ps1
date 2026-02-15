<#
.SYNOPSIS
    Verification script for minimus bootstrap
#>

$testRoot = Join-Path (Get-Location) "test_env"
$bootstrapScript = Join-Path (Get-Location) "..\bootstrap.ps1"

Write-Host "Starting minimus verification..." -ForegroundColor Cyan

if (Test-Path $testRoot) { Remove-Item -Recurse -Force $testRoot }
New-Item -ItemType Directory -Path $testRoot | Out-Null

function Run-Test {
    param($Type, $File, $Content)
    $dir = Join-Path $testRoot $Type
    New-Item -ItemType Directory -Path $dir | Out-Null
    Set-Content -Path (Join-Path $dir $File) -Value $Content
    
    Write-Host "Testing $Type..." -NoNewline
    Push-Location $dir
    # Capture 'Write-Host' (stream 6) and Standard Output (stream 1)
    $output = & $bootstrapScript *>&1 | Out-String
    Pop-Location

    if ($output -match "$Type project detected") {
        Write-Host " [PASS]" -ForegroundColor Green
    } else {
        Write-Host " [FAIL]" -ForegroundColor Red
        Write-Host "DEBUG OUTPUT:"
        Write-Host $output
    }
}

Run-Test "Node.js" "package.json" "{}"
Run-Test "Python" "requirements.txt" "# empty"
# Add more if needed

Write-Host "Verification checks complete." -ForegroundColor Cyan
Remove-Item -Recurse -Force $testRoot
