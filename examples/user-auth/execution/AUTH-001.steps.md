<!-- APS Execution: See docs/ai/prompting/steps.prompt.md -->

# Steps: AUTH-001

| Field | Value |
|-------|-------|
| Source | [./modules/auth.aps.md](../modules/auth.aps.md) |
| Task(s) | AUTH-001 — Create user registration function |
| Created by | AI |
| Status | Ready |

## Prerequisites

- [ ] PostgreSQL database accessible
- [ ] Node.js project with TypeScript configured
- [ ] bcrypt package installed

## Steps

### 1. Create users table migration

- **Checkpoint:** Migration file exists with email, password_hash, created_at columns
- **Validate:** `npm run migrate:status` shows pending migration

### 2. Run migration

- **Checkpoint:** Users table exists in database
- **Validate:** `psql -c "\d users"` shows table structure

### 3. Create auth module file

- **Checkpoint:** `src/auth/auth.ts` exists with empty exports
- **Validate:** `npm run build` succeeds

### 4. Implement registerUser function

- **Checkpoint:** Function hashes password and inserts user record
- **Validate:** `npm test -- auth.test.ts` — registration tests pass

### 5. Add duplicate email handling

- **Checkpoint:** Function throws on duplicate email
- **Validate:** `npm test -- auth.test.ts` — duplicate test passes

## Completion

- [ ] All checkpoints validated
- [ ] Task marked complete in auth.aps.md

**Completed by:** (pending)
