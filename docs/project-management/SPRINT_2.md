# Sprint 2 - Home Restaurant Feed Foundation

## Objective

Deliver the first authenticated Home slice as a prototype-aligned static restaurant feed with typed local fixtures, Riverpod wiring, centralized routing, localization, semantic theme usage, and focused validation.

Reference plan:

- `.ai/plans/2026-06-01-home-static-feed-plan.md`

Reference prototype:

- `docs/ux/prototypes/home-feed.png`

## Status

Planned and approved for incremental implementation.

## Sprint Goal

Validate the Home presentation contract and the minimum typed feed shape before introducing Supabase database tables.

## Scope

- protected `/home` route;
- typed Home models;
- typed local fixture data;
- read-only Riverpod fixture provider;
- delivery header and visual search field;
- category chips;
- promotional banner;
- featured restaurant cards;
- bottom navigation shell with Home selected;
- ARB localization;
- Theme Guard and Localization Guard validation;
- focused provider, routing, and widget tests.

## Backlog

- [ ] Define typed local Home models.
- [ ] Add local fixtures and read-only Riverpod provider.
- [ ] Register protected `/home` route.
- [ ] Add localized Home copy through ARB catalogs.
- [ ] Build prototype-aligned Home page composition.
- [ ] Add focused Home widget coverage.
- [ ] Reconcile docs, memory, and Trello after validation.

## Acceptance Criteria

- [ ] Home is reachable through a protected `/home` route.
- [ ] Authenticated users can land on Home without weakening recovery routes.
- [ ] Home renders local typed restaurant feed fixtures.
- [ ] No premature Supabase repository or datasource is introduced.
- [ ] Search, filters, and deferred tabs remain non-functional in this slice.
- [ ] UI copy uses ARB catalogs and `AppLocalizations`.
- [ ] UI styling uses semantic theme APIs and app tokens.
- [ ] Focused tests and guards pass.
- [ ] Trello checklist state reflects implementation evidence only.

## Dependencies

- [x] Approved plan: `.ai/plans/2026-06-01-home-static-feed-plan.md`.
- [x] Active branch: `feat/home`.
- [x] Existing auth foundation and protected-route policy.
- [x] Existing Riverpod, GoRouter, localization, and theme guardrails.
- [ ] Implementation approval for Task 1.

## Localization Guard Checklist

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`.
- [ ] ARB catalog parity guard remains green after copy changes.
- [ ] New placeholders are declared in template metadata and preserved across translated catalogs.
- [ ] New placeholders and route placeholders are covered by the guard tests.
- [ ] Generated localization freshness guard remains green after ARB changes.

## Theme Guard Checklist

- [ ] UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`).
- [ ] No `Color(0x...)` hardcoded values exist in feature presentation code.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage exists outside `lib/app/theme`.
- [ ] No direct `Colors.*` usage exists in feature presentation when semantic `ColorScheme` roles apply.
- [ ] Visual hardcoded guard test remains green after UI changes.

## Risks

- Supabase `public` schema currently has no restaurant tables; remote integration must remain deferred.
- Premature repository abstractions would add ceremony without a real backend contract.
- The full authenticated shell route tree can broaden scope if introduced before its destination slices exist.
- Prototype image handling needs an explicit implementation decision.

## Out of Scope

- Supabase schema, RLS, datasource, repository, DTO, and remote loading.
- Functional search and category filtering.
- Restaurant details navigation.
- Browse, orders, account, cart, and checkout flows.
- Full authenticated `StatefulShellRoute`.

## Suggested Commits

```text
feat(home): add typed restaurant feed models
feat(home): provide static restaurant feed fixtures
feat(home): register protected home route
feat(home): add localized restaurant feed copy
feat(home): create static restaurant feed page
test(home): cover static restaurant feed page
docs(home): record static restaurant feed validation
```

