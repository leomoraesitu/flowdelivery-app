# Restaurant Details Remote Catalog Plan

## Objective

Deliver the first product-browsing slice by opening a protected restaurant-details route from the validated Home feed and rendering a read-only Supabase-backed catalog, without adding product customization or cart state.

Reference prototypes:

- `docs/ux/prototypes/restaurant-details.png`
- `docs/ux/prototypes/product-details.png` for deferred product-detail context only

## Approved Scope

Include:

- navigate from a Home restaurant card to `/restaurants/:restaurantId`;
- add a dedicated `restaurant_details` feature with domain, data, repository, Riverpod, and presentation boundaries;
- reuse the existing `restaurants` table and stable restaurant IDs;
- add remote menu-category and menu-item tables with explicit grants, authenticated read RLS, and deterministic seed data;
- load restaurant details and catalog on demand by restaurant ID;
- render localized loading, error, empty, and success states;
- filter the loaded menu locally by selected menu category;
- keep presentation on semantic theme APIs and app tokens;
- validate schema, datasource, repository, provider, router, widget, localization, theme, and Trello-governance contracts.

Defer:

- product-details navigation;
- product customization, quantities, special instructions, add-ons, and variants;
- favorites, sharing, cart, checkout, orders, profile, and persisted delivery address;
- server-side ranking, pagination, Storage-backed media, and Realtime.

## Architecture Decision

Create a dedicated `restaurant_details` feature rather than expanding the Home aggregate. Home remains responsible for discovery and navigation only. The details feature loads its own screen aggregate on demand:

```text
Home restaurant card
↓
/restaurants/:restaurantId
↓
RestaurantDetailsPage
↓
Riverpod family provider
↓
RestaurantDetailsRepository
↓
RestaurantDetailsRemoteDatasource
↓
Supabase
```

This avoids loading full menus in the Home feed and keeps Supabase queries out of widgets and providers.

## Dependencies

- Existing: `flutter_riverpod`
- Existing: `go_router`
- Existing: `supabase_flutter`
- Existing: ARB + `AppLocalizations`
- Existing: Theme Guard, Localization Guard, and Trello Guard suites
- New packages: none

## Current Progress

- [x] Architecture approved.
- [x] Slice boundary approved: restaurant details plus remote catalog only.
- [x] Task 1 completed — immutable restaurant-details domain contracts and focused tests.
- [x] Task 2 completed — read-only remote catalog schema, grants, RLS, policies, and deterministic seeds.
- [x] Task 3 completed — typed DTOs and remote datasource with focused tests.
- [x] Task 4 completed — domain repository contract and DTO-to-domain mapping with focused tests.
- [x] Task 5 completed — Riverpod family loading, local category-selection state, and app composition with focused tests.
- [x] Task 6 completed — localized restaurant-details copy and generated `AppLocalizations` accessors with guard validation.

## Implementation Tasks

### Task 1: Define Restaurant Details Domain Contracts

Concept:

Model the screen aggregate before introducing Supabase concerns. Immutable domain entities keep presentation independent from database rows.

Files:

- Create `lib/features/restaurant_details/domain/entities/restaurant_details.dart`
- Create `lib/features/restaurant_details/domain/entities/restaurant_menu_category.dart`
- Create `lib/features/restaurant_details/domain/entities/restaurant_menu_item.dart`

Responsibilities:

- Represent restaurant header metadata, menu categories, and read-only menu items.
- Keep entities Flutter-free and Supabase-free.

Validation:

- Run focused domain tests.
- Run focused analyze on the new domain files.

Applicable skills:

- `dart-add-unit-test`
- `dart-run-static-analysis`

Validated evidence:

- TDD RED confirmed before implementation: the focused domain test failed because the three restaurant-details entity files did not exist yet.
- Added `RestaurantDetails`, `RestaurantMenuCategory`, and `RestaurantMenuItem` as Flutter-free and Supabase-free value models.
- `RestaurantDetails` defensively exposes immutable category and item collections.
- Dart MCP `run_tests` for `test/features/restaurant_details/domain/restaurant_details_domain_test.dart`: 3 tests passed.
- Dart MCP `analyze_files` on the three entities and focused domain test: no errors.
- `git diff --check`: no errors.

