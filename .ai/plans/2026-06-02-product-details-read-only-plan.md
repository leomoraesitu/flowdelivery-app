# Product Details Read-Only Plan

## Objective

Close the MVP "product browsing" area by opening a protected product-details route from the restaurant catalog and rendering a read-only product surface, without introducing customization, quantity, or cart state.

Reference prototype:

- `docs/ux/prototypes/product-details.png`

## Prototype Scope Mapping

`product-details.png` depicts a full commerce/customization surface. This read-only slice renders only the upper, informational portion; every interactive commerce element is deferred. This table locks Task 6 against visual-parity scope creep — do not implement deferred rows just because they appear in the prototype.

| Prototype element | This slice | Notes |
| --- | --- | --- |
| Hero image + back button | In scope (Task 6) | Reuse `restaurant_details` hero/back patterns and tokens. |
| Product name + price | In scope | From `ProductDetails.name` / `priceInCents`. |
| Description | In scope | From `ProductDetails.description`. |
| Loading / error / not-found states | In scope | `null` → not-found, `AsyncError` → error. |
| Favorite (❤) + Share icons | Deferred | Favorites and sharing are out of scope. |
| "Choice of Protein" (required radios) | Deferred | Variants need a `product_options`-style table that does not exist; no new migration in this slice. |
| "Add-ons" (priced checkboxes) | Deferred | Add-ons need the same missing table. |
| "Special Instructions" field | Deferred | Order/customization state is out of scope. |
| Quantity stepper (− 1 +) | Deferred | Quantity is out of scope. |
| "Add to Cart • $XX" button | Deferred | Cart is out of scope. |

Data implication: `ProductDetails` (id, restaurantId, categoryId, name, description, imageAssetPath, priceInCents) covers only the in-scope rows above. Protein/add-on options are intentionally unmodeled because no backing table exists and no migration is planned here.

## Architectural Context

`product_details` is a dedicated Clean Architecture feature that mirrors the validated `restaurant_details` slice. Because the route is an authenticated deep link, the product must be loaded on demand by stable ID — the page cannot assume the restaurant catalog is already cached (cold start, web URL, app restart).

```text
Restaurant catalog product card
↓
/restaurants/:restaurantId/products/:productId
↓
ProductDetailsPage
↓
Riverpod FutureProvider.family (keyed by productId)
↓
ProductDetailsRepository
↓
ProductDetailsRemoteDatasource
↓
Supabase (restaurant_menu_items, existing table)
```

Layers and responsibilities:

- Domain: immutable `ProductDetails` value model; no Flutter, no Supabase.
- Data: typed DTO parsing of a single `restaurant_menu_items` row; datasource owns the filtered query and a nullable single-row loader (null when the row is absent); explicit remote exceptions are reserved for genuine remote/parsing failures, not the expected missing-row case; repository maps DTO → domain.
- Presentation: Riverpod family loads by product ID; the provider value type is nullable so a `null` result renders the localized not-found state while an `AsyncError` renders the error state; UI renders localized loading/error/not-found/success states with semantic theme tokens; the catalog product card only delegates a stable product ID.
- App: composition root wires datasource + repository + provider override; centralized GoRouter owns the nested protected route.

Not-found contract (decision 2026-06-03): missing products are the common case because only `burger_artisan_collective` is seeded. The repository returns `Future<ProductDetails?>` — `null` means "no such product" (rendered as the localized not-found state), and exceptions are reserved for real remote/parsing failures (rendered as the error state). This keeps not-found out of exception-based control flow and lets the UI branch on `value == null` vs `AsyncError`.

## Governance Cross-Check (2026-06-02)

This plan was validated against `.ai/context/*`, `.ai/agents/architect|senior_flutter_engineer/*`, ADRs `001-004`, and `.agents/skills/*`. Intentional divergences from illustrative docs are recorded here because the architect rule treats repository code as more authoritative than generated docs and requires calling out doc/implementation inconsistencies.

- Folder convention follows the canonical structure now documented in ADR-003 (reconciled 2026-06-02 to the practiced convention): `data/datasources|dtos|repositories/`, `domain/entities|repositories/`, `presentation/pages|providers|widgets/`. This matches the existing `restaurant_details` feature.
- No dedicated ViewModel class. The slice is a read-only single load with no mutable orchestration (no category/quantity state), so a `FutureProvider.family` is sufficient and mirrors `restaurant_details`. ADR-003 documents this as the rule for read-only/single-load features and warns against adding layers that do not remove real complexity.
- Feature is named `product_details` (slice naming, following the `restaurant_details` precedent) rather than the `products` domain label in `architecture.md`.
- No cross-feature coupling: `restaurant_details` only exposes an optional product-card callback that emits a stable `productId` string; navigation to `product_details` is wired in the app-layer router. `restaurant_details` must not import `product_details`, mirroring how Home delegates `restaurantId`.
- Skills confirmed present in `.agents/skills/`: `dart-add-unit-test`, `dart-run-static-analysis`, `flutter-implement-json-serialization`, `flutter-setup-localization`, `flutter-add-widget-test`, `flutter-build-responsive-layout`, `flutter-setup-declarative-routing`, plus `flutter-apply-architecture-best-practices` for the architecture framing.

