# Enhanced Templates Module

| ID | Owner | Status |
|----|-------|--------|
| ETPL | @aneki | Draft |

## Purpose

Improve template usability through inline examples, visual differentiation of required/optional fields, and example-driven documentation.

## In Scope

- Inline mini-examples in all templates (showing format in comments)
- Visual markers for required vs optional fields
- Example-driven guidance (show pattern, then blank to fill)
- Progressive disclosure (simple → complex)
- Before/after examples for common scenarios

## Out of Scope

- Interactive wizards or form builders
- Live preview of rendered templates
- Template validation (that's VAL module)
- Custom template creation (user can copy/modify)

## Interfaces

**Depends on:**

- TPL (templates v0.2) ✓ Complete — builds on existing template work

**Exposes:**

- Enhanced `templates/*.template.md` files
- Example-driven pattern in scaffold templates
- Visual conventions for required/optional

## Boundary Rules

- Keep templates as plain markdown (no special syntax)
- Examples must be realistic (not "foo/bar" placeholders)
- Visual markers must work in all markdown renderers

## Ready Checklist

- [ ] Purpose and scope are clear
- [ ] Dependencies identified
- [ ] At least one work item defined

## Work Items

### ETPL-001: Add inline examples to module.template.md

- **Intent:** Show users what a filled template looks like
- **Expected Outcome:** Each section has commented mini-example showing format
- **Validation:** Visual inspection of template
- **Confidence:** high
- **Pattern:**
  ```markdown
  ## Work Items

  <!--
  Example:
  ### AUTH-001: Create login endpoint
  - **Intent:** Allow users to authenticate with email/password
  - **Expected Outcome:** POST /api/login returns JWT token on success
  - **Validation:** `curl -X POST localhost:3000/api/login` returns 200
  -->

  ### [MODULE-ID]-001: [Work Item Title]
  - **Intent:**
  - **Expected Outcome:**
  - **Validation:**
  ```

### ETPL-002: Add inline examples to index.template.md

- **Intent:** Help users understand index structure with real example
- **Expected Outcome:** Comments show realistic index content
- **Validation:** Visual inspection
- **Confidence:** high
- **Sections to exemplify:**
  - Problem statement
  - Success criteria
  - Module table
  - System map (Mermaid)

### ETPL-003: Add inline examples to actions.template.md

- **Intent:** Demonstrate lean checkpoint format with examples
- **Expected Outcome:** Template shows good vs bad checkpoints
- **Validation:** Visual inspection
- **Confidence:** high
- **Examples to include:**
  ```markdown
  <!--
  Good checkpoint: "Auth middleware validates requests, attaches user to context"
  Bad checkpoint: "Create auth middleware in src/middleware/auth.ts that extracts JWT..."

  Keep under 12 words, focus on observable outcome, not implementation.
  -->
  ```

### ETPL-004: Add visual markers for required/optional fields

- **Intent:** Reduce cognitive load by clearly marking what's needed
- **Expected Outcome:** Templates use consistent visual pattern
- **Validation:** All templates have markers
- **Confidence:** high
- **Pattern:**
  ```markdown
  ## Purpose ✏️ REQUIRED
  <!-- What is this module responsible for? -->

  ## Interfaces 🔌 OPTIONAL
  <!-- Only fill if explicit contracts with other modules exist -->

  ## Boundary Rules 🚧 OPTIONAL
  <!-- Use only for architectural constraints -->
  ```

### ETPL-005: Create before/after template examples

- **Intent:** Show completed template alongside blank one
- **Expected Outcome:** New directory `templates/examples/` with paired files
- **Validation:** Directory exists with at least 3 example pairs
- **Confidence:** high
- **Examples:**
  - `examples/module-blank.md` and `examples/module-filled-auth.md`
  - `examples/work-item-blank.md` and `examples/work-item-filled.md`
  - `examples/actions-blank.md` and `examples/actions-filled-lean.md`

### ETPL-006: Add confidence level guidance to templates

- **Intent:** Help users understand confidence field
- **Expected Outcome:** Templates have comment explaining high/medium/low
- **Validation:** Visual inspection
- **Confidence:** high
- **Guidance to add:**
  ```markdown
  <!-- Confidence levels:
  - high: Clear requirements, familiar patterns, low risk
  - medium: Some unknowns, moderate risk, may need exploration
  - low: Exploratory work, high uncertainty, expect changes
  -->
  ```

### ETPL-007: Add checkpoint quality guidance

- **Intent:** Train users on lean checkpoint writing
- **Expected Outcome:** actions.template.md has clear good/bad examples
- **Validation:** Template includes checkpoint quality section
- **Confidence:** high
- **Content:**
  - "~12 word max" rule
  - Observable vs implementation detail
  - 3-4 examples of good checkpoints
  - 3-4 examples of bad checkpoints (with explanations)

### ETPL-008: Create progression guide in templates

- **Intent:** Help users choose right template for their needs
- **Expected Outcome:** Each template links to simpler/more complex alternatives
- **Validation:** Templates have "Choose this template when..." section
- **Confidence:** medium
- **Pattern:**
  ```markdown
  ## When to use this template

  ✅ Use this when:
  - You have a bounded area of work with clear interfaces
  - You need 3-10 work items
  - Multiple dependencies exist

  ⚠️ Consider alternatives:
  - Simpler need? → Use [simple.template.md](simple.template.md)
  - Larger scope? → Use [index.template.md](index.template.md)
  ```

### ETPL-009: Update quickstart with inline examples

- **Intent:** Make 5-minute path even clearer
- **Expected Outcome:** quickstart.template.md is self-explanatory
- **Validation:** User can fill quickstart without reading other docs
- **Confidence:** high
- **Enhancements:**
  - Inline example of complete filled quickstart
  - Clear "replace [bracketed] content" instructions
  - Link to next steps after quickstart

### ETPL-010: Add field-by-field tooltips to all templates

- **Intent:** Provide just-in-time help without cluttering template
- **Expected Outcome:** Every field has brief tooltip comment
- **Validation:** All templates have comment under every heading
- **Confidence:** high
- **Pattern:**
  ```markdown
  ## Expected Outcome
  <!-- How will you know this work item is complete? Make it testable. -->

  ## Validation *(optional)*
  <!-- Command to verify completion, e.g., `npm test` or `curl localhost:3000/health` -->
  ```

## Execution

Action Plan: [../../execution/v0.3/ETPL.actions.md](../../execution/v0.3/ETPL.actions.md)

## Decisions

- **D-001:** Visual markers — *decided: emoji + text (✏️ REQUIRED) for clarity*
- **D-002:** Example realism — *decided: use auth/user domain (widely understood)*
- **D-003:** Checkpoint examples — *decided: show both good and bad with explanations*
- **D-004:** Example location — *decided: `templates/examples/` directory for before/after pairs*

## Notes

- Balance between helpful examples and cluttered templates
- Keep main templates clean; examples in separate directory
- Visual markers must be accessible (emoji + text, not emoji alone)
- Consider generating comparison table: "Good checkpoint" vs "Bad checkpoint"
