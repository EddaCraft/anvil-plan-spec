#!/usr/bin/env bash
#
# Simple test runner for APS CLI
#

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APS="$PROJECT_ROOT/bin/aps"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

pass() { echo -e "${GREEN}PASS${NC} $1"; }
fail() { echo -e "${RED}FAIL${NC} $1"; exit 1; }

echo "Running APS CLI tests..."
echo ""

# Test 1: Help command works
echo -n "Test: --help returns 0... "
$APS --help > /dev/null 2>&1 && pass || fail "help command failed"

# Test 2: lint --help works
echo -n "Test: lint --help returns 0... "
$APS lint --help > /dev/null 2>&1 && pass || fail "lint help failed"

# Test 3: Valid fixtures pass
echo -n "Test: valid fixtures pass... "
$APS lint "$SCRIPT_DIR/fixtures/valid/" > /dev/null 2>&1 && pass || fail "valid fixtures failed"

# Test 4: Invalid fixtures fail with exit 1
echo -n "Test: invalid fixtures return exit 1... "
if $APS lint "$SCRIPT_DIR/fixtures/invalid/" > /dev/null 2>&1; then
  fail "expected exit 1 for invalid fixtures"
else
  pass
fi

# Test 5: E001 - Missing purpose detected
echo -n "Test: E001 missing purpose detected... "
output=$($APS lint "$SCRIPT_DIR/fixtures/invalid/missing-purpose.aps.md" 2>&1) || true
echo "$output" | grep -q "E001" && pass || fail "E001 not detected"

# Test 6: E002 - Missing work items detected
echo -n "Test: E002 missing work items detected... "
output=$($APS lint "$SCRIPT_DIR/fixtures/invalid/missing-work-items.aps.md" 2>&1) || true
echo "$output" | grep -q "E002" && pass || fail "E002 not detected"

# Test 7: E003 - Missing metadata detected
echo -n "Test: E003 missing metadata detected... "
output=$($APS lint "$SCRIPT_DIR/fixtures/invalid/missing-metadata.aps.md" 2>&1) || true
echo "$output" | grep -q "E003" && pass || fail "E003 not detected"

# Test 8: E005 - Missing required fields detected
echo -n "Test: E005 missing required fields detected... "
output=$($APS lint "$SCRIPT_DIR/fixtures/invalid/missing-required-fields.aps.md" 2>&1) || true
echo "$output" | grep -q "E005" && pass || fail "E005 not detected"

# Test 9: W001 - Bad task ID format detected
echo -n "Test: W001 bad task ID detected... "
output=$($APS lint "$SCRIPT_DIR/fixtures/invalid/bad-task-id.aps.md" 2>&1) || true
echo "$output" | grep -q "W001" && pass || fail "W001 not detected"

# Test 10: Valid issues.md passes lint
echo -n "Test: valid issues.md passes... "
$APS lint "$SCRIPT_DIR/fixtures/valid/issues.md" > /dev/null 2>&1 && pass || fail "valid issues.md failed"

# Test 11: E010 - Missing Issues section detected
echo -n "Test: E010 missing Issues section detected... "
output=$($APS lint "$SCRIPT_DIR/fixtures/invalid/issues-missing-section/issues.md" 2>&1) || true
echo "$output" | grep -q "E010" && pass || fail "E010 not detected"

# Test 12: W010 - Missing issue fields detected
echo -n "Test: W010 missing issue fields detected... "
output=$($APS lint "$SCRIPT_DIR/fixtures/invalid/issues-bad-fields/issues.md" 2>&1) || true
echo "$output" | grep -q "W010" && pass || fail "W010 not detected"

# Test 13: W011 - Missing question fields detected
echo -n "Test: W011 missing question fields detected... "
output=$($APS lint "$SCRIPT_DIR/fixtures/invalid/issues-bad-fields/issues.md" 2>&1) || true
echo "$output" | grep -q "W011" && pass || fail "W011 not detected"

# Test 14: JSON output works
echo -n "Test: JSON output valid... "
output=$($APS lint "$SCRIPT_DIR/fixtures/valid/" --json 2>&1)
echo "$output" | grep -q '"summary"' && pass || fail "JSON output invalid"

