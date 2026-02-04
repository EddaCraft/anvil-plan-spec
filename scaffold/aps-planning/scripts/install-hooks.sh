#!/usr/bin/env bash
#
# APS Hooks Installer
# Merges APS hook configuration into .claude/settings.local.json
# Preserves existing settings and permissions.
#
# Usage:
#   ./aps-planning/scripts/install-hooks.sh           # Install all hooks
#   ./aps-planning/scripts/install-hooks.sh --minimal  # PreToolUse + Stop only
#   ./aps-planning/scripts/install-hooks.sh --remove   # Remove APS hooks
#
# Requires: python3 (for JSON manipulation)

set -euo pipefail

SETTINGS_DIR=".claude"
SETTINGS_FILE="$SETTINGS_DIR/settings.local.json"
MODE="full"

while [[ $# -gt 0 ]]; do
  case $1 in
    --minimal|-m) MODE="minimal"; shift ;;
    --remove|-r)  MODE="remove";  shift ;;
    --help|-h)
      echo "Usage: ./aps-planning/scripts/install-hooks.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --minimal, -m  Install only PreToolUse + Stop hooks"
      echo "  --remove, -r   Remove all APS hooks"
      echo "  --help, -h     Show this help"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# Colors
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  NC='\033[0m'
else
  GREEN='' YELLOW='' RED='' NC=''
fi

info()  { echo -e "${GREEN}[aps]${NC} $1"; }
warn()  { echo -e "${YELLOW}[aps]${NC} $1"; }
error() { echo -e "${RED}[aps]${NC} $1"; }

# Check for python3
if ! command -v python3 &>/dev/null; then
  error "python3 is required for JSON manipulation."
  echo "  Install it or manually copy hook config from aps-planning/hooks.md"
  exit 1
fi

# Ensure .claude directory exists
mkdir -p "$SETTINGS_DIR"

# Create settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
  info "Created $SETTINGS_FILE"
fi

# Use python3 for safe JSON merge
python3 - "$SETTINGS_FILE" "$MODE" << 'PYEOF'
import json
import sys

settings_path = sys.argv[1]
mode = sys.argv[2]

# Load existing settings
with open(settings_path) as f:
    settings = json.load(f)

if mode == "remove":
    # Remove APS hooks by filtering out entries with [APS] in the hook command
    if "hooks" in settings:
        for event in list(settings["hooks"].keys()):
            hooks = settings["hooks"][event]
            settings["hooks"][event] = [
                h for h in hooks
                if "[APS]" not in h.get("hook", "")
                and "aps-planning/scripts" not in h.get("hook", "")
            ]
            # Clean up empty arrays
            if not settings["hooks"][event]:
                del settings["hooks"][event]
        if not settings["hooks"]:
            del settings["hooks"]
    print(json.dumps(settings, indent=2))
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    sys.exit(0)

# Define APS hooks
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

# Build hooks based on mode
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

# Merge: add APS hooks without clobbering existing non-APS hooks
if "hooks" not in settings:
    settings["hooks"] = {}

for event, aps_hooks in new_hooks.items():
    if event not in settings["hooks"]:
        settings["hooks"][event] = []

    # Remove any existing APS hooks first (idempotent)
    existing = [
        h for h in settings["hooks"][event]
        if "[APS]" not in h.get("hook", "")
        and "aps-planning/scripts" not in h.get("hook", "")
    ]

    # Append new APS hooks
    settings["hooks"][event] = existing + aps_hooks

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
PYEOF

if [ "$MODE" = "remove" ]; then
  info "Removed APS hooks from $SETTINGS_FILE"
else
  info "Installed APS hooks ($MODE mode) into $SETTINGS_FILE"
  echo ""
  echo "  Hooks added:"
  if [ "$MODE" = "full" ]; then
    echo "    PreToolUse   — Reminds agent to check plan before code changes"
    echo "    PostToolUse  — Nudges agent to update specs after changes"
    echo "    Stop         — Blocks session end if work items unresolved"
    echo "    SessionStart — Shows planning status at session start"
  else
    echo "    PreToolUse   — Reminds agent to check plan before code changes"
    echo "    Stop         — Blocks session end if work items unresolved"
  fi
  echo ""
  info "See aps-planning/hooks.md for details on each hook."
fi
