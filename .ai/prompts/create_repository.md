# Create Repository Prompt

## Objective

Create repository contracts and implementations for FlowDelivery data access.

## Required Context

Read before acting:

- `.ai/context/architecture.md`
- `.ai/context/mvvm_rules.md`
- `.ai/context/supabase_patterns.md`
- `.ai/context/coding_standards.md`

## Instructions

1. Define domain-oriented repository methods.
2. Keep repository interfaces in the domain layer when the feature needs abstraction.
3. Keep implementations in the data layer.
4. Keep low-level Supabase queries inside datasources.
5. Map DTOs to domain models before returning to ViewModels.
6. Translate technical failures into domain-safe failures where practical.

## Recommended Shape

```text
lib/features/<feature>/
├── data/
│   ├── datasources/
│   ├── dto/
│   ├── mappers/
│   └── repositories/
└── domain/
    ├── models/
    └── repositories/
```

## Expected Deliverables

- repository interface when useful
- repository implementation
- datasource contract or implementation
- DTO/model mapping when external data exists
- tests or validation command

## Validation Checklist

- [ ] No Supabase dependency leaks into UI
- [ ] Repository methods use domain language
- [ ] DTOs do not reach presentation state
- [ ] Errors are handled intentionally
