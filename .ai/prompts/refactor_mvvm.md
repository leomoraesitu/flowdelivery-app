# Refactor MVVM Prompt

## Objective

Refactor FlowDelivery code to respect MVVM, feature-first organization and clean dependency boundaries.

## Required Context

Read before acting:

- `.ai/context/architecture.md`
- `.ai/context/mvvm_rules.md`
- `.ai/context/coding_standards.md`
- `.ai/context/supabase_patterns.md`

## Instructions

1. Inspect current responsibilities before editing.
2. Identify concrete MVVM violations.
3. Propose a small, reversible refactor plan.
4. Move rendering logic to views/widgets.
5. Move UI orchestration to ViewModels.
6. Move data access to repositories and datasources.
7. Keep domain models independent from Flutter widgets and Supabase DTOs.
8. Preserve behavior unless a behavior change is explicitly requested.

## Common Fixes

- move Supabase calls out of widgets
- move business rules out of UI
- introduce DTO mapping
- split oversized widgets
- extract feature-specific state
- clarify repository contracts

## Expected Deliverables

- smaller focused files
- clear MVVM boundaries
- updated imports
- tests or validation command

## Validation Checklist

- [ ] UI renders state only
- [ ] ViewModel coordinates user actions
- [ ] Repository hides data implementation
- [ ] Datasource owns low-level clients
- [ ] Behavior was validated