## Key Decisions and Tradeoffs

- Nested route `/restaurants/:restaurantId/products/:productId` over a flat `/products/:productId`. The product lives inside a restaurant context, back-navigation is natural, and the path already starts with `/restaurants/` so the existing protected-route classifier in `app_router.dart` covers it without new redirect logic. Tradeoff: the page receives both IDs, but only `productId` keys the data load.
- Load on demand by `productId` rather than reusing the already-loaded `RestaurantDetails.items`. This supports cold deep links and keeps the feature self-contained, at the cost of one extra single-row query. `productId` is the primary key of `restaurant_menu_items`, so a single-ID filter is sufficient and deterministic.
- No new migration. The slice reuses `restaurant_menu_items`. Broad catalog seed coverage (only `burger_artisan_collective` currently has items) stays a separate future data slice; other products resolve to the localized not-found/empty state, which is correct behavior.
- Keep restaurant-name display optional/deferred to avoid a second join and scope creep; the product surface focuses on the product itself plus back navigation.
- The route `restaurantId` is used only for back navigation and route protection; the product load filters by `productId` (primary key) alone. Cross-integrity validation (route `restaurantId` vs the product's real `restaurant_id`) is intentionally out of scope for this read-only slice; a mismatched deep link still resolves the product, and back navigation uses the route `restaurantId`. (Finding C, accepted low risk.)
- Price formatting is duplicated from `restaurant_details_sections.dart` (`_formatPrice`, `NumberFormat` by locale) rather than extracted to `lib/shared/` now, to avoid a premature refactor outside this slice's scope. (Finding D, accepted; revisit if a third consumer appears.)

## Dependencies

- Existing: `flutter_riverpod`, `go_router`, `supabase_flutter`, ARB + `AppLocalizations`.
- Existing: Theme Guard, Localization Guard, and Trello Guard suites.
- Existing: `restaurant_menu_items` table (deployed remotely 2026-06-02).
- New packages: none.
- New migrations: none.

## Current Progress

- [x] Architecture approved (reviewed and refined 2026-06-03; Findings A/B/C/D resolved).
- [x] Slice boundary approved: read-only product details only.
- [x] Task 1 — immutable product-details domain contract and focused tests (analyze clean; 3 domain tests pass, 2026-06-03).
- [x] Task 2 — typed DTO and remote datasource with focused tests (analyze clean; 3 datasource tests pass incl. null not-found, 2026-06-03).
- [x] Task 3 — domain repository contract and DTO-to-domain mapping with focused tests (analyze clean; 2 repository tests pass incl. null propagation, 2026-06-03).
- [x] Task 4 — Riverpod family loading and app composition with focused tests (analyze clean; full product_details suite 10/10, 2026-06-03).
- [ ] Task 5 — localized product-details copy and generated `AppLocalizations` accessors with guard validation.
- [ ] Task 6 — product-details UI and delegable catalog product-card entry callback with guard validation.
- [ ] Task 7 — protected nested product-details route and focused router coverage.
- [ ] Task 8 — focused product-details and catalog navigation regression coverage.
- [ ] Task 9 — docs, memory, plan checklists, and the real Trello card reconciled after verified parity.

## Implementation Tasks

### Task 1: Define Product Details Domain Contract

Concept: Model the product surface before introducing Supabase concerns; an immutable value model keeps presentation independent from rows.

Files:

- Create `lib/features/product_details/domain/entities/product_details.dart`
- Create `test/features/product_details/domain/product_details_domain_test.dart`

Responsibilities:

- Represent product id, restaurant id, category id, name, description, image asset path, and price in cents.
- Keep the entity Flutter-free and Supabase-free, with value equality and a `const` constructor for fixtures.

Validation: focused domain test; focused analyze.

Applicable skills: `flutter-apply-architecture-best-practices`, `dart-add-unit-test`, `dart-run-static-analysis`.

### Task 2: Add DTO and Remote Datasource

Concept: Keep single-row parsing and the query inside the data layer.

Files:

- Create `lib/features/product_details/data/dtos/product_details_dto.dart`
- Create `lib/features/product_details/data/datasources/product_details_remote_datasource.dart`
- Create `test/features/product_details/data/product_details_remote_datasource_test.dart`

Responsibilities:

- Parse a single `restaurant_menu_items` row into a typed DTO.
- Query the product by `id` (primary key) with `maybeSingle()`, exposing an injectable nullable single-row loader for tests (mirrors `_selectMaybeSingleRow` in `restaurant_details_remote_datasource.dart`).
- Return `null` for an absent row (the expected not-found case), and raise an explicit `ProductDetailsRemoteException` only for malformed rows or `PostgrestException`/`FormatException` failures. The datasource method returns a nullable DTO/payload.

Validation: focused datasource tests; focused analyze.

Applicable skills: `flutter-implement-json-serialization`, `dart-add-unit-test`, `dart-run-static-analysis`.

### Task 3: Add Repository Mapping

Concept: Expose a domain-oriented contract and hide DTO mapping from presentation.

Files:

- Create `lib/features/product_details/domain/repositories/product_details_repository.dart`
- Create `lib/features/product_details/data/repositories/product_details_repository_impl.dart`
- Create `test/features/product_details/data/product_details_repository_impl_test.dart`

Responsibilities:

- Define `Future<ProductDetails?> getProductDetails(String productId)` — `null` propagates the not-found case from the datasource.
- Map the remote DTO into the immutable `ProductDetails` entity when present; pass through `null` unchanged.

Validation: focused repository tests; focused analyze.

Applicable skills: `dart-add-unit-test`, `dart-run-static-analysis`.

### Task 4: Wire Riverpod Composition

Concept: Use an async family provider so each route loads only its selected product.

Files:

- Create `lib/features/product_details/presentation/providers/product_details_providers.dart`
- Modify `lib/app/di/app_providers.dart`
- Create `test/features/product_details/presentation/product_details_providers_test.dart`

Responsibilities:

- Compose datasource and repository at the app boundary and override the feature repository provider (mirrors `appRestaurantDetailsRepositoryProvider` and its override in `app_providers.dart`).
- Expose `FutureProvider.family<ProductDetails?, String>` keyed by product ID; the nullable value type carries the not-found case to presentation.

Validation: focused provider tests; focused analyze.

Applicable skills: `dart-add-unit-test`, `dart-run-static-analysis`.

### Task 5: Add Localized Product Details Copy

Concept: Add product UI copy through the canonical ARB pipeline before presentation consumes it.

Files:

- Modify `lib/l10n/app_pt_BR.arb`
- Modify `lib/l10n/app_pt.arb`
- Modify `lib/l10n/app_en.arb`

Responsibilities:

- Add product-details back navigation, loading, error, retry, not-found/empty, price label, and accessibility copy.
- Refresh generated localizations with `flutter gen-l10n`.
- Request explicit confirmation before applying, because `flutter gen-l10n` refreshes generated artifacts in addition to the three ARB catalogs.

Localization Guard:

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] Template descriptions and placeholder metadata are complete.
- [ ] Catalog parity and generated freshness guards remain green.

