# Issues & Questions Tracker

> Development-time discoveries that emerge while building. Not a bug tracker replacement — a lightweight log for planning-level concerns that need visibility.

---

## Issues

<!--
Issues are problems discovered during development.
ID format: ISS-NNN (e.g., ISS-001)
Status: Open | Resolved | Deferred | Won't Fix
Severity: Critical | High | Medium | Low

Example:
### ISS-001: API rate limits lower than expected

| Field | Value |
|-------|-------|
| Status | Open |
| Severity | medium |
| Discovered | AUTH-002 |
| Module | AUTH |

**Context:** During load testing, discovered the API rate-limits at 100 req/min, not 1000 as documented.

**Impact:** Will need retry logic or batching for bulk operations.
-->

*(No issues yet)*

---

## Questions

<!--
Questions are unknowns that emerged during development.
ID format: Q-NNN (e.g., Q-001)
Status: Open | Answered | Deferred
Priority: High | Medium | Low

Example:
### Q-001: Should retry logic live in the client or transport layer?

| Field | Value |
|-------|-------|
| Status | Open |
| Priority | medium |
| Discovered | AUTH-002 |
| Assigned | @username |

**Context:** Found we need retry logic for rate limits. Unclear where this belongs architecturally.

**Options considered:**
1. Client layer — simpler, but each client reimplements
2. Transport layer — centralized, but may hide failures
-->

*(No questions yet)*

---

## Resolved

<!--
Move resolved issues and answered questions here.
Keep for 1-2 sprints as reference, then archive or delete.
-->

*(Nothing resolved yet)*

---

## Quick Reference

| ID Type | Format | Example |
|---------|--------|---------|
| Issue | ISS-NNN | ISS-001 |
| Question | Q-NNN | Q-001 |

**Severities:** Critical > High > Medium > Low

**Reference from other docs:** `See ISS-001` or `Related: ISS-001, Q-002`
