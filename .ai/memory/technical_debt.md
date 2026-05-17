# Technical Debt

## Active Items

### Align generated documentation with implementation

Status:
Open

Impact:
Medium

Notes:
- Several AI/project workflow files were created before feature implementation.
- Future implementation must keep docs aligned with real code.

### Add planned dependencies intentionally

Status:
Open

Impact:
Medium

Notes:
- `flutter_riverpod`, `go_router` and Supabase packages are planned but not yet present in `pubspec.yaml`.
- Check `pubspec.yaml` before writing code that imports these packages.

## Rules

- Do not fix unrelated debt during feature work without confirmation.
- Convert debt into Trello cards when it affects delivery.