Validation: `flutter gen-l10n`; all localization guards.

Applicable skills: `flutter-setup-localization`, `dart-run-static-analysis`.

### Task 6: Add Product Details UI and Catalog Entry Point

Concept: Render the read-only product surface and delegate interactions. The catalog product card only navigates; the product page only renders provider state.

Files:

- Create `lib/features/product_details/presentation/pages/product_details_page.dart`
- Create `lib/features/product_details/presentation/widgets/product_details_sections.dart`
- Modify `lib/features/restaurant_details/presentation/widgets/restaurant_details_sections.dart`

Responsibilities:

- Render product image, name, price, description, loading, error, and not-found states with functional back navigation. The not-found state is rendered when the provider value is `null`; the error state is rendered on `AsyncError`.
- Add an optional `ValueChanged<String>? onProductSelected` callback in the catalog `RestaurantDetailsSections` (threaded down to `_MenuItemList`/`_MenuItemCard`) that delegates a stable product ID. This task stays at 3 files and does NOT modify `restaurant_details_page.dart`; threading the callback from the page is deferred to Task 7 to keep file count within the guardrail.
- Keep add-to-cart, quantity, customization, favorites, and sharing out of scope.

Localization Guard:

- [ ] Add ARB keys for every new user-facing string (done in Task 5).
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy exists in presentation.
- [ ] Localization guard tests remain green.

Theme Guard:

- [ ] Use `Theme.of(context)` and app tokens (`AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`).
- [ ] No `Color(0x...)` exists in presentation.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage exists outside theme.
- [ ] Visual guard test remains green.

