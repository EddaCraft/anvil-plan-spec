# ADR-001: Use Checkpoint-Based Steps

## Status

Accepted

## Context

We needed a granular execution layer below Tasks. Options considered:

1. Time-based steps (e.g., "30 minutes of work")
2. Commit-based steps (e.g., "one commit per step")
3. Checkpoint-based steps (observable state change)

Time estimates vary by person and context. Commit granularity is arbitrary and enforcement is impractical.

## Decision

Steps are checkpoint-based. Each step has an observable completion state that can be verified without subjective judgment.

## Consequences

- **Easier:** Steps are independently verifiable by both humans and AI
- **Easier:** No debates about time estimates
- **Harder:** Requires thinking about observable state, not just "do stuff"
- **Harder:** Some steps may be larger/smaller than others (intentionally)
