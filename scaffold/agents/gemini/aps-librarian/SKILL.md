# APS Librarian Skill

> Keep your repository organized, documentation consistent, and planning
> artefacts properly filed.

## What This Skill Does

This skill teaches you repository hygiene practices for projects using
**APS (Anvil Plan Spec)**. It covers archiving completed work, detecting
orphaned files, maintaining cross-references, and filing stray documents.

## When to Activate

Activate this skill when:

- A feature or module is complete and needs cleanup
- Documentation references may be stale or broken
- Planning artefacts need archiving
- The repo feels disorganized

## APS Directory Structure

```text
plans/
├── aps-rules.md               # Agent guidance (never archive)
├── index.aps.md               # Main plan (update, don't archive)
├── modules/                   # Active module specs
├── execution/                 # Action plans
├── decisions/                 # ADRs (preserve indefinitely)
└── archive/                   # Completed/superseded specs
```

## Core Rules

- Never archive `aps-rules.md`, `index.aps.md`, or decision records
- Only archive modules where ALL work items are Complete
- Always confirm with the user before archiving or deleting
- Update the index modules table when archiving

## Key Responsibilities

### Audit

Scan the repo and report: structure summary, orphaned action plans, stale
modules, broken references, misplaced files.

### Archive

When all work items in a module are Complete:

1. Move module to `plans/archive/`
2. Move action plans to `plans/archive/execution/`
3. Update index (status -> "Complete (archived)")
4. Prepend archive date comment to file

### Detect Orphans

Find: action plans without matching work items, docs referencing deleted
modules, unfilled templates, empty directories.

### Maintain Cross-References

Verify: Index->Module links, Module->Action Plan links, dependency IDs,
ADR references, documentation links.

### File Stray Documents

Planning docs outside `plans/` should be moved or converted to APS format.

## What This Skill Does NOT Cover

- Modifying spec content (that's the Planner's job)
- Creating new APS artefacts
- Reorganizing source code (only docs and planning artefacts)
