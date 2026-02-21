#!/usr/bin/env bash
# APS Agent Builder
# Generates tool-specific agent variants from shared core prompts.
#
# Usage: ./scaffold/agents/build.sh
#
# Currently generates: Claude Code
# Future: Codex, Copilot, OpenCode, Gemini

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CORE_DIR="$SCRIPT_DIR/core"

info() { echo -e "\033[0;32mags:\033[0m $1"; }
warn() { echo -e "\033[1;33mwarn:\033[0m $1" >&2; }

# Verify core files exist
for core in planner-core.md librarian-core.md; do
  if [ ! -f "$CORE_DIR/$core" ]; then
    echo "error: missing $CORE_DIR/$core" >&2
    exit 1
  fi
done

# --- Claude Code ---
CC_DIR="$SCRIPT_DIR/claude-code"
mkdir -p "$CC_DIR"

generate_claude_code() {
  local name="$1"
  local description="$2"
  local model="$3"
  local tools="$4"
  local core_file="$5"
  local output="$CC_DIR/$name.md"

  {
    echo "---"
    echo "name: $name"
    echo "description: $description"
    echo "model: $model"
    echo "tools:"
    for tool in $tools; do
      echo "  - $tool"
    done
    echo "---"
    echo ""
    cat "$core_file"
  } > "$output"

  info "wrote $output"
}

generate_claude_code \
  "aps-planner" \
  "Create, manage, execute, and review plans following the Anvil Plan Spec (APS) format, including initializing projects, modules, work items, action plans, validation, status tracking, and wave-based parallel execution" \
  "opus" \
  "Read Write Edit Glob Grep Bash Task" \
  "$CORE_DIR/planner-core.md"

generate_claude_code \
  "aps-librarian" \
  "Repository organizing, cleanup, documentation filing, archiving stale specs, detecting orphaned files, cross-reference maintenance, and general repo hygiene" \
  "sonnet" \
  "Read Write Edit Glob Grep Bash" \
  "$CORE_DIR/librarian-core.md"

info "done — $(ls "$CC_DIR"/*.md | wc -l | tr -d ' ') Claude Code agents generated"
