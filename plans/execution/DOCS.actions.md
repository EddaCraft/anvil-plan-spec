# Action Plan: DOCS

| Field | Value |
|-------|-------|
| Source | [../modules/docs.aps.md](../modules/docs.aps.md) |
| Work Items | DOCS-001 through DOCS-005 |
| Created by | AI |
| Status | Complete |

## Prerequisites

- [x] TPL module complete (templates finalized)
- [x] README has hello world example to reference

## Actions

### Action 1 — Audit current getting-started.md structure

**Checkpoint**
Notes captured on current structure and what needs moving

**Pattern**
Read docs/getting-started.md, identify decision tree location

### Action 2 — Reorganize getting-started.md with decision tree first

**Checkpoint**
Decision tree ("Which template?") appears in first 50 lines

**Validate**
`head -50 docs/getting-started.md | grep -i "which\|template\|choose"`

**Covers**
DOCS-001

### Action 3 — Add solo developer guidance to getting-started.md

**Checkpoint**
Section exists advising solo devs to use Simple template, skip formal modules

**Validate**
`grep -i "solo" docs/getting-started.md`

**Covers**
DOCS-004

### Action 4 — Surface examples earlier in getting-started.md

**Checkpoint**
Link to examples/ appears within first 100 lines

**Validate**
`head -100 docs/getting-started.md | grep -i "examples/"`

**Covers**
DOCS-005 (partial)

### Action 5 — Create docs/workflow.md with structure

**Checkpoint**
New file exists with skeleton: Overview, Scenarios, Completion sections

**Validate**
`test -f docs/workflow.md`

**Covers**
DOCS-002 (partial)

### Action 6 — Write "Starting a Feature" scenario

**Checkpoint**
Scenario shows: create spec, get approval, begin implementation

**Validate**
`grep -i "starting\|feature" docs/workflow.md`

### Action 7 — Write "Mid-Implementation" scenario

**Checkpoint**
Scenario covers: updating work items, adding actions, handling blockers

**Validate**
`grep -i "progress\|blocked\|update" docs/workflow.md`

### Action 8 — Write "Handoff" scenario

**Checkpoint**
Scenario shows: context for new dev, what to read first

**Validate**
`grep -i "handoff\|onboard" docs/workflow.md`

### Action 9 — Write "Completion and Archival" section

**Checkpoint**
Guidance on marking complete, when to archive vs delete, what to keep

**Validate**
`grep -i "complete\|archive" docs/workflow.md`

**Covers**
DOCS-003

### Action 10 — Update README to surface examples earlier

**Checkpoint**
Examples section or link appears closer to top (before Templates table)

**Validate**
README structure reviewed, examples visible in first scroll

**Covers**
DOCS-005 (complete)

### Action 11 — Run markdownlint on all changed files

**Checkpoint**
`npx markdownlint-cli docs/*.md README.md` passes

**Validate**
Exit code 0

### Action 12 — Update module status

**Checkpoint**
All DOCS work items marked complete in docs.aps.md

**Validate**
`grep -c "✓ Complete" plans/modules/docs.aps.md` returns 5

## Completion

- [x] All checkpoints validated
- [x] Work items marked complete in source module
- [x] markdownlint passes

**Completed by:** AI (2026-01-04)