### Task 2: Add Remote Catalog Schema

Concept:

Extend the validated read-only restaurant foundation with normalized catalog tables. Pair grants and RLS explicitly so exposure is intentional.

Files:

- Create `supabase/migrations/20260602120000_restaurant_details_remote_catalog.sql`

Responsibilities:

- Add `restaurant_menu_categories`.
- Add `restaurant_menu_items`.
- Add indexes, constraints, explicit grants, authenticated read policies, and deterministic seed data.

Validation:

- Run a transaction-scoped Supabase SQL smoke test for schema, grants, RLS, and seed counts.

Applicable skills:

- `supabase`
- `supabase-postgres-best-practices`

Validated evidence:

- Supabase CLI is not installed locally, so the migration file was created manually using the existing repository timestamp pattern.
- Official Supabase changelog and documentation were checked before implementation; explicit Data API grants remain required for new tables, separately from RLS.
- Added `restaurant_menu_categories` and `restaurant_menu_items` with constraints, indexes, explicit `authenticated`/`service_role` `SELECT` grants, authenticated read policies, and deterministic seeds.
- Transaction-scoped Supabase MCP smoke test passed with 4 categories, 4 items, RLS enabled on both tables, 2 authenticated `SELECT` policies, no `anon` reads, and no authenticated write grants.
- The smoke test finished with `ROLLBACK`; the shared remote project remains unchanged.
- Local whitespace review and `git diff --check` passed.

### Task 3: Add DTOs and Remote Datasource

Concept:

Keep low-level row parsing and query orchestration inside the data layer.

Files:

- Create `lib/features/restaurant_details/data/dtos/restaurant_details_dtos.dart`
- Create `lib/features/restaurant_details/data/datasources/restaurant_details_remote_datasource.dart`
- Create `test/features/restaurant_details/data/restaurant_details_remote_datasource_test.dart`

Responsibilities:

- Parse restaurant, category, and item rows.
- Query details by `restaurantId`.
- Return explicit remote exceptions for malformed or missing data.

Validation:

- Run focused datasource tests.
- Run focused analyze.

Applicable skills:

- `flutter-implement-json-serialization`
- `dart-add-unit-test`
- `dart-run-static-analysis`

Validated evidence:

- TDD RED confirmed before implementation: the focused datasource test failed because the DTO and datasource files were absent.
- Added typed restaurant, menu-category, and menu-item DTOs plus an immutable remote payload.
- Added a Supabase datasource that loads details by restaurant ID, filters category and item queries, preserves deterministic ordering, and translates missing or malformed data into explicit remote exceptions.
- Dart MCP `run_tests` for `test/features/restaurant_details/data/restaurant_details_remote_datasource_test.dart`: 3 tests passed.
- Dart MCP `analyze_files` on the DTO, datasource, and focused test files: no errors.
- `git diff --check`: no errors.

### Task 4: Add Repository Mapping

Concept:

Expose a domain-oriented contract and keep DTO mapping hidden from presentation.

Files:

- Create `lib/features/restaurant_details/domain/repositories/restaurant_details_repository.dart`
- Create `lib/features/restaurant_details/data/repositories/restaurant_details_repository_impl.dart`
- Create `test/features/restaurant_details/data/restaurant_details_repository_impl_test.dart`

Responsibilities:

- Define `getRestaurantDetails(restaurantId)`.
- Map remote payloads into immutable domain entities.

Validation:

- Run focused repository tests.
- Run focused analyze.

Applicable skills:

- `dart-add-unit-test`
- `dart-run-static-analysis`

Validated evidence:

- TDD RED confirmed before implementation: the focused repository test failed because the repository implementation file was absent.
- Added a domain-oriented `RestaurantDetailsRepository` contract and a data-layer implementation that forwards the selected restaurant ID and maps remote DTOs into immutable restaurant-details entities.
- Dart MCP `run_tests` for the focused repository test: 1 test passed.
- Dart MCP `run_tests` for the restaurant-details datasource and repository suites: 4 tests passed.
- Dart MCP `analyze_files` on the repository contract, implementation, and focused test: no errors.
- `git diff --check`: no errors.

