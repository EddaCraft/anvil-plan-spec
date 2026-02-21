# ADR-001: Use Checkpoint-Based Actions

> **Terminology note:** This ADR was originally written using "Steps" and "Tasks".
> These have since been renamed to "Actions" and "Work Items" respectively.
> See [docs/TERMINOLOGY.md](../TERMINOLOGY.md) for the full mapping.

## Status

Accepted

## Context

We needed a granular execution layer below Work Items. Options considered:

1. Time-based actions (e.g., "30 minutes of work")
2. Commit-based actions (e.g., "one commit per action")
3. Checkpoint-based actions (observable state change)

Time estimates vary by person and context. Commit granularity is arbitrary and enforcement is impractical.

## Decision

Actions are checkpoint-based. Each action has an observable completion state that can be verified without subjective judgment.

## Consequences

- **Easier:** Actions are independently verifiable by both humans and AI
- **Easier:** No debates about time estimates
- **Harder:** Requires thinking about observable state, not just "do stuff"
- **Harder:** Some actions may be larger/smaller than others (intentionally)
