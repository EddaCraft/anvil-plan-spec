# /plan-status

Review the current state of APS planning in this project.

## Instructions

Scan all APS artefacts and give a concise status report.

### What to check

1. Read `plans/index.aps.md` — overall plan status
2. Read all files in `plans/modules/` — module statuses
3. Check for work items and their statuses across all modules
4. Read any action plans in `plans/execution/`
5. Run `./bin/aps lint` if available to check for validation errors

### Report format

Provide a summary like this:

```
## APS Status

**Plan:** [Plan title from index]
**Modules:** N total (N complete, N ready, N draft)

### Ready / In Progress
- AUTH-001: [title] — [status]
- AUTH-002: [title] — [status]

### Blocked
- SESSION-001: [title] — Blocked: [reason]

### Recently Completed
- CORE-001: [title]

### Validation
- [N errors, N warnings from aps lint]

### Suggested Next
- [What to work on next based on dependencies and status]
```

### Workflow phase

After the status table, indicate the current workflow phase:

```
### Workflow Phase
Current: [Plan / Work / Review / Compound]
```

Determine the phase from work item statuses:

- **Plan** — Most items are Draft, no items In Progress or Complete
- **Work** — Items are Ready or In Progress
- **Review** — Items are Complete but `plans/issues.md` has Open issues, or no `/review` has been run
- **Compound** — All items Complete, issues resolved, ready to capture learnings

### After reporting

Ask the user if they want to:

1. Start working on a Ready item (`/work`)
2. Review completed items (`/review`)
3. Capture learnings (`/compound`)
4. Update any statuses
5. Add new work items
6. Create an action plan for a complex item

### Reminders

- Re-read the relevant module spec before starting any work
- Check dependencies — don't start blocked items
- Update statuses immediately as work progresses
- The workflow phases are a guide, not a gate — you can `/review` mid-work or `/compound` at any time
