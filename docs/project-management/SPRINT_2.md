# Sprint 2 - Home Restaurant Feed Foundation

## Objective

Deliver the first authenticated Home slice as a prototype-aligned static restaurant feed with typed local fixtures, Riverpod wiring, centralized routing, localization, semantic theme usage, and focused validation.

Reference plan:

- `.ai/plans/2026-06-01-home-static-feed-plan.md`

Reference prototype:

- `docs/ux/prototypes/home-feed.png`

## Status

Completed and validated.

Sprint 2 is closed and its implementation state is reflected in repository documentation, memory artifacts, and the real Trello story.

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

- [x] Define typed local Home models.
- [x] Add local fixtures and read-only Riverpod provider.
- [x] Register protected `/home` route.
- [x] Add localized Home copy through ARB catalogs.
- [x] Build prototype-aligned Home page composition.
- [x] Add focused Home widget coverage.
- [x] Reconcile docs, memory, and Trello after validation.

## Acceptance Criteria

- [x] Home is reachable through a protected `/home` route.
- [x] Authenticated users can land on Home without weakening recovery routes.
- [x] Home renders local typed restaurant feed fixtures.
- [x] No premature Supabase repository or datasource is introduced.
- [x] Search, filters, and deferred tabs remain non-functional in this slice.
- [x] UI copy uses ARB catalogs and `AppLocalizations`.
- [x] UI styling uses semantic theme APIs and app tokens.
- [x] Focused tests and guards pass.
- [x] Trello checklist state reflects implementation evidence only.

## Dependencies

- [x] Approved plan: `.ai/plans/2026-06-01-home-static-feed-plan.md`.
- [x] Active branch: `feat/home`.
- [x] Existing auth foundation and protected-route policy.
- [x] Existing Riverpod, GoRouter, localization, and theme guardrails.
- [x] Implementation approval for Task 1.

## Localization Guard Checklist

- [x] Every new user-facing string has an ARB key.
- [x] UI reads strings through `AppLocalizations`.
- [x] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`.
- [x] ARB catalog parity guard remains green after copy changes.
- [x] New placeholders are declared in template metadata and preserved across translated catalogs.
- [x] New placeholders and route placeholders are covered by the guard tests.
- [x] Generated localization freshness guard remains green after ARB changes.

## Theme Guard Checklist

- [x] UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`).
- [x] No `Color(0x...)` hardcoded values exist in feature presentation code.
- [x] No direct `AppLightColors` or `AppDarkColors` usage exists outside `lib/app/theme`.
- [x] No direct `Colors.*` usage exists in feature presentation when semantic `ColorScheme` roles apply.
- [x] Visual hardcoded guard test remains green after UI changes.

## Validation Evidence

- `flutter analyze lib\\features\\home\\data\\fixtures\\home_feed_fixtures.dart lib\\features\\home\\presentation\\pages\\home_page.dart lib\\features\\home\\presentation\\widgets\\home_feed_header.dart lib\\features\\home\\presentation\\widgets\\home_feed_sections.dart lib\\app\\routes\\app_router.dart test\\features\\home\\presentation\\home_feed_providers_test.dart test\\app\\routes\\app_router_test.dart`
- `flutter test test\\features\\home\\presentation\\home_feed_providers_test.dart test\\app\\routes\\app_router_test.dart test\\app\\l10n\\no_hardcoded_ui_strings_test.dart test\\app\\theme\\no_hardcoded_visual_values_test.dart`
- `flutter test test\\features\\home\\presentation\\home_page_test.dart test\\features\\home\\presentation\\home_feed_providers_test.dart test\\app\\routes\\app_router_test.dart test\\app\\l10n\\no_hardcoded_ui_strings_test.dart test\\app\\theme\\no_hardcoded_visual_values_test.dart`
- `flutter analyze test\\features\\home\\presentation\\home_page_test.dart`
- `flutter test test\\app\\project_management\\trello_guard_checklists_test.dart`

## Closure Notes

- The validated Home slice remains presentation-first and intentionally uses typed local fixtures through Riverpod.
- Supabase restaurant schema, datasource, repository, DTO, remote loading, functional search, functional filters, and destination navigation remain explicitly deferred.
- Real Trello story parity is verified against validated implementation only: `https://trello.com/c/X3jAdpd2`.

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
