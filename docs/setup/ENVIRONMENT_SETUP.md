# FlowDelivery — Environment Setup

## Objective

Define the baseline setup required to run and develop FlowDelivery.

## Required Tools

- Flutter SDK
- Dart SDK
- Android Studio
- VS Code or compatible editor
- Git
- Supabase account

## Recommended Commands

Install dependencies:

```bash
flutter pub get
```

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Run app:

```bash
flutter run
```

## Environment Variables

Expected variables:

```text
APP_ENV
SUPABASE_URL
SUPABASE_ANON_KEY
API_BASE_URL
```

## Secret Rules

- Do not commit real secrets.
- Do not commit production credentials.
- Keep local environment files out of version control.
- Use CI secrets for pipelines.

## Environments

Initial target environments:

- development
- production

Staging can be added when release flow requires it.
