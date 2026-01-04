# Steps: VAL

| Field | Value |
|-------|-------|
| Source | [../modules/validation.aps.md](../modules/validation.aps.md) |
| Task(s) | VAL-001 through VAL-006 |
| Created by | AI |
| Status | Pending |

## Prerequisites

- [x] TPL module complete (template structure known)
- [ ] DOCS module complete (validation rules may reference docs)

## Steps

### 1. Document validation rules for each template type

- **Checkpoint:** Markdown file lists required fields for: index, module, simple, steps
- **Validate:** `test -f docs/validation-rules.md`
- **Covers:** VAL-001

### 2. Create bin/ directory and aps script skeleton

- **Checkpoint:** `bin/aps` exists, is executable, shows help on `--help`
- **Validate:** `./bin/aps --help` exits 0 with usage text

### 3. Implement `lint` subcommand argument parsing

- **Checkpoint:** `aps lint <file>` accepts file path; `aps lint <dir>` accepts directory
- **Validate:** `./bin/aps lint plans/` runs without syntax error
- **Covers:** VAL-002

### 4. Create test fixtures (valid and invalid)

- **Checkpoint:** `tests/fixtures/` contains valid.aps.md and invalid-*.aps.md samples
- **Validate:** `ls tests/fixtures/*.md | wc -l` >= 3

### 5. Implement required field detection for module template

- **Checkpoint:** Script detects missing Status, Purpose, Tasks in module files
- **Validate:** `./bin/aps lint tests/fixtures/invalid-missing-status.aps.md` exits 1
- **Covers:** VAL-003

### 6. Implement task ID format validation

- **Checkpoint:** Script warns on task IDs not matching `[A-Z]+-[0-9]{3}` pattern
- **Validate:** `./bin/aps lint tests/fixtures/invalid-task-id.aps.md` outputs warning
- **Covers:** VAL-004

### 7. Implement dependency reference check

- **Checkpoint:** Script warns when Depends on references non-existent module
- **Validate:** `./bin/aps lint tests/fixtures/invalid-dep.aps.md` outputs warning
- **Covers:** VAL-005

### 8. Add JSON output option

- **Checkpoint:** `aps lint --json <file>` outputs structured JSON
- **Validate:** `./bin/aps lint --json plans/index.aps.md | jq .` parses successfully

### 9. Create CI example workflow

- **Checkpoint:** `.github/examples/aps-lint.yml` or `docs/ci-example.md` exists
- **Validate:** Valid YAML referencing `./bin/aps lint`
- **Covers:** VAL-006

### 10. Add README section for validation tool

- **Checkpoint:** README mentions `aps lint` in tooling or usage section
- **Validate:** `grep -i "aps lint" README.md`

### 11. Run full validation suite

- **Checkpoint:** All test fixtures produce expected results
- **Validate:** Manual test or simple test script

### 12. Update module status

- **Checkpoint:** All VAL tasks marked complete in validation.aps.md
- **Validate:** `grep -c "✓ Complete" plans/modules/validation.aps.md` returns 6

## Completion

- [ ] All checkpoints validated
- [ ] Task(s) marked complete in source module
- [ ] aps lint passes on this repo's own plans/

**Completed by:** ___
