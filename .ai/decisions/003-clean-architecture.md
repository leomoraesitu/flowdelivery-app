# ADR 003 — Clean Architecture

## Status

Accepted

## Context

FlowDelivery is intended to demonstrate scalable Flutter engineering.

The existing architecture contract already defines:

- MVVM
- feature-first organization
- Repository Pattern
- Supabase isolated from presentation
- typed models
- explicit boundaries

The project needs a clear dependency direction so features remain testable and maintainable as the app grows.

## Decision

Use Clean Architecture principles inside the existing MVVM + feature-first structure.

This means:

- presentation depends on ViewModels and UI state
- ViewModels coordinate user actions and screen state
- domain models and contracts stay independent from Flutter and Supabase
- repositories abstract data access
- datasources own low-level integrations

## Consequences

Positive:

- features remain easier to test
- Supabase details stay isolated
- UI code remains focused on rendering
- future backend changes are easier to contain

Tradeoffs:

- more files may be needed for non-trivial features
- simple features should avoid unnecessary abstractions
- agents must not add layers that do not remove real complexity

## Implementation Notes

Recommended feature structure:

```text
lib/features/<feature>/
├── data/
│   ├── datasources/
│   ├── dto/
│   ├── mappers/
│   └── repositories/
├── domain/
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── pages/
│   ├── states/
│   └── widgets/
└── viewmodels/
```

Rule of thumb:

- Flutter widgets belong to presentation
- Supabase table knowledge belongs to data
- reusable business concepts belong to domain
