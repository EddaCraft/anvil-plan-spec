# APS Completion Checker (PowerShell)
# Verifies that all In Progress work items and action plans have been completed.
# Use as a Stop hook or run before ending a session.
#
# Usage: .\aps-planning\scripts\check-complete.ps1 [plans-dir]
#
# Exit codes:
#   0 - All work items resolved (none in progress)
#   1 - Work items or action plans still in progress

param(
    [string]$PlansDir = "plans"
)

$ErrorActionPreference = "Stop"

# If no plans directory, nothing to check
if (-not (Test-Path $PlansDir -PathType Container)) {
    exit 0
}

$incomplete = 0
$complete = 0

# Check all APS files for work item status
$searchPaths = @()
$modulesDir = Join-Path $PlansDir "modules"
if (Test-Path $modulesDir -PathType Container) {
    $searchPaths += Get-ChildItem (Join-Path $modulesDir "*.aps.md") -ErrorAction SilentlyContinue
}
$searchPaths += Get-ChildItem (Join-Path $PlansDir "*.aps.md") -ErrorAction SilentlyContinue

foreach ($f in $searchPaths) {
    if ($f.Name -match '^\.') { continue }
    if ($f.Name -match '^index') { continue }

    $currentItem = ""
    foreach ($line in (Get-Content $f.FullName)) {
        if ($line -match '^### ([A-Z]+-[0-9]+: .+)$') {
            $currentItem = $Matches[1]
        }

        if ($currentItem) {
            if ($line -match '(?i)\*\*Status:\*\* *In Progress|Status: *In Progress') {
                Write-Host "Still in progress: $currentItem ($($f.Name))" -ForegroundColor Yellow
                $incomplete++
                $currentItem = ""
            }
            elseif ($line -match '(?i)\*\*Status:\*\* *Complete|Status: *Complete') {
                $complete++
                $currentItem = ""
            }
        }
    }
}

# Check action plans for incomplete checkpoints (only In Progress ones)
$execDir = Join-Path $PlansDir "execution"
if (Test-Path $execDir -PathType Container) {
    foreach ($f in Get-ChildItem (Join-Path $execDir "*.actions.md") -ErrorAction SilentlyContinue) {
        $content = Get-Content $f.FullName -Raw
        if ($content -match '(?i)^\| *Status *\|.*(In Progress|In-Progress)') {
            $unchecked = (Select-String -Path $f.FullName -Pattern '^ *- \[ \]' -AllMatches).Matches.Count
            if ($unchecked -gt 0) {
                Write-Host "Unchecked items: $unchecked in $($f.Name)" -ForegroundColor Yellow
                $incomplete++
            }
        }
    }
}

if ($incomplete -gt 0) {
    Write-Host ""
    Write-Host "Session incomplete. $incomplete item(s) still need attention." -ForegroundColor Red
    if ($complete -gt 0) {
        Write-Host "Session status: $complete complete, $incomplete incomplete" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "Before ending this session:"
    Write-Host "  1. Complete or explicitly mark items as Blocked"
    Write-Host "  2. Update work item statuses in the module spec"
    Write-Host "  3. Add any discovered work as Draft items"
    Write-Host "  4. Commit APS changes to git"
    exit 1
} else {
    if ($complete -gt 0) {
        Write-Host "All work items resolved. $complete item(s) complete. Session can end cleanly." -ForegroundColor Green
    } else {
        Write-Host "All work items resolved. Session can end cleanly." -ForegroundColor Green
    }
    exit 0
}
