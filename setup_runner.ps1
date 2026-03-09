# setup_runner.ps1
# Quick-start helper script for setting up a GitHub Actions self-hosted runner
# Run this in PowerShell as Administrator

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  GitHub Self-Hosted Runner Setup Helper" -ForegroundColor Cyan
Write-Host "  For: Windows + Python Beginners Guide" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Check Python ─────────────────────────────────────────────────────
Write-Host "[1/4] Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "  OK: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Python not found. Download from https://python.org/downloads" -ForegroundColor Red
    Write-Host "         Make sure to check 'Add Python to PATH' during installation." -ForegroundColor Red
    exit 1
}

# ── Step 2: Check Git ─────────────────────────────────────────────────────────
Write-Host "[2/4] Checking Git installation..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "  OK: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Git not found. Download from https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# ── Step 3: Install Python dependencies ──────────────────────────────────────
Write-Host "[3/4] Installing Python dependencies..." -ForegroundColor Yellow
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

pip install -r requirements.txt --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK: Dependencies installed (pytest)" -ForegroundColor Green
} else {
    Write-Host "  ERROR: Failed to install dependencies." -ForegroundColor Red
    exit 1
}

# ── Step 4: Run local tests ───────────────────────────────────────────────────
Write-Host "[4/4] Running tests locally to verify setup..." -ForegroundColor Yellow
pytest test_calculator.py -v

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  All tests PASSED! Local setup is complete." -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "NEXT STEPS:" -ForegroundColor Cyan
    Write-Host "  1. Create a GitHub repository" -ForegroundColor White
    Write-Host "  2. Push this folder to GitHub (see README.md)" -ForegroundColor White
    Write-Host "  3. Go to GitHub Settings -> Actions -> Runners" -ForegroundColor White
    Write-Host "  4. Register this Windows machine as a runner" -ForegroundColor White
    Write-Host "  5. Run .\run.cmd in C:\actions-runner" -ForegroundColor White
    Write-Host "  6. Push a commit and watch the workflow run!" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "  Some tests FAILED. Check the output above." -ForegroundColor Red
}
