# FlowDelivery — MVVM Structure

## Objective

Define how MVVM is applied in FlowDelivery.

## Model

Models represent business data and should be:

- strongly typed
- immutable when possible
- independent from UI widgets
- mapped from DTOs when data comes from Supabase or APIs

## View

Views are Flutter UI components.

Views should:

- render state
- delegate user actions to ViewModels
- avoid business logic
- avoid direct Supabase calls
- avoid persistence logic

## ViewModel

ViewModels coordinate UI state and user actions.

ViewModels should:

- expose screen state
- handle loading and error states
- call repositories
- keep UI workflows predictable
- avoid direct database queries

## Repository

Repositories abstract data access.

Repositories should:

- expose domain-oriented methods
- hide Supabase implementation details
- map DTOs to domain models
- centralize query behavior

## Datasource

Datasources are responsible for low-level integration.

Datasources may depend on:

- Supabase client
- external APIs
- local storage
- platform services

## Recommended Feature Layout

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

## Rule of Thumb

If a class knows about Flutter widgets, it belongs to presentation. If it knows about Supabase tables, it belongs to data.
