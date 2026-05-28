# FlowDelivery AI Context — Stack

## Source of Truth

Primary docs:

- `docs/setup/ENVIRONMENT_SETUP.md`
- `docs/setup/SUPABASE_SETUP.md`
- `pubspec.yaml`

## Current Stack

Current project bootstrap:

- Flutter
- Dart
- Material
- flutter_riverpod
- go_router
- supabase_flutter
- flutter_lints
- flutter_test

Current `pubspec.yaml` already includes Supabase, Riverpod and routing packages.

## State Management

Riverpod is the selected state management approach for FlowDelivery.

Current package:

- `flutter_riverpod`

## Backend Platform

Supabase is the backend foundation in the current stack.

Expected services:

- Auth
- PostgreSQL Database
- Realtime
- Storage
- Edge Functions

## Expected Environment Variables

```text
APP_ENV
SUPABASE_URL
SUPABASE_ANON_KEY
API_BASE_URL
```

## Tooling Commands

Use these commands when applicable:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Dependency Rule

Do not assume a dependency is installed.

Before using a package:

- check `pubspec.yaml`
- add the dependency intentionally
- keep the architecture docs aligned when the package affects structure
