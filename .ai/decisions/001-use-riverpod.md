# ADR 001 — Use Riverpod

## Status

Accepted

## Context

FlowDelivery uses Flutter with MVVM and feature-first organization.

The project needs predictable state management that supports:

- typed state
- dependency injection
- testable ViewModels
- clear separation between UI and business orchestration
- scalable feature development

The current `pubspec.yaml` does not yet include Riverpod.

## Decision

Use Riverpod as the official state management approach for FlowDelivery.

The intended package is:

- `flutter_riverpod`

Riverpod providers should support MVVM rather than replace architectural boundaries.

## Consequences

Positive:

- state and dependency wiring become explicit
- ViewModels can be provided and tested independently
- widgets can observe state without owning business logic
- feature dependencies can be composed cleanly

Tradeoffs:

- Riverpod must be introduced intentionally when implementation starts
- provider structure must stay disciplined to avoid global shortcuts
- agents must check `pubspec.yaml` before writing Riverpod code

## Implementation Notes

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

Rules:

- widgets watch providers and render state
- ViewModels coordinate UI state and user actions
- repositories own domain-oriented data access
- datasources own low-level external clients
- providers must not expose raw Supabase responses to UI
