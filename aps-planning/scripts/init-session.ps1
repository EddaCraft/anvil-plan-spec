# APS Session Initializer (PowerShell)
# Checks for APS planning files and reports status.
# Use as a hook or run manually at session start.
#
# Usage: .\aps-planning\scripts\init-session.ps1 [plans-dir]

param(
    [string]$PlansDir = "plans"
)

$ErrorActionPreference = "Stop"

function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color -NoNewline
}

Write-Host "APS Planning Session" -ForegroundColor White
Write-Host ([char]0x2500 * 21)

# Check if plans/ exists
if (-not (Test-Path $PlansDir -PathType Container)) {
    Write-Host "No plans/ directory found." -ForegroundColor Yellow
    Write-Host "Run /plan to start APS planning, or create plans/ manually."
    exit 0
}

# Check for index
$indexPath = Join-Path $PlansDir "index.aps.md"
if (Test-Path $indexPath) {
    $title = Get-Content $indexPath -TotalCount 5 |
        Where-Object { $_ -match '^# ' } |
        Select-Object -First 1
    if ($title) { $title = $title -replace '^# ', '' } else { $title = "[untitled]" }
    Write-Color "Plan: " "Green"; Write-Host $title
} else {
    Write-Host "No index.aps.md found." -ForegroundColor Yellow
}

# Check for aps-rules.md
$rulesPath = Join-Path $PlansDir "aps-rules.md"
if (Test-Path $rulesPath) {
    Write-Color "Agent rules: " "Green"; Write-Host "plans/aps-rules.md"
}

# Count modules
$moduleCount = 0
$readyCount = 0
$progressCount = 0
$completeCount = 0

$modulesDir = Join-Path $PlansDir "modules"
if (Test-Path $modulesDir -PathType Container) {
    foreach ($f in Get-ChildItem (Join-Path $modulesDir "*.aps.md") -ErrorAction SilentlyContinue) {
        if ($f.Name -match '^\.') { continue }
        $moduleCount++
        $content = Get-Content $f.FullName -Raw
        if ($content -match '(?i)\| *Ready *\|') { $readyCount++ }
        elseif ($content -match '(?i)\| *In Progress *\|') { $progressCount++ }
        elseif ($content -match '(?i)\| *Complete *\|') { $completeCount++ }
    }
}

# Also check for simple specs at plans/ root
foreach ($f in Get-ChildItem (Join-Path $PlansDir "*.aps.md") -ErrorAction SilentlyContinue) {
    if ($f.Name -match '^index') { continue }
    $moduleCount++
}

if ($moduleCount -gt 0) {
    Write-Color "Modules: " "Green"; Write-Host "$moduleCount total"
    if ($readyCount -gt 0)    { Write-Host "  Ready: $readyCount" }
    if ($progressCount -gt 0) { Write-Host "  In Progress: $progressCount" }
    if ($completeCount -gt 0) { Write-Host "  Complete: $completeCount" }
} else {
    Write-Host "No modules found." -ForegroundColor Yellow
}

# Find work items from non-Complete modules
Write-Host ""
Write-Host "Work items to act on:" -ForegroundColor White

$foundItems = 0
$searchPaths = @()
if (Test-Path $modulesDir -PathType Container) {
    $searchPaths += Get-ChildItem (Join-Path $modulesDir "*.aps.md") -ErrorAction SilentlyContinue
}
$searchPaths += Get-ChildItem (Join-Path $PlansDir "*.aps.md") -ErrorAction SilentlyContinue

foreach ($f in $searchPaths) {
    if ($f.Name -match '^\.') { continue }
    if ($f.Name -match '^index') { continue }

    $content = Get-Content $f.FullName -Raw
    if ($content -match '(?i)\| *Complete *\|') { continue }

    foreach ($line in (Get-Content $f.FullName)) {
        if ($line -match '^### ([A-Z]+-[0-9]+): *(.+)$') {
            $itemId = $Matches[1]
            $itemTitle = $Matches[2]
            Write-Host "  - ${itemId}: $itemTitle  ($($f.Name))"
            $foundItems++
        }
    }
}

if ($foundItems -eq 0) {
    Write-Host "  (none - all modules complete or no work items defined)"
}

Write-Host ""
Write-Host "Tip: Read the relevant module spec before starting work."
