# FlowDelivery AI Context — Coding Standards

## Source of Truth

Primary docs:

- `docs/ai/CODEX_GOVERNANCE.md`
- `docs/project-management/DEFINITION_OF_DONE.md`
- `docs/project-management/BRANCHING_STRATEGY.md`

## General Rules

- Keep changes small and reversible.
- Inspect relevant files before editing.
- Propose a short plan before changing files.
- Validate the smallest executable scope.
- Do not overwrite unrelated user changes.
- Do not delete files without explicit confirmation.
- Do not commit without approval.

## Flutter Rules

- Keep widgets focused on rendering.
- Keep business logic out of widgets.
- Keep Supabase calls out of UI.
- Prefer typed models and explicit state.
- Prefer feature-first organization.
- Update docs when behavior or architecture changes.

## Naming Rules

- Use clear domain names.
- Avoid vague helper names.
- Keep file names aligned with class or responsibility.
- Prefer explicit method names over clever abbreviations.

## Validation Rules

Run the smallest relevant validation.

Common commands:

```bash
flutter analyze
flutter test
```

If validation cannot run, document why.

## Documentation Rule

When implementation changes architecture, process or public behavior, update the relevant documentation in the same task.
