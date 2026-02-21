# CLI Usage

## Commands

```bash
aps lint [file|dir]     # Validate APS documents
aps init [dir]          # Create APS structure in a new project
aps update [dir]        # Update templates, skill, and commands
aps --help              # Show help
```

## Validation

```bash
./bin/aps lint plans/
./bin/aps lint plans/modules/auth.aps.md
./bin/aps lint . --json
```

### PowerShell

```powershell
.\bin\aps.ps1 lint plans\
.\bin\aps.ps1 lint plans\modules\auth.aps.md
.\bin\aps.ps1 lint plans\ --json
```

### What It Checks

Errors cause a non-zero exit code. Warnings are informational.

#### Errors

| Code | Scope | Description |
|------|-------|-------------|
| E001 | Module | Missing `## Purpose` section |
| E002 | Module | Missing `## Work Items` section |
| E003 | Module | Missing ID/Status metadata table |
| E004 | Index | Missing `## Modules` section |
| E005 | Work Item | Missing required field (`**Intent:**`, `**Expected Outcome:**`, or `**Validation:**`) |
| E010 | Issues | Missing `## Issues` section |
| E011 | Issues | Missing `## Questions` section |

#### Warnings

| Code | Scope | Description |
|------|-------|-------------|
| W001 | Work Item | ID does not match `PREFIX-NNN` pattern (e.g., `AUTH-001`) |
| W003 | Work Item | Dependency references a work item ID not found in the same file |
| W004 | Module / Index | Section exists but is empty (`## Purpose`, `## In Scope`, `## Overview`, `## Problem & Success Criteria`, `## Modules`) |
| W005 | Module | Status is `Ready` but no work items are defined |
| W010 | Issues | Issue entry missing `Status`, `Discovered`, or `Severity` field |
| W011 | Issues | Question entry missing `Status`, `Discovered`, or `Priority` field |
| W012 | Issues | Issue ID does not match `ISS-NNN` format or uses wrong casing |
| W013 | Issues | Question ID does not match `Q-NNN` format or uses wrong casing |

### JSON Output

Pass `--json` to get machine-readable results:

```bash
./bin/aps lint plans/ --json
```

Example output:

```json
{
  "files": [
    {
      "path": "plans/index.aps.md",
      "type": "index",
      "errors": [],
      "warnings": []
    },
    {
      "path": "plans/modules/auth.aps.md",
      "type": "module",
      "errors": [],
      "warnings": [
        {
          "code": "W003",
          "message": "Dependency 'VAL-002' not found in this file",
          "line": 105
        }
      ]
    }
  ],
  "summary": {
    "files": 2,
    "errors": 0,
    "warnings": 1
  }
}
```

### CI Integration

Add `.github/workflows/lint-aps.yml` to your project:

```yaml
name: Lint APS Documents

on:
  push:
    paths:
      - 'plans/**/*.aps.md'
      - 'plans/**/*.actions.md'
  pull_request:
    paths:
      - 'plans/**/*.aps.md'
      - 'plans/**/*.actions.md'

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Download APS CLI
        run: |
          mkdir -p bin lib/rules
          curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/bin/aps -o bin/aps
          curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/lib/lint.sh -o lib/lint.sh
          curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/lib/output.sh -o lib/output.sh
          curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/lib/rules/common.sh -o lib/rules/common.sh
          curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/lib/rules/module.sh -o lib/rules/module.sh
          curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/lib/rules/index.sh -o lib/rules/index.sh
          curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/lib/rules/workitem.sh -o lib/rules/workitem.sh
          chmod +x bin/aps

      - name: Lint APS documents
        run: ./bin/aps lint plans/

      - name: Upload results (on failure)
        if: failure()
        run: ./bin/aps lint plans/ --json > aps-lint-results.json

      - name: Upload artefact
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: aps-lint-results
          path: aps-lint-results.json
```

See [`docs/ci-lint-example.yml`](ci-lint-example.yml) for the canonical
copy of this workflow.
