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

### Add planned dependencies intentionally

Status:
Open

Impact:
Medium

Notes:
- `flutter_riverpod`, `go_router` and Supabase packages are planned but not yet present in `pubspec.yaml`.
- Check `pubspec.yaml` before writing code that imports these packages.
- `go_router` conventions are documented, but the dependency remains intentionally absent until an approved implementation step.

## Rules

- Do not fix unrelated debt during feature work without confirmation.
- Convert debt into Trello cards when it affects delivery.
