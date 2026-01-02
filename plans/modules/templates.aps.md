# Templates Module

| ID | Owner | Status |
|----|-------|--------|
| TPL | @aneki | Ready |

## Purpose

Reduce template friction by marking optional fields, providing inline guidance, and creating a minimal quickstart path for new users.

## In Scope

- Mark optional sections with *(optional)* across all templates
- Add Ready Checklist to module templates
- Add confidence level definitions (high/medium/low)
- Create quickstart.template.md for 5-minute onboarding
- Rename leaf → module for clarity

## Out of Scope

- Changing required field names (breaking change)
- Adding new required fields
- Template validation tooling (separate module)

## Interfaces

**Depends on:**

- None

**Exposes:**

- templates/*.template.md — canonical templates
- scaffold/plans/modules/*.template.md — scaffold versions with agent comments

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified (none)
- [x] At least one task defined

## Tasks

### TPL-001: Rename leaf.template.md to module.template.md

- **Intent:** Eliminate confusing "leaf" terminology
- **Expected Outcome:** All references updated (templates, docs, prompts, scaffold)
- **Validation:** `grep -r "leaf" --include="*.md" | grep -v REVIEW | wc -l` returns 0
- **Confidence:** high
- **Status:** ✓ Complete

### TPL-002: Mark optional fields in templates

- **Intent:** Reduce perceived complexity for new users
- **Expected Outcome:** Optional sections marked with *(optional)* in module.template.md and simple.template.md
- **Validation:** Visual inspection of templates
- **Confidence:** high
- **Status:** ✓ Complete

### TPL-003: Add Ready Checklist to module template

- **Intent:** Clarify when to change status from Draft to Ready
- **Expected Outcome:** Checklist appears in module.template.md with clear criteria
- **Validation:** Visual inspection
- **Confidence:** high
- **Status:** ✓ Complete

### TPL-004: Create quickstart.template.md

- **Intent:** 5-minute path to value for new users
- **Expected Outcome:** Minimal single-file template in templates/
- **Validation:** `cat templates/quickstart.template.md` shows minimal structure
- **Confidence:** high
- **Status:** ✓ Complete

### TPL-005: Add hello world example to README

- **Intent:** Show, don't tell — immediate understanding of APS format
- **Expected Outcome:** Inline code block in README showing complete minimal spec
- **Validation:** Visual inspection of README
- **Confidence:** high
- **Status:** ✓ Complete

### TPL-006: Change SCOPE placeholder to ID with guidance

- **Intent:** Reduce confusion with In Scope/Out of Scope sections
- **Expected Outcome:** Templates use ID field with guidance comment ("2-6 uppercase chars")
- **Validation:** Visual inspection of templates
- **Confidence:** high
- **Status:** ✓ Complete

## Execution

Steps: Not needed — all tasks complete

## Notes

- Scaffold templates include additional agent-focused comments
- Original templates/ remain cleaner for human readability
