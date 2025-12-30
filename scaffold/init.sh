#!/usr/bin/env bash
#
# APS Scaffold Initializer
# Creates the plans/ directory structure with templates and agent guidance.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/init.sh | bash
#   # or
#   bash init.sh [target-dir]
#

set -euo pipefail

TARGET="${1:-.}"
PLANS_DIR="$TARGET/plans"
APS_REPO="https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/plans"

# Colors (if terminal supports them)
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

# Check if plans/ already exists
if [[ -d "$PLANS_DIR" ]]; then
  warn "plans/ directory already exists. Aborting to avoid overwrite."
  warn "Remove it first if you want to reinitialize: rm -rf $PLANS_DIR"
  exit 1
fi

info "Creating APS structure in $PLANS_DIR..."

# Create directory structure
mkdir -p "$PLANS_DIR/modules"
mkdir -p "$PLANS_DIR/execution"
mkdir -p "$PLANS_DIR/decisions"

# Download files (or copy if running locally)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/plans/.aps-rules.md" ]]; then
  # Local mode (running from cloned repo)
  info "Copying from local scaffold..."
  cp "$SCRIPT_DIR/plans/.aps-rules.md" "$PLANS_DIR/"
  cp "$SCRIPT_DIR/plans/index.aps.md" "$PLANS_DIR/"
  cp "$SCRIPT_DIR/plans/modules/.module.template.md" "$PLANS_DIR/modules/"
  cp "$SCRIPT_DIR/plans/modules/.simple.template.md" "$PLANS_DIR/modules/"
  cp "$SCRIPT_DIR/plans/execution/.steps.template.md" "$PLANS_DIR/execution/"
else
  # Remote mode (curl | bash)
  info "Downloading from APS repository..."
  curl -fsSL "$APS_REPO/.aps-rules.md" -o "$PLANS_DIR/.aps-rules.md"
  curl -fsSL "$APS_REPO/index.aps.md" -o "$PLANS_DIR/index.aps.md"
  curl -fsSL "$APS_REPO/modules/.module.template.md" -o "$PLANS_DIR/modules/.module.template.md"
  curl -fsSL "$APS_REPO/modules/.simple.template.md" -o "$PLANS_DIR/modules/.simple.template.md"
  curl -fsSL "$APS_REPO/execution/.steps.template.md" -o "$PLANS_DIR/execution/.steps.template.md"
fi

# Create .gitkeep files for empty dirs
touch "$PLANS_DIR/decisions/.gitkeep"

info "Done! Created:"
echo ""
echo "  plans/"
echo "  ├── .aps-rules.md           <- Agent guidance (READ THIS)"
echo "  ├── index.aps.md            <- Your main plan (edit this)"
echo "  ├── modules/"
echo "  │   ├── .module.template.md <- Template for modules"
echo "  │   └── .simple.template.md <- Template for small features"
echo "  ├── execution/"
echo "  │   └── .steps.template.md  <- Template for steps"
echo "  └── decisions/"
echo "      └── .gitkeep"
echo ""
info "Next steps:"
echo "  1. Edit plans/index.aps.md to define your plan"
echo "  2. Copy templates to create modules (remove leading dot)"
echo "  3. Point your AI agent at plans/.aps-rules.md"
echo ""
