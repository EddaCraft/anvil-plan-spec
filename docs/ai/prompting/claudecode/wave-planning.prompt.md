# Wave Planning for Parallel Execution

Use this prompt to analyze APS work items and plan parallel execution waves.

---

## Prompt

```
I have an APS project with these work items and dependencies:

{PASTE WORK ITEMS TABLE OR MODULE CONTENT}

Analyze the dependency graph and create a wave-based execution plan:

1. **Wave 1**: Work items with no dependencies (can start immediately)
2. **Wave 2**: Work items whose dependencies are all in Wave 1
3. **Wave 3+**: Continue until all work items are assigned

For each wave, show:
- Which work items can run in parallel
- Expected blockers
- Recommended agent count

Output format:
| Wave | Work Items | Parallel Agents | Blocked Until |
|------|------------|-----------------|---------------|
```

---

## Example

Input:

```
AUTH-001: User registration (no deps)
AUTH-002: Email verification (deps: AUTH-001)
CORE-001: Config parsing (no deps)
CORE-002: Database connection (deps: CORE-001)
UI-001: Login page (deps: AUTH-001, CORE-002)
```

Output:

```
| Wave | Work Items | Parallel Agents | Blocked Until |
|------|------------|-----------------|---------------|
| 1 | AUTH-001, CORE-001 | 2 | - |
| 2 | AUTH-002, CORE-002 | 2 | Wave 1 complete |
| 3 | UI-001 | 1 | AUTH-002, CORE-002 |

Recommended: 2 agents
- Agent A: AUTH-001 → AUTH-002 (auth domain)
- Agent B: CORE-001 → CORE-002 → UI-001 (core + ui)
```

---

## Visual Dependency Graph

Add this to get a mermaid diagram:

```
Also generate a mermaid dependency graph showing:
- Nodes = work items
- Edges = blockedBy relationships
- Color by wave (Wave 1 = green, Wave 2 = yellow, etc.)
```
