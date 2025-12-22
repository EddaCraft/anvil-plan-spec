# Architecture & Boundaries (Intent)

This repo has architectural intent. The goal is to prevent "locally reasonable"
changes from causing long-term drift.

## Default stance

- Prefer **warning before commit/save** (developer-time feedback).
- Warn on **new** boundary violations even if existing drift exists.
- When drift exists, be explicit: "This boundary is already violated elsewhere.
  This change introduces a new dependency."

## Boundary violations (typical signals)

- A function/class calling across contexts or layers it should not know about
- New imports/dependencies from "inner" modules to "outer" modules (wrong
  direction)
- Direct calls into internal modules (bypassing public interfaces)

## Evidence to include in warnings

- The boundary crossed (e.g. `Payments -> Identity`)
- The exact code location (file + line + symbol) when possible
- The named pattern/rule (if known)
- Blast radius in terms of **runtime/product impact** where possible
  (routes/handlers/services)
- Confidence only when low (phrase carefully otherwise)

## Exceptions

- Exceptions must be explicitly documented (inline + provenance).
- Risk acceptance is human-only.
