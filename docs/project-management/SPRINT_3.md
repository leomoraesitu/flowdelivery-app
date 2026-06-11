# Sprint 3 - Home Remote Feed Foundation

## Objective

Deliver the next Home slice by replacing the static feed source with read-only Supabase-backed data while preserving the validated `/home` experience, route ownership, localization discipline, and semantic theme usage.

Reference plan:

- `.ai/plans/2026-06-01-home-remote-feed-plan.md`

Reference prototype:

- `docs/ux/prototypes/home-feed.png`

## Status

Validated / Completed.

Sprint 3 closed with the Home remote-feed foundation validated against focused datasource, repository, provider, widget, localization, theme, router, and Trello-governance checks.

## Sprint Goal

Validate the first remote read path for Home without broadening into profile persistence, search/filter behavior, detail navigation, or new tab destinations.

## Scope

- promote the Home feed aggregate into a reusable domain contract;
- add Supabase schema, explicit grants, RLS, and seed data for the Home feed;
- add Home remote DTOs and datasource;
- add repository and async Riverpod provider wiring;
- keep the delivery-address placeholder local;
- add localized loading, empty, and error states only if required by the async provider;
- preserve the current `/home` composition and route contract;
- validate the remote slice with focused tests and guard suites.

## Backlog

- [x] Promote the Home feed aggregate and repository contract.
- [x] Add the Supabase Home feed schema, grants, RLS, and seed data.
- [x] Add Home remote DTOs and Supabase datasource.
- [x] Implement the Home repository and async Riverpod wiring.
- [x] Add localized async Home states.
- [x] Add focused remote feed coverage.
- [x] Reconcile docs, memory, and Trello after validation.

## Acceptance Criteria

- [x] `/home` keeps its protected authenticated route contract.
- [x] Home feed categories, featured restaurants, and promotions are loaded from Supabase through repository and datasource boundaries.
- [x] New Home feed tables are created with explicit grants and RLS enabled.
- [x] `anon` does not gain access to the Home feed tables.
- [x] The validated Home composition from Sprint 2 is preserved for successful data rendering.
- [x] Loading, empty, and error states are localized through ARB catalogs and `AppLocalizations`.
- [x] Presentation styling for new states uses semantic theme APIs and app tokens only.
- [x] Focused datasource, repository, provider, widget, localization guard, theme guard, and governance validation pass.
- [x] Trello checklist state reflects implementation evidence only.

## Dependencies

- [x] Sprint 2 static Home baseline is completed and validated.
- [x] Existing Supabase bootstrap and `supabaseClientProvider`.
- [x] Existing Riverpod, GoRouter, localization, and theme guardrails.
- [x] Existing Home domain entities and Home presentation widgets.
- [x] Approved plan: `.ai/plans/2026-06-01-home-remote-feed-plan.md`.
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

## Validation Plan

- `flutter test test/features/home/data/home_remote_datasource_test.dart`
- `flutter test test/features/home/data/home_repository_impl_test.dart`
- `flutter test test/features/home/presentation/home_feed_async_providers_test.dart`
- `flutter test test/features/home/presentation/home_page_test.dart`
- `flutter test test/app/routes/app_router_test.dart`
- `flutter test test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart test/app/l10n/generated_localizations_freshness_test.dart`
- `flutter test test/app/theme/no_hardcoded_visual_values_test.dart`
- `flutter test test/app/project_management/trello_guard_checklists_test.dart`
- focused `flutter analyze` on touched Home, Supabase, and localization files

## Validation Evidence

- Task 1: `dart analyze lib/features/home test/features/home` and `flutter test test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart`.
- Task 2: transaction-scoped Supabase SQL smoke test confirmed the Home tables, authenticated read policies, `SELECT`-only grants, and expected seed counts.
- Task 3: `dart analyze lib/features/home/data/dtos lib/features/home/data/datasources test/features/home/data` and `flutter test test/features/home/data/home_remote_datasource_test.dart`.
- Task 4: focused `dart analyze` on repository/provider/app wiring files and `flutter test test/features/home/data/home_repository_impl_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart test/app/routes/app_router_test.dart`.
- Task 5: `flutter gen-l10n`, focused `dart analyze` on Home page/l10n/guard files, and `flutter test test/features/home/presentation/home_page_test.dart test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart test/app/l10n/generated_localizations_freshness_test.dart test/app/theme/no_hardcoded_visual_values_test.dart test/app/routes/app_router_test.dart`.
- Task 6: `dart analyze test/features/home/presentation/home_page_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/data/home_repository_impl_test.dart test/features/home/data/home_remote_datasource_test.dart test/features/home/presentation/home_feed_providers_test.dart` and `flutter test test/features/home/data/home_remote_datasource_test.dart test/features/home/data/home_repository_impl_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart test/app/routes/app_router_test.dart test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/theme/no_hardcoded_visual_values_test.dart`.
- Task 7: `flutter test test/app/project_management/trello_guard_checklists_test.dart`.

No new placeholders or route placeholders were introduced in this slice; the placeholder-related localization guard items remained satisfied without requiring new runtime placeholder coverage.

## Technical Notes

- Keep category display text in ARB and use stable remote slugs to select localization keys.
- Pair explicit Data API grants with RLS in the same migration because new table exposure is no longer safe to assume.
- Keep `anon` ungranted for Home feed tables; `/home` is authenticated-only.
- Keep the delivery-address placeholder local until a dedicated profile/address slice exists.
- Keep image references as bundled asset-path strings for now; remote media hosting remains deferred.

## Risks

- Schema design can balloon if search/filter or profile scope leaks into the slice.
- Remote image handling can expand into Storage prematurely.
- Async states can introduce hardcoded copy or non-semantic visual values if not guarded.
- Misconfigured grants or missing RLS can expose new `public` tables incorrectly.

## Out of Scope

- Profile/address persistence.
- Functional search, filtering, sorting, and pagination.
- Restaurant details navigation.
- Browse, orders, account, cart, and checkout flows.
- Storage-backed media, uploads, or signed URLs.
- Admin CRUD or moderation workflows.

## Suggested Commits

```text
refactor(home): promote remote feed domain contract
feat(home): add remote feed supabase schema
feat(home): add remote feed datasource
feat(home): wire remote feed repository and provider
feat(home): add remote feed async states
test(home): cover remote feed states
docs(home): record remote feed validation
```
