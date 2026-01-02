# Validation Module

| ID | Owner | Status |
|----|-------|--------|
| VAL | @aneki | Draft |

## Purpose

Provide tooling to validate APS documents against expected structure, catching common errors before they cause confusion.

## In Scope

- CLI tool to validate APS markdown files
- Check required fields are present
- Validate task ID format (MODULE-NNN)
- Check dependency references resolve
- Warning on common issues (empty sections, missing checkpoints)

## Out of Scope

- IDE plugins or extensions (separate module)
- Automated fixes or corrections
- Semantic validation (e.g., "is this task well-written?")

## Interfaces

**Depends on:**

- TPL (templates) — validation rules based on template structure

**Exposes:**

- `aps validate [file|dir]` — CLI command
- Exit codes for CI integration
- JSON output option for tooling

## Ready Checklist

- [ ] Purpose and scope are clear
- [ ] Dependencies identified
- [ ] At least one task defined

## Tasks

Module is Draft — tasks to be defined when Ready.

Candidate tasks from roadmap:

1. Define validation rules (required fields per template type)
2. Create CLI tool skeleton (Node.js or shell)
3. Implement field presence checks
4. Implement task ID format validation
5. Implement dependency reference resolution
6. Add CI integration example (GitHub Action)

## Decisions

- **D-001:** CLI language choice — *pending (Node.js vs shell vs Deno)*
- **D-002:** Strictness levels — *pending (error vs warning)*

## Notes

- Could start as simple shell script using grep/awk
- JSON Schema approach mentioned in review but may be overkill
- GitHub Action could be separate deliverable
