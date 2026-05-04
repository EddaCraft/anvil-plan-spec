#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APS="$ROOT/bin/aps"
PLANS="$ROOT/test/fixtures/orchestrate/plans"

assert_contains() {
  local output="$1"
  local expected="$2"

  if [[ "$output" != *"$expected"* ]]; then
    printf 'Expected output to contain: %s\nActual output:\n%s\n' "$expected" "$output" >&2
    exit 1
  fi
}

output=$("$APS" next --plans "$PLANS")
assert_contains "$output" "AUTH-003: Add token refresh"
assert_contains "$output" "Dependencies: AUTH-001"
assert_contains "$output" "AUTH-002"
assert_contains "$output" "CORE-001"

output=$("$APS" next auth --plans "$PLANS")
assert_contains "$output" "AUTH-003: Add token refresh"
assert_contains "$output" "CORE-001"

if output=$("$APS" next billing --plans "$PLANS" 2>&1); then
  printf 'Expected billing module lookup to fail\n' >&2
  exit 1
fi

assert_contains "$output" "No ready work item found for module: billing"

printf 'orchestrate tests passed\n'
