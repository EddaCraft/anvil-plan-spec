<!--
APS Steps Template
==================
FILE NAMING:
- Per-task (TASK-ID.steps.md): Complex projects, independent tasks
- Per-module (MODULE.steps.md): Simple projects, tightly coupled tasks

See: docs/ai/prompting/steps.prompt.md
-->

# Steps: [TASK-ID or MODULE]

| Field | Value |
|-------|-------|
| Source | [./modules/module.aps.md](./modules/module.aps.md) |
| Task(s) | TASK-ID — [Task title] |
| Created by | @username / AI |
| Status | Draft |

## Prerequisites

- [ ] [Dependency, decision, or precondition]

## Steps

### 1. [Action verb] [target]

- **Checkpoint:** [Observable state when done]
- **Validate:** `[command]` *(optional)*
- **Pattern:** [file:line or ADR] *(optional)*

### 2. [Action verb] [target]

- **Checkpoint:** [Observable state]

### 3. [Action verb] [target]

- **Checkpoint:** [Observable state]
- **Status:** Blocked — [reason] *(only if blocked/deferred)*

## Completion

- [ ] All checkpoints validated
- [ ] Task(s) marked complete in source module

**Completed by:** @username / AI
