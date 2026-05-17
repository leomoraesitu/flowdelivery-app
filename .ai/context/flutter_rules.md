# FlowDelivery AI Context — Flutter Rules

## Project Style

FlowDelivery is a Flutter app using a feature-first MVVM architecture.

Flutter implementation should remain aligned with:

- Material 3
- design tokens
- responsive layouts
- accessible UI states
- clear separation between rendering and logic

## Widget Rules

Widgets should:

- render input state
- call callbacks or ViewModel methods for actions
- avoid direct repository calls
- avoid direct Supabase calls
- avoid hidden side effects in build methods

## State Rules

Represent UI state explicitly.

Common state fields:

- loading
- data
- empty
- error
- action in progress

Avoid representing complex state only with nullable values.

## Theme Rules

- Use app theme and design tokens.
- Avoid hardcoded spacing when tokens exist.
- Avoid hardcoded semantic colors.
- Support light and dark theme evolution.

## File Organization

Prefer this feature shape:

```text
lib/features/<feature>/
├── data/
├── domain/
├── presentation/
└── viewmodels/
```

## Validation

For Flutter changes, prefer:

```bash
flutter analyze
flutter test
```

Run narrower validation when the project provides a smaller reliable command.
