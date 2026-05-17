# Create Feature Prompt

## Objective

Create or extend a FlowDelivery feature using MVVM, feature-first organization and Riverpod-compatible state management.

## Required Context

Read before acting:

- `.ai/context/architecture.md`
- `.ai/context/mvvm_rules.md`
- `.ai/context/flutter_rules.md`
- `.ai/context/state_management_riverpod.md`
- `.ai/context/coding_standards.md`

## Instructions

1. Inspect the existing feature structure before editing.
2. Propose a short implementation plan.
3. Keep the feature inside `lib/features/<feature>/`.
4. Separate responsibilities across `data`, `domain`, `presentation` and `viewmodels`.
5. Keep widgets focused on rendering and user interaction.
6. Keep data access behind repositories and datasources.
7. Use Riverpod providers only after confirming the dependency exists in `pubspec.yaml`.
8. Update documentation when architecture or behavior changes.

## Expected Deliverables

- feature files added or updated
- explicit state model when needed
- ViewModel or equivalent orchestration layer
- repository/datasource boundaries when data access exists
- focused tests when practical

## Validation Checklist

- [ ] No Supabase calls in widgets
- [ ] No business logic in UI
- [ ] Feature remains isolated
- [ ] State is explicit and typed
- [ ] Smallest relevant validation command was run