Validation: focused widget tests after the dedicated UI test step; focused analyze.

Applicable skills: `flutter-add-widget-test`, `flutter-build-responsive-layout`, `dart-run-static-analysis`.

### Task 7: Add Protected Nested Product Details Route

Concept: Treat product details as an authenticated nested deep link under the restaurant route.

Files (4 — exceeds the 3-file guardrail, so this task requires explicit confirmation before implementation):

- Modify `lib/app/routes/app_routes.dart`
- Modify `lib/app/routes/app_router.dart`
- Modify `lib/features/restaurant_details/presentation/pages/restaurant_details_page.dart`
- Modify `test/app/routes/app_router_test.dart`

Responsibilities:

- Add `/restaurants/:restaurantId/products/:productId` name and path constants in `AppRoutes`.
- Add a flat `GoRoute` that builds `ProductDetailsPage` from `restaurantId` and `productId` path parameters (matches the existing flat route style; no `routes:` children needed).
- Thread the catalog product callback router → page → sections: give `RestaurantDetailsPage` an `onProductSelected` parameter (mirrors `HomePage.onRestaurantSelected`) and have the router pass a callback that `goNamed`s the product route with `{restaurantId, productId}`.
- Confirm unauthenticated access redirects to sign-in. The path already starts with `/restaurants/`, so the existing `isProtectedRoute` classifier in `app_router.dart` (`currentPath.startsWith('${AppRoutes.restaurantDetailsBasePath}/')`) covers it without new redirect logic; add explicit test coverage to pin this.

Localization Guard:

- [ ] No new user-facing strings introduced in route wiring (route builds an already-localized page).

Validation: focused router tests; focused analyze.

Applicable skills: `flutter-setup-declarative-routing`, `dart-add-unit-test`, `dart-run-static-analysis`.

### Task 8: Add Focused UI Regression Coverage

Concept: Pin the approved product-browsing behavior without asserting deferred cart interactions.

Files:

- Create `test/features/product_details/presentation/product_details_page_test.dart`
- Modify `test/features/restaurant_details/presentation/restaurant_details_page_test.dart`

Responsibilities:

- Cover loading, error (retry), not-found, success, and back navigation.
- Cover navigation from a catalog product card to product details.
- Preserve restaurant-details regressions.

Validation: product-details tests; re-run restaurant-details, router, Localization Guard, Theme Guard, and Trello Guard suites.

Applicable skills: `flutter-add-widget-test`, `dart-run-static-analysis`.

### Task 9: Reconcile Documentation, Memory, and Trello

Concept: Advance delivery records only after implementation evidence exists.

Files:

- Modify `docs/project-management/SPRINT_6.md`
- Modify `.ai/memory/current_feature.md`
- Modify `.ai/memory/current_sprint.md`

Responsibilities:

- Record validated tasks and remaining deferred scope.
- Verify real Trello checklist parity and add an evidence comment.
- Keep technical-debt notes evidence-based (note partial catalog seed coverage as the demo follow-up).

Validation: Trello Guard; review documentation against implemented code.

Applicable skills: `dart-run-static-analysis`.

## Acceptance Criteria

- [ ] Authenticated users can open a product from the restaurant catalog.
- [ ] Unauthenticated product deep links redirect to sign-in.
- [ ] Product data loads remotely by stable product ID.
- [ ] Loading, error, not-found, and success states are localized.
- [ ] UI uses semantic theme APIs and app tokens.
- [ ] Supabase access stays inside the datasource layer.
- [ ] UI remains free of business logic, hardcoded copy, and hardcoded visual values.
- [ ] Focused regression, guard, and Trello parity validation pass.

## Risks

- Prototype parity can tempt premature add-to-cart, quantity, or customization behavior.
- Loading product data from the cached catalog instead of on demand would break cold deep links.
- Route protection can regress if the nested path is excluded from the protected-route classifier.
- New copy and styling can bypass guards if localization and widget work are combined without validation.

## Out of Scope

- Add-to-cart, quantity, customization, variants, add-ons, and special instructions.
- Favorites and sharing behavior.
- Cart, checkout, orders, and account destinations.
- Persisted profile/address data.
- Broad catalog seed expansion for the other restaurants.
- Storage media hosting, Realtime, pagination, ranking, and recommendations.

## Suggested Commits

```text
feat(product-details): add domain contract
feat(product-details): add remote datasource
feat(product-details): map repository
feat(product-details): wire async providers
feat(product-details): add localized copy
feat(product-details): add product UI
feat(routes): add product details deep link
test(product-details): cover product browsing
docs(product-details): record sprint validation
```