# Test 15: Dogfood - lint our own plans/
echo -n "Test: plans/ directory passes lint... "
$APS lint "$PROJECT_ROOT/plans/" > /dev/null 2>&1 && pass || fail "our own plans failed lint"

# Test 16: aps next picks ready item with deps complete
echo -n "Test: aps next on fixture picks ALPHA-003... "
output=$($APS next --plans-dir "$SCRIPT_DIR/fixtures/orch" 2>&1) || true
echo "$output" | grep -q "ALPHA-003" && pass || fail "expected ALPHA-003, got: $output"

# Test 17: aps next --json emits structured output
echo -n "Test: aps next --json includes id and module... "
output=$($APS next --plans-dir "$SCRIPT_DIR/fixtures/orch" --json 2>&1) || true
echo "$output" | grep -q '"id":"ALPHA-003"' && \
  echo "$output" | grep -q '"module":"alpha"' && pass || \
  fail "JSON missing fields: $output"

# Test 18: aps next module filter restricts scope
echo -n "Test: aps next beta filters to beta module... "
output=$($APS next beta --plans-dir "$SCRIPT_DIR/fixtures/orch" 2>&1) || true
echo "$output" | grep -q "BETA-001" && pass || fail "expected BETA-001, got: $output"

# Test 19: aps next returns exit 1 when nothing startable
echo -n "Test: aps next returns 1 on empty result... "
mkdir -p /tmp/aps-orch-empty/modules
echo "# Empty" > /tmp/aps-orch-empty/modules/empty.aps.md
if $APS next --plans-dir /tmp/aps-orch-empty > /dev/null 2>&1; then
  fail "expected exit 1 for empty plans"
else
  pass
fi
rm -rf /tmp/aps-orch-empty

# Test 20: aps next skips In Progress items
echo -n "Test: aps next does not return ALPHA-002 (In Progress)... "
output=$($APS next --plans-dir "$SCRIPT_DIR/fixtures/orch" --json 2>&1) || true
if echo "$output" | grep -q '"id":"ALPHA-002"'; then
  fail "should not return In Progress item"
else
  pass
fi

# Test 21: aps next does NOT promote items in a Draft module to Ready
echo -n "Test: aps next skips items in Draft modules... "
if $APS next --plans-dir "$SCRIPT_DIR/fixtures/orch/edge-cases/draft-module" >/dev/null 2>&1; then
  fail "should not return any Ready items in a Draft module"
else
  pass
fi

# Test 22: aps next handles duplicate IDs — Complete-wins, dependent unblocks
echo -n "Test: aps next resolves DUP-002 (DUP-001 dup-Complete wins)... "
output=$($APS next --plans-dir "$SCRIPT_DIR/fixtures/orch/edge-cases/dup-ids" --json 2>/dev/null) || true
echo "$output" | grep -q '"id":"DUP-002"' && pass || fail "expected DUP-002, got: $output"

# Test 23: aps next emits a warning for duplicate IDs
echo -n "Test: aps next warns to stderr about duplicate ID... "
stderr=$($APS next --plans-dir "$SCRIPT_DIR/fixtures/orch/edge-cases/dup-ids" 2>&1 >/dev/null) || true
echo "$stderr" | grep -q "duplicate work item id DUP-001" && pass || fail "expected duplicate warning, got: $stderr"

# Test 24: aps next does not return items with circular deps
echo -n "Test: aps next exits 1 on circular dependencies... "
if $APS next --plans-dir "$SCRIPT_DIR/fixtures/orch/edge-cases/circular" >/dev/null 2>&1; then
  fail "circular deps should not produce a startable item"
else
  pass
fi

# Test 25: aps next --json emits valid JSON parseable by jq
echo -n "Test: aps next --json output is valid JSON... "
if command -v jq >/dev/null 2>&1; then
  output=$($APS next --plans-dir "$SCRIPT_DIR/fixtures/orch" --json 2>&1)
  echo "$output" | jq -e '.found == true and .id == "ALPHA-003"' >/dev/null && pass || fail "jq could not parse: $output"
else
  echo "SKIP (no jq)"
fi

echo ""
echo -e "${GREEN}All tests passed!${NC}"
