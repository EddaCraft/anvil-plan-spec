# Contributing to Anvil Plan Spec

Thank you for your interest in contributing to APS! This document provides
guidelines for contributing to the project.

## Pull Request Process

1. **Open an issue first** for significant changes to discuss approach
2. **Create a feature branch** from `main`
3. **Update documentation** if behaviour changes
4. **Keep PRs focused** on one logical change per PR
5. **Ensure linting passes** before requesting review (`npx markdownlint-cli "**/*.md"`)
   - CI will automatically run markdown linting on all PRs
   - Fix any linting errors before requesting review

### Commit Messages

Use clear, descriptive commit messages:

```text
Feat: Add steps template for granular execution

Steps translate task intent into ordered, observable actions.
Each step has a checkpoint for verification.

Closes #12
```

## Scope Guardrails

APS is a specification format for planning and task authorisation.
Contributions should align with this scope.

### In Scope

- Template improvements and new templates
- Prompting guidance for AI assistants
- Examples and worked use cases
- Documentation and getting-started guides
- Tooling for validation or linting APS files

### Out of Scope

These belong to downstream implementations and will not be accepted:

- Runtime execution engines
- IDE plugins or integrations
- Project management tool integrations (Jira, Linear, etc.) **We may revist this in the future**
- AI model fine-tuning or training data

If you're unsure whether something is in scope, open an issue to discuss
before investing time.

### Feature Requests

For net-new functionality, start with a design conversation. Open an issue
describing:

- The problem you're solving
- Your proposed approach (optional)
- Why it belongs in APS

The maintainers will help decide whether it should move forward. Please wait
for approval before opening a feature PR.

## AI-Assisted Contributions

When using AI tools to contribute:

- Follow the guidance in [AGENTS.md](AGENTS.md)
- Ensure AI-generated content is reviewed and validated

## Questions?

Open an issue for questions about contributing or the project.

## License

By contributing, you agree that your contributions will be licensed under
the Apache-2.0 License.
