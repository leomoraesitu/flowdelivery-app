# Home Remote Feed Foundation Plan

## Objective

Replace the static Home feed source with a read-only Supabase-backed feed while preserving the approved `/home` route contract, the existing visual composition, Riverpod ownership, localization guardrails, and semantic theme usage.

Reference prototype:

- `docs/ux/prototypes/home-feed.png`

Reference documentation:

- `https://supabase.com/changelog/45329-breaking-change-tables-not-exposed-to-data-and-graphql-api-automatically`
- `https://supabase.com/docs/guides/api/securing-your-api`
- `https://supabase.com/docs/guides/database/postgres/row-level-security`

## Approved Scope

This slice introduces the minimum remote read model required to populate the existing Home feed from Supabase without expanding into search, filtering, navigation destinations, or restaurant detail flows.

Include:

- promote the Home feed aggregate to a reusable domain contract;
- create the minimal Supabase schema for Home categories, featured restaurants, and promotions;
- add explicit Data API grants and RLS policies for new exposed tables;
- seed non-sensitive development data for the Home feed;
- add Home remote DTOs and a Supabase datasource;
- add a Home repository and async Riverpod provider wiring;
- preserve the current Home page structure while loading remote data;
- add localized loading, empty, and error states if the async provider surfaces them;
- keep the delivery address placeholder local until a separate profile/address slice is approved;
- validate datasource, repository, provider, routing, localization, theme, and Home widget coverage.

Defer:

- profile/address persistence;
- functional search and category filtering;
- restaurant details navigation;
- browse, orders, account, cart, and checkout flows;
- admin CRUD for restaurants, categories, and promotions;
- remote image hosting or Storage-backed media;
- Realtime updates and pagination;
- anonymous client access to the Home feed.

## Architecture Decision

Use the existing typed Home domain entities as the stable UI contract and introduce the missing remote boundary only now that a real backend slice exists. Keep Supabase access inside a datasource, map DTOs into domain models before presentation, and keep provider ownership in Riverpod.

The flow for this slice becomes:

```text
HomePage
↓
Riverpod async provider
↓
HomeRepository
↓
HomeRemoteDatasource
↓
Supabase
```

The Home page continues to own composition only. Widgets must not import Supabase SDK types, table row maps, or datasource classes directly.

Because of the 2026-04-28 Supabase Data API change, new tables must not rely on implicit exposure. The migration for this slice must explicitly:

- grant only the minimum required privileges to `authenticated` and `service_role`;
- keep `anon` ungranted for Home feed tables;
- enable RLS on every new table in `public`;
- add explicit read policies for authenticated access.

## Remote Data Contract

Preserve the UI contract from Sprint 2 but replace the fixture-backed collections with remote data.

- Category records must expose stable slugs/keys, not localized labels. The UI keeps ARB + `AppLocalizations` as the source of truth for category labels.
- Promotion records should carry structured values (for example `discount_percentage`, `is_free_delivery_enabled`, `image_asset_path`, `sort_order`) rather than localized banner text.
- Restaurant records should expose the exact fields needed by the current cards (`name`, `image_asset_path`, `rating`, `delivery_fee`, `delivery_time_min`, `delivery_time_max`, `is_featured`, `sort_order`).
- Restaurant/category association should be modeled explicitly, not embedded as a comma-separated field.
- Delivery address remains local placeholder data in this slice and does not drive schema design.

## Dependencies

- Existing: `supabase_flutter`
- Existing: `flutter_riverpod`
- Existing: `go_router`
- Existing: Home domain entities and Home presentation widgets from Sprint 2
- Existing: `supabaseClientProvider` in `lib/app/bootstrap/supabase_providers.dart`
- Existing: Flutter gen-l10n ARB pipeline
- Existing: Theme Guard and Localization Guard tests
- New packages: none

## Implementation Tasks

### Task 1: Promote the Home Feed Aggregate and Repository Contract

Concept:

Sprint 2 kept the feed aggregate inside the fixture layer because there was no backend boundary yet. Before adding a remote datasource, move the aggregate contract into the domain layer and define a repository interface that presentation can depend on safely.

Files:

- Create `lib/features/home/domain/entities/home_feed_content.dart`
- Create `lib/features/home/domain/repositories/home_repository.dart`
- Modify `lib/features/home/data/fixtures/home_feed_fixtures.dart`
- Modify `lib/features/home/presentation/providers/home_feed_providers.dart`
- Modify `test/features/home/presentation/home_feed_providers_test.dart`

Checklist:

