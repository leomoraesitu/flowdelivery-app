# FlowDelivery AI Context — State Management Riverpod

## Source of Truth

Primary doc:

- `docs/PROJECT_BOOTSTRAP.md`

## Current Status

The current `pubspec.yaml` does not yet include Riverpod packages.

Riverpod is the selected state management approach for FlowDelivery.

## Intended Package

When state management implementation starts, evaluate adding:

- `flutter_riverpod`

Do not import or use Riverpod APIs before the package is added to `pubspec.yaml`.

## MVVM Alignment

FlowDelivery uses MVVM with Riverpod providers.

Recommended flow:

```text
Widget
↓
Riverpod Provider
↓
ViewModel / State Notifier
↓
Repository
↓
Datasource
↓
Supabase
```

## Provider Responsibilities

Providers may:

- expose ViewModels
- expose feature state
- provide repositories or datasources through dependency injection
- coordinate lifecycle and dependency wiring

Providers should not:

- contain complex business rules
- perform raw Supabase queries from UI-facing providers
- expose raw DTOs to widgets
- become global mutable state shortcuts

## ViewModel Rules

ViewModels should:

- own UI state orchestration
- call repositories
- expose loading, data, empty and error states
- keep Supabase implementation details hidden
- be testable without widgets

## State Rules

State should be:

- immutable when possible
- strongly typed
- explicit about loading and errors
- safe for UI rendering

Avoid representing complex UI state only with nullable values.

## UI Rules

Widgets should:

- watch providers
- render state
- trigger ViewModel actions
- avoid business logic
- avoid direct repository or Supabase calls

## Testing Rule

When Riverpod is introduced for a feature, add focused tests for ViewModels/providers where practical.
