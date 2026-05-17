# ADR 004 — Use GoRouter

## Status

Accepted

## Context

FlowDelivery needs app routing that can support:

- authentication guards
- nested navigation
- deep links
- web-compatible routes
- feature-first route organization
- future customer, restaurant, driver and admin flows

`docs/PROJECT_BOOTSTRAP.md` already identifies `go_router` as the planned routing package.

The current `pubspec.yaml` does not yet include `go_router`.

## Decision

Use GoRouter as the planned routing solution for FlowDelivery.

The intended package is:

- `go_router`

Routing should live under `lib/app/routes` or an equivalent app-level routing module.

## Consequences

Positive:

- route definitions remain centralized and explicit
- auth redirects can be handled consistently
- nested navigation can scale with product modules
- web route support is easier to maintain

Tradeoffs:

- route configuration must stay organized as features grow
- auth and loading states must be handled carefully
- the dependency must be added intentionally before implementation

## Implementation Notes

Routing rules:

- do not define routes inside feature widgets
- keep route names and paths centralized
- route guards should depend on auth state, not raw Supabase calls
- feature pages should not own global navigation policy
- update documentation when route structure changes