- [ ] Move `HomeFeedContent` ownership out of fixture infrastructure and into the domain layer.
- [ ] Define a `HomeRepository` interface returning typed Home feed content.
- [ ] Keep domain contracts free of Supabase row maps and Flutter types.
- [ ] Preserve the validated static slice behavior while the remote implementation is still pending.

Validation:

- Run focused analyze on updated Home domain/provider files.
- Re-run `test/features/home/presentation/home_feed_providers_test.dart`.

Skills:

- `flutter-apply-architecture-best-practices`

Commit:

```text
refactor(home): promote remote feed domain contract
```

### Task 2: Add the Supabase Home Feed Schema, Grants, RLS, and Seed Data

Concept:

Create the minimum database contract required to read the existing Home feed remotely. Keep it read-only for client usage and pair exposure controls with RLS in the same migration.

Files:

- Create `supabase/migrations/<timestamp>_home_remote_feed_foundation.sql`
- Modify `supabase/README.md` if local usage notes need the new objects

Checklist:

- [ ] Add `public.restaurant_categories`.
- [ ] Add `public.restaurants`.
- [ ] Add `public.restaurant_category_links`.
- [ ] Add `public.home_promotions`.
- [ ] Add explicit `GRANT SELECT` for `authenticated` and `service_role` only.
- [ ] Enable RLS on every new table.
- [ ] Add authenticated read policies with `TO authenticated`.
- [ ] Seed minimal development data aligned with the current Home UI contract.
- [ ] Keep image references as bundled asset-path strings for now; do not introduce Storage yet.

Validation:

- Run Supabase security/performance advisors after schema design is ready.
- Verify the new tables and policies with a focused SQL read.

Skills:

- `supabase`
- `supabase-postgres-best-practices`

Commit:

```text
feat(home): add remote feed supabase schema
```

### Task 3: Add Home Remote DTOs and Supabase Datasource

Concept:

The datasource owns low-level Supabase queries and DTO mapping from raw rows. Keep it read-only and narrowly scoped to the Home feed.

Files:

- Create `lib/features/home/data/dtos/home_category_dto.dart`
- Create `lib/features/home/data/dtos/home_promotion_dto.dart`
- Create `lib/features/home/data/dtos/home_restaurant_dto.dart`
- Create `lib/features/home/data/datasources/home_remote_datasource.dart`
- Create `test/features/home/data/home_remote_datasource_test.dart`

Checklist:

- [ ] Map Supabase row payloads into typed DTOs before domain conversion.
- [ ] Query only the tables/columns required by the current Home feed.
- [ ] Keep query orchestration inside the datasource, not inside providers or widgets.
- [ ] Surface datasource failures explicitly with a Home-specific remote exception.

Validation:

- Run focused datasource tests.
- Run focused analyze on DTO/datasource files.

Skills:

- `supabase`
- `dart-add-unit-test`

Commit:

```text
feat(home): add remote feed datasource
```

### Task 4: Implement the Home Repository and Async Riverpod Wiring

Concept:

Swap the presentation entry point from static fixtures to a repository-backed async provider while preserving the existing route and page ownership.

Files:

- Create `lib/features/home/data/repositories/home_repository_impl.dart`
- Modify `lib/features/home/presentation/providers/home_feed_providers.dart`
- Modify `lib/app/di/app_providers.dart` if Home dependency wiring belongs there
- Create `test/features/home/data/home_repository_impl_test.dart`
- Create `test/features/home/presentation/home_feed_async_providers_test.dart`

Checklist:

- [ ] Implement `HomeRepository` with datasource + DTO-to-domain mapping.
- [ ] Reuse `supabaseClientProvider` as the Supabase composition root.
- [ ] Replace the fixture-only provider entry point with an async Riverpod provider.
- [ ] Keep direct Supabase client access out of presentation widgets and ViewModels.
- [ ] Preserve the local delivery-address placeholder until a dedicated profile/address slice exists.

Validation:

- Run focused repository/provider tests.
- Re-run router and existing Home provider/widget suites impacted by the async flow.

Skills:

- `flutter-apply-architecture-best-practices`
- `dart-add-unit-test`

Commit:

```text
feat(home): wire remote feed repository and provider
```

### Task 5: Add Localized Async Home States

Concept:

An async provider introduces loading, empty, and error paths. Add the minimum stateful UI needed to keep the Home experience usable without broadening into new product behavior.

Files:

- Modify `lib/features/home/presentation/pages/home_page.dart`
- Modify `lib/features/home/presentation/widgets/home_feed_header.dart`
- Modify `lib/features/home/presentation/widgets/home_feed_sections.dart`
- Modify `lib/l10n/app_pt_BR.arb`
- Modify `lib/l10n/app_pt.arb`
- Modify `lib/l10n/app_en.arb`
- Update generated localization files after gen-l10n

