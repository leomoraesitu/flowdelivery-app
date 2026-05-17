# Create Riverpod Prompt

## Objective

Create Riverpod providers for FlowDelivery while preserving MVVM boundaries.

## Required Context

Read before acting:

- `.ai/context/state_management_riverpod.md`
- `.ai/context/mvvm_rules.md`
- `.ai/context/flutter_rules.md`
- `.ai/context/coding_standards.md`

## Instructions

1. Check `pubspec.yaml` before using Riverpod APIs.
2. If `flutter_riverpod` is missing, propose adding it before writing Riverpod code.
3. Keep providers focused on dependency wiring and state exposure.
4. Keep complex orchestration in ViewModels.
5. Keep repositories responsible for data access contracts.
6. Keep datasources responsible for Supabase or external clients.
7. Avoid global mutable shortcuts.

## Provider Guidelines

Providers may expose:

- repository instances
- datasource instances
- ViewModels
- feature state
- app-level configuration dependencies

Providers should not expose:

- raw Supabase responses
- mutable global state
- UI-specific implementation details

## Expected Deliverables

- provider definitions
- ViewModel integration when needed
- updated widget consumption when applicable
- focused tests when practical

## Validation Checklist

- [ ] Riverpod dependency exists or dependency change is proposed
- [ ] Providers do not contain business-heavy logic
- [ ] Widgets watch providers and render state
- [ ] State remains typed and explicit