### Task 5: Wire Riverpod Composition

Concept:

Use an async family provider so each route loads only its selected restaurant.

Files:

- Create `lib/features/restaurant_details/presentation/providers/restaurant_details_providers.dart`
- Modify `lib/app/di/app_providers.dart`
- Create `test/features/restaurant_details/presentation/restaurant_details_providers_test.dart`

Responsibilities:

- Compose datasource and repository at the app boundary.
- Expose async details by restaurant ID.
- Keep local category selection outside widgets.

Validation:

- Run focused provider tests.
- Run focused analyze.

Applicable skills:

- `dart-add-unit-test`
- `dart-run-static-analysis`

Validated evidence:

- TDD RED confirmed before implementation: the focused provider test failed because the restaurant-details provider file was absent.
- Added an abstract repository provider, a `FutureProvider.family` that loads details by stable restaurant ID, and a `NotifierProvider.family` that owns category selection independently per restaurant.
- Added app-boundary composition for the Supabase datasource, repository implementation, and feature repository override.
- Kept catalog filtering deferred until the presentation contract lands; widgets will not own category state.
- Dart MCP `run_tests` for the focused provider suite: 3 tests passed.
- Dart MCP `run_tests` for the restaurant-details domain, datasource, repository, and provider suites: 10 tests passed.
- Dart MCP `analyze_files` on the touched provider, composition-root, and focused test files: no errors.
- `git diff --check`: no errors.

### Task 6: Add Localized Restaurant Details Copy

Concept:

Add catalog UI copy through the canonical ARB pipeline before presentation consumes it.

Files:

- Modify `lib/l10n/app_pt_BR.arb`
- Modify `lib/l10n/app_pt.arb`
- Modify `lib/l10n/app_en.arb`

Responsibilities:

- Add restaurant-details loading, error, empty, category, metadata, and accessibility copy.
- Refresh generated localizations with `flutter gen-l10n`.
- Request explicit confirmation before applying this task because `flutter gen-l10n` refreshes generated artifacts in addition to the three ARB catalogs.

Localization Guard:

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] Template descriptions and placeholder metadata are complete.
- [ ] Catalog parity and generated freshness guards remain green.

Validation:

- Run `flutter gen-l10n`.
- Run all localization guards.

Applicable skills:

- `flutter-setup-localization`
- `dart-run-static-analysis`

Validated evidence:

- Added feature-prefixed ARB keys for back navigation, loading, error, retry, empty state, menu section, seed categories, metadata, and accessibility labels across `pt_BR`, `pt`, and `en`.
- Added template descriptions and typed placeholder metadata for restaurant metadata, menu semantics, and category-filter semantics.
- `flutter gen-l10n` refreshed the generated `AppLocalizations` accessors after correcting the ICU apostrophe escape in the English empty-state message.
- Dart MCP `run_tests` for hardcoded-copy, ARB catalog parity, and generated localization freshness guards: 9 tests passed.
- Dart MCP `analyze_files` on generated localization artifacts and guard tests: no errors.
- `git diff --check`: no errors.

### Task 7: Add Restaurant Details UI and Home Entry Point

Concept:

Render the read-only browsing surface and delegate interactions. The Home card only navigates; the details page only renders provider state and category selection.

Files:

- Create `lib/features/restaurant_details/presentation/pages/restaurant_details_page.dart`
- Create `lib/features/restaurant_details/presentation/widgets/restaurant_details_sections.dart`
- Modify `lib/features/home/presentation/widgets/home_feed_sections.dart`

Responsibilities:

- Render header, categories, product cards, loading, error, and empty states.
- Add functional back navigation.
- Navigate from Home cards using stable restaurant IDs.
- Keep product taps, favorites, sharing, and cart out of scope.

Localization Guard:

- [ ] Add ARB keys for every new user-facing string in a separate localization step.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy exists in presentation.
- [ ] Localization guard tests remain green.

