# Technical Debt

## Active Items

### Align generated documentation with implementation

Status:
Monitoring

Impact:
Low

Notes:
- Several AI/project workflow files were created before feature implementation.
- Sprint 0 governance docs and local Trello artifacts were reconciled after theme, labels and Trello sync tasks.
- Future feature work must keep docs aligned with real code.
- Routing documentation remains reconciled with the deferred implementation decision.

### Keep auth documentation aligned with implementation

Status:
Monitoring

Impact:
Low

Notes:
- `flutter_riverpod`, `go_router`, and `supabase_flutter` are already present in `pubspec.yaml`.
- Supabase initialization at app startup was implemented in Task 9.
- Auth dependency wiring now uses app-level provider overrides and an unconfigured repository fallback when Supabase Dart defines are absent.
- Keep docs/memory synchronized with each validated implementation slice.

## Rules

- Do not fix unrelated debt during feature work without confirmation.
- Convert debt into Trello cards when it affects delivery.
