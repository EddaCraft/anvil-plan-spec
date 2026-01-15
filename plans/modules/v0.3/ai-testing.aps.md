# AI Testing Module

| ID | Owner | Status |
|----|-------|--------|
| AI | @aneki | Draft |

## Purpose

Provide automated testing framework to verify that AI agents (Claude, GPT-4, Cursor, etc.) follow APS conventions when given aps-rules.md guidance.

## In Scope

- Test scenario definitions (markdown format)
- Evaluation criteria for agent responses
- Test runner that prompts agents and scores responses
- Regression test suite for major agents
- Scoring system for compliance
- CI integration for detecting guidance regressions

## Out of Scope

- Fine-tuning models or custom training
- Agent-specific plugins or extensions
- Live monitoring of agent usage
- User behavior analytics
- Production deployment monitoring

## Interfaces

**Depends on:**

- VAL (validation) — reuses parser for checking agent outputs
- EDOC (enhanced-docs) — tests reference aps-rules.md

**Exposes:**

- `tests/ai-agents/` — scenario library
- `tests/ai-agents/runner.js` — test execution script
- `tests/ai-agents/evaluate.js` — scoring logic
- CI workflow — regression testing on guidance changes

## Boundary Rules

- Tests must be runnable without API keys in CI (use fixtures)
- Evaluation must be deterministic (no subjective scoring)
- Test scenarios must reflect real-world usage

## Ready Checklist

- [ ] Purpose and scope are clear
- [ ] Dependencies identified
- [ ] At least one work item defined

## Work Items

### AI-001: Define test scenario format

- **Intent:** Establish standard structure for AI test scenarios
- **Expected Outcome:** Specification document and example scenarios
- **Validation:** File exists at tests/ai-agents/SCENARIO-FORMAT.md
- **Confidence:** high
- **Format:**
  ```markdown
  # Scenario: Create Module from Scratch

  ## Setup
  Project has existing index.aps.md with 2 modules defined.

  ## User Prompt
  "Create a new module for payment processing"

  ## Required Context
  - plans/index.aps.md
  - plans/aps-rules.md

  ## Expected Agent Actions
  1. Read index.aps.md to understand project
  2. Read aps-rules.md for conventions
  3. Create plans/modules/03-payments.aps.md
  4. Use correct module ID format (PAY or PAYMENTS)
  5. Include required sections (Purpose, Scope, Interfaces)
  6. Leave Work Items empty (module is Draft)

  ## Evaluation Criteria
  - [ ] File created at correct path
  - [ ] Module ID follows convention (2-6 uppercase chars)
  - [ ] Required sections present
  - [ ] No work items defined (status is Draft)
  - [ ] Interfaces section mentions dependencies if any

  ## Anti-Patterns to Detect
  - ❌ Creating work items before module is Ready
  - ❌ Using invalid module ID (lowercase, numbers, wrong length)
  - ❌ Skipping required sections
  - ❌ Implementation details in Purpose section
  ```

### AI-002: Create core test scenarios

