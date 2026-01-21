#!/usr/bin/env bash
#
# APS Scaffold Initializer
# Creates or updates APS structure with templates and agent guidance.
#
# Usage:
#   # Initialize new project
#   curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/init.sh | bash
#
#   # Update existing project (creates missing dirs, updates templates)
#   curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/init.sh | bash -s -- --update
#
#   # Local usage
#   bash init.sh [target-dir]           # Initialize new project
#   bash init.sh --update [target-dir]  # Update templates only (preserves your specs)
#

set -euo pipefail

UPDATE_MODE=false
TARGET="."

while [[ $# -gt 0 ]]; do
  case $1 in
    --update|-u)
      UPDATE_MODE=true
      shift
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

PLANS_DIR="$TARGET/plans"
APS_REPO="https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/plans"

if [[ -t 1 ]]; then
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  NC='\033[0m'
else
  GREEN=''
  YELLOW=''
  NC=''
fi

info() { echo -e "${GREEN}[aps]${NC} $1"; }
warn() { echo -e "${YELLOW}[aps]${NC} $1"; }

copy_or_download() {
  local src_name="$1"
  local dest_path="$2"
  
  if [[ -f "$SCRIPT_DIR/plans/$src_name" ]]; then
    cp "$SCRIPT_DIR/plans/$src_name" "$dest_path"
  else
    curl -fsSL "$APS_REPO/$src_name" -o "$dest_path"
  fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$UPDATE_MODE" == true ]]; then
  if [[ ! -d "$PLANS_DIR" ]]; then
    warn "No plans/ directory found. Run without --update to initialize."
    exit 1
  fi

  info "Updating APS templates and rules (your specs are preserved)..."

  # Create any missing directories
  mkdir -p "$PLANS_DIR/modules"
  mkdir -p "$PLANS_DIR/execution"
  mkdir -p "$PLANS_DIR/decisions"

  copy_or_download "aps-rules.md" "$PLANS_DIR/aps-rules.md"
  copy_or_download "modules/.module.template.md" "$PLANS_DIR/modules/.module.template.md"
  copy_or_download "modules/.simple.template.md" "$PLANS_DIR/modules/.simple.template.md"
  copy_or_download "modules/.index-monorepo.template.md" "$PLANS_DIR/modules/.index-monorepo.template.md"
  copy_or_download "execution/.steps.template.md" "$PLANS_DIR/execution/.steps.template.md"

  info "Updated:"
  echo "  - aps-rules.md (agent guidance + session rituals)"
  echo "  - modules/.module.template.md"
  echo "  - modules/.simple.template.md"
  echo "  - modules/.index-monorepo.template.md (for monorepos)"
  echo "  - execution/.steps.template.md"
  echo ""
  info "Your specs (index.aps.md, modules/*.aps.md) were NOT modified."
  
else
  if [[ -d "$PLANS_DIR" ]]; then
    warn "plans/ directory already exists."
    warn "To update templates only: bash init.sh --update"
    warn "To reinitialize: rm -rf $PLANS_DIR && bash init.sh"
    exit 1
  fi
  
  info "Creating APS structure in $PLANS_DIR..."
  
  mkdir -p "$PLANS_DIR/modules"
  mkdir -p "$PLANS_DIR/execution"
  mkdir -p "$PLANS_DIR/decisions"
  
  copy_or_download "aps-rules.md" "$PLANS_DIR/aps-rules.md"
  copy_or_download "index.aps.md" "$PLANS_DIR/index.aps.md"
  copy_or_download "modules/.module.template.md" "$PLANS_DIR/modules/.module.template.md"
  copy_or_download "modules/.simple.template.md" "$PLANS_DIR/modules/.simple.template.md"
  copy_or_download "modules/.index-monorepo.template.md" "$PLANS_DIR/modules/.index-monorepo.template.md"
  copy_or_download "execution/.steps.template.md" "$PLANS_DIR/execution/.steps.template.md"

  touch "$PLANS_DIR/decisions/.gitkeep"

  info "Done! Created:"
  echo ""
  echo "  plans/"
  echo "  ├── aps-rules.md                     <- Agent guidance (READ THIS)"
  echo "  ├── index.aps.md                     <- Your main plan (edit this)"
  echo "  ├── modules/"
  echo "  │   ├── .module.template.md          <- Template for modules"
  echo "  │   ├── .simple.template.md          <- Template for small features"
  echo "  │   └── .index-monorepo.template.md  <- Index for monorepos"
  echo "  ├── execution/"
  echo "  │   └── .steps.template.md           <- Template for steps"
  echo "  └── decisions/"
  echo "      └── .gitkeep"
  echo ""
  info "Next steps:"
  echo "  1. Edit plans/index.aps.md to define your plan"
  echo "  2. Copy templates to create modules (remove leading dot)"
  echo "  3. Point your AI agent at plans/aps-rules.md"
  echo ""
fi
