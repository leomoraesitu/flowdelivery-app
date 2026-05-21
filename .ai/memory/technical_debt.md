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

### Keep runtime initialization aligned with installed dependencies

Status:
Open

Impact:
Medium

Notes:
- `flutter_riverpod`, `go_router`, and `supabase_flutter` are already present in `pubspec.yaml`.
- Supabase initialization at app startup is still pending Task 9.
- Keep docs/memory synchronized with each validated implementation slice.

## Rules

- Do not fix unrelated debt during feature work without confirmation.
- Convert debt into Trello cards when it affects delivery.
