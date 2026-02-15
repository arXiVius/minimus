<#
.SYNOPSIS
    minimus bootstrap - universal repo setup
.DESCRIPTION
    automatically detects the project type in the current directory and runs the appropriate setup command.
.PARAMETER Help
    show this help message.
#>
param (
    [switch]$Help
)

if ($Help) {
    Write-Host "minimus bootstrap" -ForegroundColor Cyan
    Write-Host "usage: ./bootstrap.ps1"
    Write-Host ""
    Write-Host "detects:"
    Write-Host "  package.json      -> npm install"
    Write-Host "  requirements.txt  -> venv + pip install"
    Write-Host "  pyproject.toml    -> poetry install (or pip)"
    Write-Host "  Cargo.toml        -> cargo build"
    Write-Host "  go.mod            -> go mod tidy"
    Write-Host "  Dockerfile        -> docker build"
    exit
}

$currentDir = Get-Location

# new ASCII Art
Write-Host " _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ " -ForegroundColor DarkGray
Write-Host "| '_ `` _ \| | '_ \| | '_ `` _ \| | | / __|" -ForegroundColor Gray
Write-Host "| | | | | | | | | | | | | | | | |_| \__ \" -ForegroundColor White
Write-Host "|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/" -ForegroundColor Cyan
Write-Host "minimus bootstrap: $currentDir" -ForegroundColor Cyan
Write-Host ""

if (Test-Path "$currentDir\package.json") {
    Write-Host "  [+] node.js project detected" -ForegroundColor Green
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Host "  [>] running 'npm install'..." -ForegroundColor Gray
        npm install
    } else {
        Write-Host "  [!] npm not found in path" -ForegroundColor Red
    }
}
elseif (Test-Path "$currentDir\requirements.txt") {
    Write-Host "  [+] python project detected (requirements.txt)" -ForegroundColor Green
    Write-Host "  [>] creating venv..." -ForegroundColor Gray
    
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
         Write-Host "  [!] python not found in path" -ForegroundColor Red
         exit 1
    }

    python -m venv venv
    if (Test-Path "$currentDir\venv\Scripts\python.exe") {
        Write-Host "  [>] installing dependencies..." -ForegroundColor Gray
        & "$currentDir\venv\Scripts\python.exe" -m pip install -r requirements.txt
    } else {
        Write-Host "  [!] failed to create venv or locate python executable" -ForegroundColor Red
    }
}
elseif (Test-Path "$currentDir\pyproject.toml") {
     Write-Host "  [+] python project detected (pyproject.toml)" -ForegroundColor Green
     if (Get-Command poetry -ErrorAction SilentlyContinue) {
        Write-Host "  [>] found poetry. running 'poetry install'..." -ForegroundColor Gray
        poetry install
     } else {
        Write-Host "  [!] poetry not found. using pip to install current directory" -ForegroundColor Yellow
        pip install .
     }
}
elseif (Test-Path "$currentDir\Cargo.toml") {
    Write-Host "  [+] rust project detected" -ForegroundColor Green
    if (Get-Command cargo -ErrorAction SilentlyContinue) {
        Write-Host "  [>] running 'cargo build'..." -ForegroundColor Gray
        cargo build
    } else {
        Write-Host "  [!] cargo not found in path" -ForegroundColor Red
    }
}
elseif (Test-Path "$currentDir\go.mod") {
    Write-Host "  [+] go project detected" -ForegroundColor Green
    if (Get-Command go -ErrorAction SilentlyContinue) {
        Write-Host "  [>] running 'go mod tidy'..." -ForegroundColor Gray
        go mod tidy
    } else {
        Write-Host "  [!] go not found in path" -ForegroundColor Red
    }
}
elseif (Test-Path "$currentDir\Dockerfile") {
    Write-Host "  [+] docker project detected" -ForegroundColor Green
     if (Get-Command docker -ErrorAction SilentlyContinue) {
        Write-Host "  [>] building image..." -ForegroundColor Gray
        docker build -t .
    } else {
        Write-Host "  [!] docker not found in path" -ForegroundColor Red
    }
}
else {
    Write-Host "  [?] no recognized project type found" -ForegroundColor Yellow
    Write-Host "      (checked for package.json, requirements.txt, Cargo.toml, etc.)"
}
