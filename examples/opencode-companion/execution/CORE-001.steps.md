<!-- APS Execution: See docs/ai/prompting/steps.prompt.md -->

# Steps: CORE-001

| Field | Value |
|-------|-------|
| Source | [./modules/core.aps.md](../modules/core.aps.md) |
| Task(s) | CORE-001 — Implement config discovery and parsing |
| Created by | AI |
| Status | Ready |

## Prerequisites

- [ ] Tauri project initialized
- [ ] Zod package installed
- [ ] Sample OpenCode config available for testing

## Steps

### 1. Research OpenCode config location

- **Checkpoint:** Document confirms `~/.config/opencode/` or `~/.opencode/` path
- **Validate:** Manual inspection of local OpenCode installation

### 2. Define config TypeScript types

- **Checkpoint:** `src/core/types.ts` exports `OpenCodeConfig` type
- **Validate:** `npm run build` succeeds

### 3. Create Zod schema for config

- **Checkpoint:** Schema validates known config fields, allows unknown
- **Validate:** Unit test with sample config passes

### 4. Implement getConfigPath function

- **Checkpoint:** Function returns correct path on macOS and Linux
- **Validate:** `npm test -- config.test.ts` — path tests pass

### 5. Implement getConfig function

- **Checkpoint:** Function reads and parses config, returns typed object
- **Validate:** `npm test -- config.test.ts` — all tests pass

### 6. Handle missing/malformed config

- **Checkpoint:** Function returns sensible defaults, logs warning
- **Validate:** Test with missing file and invalid JSON passes

## Completion

- [ ] All checkpoints validated
- [ ] Task marked complete in core.aps.md

**Completed by:** (pending)
