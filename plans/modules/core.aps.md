# Core APS Library (@aps/core)

| Field | Value |
|-------|-------|
| Status | Draft |
| Owner | @EddaCraft |
| Created | 2026-01-01 |
| Module ID | CORE |

## Purpose

Provide core APS functionality (validation, parsing, scaffolding, querying) as a tool-agnostic npm library that all plugins/adapters can depend on.

## In Scope

- Markdown parsing of APS documents (Index, Module, Task, Steps)
- Template rendering with variable substitution
- Structural validation against APS schema
- File system scaffolding (create plans/ directory structure)
- Querying (find Ready tasks, resolve dependencies, etc.)
- Template management (embed, list, render)

## Out of Scope

- Tool-specific integrations (those live in adapter packages)
- AI agent orchestration
- Code execution
- Git operations
- Web UI or visual editor

## Interfaces

### Public API

```typescript
export class APSCore {
  // Validation
  validate(filePath: string): Promise<ValidationResult>
  validateDirectory(path: string): Promise<ValidationResult[]>

  // Scaffolding
  scaffold(targetDir: string, options?: ScaffoldOptions): Promise<void>
  createIndex(path: string, metadata: IndexMetadata): Promise<void>
  createModule(path: string, metadata: ModuleMetadata): Promise<void>
  createTask(modulePath: string, task: TaskDefinition): Promise<void>

  // Parsing
  parseIndex(path: string): Promise<APSIndex>
  parseModule(path: string): Promise<APSModule>

  // Querying
  findReadyTasks(plansDir: string): Promise<Task[]>
  getTaskById(taskId: string, plansDir: string): Promise<Task | null>
  resolveDependencies(taskId: string, plansDir: string): Promise<Task[]>

  // Templates
  renderTemplate(type: TemplateType, data: any): Promise<string>
  getTemplateList(): TemplateInfo[]
}
```

### File System Contract

Expects standard APS structure:
```
plans/
├── .aps-rules.md
├── index.aps.md
├── modules/*.aps.md
└── execution/*.steps.md
```

### Dependencies

- **zod** - Schema validation
- **gray-matter** - Frontmatter parsing
- **unified/remark** - Markdown AST parsing
- **ejs** or **handlebars** - Template rendering

## Acceptance Criteria

- [ ] Validates all APS templates without errors
- [ ] Parses examples/user-auth correctly
- [ ] Scaffold creates working plans/ directory
- [ ] findReadyTasks returns tasks with status="Ready"
- [ ] 90%+ test coverage
- [ ] Zero dependencies on AI tools or OpenCode
- [ ] Published to npm as `@aps/core`

## Tasks

*Tasks will be added when module status changes to Ready*

## Execution Notes

This is a foundational module. All other modules depend on it.
Prioritize stability and clean API over features.

## Risks

| Risk | Mitigation |
|------|------------|
| Markdown parsing edge cases | Comprehensive test suite with real examples |
| Template rendering complexity | Use battle-tested library (EJS) |
| Breaking changes to API | Semantic versioning, deprecation warnings |

## Decisions

- **CORE-D001:** Use Zod for validation schemas — *approved*
- **CORE-D002:** Use remark for markdown parsing — *pending*
- **CORE-D003:** Embed templates in package vs external files — *pending*
