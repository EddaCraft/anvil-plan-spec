# AI Anti-Patterns (High-Confidence Warnings)

These patterns are commonly introduced by AI coding tools to "make it work",
but they usually degrade quality, trust, and maintainability.

## Default stance

- Treat these as **high-confidence warnings**.
- Do not introduce them unless unavoidable.
- If unavoidable, use **explicit suppression** with:
  1. an inline note (JSDoc/comment) and
  2. provenance metadata (task/exception note).

## Avoid (unless explicitly justified)

### Broad lint suppression

- `// eslint-disable`
- `/* eslint-disable */`
- Disabling whole files or large regions

Prefer:

- fix the underlying issue
- narrow suppression to a single rule + single line
- add a clear justification and link to the relevant task/decision

### Type escape hatches

- `any` and broad `unknown` usage as a shortcut
- `as any` / unsafe casts to bypass type checking

Prefer:

- proper types/interfaces
- narrow generics
- safe parsing/validation (e.g. schema validation)

### Over-generalisation

- premature abstraction layers
- generic "utility" helpers that obscure domain meaning

Prefer:

- simple, specific code aligned to the domain
- refactor only when you have at least 2-3 concrete usages

### "Just ship it" fixes

- swallowing errors
- returning empty defaults instead of handling failure
- adding retries/timeouts without rationale

Prefer:

- explicit error paths
- clear, testable failure behaviour
- logging/metrics only if they exist in the project's norms