Checklist:

- [ ] Render a semantic loading state for the remote feed.
- [ ] Render a localized retryable error state.
- [ ] Render a localized empty state if no featured feed content is available.
- [ ] Keep existing Home layout and semantics intact for the successful data state.
- [ ] Continue using semantic theme roles and app tokens only.

Localization Guard:

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`.
- [ ] ARB catalog parity guard remains green after copy changes.
- [ ] New placeholders are declared in template metadata and preserved across translated catalogs.
- [ ] New placeholders and route placeholders are covered by the guard tests.
- [ ] Generated localization freshness guard remains green after ARB changes.

Theme Guard:

- [ ] UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`).
- [ ] No `Color(0x...)` hardcoded values in feature presentation code.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage outside `lib/app/theme`.
- [ ] No direct `Colors.*` hardcoded usage in feature presentation when equivalent semantic `ColorScheme` roles exist.
- [ ] Visual hardcoded guard test remains green after UI changes.

Validation:

- Run `flutter test` for localization and theme guard suites.
- Re-run focused Home page/widget tests.

Skills:

- `flutter-build-responsive-layout`
- `flutter-add-widget-test`
- `flutter-setup-localization`

Commit:

```text
feat(home): add remote feed async states
```

### Task 6: Add Focused Remote Feed Coverage

Concept:

The remote slice needs regression coverage on the data path and the UI states introduced by async loading. Keep tests contract-oriented and avoid live network dependencies.

Files:

- Modify `test/features/home/presentation/home_page_test.dart`
- Create any focused Home test files required by Tasks 3-5

Checklist:

- [ ] Verify repository/provider success flow renders the remote Home feed.
- [ ] Verify loading state renders without hardcoded copy.
- [ ] Verify empty state renders when the repository returns no featured content.
- [ ] Verify retry/error behavior stays localized and deterministic.
- [ ] Keep datasource/repository/provider tests independent from widget layout assertions.

Validation:

- Run focused Home datasource/repository/provider/widget suites.
- Re-run router, localization guard, theme guard, and Trello guard suites as applicable.

Skills:

- `dart-add-unit-test`
- `flutter-add-widget-test`

Commit:

```text
test(home): cover remote feed states
```

### Task 7: Reconcile Documentation, Memory, and Trello After Validation

Concept:

Only after the remote slice is validated should project records and the real Trello story be advanced. Documentation must reflect the actual implementation, not the intended design.

Files:

- Modify `docs/project-management/SPRINT_3.md`
- Modify `.ai/memory/current_feature.md`
- Modify `.ai/memory/current_sprint.md`
- Update the real Trello card after parity verification

Checklist:

- [ ] Record completed tasks and validation evidence.
- [ ] Keep deferred profile/address, search, filtering, details, and navigation scope explicit.
- [ ] Confirm Trello checklist state matches validated implementation only.
- [ ] Add a Trello evidence comment after real-card parity verification.

Validation:

- Review documentation against implemented code.
- Run `flutter test test/app/project_management/trello_guard_checklists_test.dart`.

Skills:

- `dart-run-static-analysis`

Commit:

```text
docs(home): record remote feed validation
```

## Acceptance Criteria

- [ ] `/home` keeps its protected authenticated route contract.
- [ ] Home feed categories, featured restaurants, and promotions are loaded from Supabase through repository and datasource boundaries.
- [ ] New Home feed tables are created with explicit grants and RLS enabled.
- [ ] `anon` does not gain access to the Home feed tables.
- [ ] The validated Home composition from Sprint 2 is preserved for successful data rendering.
- [ ] Loading, empty, and error states are localized through ARB + `AppLocalizations`.
- [ ] Presentation styling for new states uses semantic theme APIs and app tokens only.
- [ ] Focused datasource, repository, provider, widget, localization guard, theme guard, and documentation/Trello parity validation pass.

## Risks

- Supabase schema work can expand quickly if category taxonomy, image hosting, or moderation rules are not constrained.
- A remote slice can accidentally absorb profile/address persistence if the delivery header is not explicitly kept local.
- New `public` tables can be exposed incorrectly if grants and RLS are not applied together.
- Async UI states can leak hardcoded copy or visual values if loading/error/empty paths are added ad hoc.
- Remote image strategy can broaden into Storage work if asset-path seeding is not treated as temporary.

## Out of Scope

- User profile/address tables and persistence.
- Search, filters, sorting, pagination, and recommendation logic.
- Restaurant details and deep linking.
- Browse, orders, account, cart, and checkout destination flows.
- Admin tooling, dashboard CRUD, or content moderation workflows.
- Storage buckets, signed URLs, or remote image upload pipelines.
