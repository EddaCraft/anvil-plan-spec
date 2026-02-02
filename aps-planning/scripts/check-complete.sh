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

  # Look for In Progress status markers
  if grep -qi 'In Progress' "$f" 2>/dev/null; then
    # Find which work items are in progress
    CURRENT_ITEM=""
    while IFS= read -r line; do
      if echo "$line" | grep -qP '^### [A-Z]+-\d+:'; then
        CURRENT_ITEM=$(echo "$line" | sed 's/^### //' | sed 's/ *$//')
      fi
      if [ -n "$CURRENT_ITEM" ] && echo "$line" | grep -qi 'In Progress'; then
        echo -e "${YELLOW}Still in progress:${NC} $CURRENT_ITEM ($(basename "$f"))"
        INCOMPLETE=$((INCOMPLETE + 1))
        CURRENT_ITEM=""
      fi
    done < "$f"
  fi
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
  echo ""
  echo "Before ending this session:"
  echo "  1. Complete or explicitly mark items as Blocked"
  echo "  2. Update work item statuses in the module spec"
  echo "  3. Add any discovered work as Draft items"
  echo "  4. Commit APS changes to git"
  exit 1
else
  echo -e "${GREEN}All work items resolved.${NC} Session can end cleanly."
  exit 0
fi
