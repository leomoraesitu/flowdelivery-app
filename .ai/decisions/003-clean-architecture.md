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

> Amendment 2026-06-02: This section originally sketched an illustrative tree
> (`data/dto/`, `data/mappers/`, `domain/models/`, `domain/services/`,
> `presentation/states/`, feature-root `viewmodels/`). The shipped features
> (`auth`, `home`, `restaurant_details`) converged on a slightly different,
> consistent convention. Because repository code is the source of truth, the
> structure below is reconciled to the practiced convention. The decision and
> dependency rules are unchanged.

Canonical feature structure (required folders, present in every feature):

```text
lib/features/<feature>/
├── data/
│   ├── datasources/      # low-level Supabase/API integration
│   ├── dtos/             # typed row/payload parsing
│   └── repositories/     # repository implementations + DTO→domain mapping
├── domain/
│   ├── entities/         # immutable, Flutter-free, Supabase-free models
│   └── repositories/     # domain-oriented repository contracts
└── presentation/
    ├── pages/            # screens
    ├── providers/        # Riverpod wiring and derived state
    └── widgets/          # focused UI components
```

Optional folders, added only when a feature needs them:

- `data/fixtures/` — local deterministic fixtures (used by `home`).
- `domain/failures/` — typed domain failures (used by `auth`).
- `presentation/viewmodels/` + `presentation/state/` — a dedicated ViewModel and
  its typed state, when the feature has mutable orchestration (used by `auth`).
- `presentation/localization/` — feature-scoped localization helpers (used by `auth`).

Notes on practiced conventions:

- DTO mapping lives in the repository implementation; a separate `data/mappers/`
  folder is not used.
- Read-only or single-load features (e.g. `restaurant_details`) use
  `presentation/providers/` (Riverpod `FutureProvider.family`) without a
  dedicated ViewModel class, per the ADR rule against layers that do not remove
  real complexity. Introduce `viewmodels/`/`state/` only when mutable UI
  orchestration justifies it.

Rule of thumb:

- Flutter widgets belong to presentation
- Supabase table knowledge belongs to data
- reusable business concepts belong to domain
