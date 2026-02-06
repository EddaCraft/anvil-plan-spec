# APS Hooks Installer (PowerShell)
# Merges APS hook configuration into .claude/settings.local.json
# Preserves existing settings and permissions.
#
# Usage:
#   .\aps-planning\scripts\install-hooks.ps1            # Install all hooks
#   .\aps-planning\scripts\install-hooks.ps1 -Minimal   # PreToolUse + Stop only
#   .\aps-planning\scripts\install-hooks.ps1 -Remove    # Remove APS hooks
#
# Requires: Python 3 (for JSON manipulation)

param(
    [switch]$Minimal,
    [switch]$Remove,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

$SettingsDir = ".claude"
$SettingsFile = Join-Path $SettingsDir "settings.local.json"

if ($Help) {
    Write-Host "Usage: .\aps-planning\scripts\install-hooks.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Minimal   Install only PreToolUse + Stop hooks"
    Write-Host "  -Remove    Remove all APS hooks"
    Write-Host "  -Help      Show this help"
    exit 0
}

if ($Remove) { $Mode = "remove" }
elseif ($Minimal) { $Mode = "minimal" }
else { $Mode = "full" }

function Write-Info  { param([string]$Msg) Write-Host "[aps] $Msg" -ForegroundColor Green }
function Write-Warn  { param([string]$Msg) Write-Host "[aps] $Msg" -ForegroundColor Yellow }
function Write-Err   { param([string]$Msg) Write-Host "[aps] $Msg" -ForegroundColor Red }

# Check for python3
$pythonCmd = if (Get-Command python3 -ErrorAction SilentlyContinue) { "python3" }
             elseif (Get-Command python -ErrorAction SilentlyContinue) { "python" }
             else { $null }

if (-not $pythonCmd) {
    Write-Err "Python 3 is required for JSON manipulation."
    Write-Host "  Install it or manually copy hook config from aps-planning/hooks.md"
    exit 1
}

# Ensure .claude directory exists
if (-not (Test-Path $SettingsDir -PathType Container)) {
    New-Item -ItemType Directory -Path $SettingsDir -Force | Out-Null
}

# Create settings file if it doesn't exist
if (-not (Test-Path $SettingsFile)) {
    Set-Content -Path $SettingsFile -Value "{}"
    Write-Info "Created $SettingsFile"
}

# Use python for safe JSON merge
$pyScript = @'
import json
import sys

settings_path = sys.argv[1]
mode = sys.argv[2]

with open(settings_path) as f:
    settings = json.load(f)

if mode == "remove":
    if "hooks" in settings:
        for event in list(settings["hooks"].keys()):
            hooks = settings["hooks"][event]
            settings["hooks"][event] = [
                h for h in hooks
                if "[APS]" not in h.get("hook", "")
                and "aps-planning/scripts" not in h.get("hook", "")
            ]
            if not settings["hooks"][event]:
                del settings["hooks"][event]
        if not settings["hooks"]:
            del settings["hooks"]
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    sys.exit(0)

pretool = {
    "matcher": "Write|Edit|Bash",
    "hook": "if [ -d plans ] && [ -f plans/index.aps.md -o -d plans/modules ]; then echo '[APS] Re-read your current work item before making changes. Are you still on-plan?'; fi"
}

posttool = {
    "matcher": "Write|Edit",
    "hook": "if [ -d plans ]; then echo '[APS] If you completed a work item or discovered new scope, update the APS spec now.'; fi"
}

stop = {
    "hook": "./aps-planning/scripts/check-complete.sh"
}

session_start = {
    "hook": "./aps-planning/scripts/init-session.sh"
}

if mode == "minimal":
    new_hooks = {
        "PreToolUse": [pretool],
        "Stop": [stop],
    }
else:
    new_hooks = {
        "PreToolUse": [pretool],
        "PostToolUse": [posttool],
        "Stop": [stop],
        "SessionStart": [session_start],
    }

if "hooks" not in settings:
    settings["hooks"] = {}

for event, aps_hooks in new_hooks.items():
    if event not in settings["hooks"]:
        settings["hooks"][event] = []

    existing = [
        h for h in settings["hooks"][event]
        if "[APS]" not in h.get("hook", "")
        and "aps-planning/scripts" not in h.get("hook", "")
    ]

    settings["hooks"][event] = existing + aps_hooks

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
'@

$pyScript | & $pythonCmd - $SettingsFile $Mode

if ($Mode -eq "remove") {
    Write-Info "Removed APS hooks from $SettingsFile"
} else {
    Write-Info "Installed APS hooks ($Mode mode) into $SettingsFile"
    Write-Host ""
    Write-Host "  Hooks added:"
    if ($Mode -eq "full") {
        Write-Host "    PreToolUse   - Reminds agent to check plan before code changes"
        Write-Host "    PostToolUse  - Nudges agent to update specs after changes"
        Write-Host "    Stop         - Blocks session end if work items unresolved"
        Write-Host "    SessionStart - Shows planning status at session start"
    } else {
        Write-Host "    PreToolUse   - Reminds agent to check plan before code changes"
        Write-Host "    Stop         - Blocks session end if work items unresolved"
    }
    Write-Host ""
    Write-Info "See aps-planning/hooks.md for details on each hook."
}