- **Intent:** Cover common APS operations agents will perform
- **Expected Outcome:** 10+ scenario files in tests/ai-agents/scenarios/
- **Validation:** Each scenario follows format spec
- **Confidence:** high
- **Scenarios:**
  1. Create module from scratch
  2. Add work item to existing module
  3. Write lean checkpoint (not implementation guide)
  4. Follow naming conventions (module ID, work item ID)
  5. Respect module status (don't execute Draft modules)
  6. Check dependencies before execution
  7. Create action plan for complex work item
  8. Avoid implementation detail in specs
  9. Mark optional fields correctly
  10. Update index when adding module

### AI-003: Implement evaluation scorer

- **Intent:** Automatically score agent responses against criteria
- **Expected Outcome:** Script that checks agent output, returns pass/fail/score
- **Validation:** Scorer correctly evaluates test fixtures
- **Confidence:** high
- **Checks:**
  - File existence and path correctness
  - Required sections present (via validation parser)
  - Naming convention compliance (regex matching)
  - Checkpoint word count (≤12 words)
  - Implementation detail detection (keyword matching)
  - Status field correctness
- **Output:**
  ```
  Scenario: Create Module
  ✓ File created at correct path
  ✓ Module ID follows convention
  ✓ Required sections present
  ✗ Work items defined in Draft module (should be empty)
  ✓ No implementation details detected

  Score: 4/5 (80%) - PASS
  ```

### AI-004: Create test runner for manual evaluation

- **Intent:** Facilitate manual testing with real agents
- **Expected Outcome:** CLI tool that shows scenario, waits for agent action, evaluates
- **Validation:** Tool runs scenario, prompts for agent output, scores result
- **Confidence:** medium
- **Workflow:**
  ```bash
  $ node tests/ai-agents/runner.js --scenario create-module --agent claude

  === Scenario: Create Module from Scratch ===
  Setup: [displays setup instructions]
  Prompt: [displays user prompt to give agent]

  [Paste this into agent with aps-rules.md context]

  Press Enter when agent has completed...

  Evaluating agent output...
  ✓ File created at correct path
  ✗ Module ID uses lowercase (expected: PAY, got: pay)
  ...

  Score: 4/5 (80%)
  ```

### AI-005: Create fixture-based automated tests

- **Intent:** Allow CI testing without live agent API calls
- **Expected Outcome:** Test fixtures (agent outputs) that can be scored deterministically
- **Validation:** `npm test` runs fixture-based tests in CI
- **Confidence:** high
- **Structure:**
  ```
  tests/ai-agents/
  ├── scenarios/
  │   └── 001-create-module.md
  ├── fixtures/
  │   ├── 001-create-module-good.md (expected output)
  │   ├── 001-create-module-bad-id.md (wrong ID format)
  │   └── 001-create-module-bad-status.md (work items in Draft)
  ├── evaluate.js (scorer)
  └── test.js (Jest/Mocha test suite)
  ```

### AI-006: Add checkpoint quality detection

- **Intent:** Automatically detect verbose or implementation-heavy checkpoints
- **Expected Outcome:** Evaluation script flags checkpoints >12 words or with implementation keywords
- **Validation:** Test fixture with bad checkpoint scores low on checkpoint quality
- **Confidence:** medium
- **Detection heuristics:**
  - Word count >12 → flag as verbose
  - Contains code keywords (if/else, for loop, function, class) → flag as implementation
  - Contains library names (jsonwebtoken, express, react) → flag as prescriptive
  - Contains file paths with line numbers → flag as implementation
  - Starts with "Create X that does Y by Z..." → flag as tutorial

### AI-007: Create agent comparison matrix

- **Intent:** Track which agents comply best with APS conventions
- **Expected Outcome:** Markdown table showing pass rates per agent per scenario
- **Validation:** Matrix updates based on test runs
- **Confidence:** medium
- **Format:**
  ```markdown
  # Agent Compliance Matrix

  Last updated: 2026-01-15

  | Scenario | Claude Sonnet | GPT-4 | Cursor | Average |
  |----------|---------------|-------|--------|---------|
  | Create module | 100% (5/5) | 80% (4/5) | 80% (4/5) | 87% |
  | Add work item | 100% (5/5) | 100% (5/5) | 60% (3/5) | 87% |
  | Lean checkpoint | 80% (4/5) | 60% (3/5) | 40% (2/5) | 60% |
  | Naming conventions | 100% (5/5) | 100% (5/5) | 100% (5/5) | 100% |
  | ... | ... | ... | ... | ... |
  | **Overall** | **92%** | **84%** | **70%** | **82%** |
  ```

### AI-008: Add scenario for common mistakes

- **Intent:** Explicitly test for anti-patterns identified in usability review
- **Expected Outcome:** Scenarios that detect common failure modes
- **Validation:** Anti-pattern scenarios catch violations
- **Confidence:** high
- **Anti-pattern scenarios:**
  1. Agent writes implementation tutorial as checkpoint
  2. Agent creates work items in Draft module
  3. Agent uses lowercase or invalid module ID
  4. Agent includes library choice in spec (not emergent)
  5. Agent skips validation command
  6. Agent doesn't check module status before executing
  7. Agent forgets to update index when adding module
  8. Agent uses "Task" instead of "Work Item"

### AI-009: Create CI workflow for regression testing

- **Intent:** Catch regressions in aps-rules.md or template guidance
- **Expected Outcome:** GitHub Action that runs fixture tests on PRs
- **Validation:** Workflow file passes in CI
- **Confidence:** high
- **Workflow:**
  ```yaml
  name: AI Agent Regression Tests
  on: [pull_request]
  jobs:
    test-agents:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v2
        - run: npm install
        - run: npm test -- tests/ai-agents/
        - name: Post results
          if: failure()
          run: echo "Agent compliance tests failed - check guidance changes"
  ```

### AI-010: Document testing methodology

- **Intent:** Help contributors add new scenarios and maintain tests
- **Expected Outcome:** README in tests/ai-agents/ with instructions
- **Validation:** README covers adding scenarios, running tests, interpreting results
- **Confidence:** high
- **Sections:**
  - Overview of AI testing framework
  - How to add a new scenario
  - How to create test fixtures
  - Running tests manually vs CI
  - Interpreting scores and pass/fail
  - Updating evaluation criteria
  - When to update aps-rules.md based on test failures

### AI-011: Add live agent testing script (optional)

- **Intent:** Enable testing with real API calls (for maintainer use)
- **Expected Outcome:** Script that calls OpenAI/Anthropic APIs with scenarios
- **Validation:** Script runs scenario through API, evaluates response
- **Confidence:** low
- **Note:** Requires API keys, not for CI
- **Usage:**
  ```bash
  $ ANTHROPIC_API_KEY=... node tests/ai-agents/live-test.js \
      --scenario create-module \
      --agent claude-sonnet-4.5

  Sending prompt to Claude Sonnet 4.5...
  Received response (2.3s)
  Evaluating...

  Score: 5/5 (100%) - PASS
  ```

## Execution

Action Plan: [../../execution/v0.3/AI.actions.md](../../execution/v0.3/AI.actions.md)

## Decisions

- **D-001:** Test format — *decided: markdown scenarios (consistent with APS)*
- **D-002:** Evaluation method — *decided: deterministic rule-based (no LLM-as-judge)*
- **D-003:** CI integration — *decided: fixture-based tests (no API calls in CI)*
- **D-004:** Live testing — *decided: optional script for maintainers, not required*
- **D-005:** Agents to test — *decided: Claude, GPT-4, Cursor (cover major tools)*

## Acceptance Criteria

AI testing is ready when:
- [ ] 10+ scenarios cover common APS operations
- [ ] Evaluation scorer runs deterministically
- [ ] Fixture-based tests pass in CI
- [ ] Agent compliance matrix shows >80% average pass rate
- [ ] Anti-pattern detection catches known mistakes
- [ ] Documentation explains how to add scenarios

## Risks

| Risk | Mitigation |
|------|------------|
| Agents improve/change, tests become stale | Periodic review and updates to fixtures |
| Evaluation too strict (false negatives) | Allow tolerance ranges, focus on critical violations |
| Scenarios don't match real-world usage | Base scenarios on actual user feedback and issues |
| API costs for live testing | Make live testing optional, rely on fixtures for CI |

## Notes

- This is a quality gate for aps-rules.md changes
- Scenarios evolve based on observed agent behavior
- Consider crowd-sourcing scenarios from community
- Future: automated prompt optimization based on test results
- Long-term: track compliance trends over model versions
