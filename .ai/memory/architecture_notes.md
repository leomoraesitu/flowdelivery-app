# Architecture Notes

## Current Direction

FlowDelivery follows:

- MVVM
- Clean Architecture
- feature-first organization
- Riverpod for state management
- Supabase isolated behind datasources and repositories
- GoRouter as planned routing solution

## Active Constraints

- Do not create logic directly in UI.
- Do not call Supabase directly from widgets.
- Check `pubspec.yaml` before using planned packages.
- Keep feature implementation incremental.
- Keep architecture decisions documented in `.ai/decisions/`.

## Notes

- `.ai/context/` is the fast-loading project context.
- `.ai/agents/` contains role-specific operating instructions.
- `.codex/workflows/` contains repeatable execution workflows.
