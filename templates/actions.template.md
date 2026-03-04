<!--
APS Action Plan Template
========================
FILE NAMING:
- Per-work-item (WORK-ITEM-ID.actions.md): Complex projects, independent work items
- Per-module (MODULE.actions.md): Simple projects, tightly coupled work items

See: docs/ai/prompting/actions.prompt.md
-->

# Action Plan: [WORK-ITEM-ID or MODULE]

| Field | Value |
|-------|-------|
| Source | [./modules/module.aps.md](./modules/module.aps.md) |
| Work Item | WORK-ITEM-ID — [Work item title] |
| Created by | @username / AI |
| Status | Draft |

## Prerequisites

- [ ] [Dependency, decision, or precondition]

## Waves *(optional)*

<!--
Use waves to group actions that can run in parallel.
Actions within the same wave have no dependencies on each other.
Each wave completes before the next begins.
Omit this section for purely sequential action plans.
-->

| Wave | Actions | Gate |
|------|---------|------|
| 1 | 1, 2 | Both checkpoints pass |
| 2 | 3 | Checkpoint passes |

## Actions

### Action 1 — [Action verb] [target]

**Purpose**
[Why this action exists]

**Produces**
[Concrete artefacts or state]

**Checkpoint**
[Observable state (max ~12 words)]

**Validate**
`[command]` *(optional)*

**Wave** 1 *(optional — omit for sequential plans)*
**Agent** general-purpose *(optional — agent type for dispatch)*

### Action 2 — [Action verb] [target]

**Purpose**
[Why this action exists]

**Produces**
[Concrete artefacts or state]

**Checkpoint**
[Observable state]

**Validate**
`[command]` *(optional)*

**Wave** 1

### Action 3 — [Action verb] [target]

**Purpose**
[Why this action exists]

**Produces**
[Concrete artefacts or state]

**Checkpoint**
[Observable state]

**Depends on** 1, 2 *(optional — action numbers that must complete first)*

**Status**
Blocked — [reason] *(only if blocked/deferred)*

## Completion

- [ ] All checkpoints validated
- [ ] Work item marked complete in source module

**Completed by:** @username / AI
