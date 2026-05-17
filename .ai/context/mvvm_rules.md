# FlowDelivery AI Context — MVVM Rules

## Source of Truth

Primary doc:

- `docs/architecture/MVVM_STRUCTURE.md`

## Model

Models represent business data.

Models should be:

- strongly typed
- immutable when possible
- independent from widgets
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

Datasources own low-level integration.

Datasources may depend on:

- Supabase client
- external APIs
- local storage
- platform services

## Rule of Thumb

If a class knows about Flutter widgets, it belongs to presentation.

If a class knows about Supabase tables, it belongs to data.
