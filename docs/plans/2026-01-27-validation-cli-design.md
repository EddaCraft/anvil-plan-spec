# Validation CLI Design

| Field | Value |
|-------|-------|
| Status | Approved |
| Created | 2026-01-27 |
| Module | [VAL](../../plans/modules/validation.aps.md) |

## Overview

A bash CLI tool (`aps lint`) to validate APS documents against expected structure, catching common errors before they cause confusion. No runtime dependencies.

## Command Interface

```bash
aps lint [file|dir]     # Validate file(s), default: plans/
aps lint --help         # Show usage
aps lint --json         # JSON output for tooling
```

Exit codes:
- `0` — No errors (may include warnings)
- `1` — One or more errors found

## File Type Detection

Filename-based detection:

| Pattern | Type | Description |
|---------|------|-------------|
| `**/index.aps.md` | index | Project plan overview |
| `**/modules/*.aps.md` | module | Bounded work area |
| `**/execution/*.actions.md` | actions | Action plan checkpoints |
| `**/*.aps.md` (elsewhere) | simple | Small self-contained feature |

Directory scanning:
- Find all `*.aps.md` and `*.actions.md` files
- Skip dotfiles (`.module.template.md`)
- Default to `plans/` if no argument given

## Validation Rules

### Errors (exit 1)

| Code | Applies To | Check |
|------|------------|-------|
| E001 | module, simple | Missing `## Purpose` section |
| E002 | module, simple | Missing `## Work Items` section |
| E003 | module, simple | Missing ID/Status metadata table |
| E004 | index | Missing `## Modules` section |
| E005 | work item | Missing required field (Intent, Expected Outcome, or Validation) |

### Warnings (exit 0)

| Code | Applies To | Check |
|------|------------|-------|
| W001 | work item | ID doesn't match `[A-Z]+-[0-9]{3}` pattern |
| W002 | module | `Depends on` references unknown module |
| W003 | work item | `Dependencies` references unknown task ID |
| W004 | any | Empty section (just header, no content) |
| W005 | module | Status=Ready but no work items defined |

## Output Format

### Text (default)

```
plans/modules/auth.aps.md
  E003: Missing ID/Status metadata table
  W001: AUTH-1 should be AUTH-001 (line 45)

plans/index.aps.md
  ✓ valid

2 files checked, 1 error, 1 warning
```

### JSON (`--json`)

```json
{
  "files": [
    {
      "path": "plans/modules/auth.aps.md",
      "type": "module",
      "errors": [{"code": "E003", "message": "Missing ID/Status metadata table"}],
      "warnings": [{"code": "W001", "message": "AUTH-1 should be AUTH-001", "line": 45}]
    }
  ],
  "summary": {"files": 2, "errors": 1, "warnings": 1}
}
```

## File Structure

```
bin/
└── aps                    # Main CLI entry point

lib/
├── lint.sh                # Core linting logic
├── rules/
│   ├── common.sh          # Shared validation helpers
│   ├── module.sh          # Module/simple rules
│   ├── index.sh           # Index rules
│   └── workitem.sh        # Work item rules
└── output.sh              # Formatting (text/json)

test/
└── fixtures/
    ├── valid/             # Should pass
    └── invalid/           # Should fail with known errors
```

## Implementation Notes

- Pure bash + grep/sed/awk (no external dependencies)
- Each rule is a function returning error/warning tuples
- Accumulate results, format at end
- JSON output via string building (no jq required)
- CI runs `aps lint plans/` on this repo (dogfooding)

## Decisions

- **D-001:** CLI language — bash for v1, no runtime dependencies
- **D-002:** Strictness — errors (exit 1) vs warnings (exit 0 with output)
- **D-003:** Detection — filename-based (not content markers)
