#!/usr/bin/env bash
# APS Completion Checker
# Verifies that all In Progress work items have been completed.
# Use as a Stop hook or run before ending a session.
#
# Usage: ./aps-planning/scripts/check-complete.sh [plans-dir]
#
# Exit codes:
#   0 — All work items resolved (none in progress)
#   1 — Work items still in progress

set -euo pipefail

PLANS_DIR="${1:-plans}"

# Colors
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  GREEN='' YELLOW='' RED='' BOLD='' NC=''
fi

# If no plans directory, nothing to check
if [ ! -d "$PLANS_DIR" ]; then
  exit 0
fi

INCOMPLETE=0
COMPLETE=0

# Check all APS files for work item status
for f in "$PLANS_DIR/modules/"*.aps.md "$PLANS_DIR/"*.aps.md; do
  [ -f "$f" ] || continue
  basename "$f" | grep -q '^\.' && continue
  basename "$f" | grep -q '^index' && continue

  # Parse work items and their statuses
  CURRENT_ITEM=""
  while IFS= read -r line; do
    if echo "$line" | grep -qE '^### [A-Z]+-[0-9]+:'; then
      CURRENT_ITEM=$(echo "$line" | sed 's/^### //' | sed 's/ *$//')
    fi
    
    if [ -n "$CURRENT_ITEM" ]; then
      # Check for In Progress status
      if echo "$line" | grep -qi 'In Progress'; then
        echo -e "${YELLOW}Still in progress:${NC} $CURRENT_ITEM ($(basename "$f"))"
        INCOMPLETE=$((INCOMPLETE + 1))
        CURRENT_ITEM=""
      # Check for Complete status
      elif echo "$line" | grep -qiE '\*\*Status:\*\* *Complete|Status: *Complete'; then
        COMPLETE=$((COMPLETE + 1))
        CURRENT_ITEM=""
      fi
    fi
  done < "$f"
done

# Check action plans for incomplete checkpoints
if [ -d "$PLANS_DIR/execution" ]; then
  for f in "$PLANS_DIR/execution/"*.actions.md; do
    [ -f "$f" ] || continue
    UNCHECKED=$(grep -c '^\- \[ \]' "$f" 2>/dev/null || true)
    if [ "$UNCHECKED" -gt 0 ]; then
      echo -e "${YELLOW}Unchecked items:${NC} $UNCHECKED in $(basename "$f")"
      INCOMPLETE=$((INCOMPLETE + 1))
    fi
  done
fi

if [ "$INCOMPLETE" -gt 0 ]; then
  echo ""
  echo -e "${RED}${BOLD}Session incomplete.${NC} $INCOMPLETE item(s) still need attention."
  if [ "$COMPLETE" -gt 0 ]; then
    echo -e "${GREEN}Session status:${NC} $COMPLETE complete, $INCOMPLETE incomplete"
  fi
  echo ""
  echo "Before ending this session:"
  echo "  1. Complete or explicitly mark items as Blocked"
  echo "  2. Update work item statuses in the module spec"
  echo "  3. Add any discovered work as Draft items"
  echo "  4. Commit APS changes to git"
  exit 1
else
  if [ "$COMPLETE" -gt 0 ]; then
    echo -e "${GREEN}All work items resolved.${NC} $COMPLETE item(s) complete. Session can end cleanly."
  else
    echo -e "${GREEN}All work items resolved.${NC} Session can end cleanly."
  fi
  exit 0
fi
