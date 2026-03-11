# /work

Execute work items from an APS spec.

## Instructions

### 1. Identify the target work item

1. If the user specifies a work item ID (e.g., `AUTH-001`), locate it in `plans/modules/`.
2. If no ID is given, scan all module files for work items with status **Ready** or **In Progress**.
3. If multiple items are Ready, list them and ask which one to work on.
4. If no items are Ready, report the current statuses and suggest what to move to Ready.

### 2. Verify execution authority

1. The work item **must** have status `Ready` or `In Progress`. Do not execute `Draft` or `Blocked` items.
2. Read the work item's **Intent**, **Expected Outcome**, and **Validation** fields.
3. If any required field is missing, stop and ask the user to complete the spec first.

### 3. Check for an action plan

1. Look for `plans/execution/WORK-ITEM-ID.actions.md`.
2. If an action plan exists, follow it action by action. After each action, run its **Validate** command and update the checkpoint status.
3. If no action plan exists and the work item is straightforward (1-3 files changed), proceed directly.
4. If no action plan exists and the work is non-trivial (4+ files, multiple concerns), create one before starting. Use the template in `plans/execution/.steps.template.md`.

### 4. Execute

1. Update the work item status to `In Progress` in the module file.
2. Work toward the **Expected Outcome** described in the spec.
3. After every 5 tool operations, pause and check:
   - Am I still working toward the work item's Intent?
   - Have I discovered something that belongs in the spec?
   - Should I re-read the plan to stay on track?
4. If you discover new work that is out of scope, add it as a new `Draft` work item in the appropriate module — do not expand the current item.

### 5. Validate

1. Run the work item's **Validation** command.
2. If the action plan has per-action validation commands, run those too.
3. If validation passes, update the work item status to `Complete`.
4. If validation fails, report what failed and leave the status as `In Progress`.

### 6. Update the spec

1. Set the final status in the module file.
2. If you created or modified an action plan, ensure checkpoint statuses are current.
3. Run `./bin/aps lint` to check for spec errors.

## Reminders

- Do not start work on items that are not `Ready` — that is the execution authority model.
- Do not expand scope mid-work-item. New discoveries become new Draft items.
- Specs describe intent, not implementation. Do not add implementation details to the spec.
- If blocked, update the status to `Blocked` with a reason and move on.
- Always validate before marking Complete.
