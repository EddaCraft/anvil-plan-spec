#!/usr/bin/env bash
#
# Validation rules for design documents
# All rules are WARNINGS only — free-form designs are accepted.
#

# W014: Missing ## Problem section
check_w014_problem() {
  local file="$1"
  if ! has_section "$file" "## Problem"; then
    add_result "$file" "warning" "W014" "Missing ## Problem section"
  fi
}

# W015: Missing ## Design section
check_w015_design() {
  local file="$1"
  if ! has_section "$file" "## Design"; then
    add_result "$file" "warning" "W015" "Missing ## Design section"
  fi
}

# W016: Missing metadata table with Status field
check_w016_design_metadata() {
  local file="$1"
  # Look for a table with Status in the header row within the first 20 lines
  if ! head -20 "$file" | grep -qE '^\| *(Field|Status) *\|'; then
    add_result "$file" "warning" "W016" "Missing metadata table with Status field"
  fi
}

# Run all design rules (warnings only)
lint_design() {
  local file="$1"

  check_w014_problem "$file"
  check_w015_design "$file"
  check_w016_design_metadata "$file"

  return 0
}