Theme Guard:

- [ ] Use `Theme.of(context)` and app tokens.
- [ ] No `Color(0x...)` exists in presentation.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage exists outside theme.
- [ ] Visual guard test remains green.

Validation:

- Run focused widget tests after the dedicated UI test step.
- Run focused analyze.

Applicable skills:

- `flutter-add-widget-test`
- `flutter-build-responsive-layout`
- `dart-run-static-analysis`

### Task 8: Add Protected Restaurant Details Route

Concept:

Treat restaurant details as an authenticated deep link. Central routing policy must protect both Home and details routes.

Files:

- Modify `lib/app/routes/app_routes.dart`
- Modify `lib/app/routes/app_router.dart`
- Modify `test/app/routes/app_router_test.dart`

Responsibilities:

- Add `/restaurants/:restaurantId`.
- Build the details page with the route parameter.
- Redirect unauthenticated access to sign-in.

Localization Guard:

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy exists in presentation or route UI.
- [ ] Localization guard tests remain green.

Validation:

- Run focused router tests.
- Run focused analyze.

Applicable skills:

- `flutter-setup-declarative-routing`
- `dart-add-unit-test`
- `dart-run-static-analysis`

### Task 9: Add Focused UI Regression Coverage

Concept:

Pin the approved browsing behavior without asserting deferred product or cart interactions.

Files:

- Create `test/features/restaurant_details/presentation/restaurant_details_page_test.dart`
- Modify `test/features/home/presentation/home_page_test.dart`

Responsibilities:

- Cover loading, error, empty, success, category filtering, and back navigation.
- Cover navigation from Home to details.
- Preserve Home discovery regressions.

Validation:

- Run restaurant-details tests.
- Re-run Home, router, Localization Guard, Theme Guard, and Trello Guard suites.

Applicable skills:

- `flutter-add-widget-test`
- `dart-run-static-analysis`

### Task 10: Reconcile Documentation, Memory, and Trello

Concept:

Advance delivery records only after implementation evidence exists.

Files:

- Modify `docs/project-management/SPRINT_5.md`
- Modify `.ai/memory/current_feature.md`
- Modify `.ai/memory/current_sprint.md`

Responsibilities:

- Record validated tasks and remaining deferred scope.
- Verify real Trello checklist parity and add an evidence comment.
- Keep technical debt notes evidence-based.

Validation:

- Run Trello Guard.
- Review documentation against implemented code.

Applicable skills:

- `dart-run-static-analysis`

## Acceptance Criteria

- [ ] Authenticated users can open `/restaurants/:restaurantId` from a Home restaurant card.
- [ ] Unauthenticated deep links redirect to sign-in.
- [ ] Restaurant details and catalog load remotely by stable restaurant ID.
- [ ] Catalog categories filter loaded items locally and deterministically.
- [ ] Loading, error, empty, and success states are localized.
- [ ] Supabase access remains inside the datasource layer.
- [ ] UI remains free of business logic, hardcoded copy, and hardcoded visual values.
- [ ] Focused regression, guard, and Trello parity validation pass.

## Risks

- Route protection can remain limited to `/home` if protected-route classification is not expanded deliberately.
- Schema work can drift into product customization if menu items are modeled too broadly.
- UI parity can tempt premature cart, favorite, or share behavior.
- New copy and styling can bypass existing guards if localization and widget work are combined without validation.

## Out of Scope

- Product-details route and deep link.
- Product variants, add-ons, customization, quantity, and special instructions.
- Favorites and sharing behavior.
- Cart, checkout, orders, and account destinations.
- Persisted profile/address data.
- Storage media hosting, Realtime, pagination, ranking, and recommendations.

## Suggested Commits

```text
feat(restaurant-details): add domain contracts
feat(restaurant-details): add remote catalog schema
feat(restaurant-details): add remote datasource
feat(restaurant-details): map repository aggregate
feat(restaurant-details): wire async providers
feat(restaurant-details): add catalog UI
feat(routes): add restaurant details deep link
test(restaurant-details): cover remote catalog browsing
docs(restaurant-details): record sprint validation
```
