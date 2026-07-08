# Current Sprint

## Active Sprint

Sprint 11 - Payments Foundation (Closed)

## Active Status

Closed on 2026-07-07. All 7 tasks were implemented, validated, and
committed task-by-task on `feat/payments-foundation`. The focused
regression suite passed with 72 tests and the consolidated `flutter test`
matrix passed with 206 tests. The `payments` foundation migration is
applied to the remote project, Trello checklist parity is complete on
`https://trello.com/c/cQDUVgYR`, and the card is in `🎉 Done`. The branch
was merged through PR #7 (`feat/payments-foundation` -> `develop`) and
PR #8 (`develop` -> `main`), and the milestone shipped as release
`v0.5.0` on 2026-07-08.

## Sprint 11 Goal

Persist a payment record atomically with every confirmed order and render
the payment method and status in the checkout experience, laying the
foundation for future payment lifecycle work without a gateway.

## Sprint 11 Outcome

- Supabase `payments` table with explicit grants, named constraints, and
  RLS scoped to the order owner through `auth.uid()`; the atomic
  `create_order` function evolved to insert the payment row in the same
  transaction as `orders`/`order_items` (commit `81afca3`).
- Pure-Dart payment domain types wired into checkout contracts:
  `PaymentMethod`, `PaymentStatus`, `PaymentSummary`; `OrderDraft` carries
  the payment method and `PlacedOrder` exposes a payment summary with a
  pending-on-delivery default.
- Data layer payment mapping: payment method forwarded to the RPC payload,
  payment summary mapped from the remote response, invalid remote payment
  values mapped to a neutral domain failure.
- Localized payment method/status copy in pt_BR/pt/en; obsolete
  `cartCheckoutPlaceholder` key removed; localization guards green.
- `CheckoutViewModel` sends `PaymentMethod.cashOnDelivery` explicitly; the
  checkout payment section renders the localized method description and
  the success state renders the localized payment status.
- Accepted debt: `orders.payment_method` remains as transitional
  duplication while `payments.method` is the new source of truth.

## Sprint 11 Validation

- Focused regression suite: 72 tests across checkout data/presentation,
  cart, router/auth-recovery, and localization/theme guards.
- Consolidated `flutter test` matrix: 206 tests passed.
- Dart MCP `analyze_files` clean on every touched slice.

## Sprint 11 Plan

- `docs/project-management/SPRINT_11.md`
- Real Trello story (Done): `https://trello.com/c/cQDUVgYR`

## Sprint 11 Deferred

- Payment gateway integration, card capture, and payment status
  transitions.
- Removal of the transitional `orders.payment_method` duplication (future
  approved migration slice).
- Order history (`/orders`), tracking, Realtime, coupons, dynamic delivery
  fee, persisted profile/address data, and cart persistence across
  restarts.

## Previous Sprint

Sprint 10 - Checkout (Closed)

## Sprint 10 Status

Closed on 2026-07-07. All 9 tasks were implemented, validated, and
committed task-by-task on `feat/checkout`. The consolidated regression
matrix passed with 66 tests, the `checkout_orders_foundation` migration is
applied to the remote project, all six real Trello checklists on
`https://trello.com/c/yEdTwW5F` are complete, and the card is in `Done`.

## Sprint 10 Goal

Add a checkout flow so authenticated users can review their cart on a
protected `/checkout` page and confirm the order, persisting it to
Supabase — the project's first complete write path.

## Sprint 10 Outcome

- `orders`/`order_items` with named constraints, explicit paired grants,
  RLS `INSERT`/`SELECT` scoped to `auth.uid()`, and the atomic
  `create_order` function (SECURITY INVOKER, empty search_path,
  server-side totals); validated in a rollback transaction before apply
  and verified post-apply (anon denial, cross-user isolation, advisors).
- Pure-Dart `OrderDraft`/`OrderDraftItem`/`PlacedOrder` with derived
  totals and `OrderDraft.standardDeliveryFeeInCents`;
  `OrderPlacementFailure` neutral codes (auth convention);
  `OrderRepository.placeOrder` documented as atomic and non-retryable.
- `SupabaseOrderRemoteDatasource` owning `.rpc('create_order')` with an
  injectable rpcCaller; `OrderRepositoryImpl` mapping draft→payload and
  remote→domain failures; composed via `appOrderRepositoryProvider` and
  the presentation `orderRepositoryProvider` override.
- `CheckoutViewModel` (`Notifier<CheckoutState>` sealed states) with
  re-entry guard, empty-cart no-op, single cart clear on success, and
  `reset()` for page re-entry.
- Protected `/checkout` + CartPage CTA navigation via router-injected
  callback; "Checkout em breve" placeholder removed.
- `CheckoutPage` per prototype: demo address card, static pay-on-delivery,
  quantity-prefixed summary rows, subtotal/fee/total via the shared
  formatter, submitting/failure/success states, back-to-home.
- 18 `checkout*` ARB keys (pt_BR template, pt, en; no-accent PT).
- 21 new tests (7 ViewModel, 6 datasource, 3 repository, 5 page) inside
  the consolidated 66-test matrix.

## Sprint 10 Validation

- Rollback-transaction smoke test + `apply_migration` + post-apply
  security checks on the remote project.
- Dart MCP `analyze_files` clean on every touched slice.
- Consolidated matrix: 66 tests passed (checkout, cart, router, l10n
  guards, Theme Guard, Trello Guard).

## Sprint 10 Plan

- `.ai/plans/2026-07-06-checkout-plan.md`
- `docs/project-management/SPRINT_10.md`
- Real Trello story (Done): `https://trello.com/c/yEdTwW5F`
- Epic: `https://trello.com/c/iXdaDVOO`

## Sprint 10 Deferred

- Order history (`/orders`), tracking, Realtime, status transitions.
- Payment gateway, coupons, dynamic delivery fee.
- Persisted profile/address data.
- Cart persistence across restarts (Planned Scope / Monitoring).
- `cartCheckoutPlaceholder` unused ARB key removal (accepted minor debt).

## Previous Sprint

Sprint 9 - Cart (Closed)

## Sprint 9 Status

Closed on 2026-07-03. All 8 tasks were implemented, validated, and
committed task-by-task on `feat/cart`. The consolidated regression matrix
passed with 64 tests, all seven real Trello checklists on
`https://trello.com/c/VFGNIm0O` are complete, and the card is in `Done`.

## Sprint 9 Goal

Add a session-local shopping cart so authenticated users can add products
from product details, review and adjust quantities on a dedicated `/cart`
page, and see a running total — without remote persistence or checkout.

## Sprint 9 Outcome

- `CartItem`/`Cart` immutable pure-Dart aggregates with value equality;
  `CartNotifier` (`Notifier<Cart>`) as the feature's domain boundary — no
  repository/datasource, per the approved plan.
- Single-restaurant constraint enforced in the domain via the
  `CartAddResult { added, requiresConfirmation }` return signal (no
  exception-based control flow, Finding A precedent) with a localized
  confirmation dialog in presentation.
- Protected `/cart` route with centralized GoRouter guard coverage.
- `CartPage` empty/non-empty states, quantity controls with remove
  affordance at qty 1, disabled checkout CTA with placeholder microcopy.
- Product details integration: add-to-cart button ↔ in-cart quantity
  controls through the derived `cartItemProvider` family selector.
- `CartBadgeButton` (Badge M3, hidden at zero) floating on restaurant and
  product hero headers, watching only `cartItemCountProvider`; navigation
  injected by the router via `onOpenCart` callbacks.
- `formatPriceInCents` extracted to `lib/shared/utils/price_formatter.dart`
  (Finding D rule: cart was the third consumer); duplicated `_formatPrice`
  removed from restaurant/product details sections.
- 21 `cart*` ARB keys (pt_BR template with descriptions, pt, en) including
  the ICU plural `cartItemCount`.
- Approved deviations: no-accent PT copy per catalog convention; extra
  `cartClearAction` key; `CartItem.restaurantName` removed (dialog copy
  does not use it and ProductDetailsPage cannot source it).

## Sprint 9 Validation

- 12 widget-free `CartNotifier` unit tests, 5 `CartPage` widget tests,
  5 product-details cart-integration tests, 2 `/cart` router guard tests.
- Consolidated matrix: 64 tests passed; Dart MCP `analyze_files` clean on
  every touched slice; all l10n/theme/Trello guards green.

## Sprint 9 Plan

- `.ai/plans/2026-06-24-cart-plan.md`
- `docs/project-management/SPRINT_9.md`
- Real Trello story (Done): `https://trello.com/c/VFGNIm0O`

## Sprint 9 Deferred

- Cart persistence across restarts (Checkout sprint).
- Checkout, payment, order creation, delivery fee/address, coupons.
- Product customization (variants, add-ons, special instructions).

## Previous Sprint

Sprint 8 - Storage-Backed Catalog Media (Closed)

## Sprint 8 Status

Closed on 2026-06-11. Runtime, automated validation, and authenticated
mobile/wide visual QA are complete. All seven real Trello checklists are
complete, final evidence is recorded, and
`https://trello.com/c/PXq6TWpP` is in `Done`.

## Sprint 8 Goal

Make Home -> restaurant details -> product details visually credible for all
existing seeded entries by serving 4 restaurant covers and 16 product images
from a public-read Supabase Storage bucket.

## Sprint 8 Scope

- AI-generate and review 20 realistic food-photography WebPs;
- use 16:9 for restaurant covers and 1:1 for product images;
- keep generated files versioned under `supabase/seed-assets/catalog/`, outside
  the Flutter asset bundle;
- create public bucket `catalog-media` with constrained catalog media settings;
- keep Storage mutations outside Flutter;
- update existing database rows to stable Storage object paths;
- resolve public URLs in a shared data-layer service;
- render local assets and remote images through a shared presentation widget;
- integrate Home, restaurant details, and product details;
- validate security, remote parity, loading/error behavior, guards, and the
  complete read-only flow.

## Sprint 8 Plan

- `.ai/plans/2026-06-08-storage-backed-catalog-media-plan.md`
- `docs/project-management/SPRINT_8.md`

## Sprint 8 Backlog

- [x] Task 1 — lock the 20-object media manifest.
- [x] Task 2 — generate, curate, optimize, and version the media.
- [x] Task 3 — create and validate the Storage foundation.
- [x] Task 4 — upload and verify all objects.
- [x] Task 5 — migrate database rows to stable Storage paths.
- [x] Task 6 — add and compose the shared public-media resolver.
- [x] Task 7 — wire resolution into the three remote datasources.
- [x] Task 8 — add the shared renderer and update presentation.
- [x] Task 9 — validate the complete media flow and regressions.
- [x] Task 10 — reconcile governance and technical debt.

## Sprint 8 Out of Scope

- Home promotion media.
- In-app upload/update/delete, private media, signed URLs, or service-role usage
  in Flutter.
- Responsive variants, transformations, blur hashes, or external CDN.
- Renaming `image_asset_path`/`imageAssetPath`.
- New restaurants/products or changes to catalog copy, pricing, taxonomy, and
  navigation.
- Cart, checkout, orders, customization, quantity, variants, add-ons,
  favorites, sharing, Realtime, recommendations, and analytics.

## Sprint 8 Risks

- AI visual artifacts or inconsistent photography.
- Repository growth if WebP optimization limits are not enforced.
- CDN/browser cache staleness when replacing unchanged object URLs.
- Transitional naming debt in `image_asset_path`.
- Network loading/failure regressions across three presentation surfaces.
- Drift between versioned manifest, Storage objects, and database paths.
- Future replacements should prefer versioned filenames to avoid stale cache
  behavior.

## Previous Sprint

Sprint 7 - Catalog Demo Coverage (Closed)

## Previous Sprint Status

Closed (2026-06-03). Sprint 7 expanded deterministic catalog demo seed coverage
for all four existing Home restaurants while preserving the validated read-only
browsing architecture. The remote project has 13 menu categories and 16 menu
items, focused datasource regressions cover non-burger payloads, and the real
Trello card is reconciled.

## Sprint 7 Goal

Make Home -> restaurant details -> product details feel complete for every existing seeded restaurant, without adding cart, checkout, customization, Storage, Realtime, or new UI behavior.

## Sprint 7 Scope

- add deterministic menu categories and items for `pasta_roma`, `sushi_zen`, and `taco_harbor`;
- preserve existing `burger_artisan_collective` behavior;
- keep seed changes idempotent and deployable through a new migration;
- validate Supabase read-only access, RLS/grants, and existing datasource/repository compatibility;
- add focused multi-restaurant regression coverage where needed;
- reconcile docs, memory, technical debt, and Trello only after validation.

## Sprint 7 Plan

- `.ai/plans/2026-06-03-catalog-demo-coverage-plan.md`
- `docs/project-management/SPRINT_7.md`

## Sprint 7 Backlog

- [x] Task 1 — audit current seed baseline and expected target counts.
- [x] Task 2 — add deterministic catalog demo seed migration.
- [x] Task 3 — validate Supabase read contracts, RLS/grants, and datasource compatibility.
- [x] Task 4 — add focused multi-restaurant catalog/product regression coverage.
- [x] Task 5 — reconcile docs, memory, technical debt, and Trello after validation.

## Sprint 7 Progress

- Task 1 completed — local migrations and Supabase MCP read-only queries confirmed all four existing Home restaurants are present, while only `burger_artisan_collective` has current menu coverage (4 categories and 4 items).
- Task 2 completed — `supabase/migrations/20260603183000_catalog_demo_coverage.sql` now adds deterministic idempotent seeds for `pasta_roma`, `sushi_zen`, and `taco_harbor` (9 categories and 12 items total).
- Task 2 validation passed — `git diff --check` reported no errors; Supabase MCP executed the migration SQL in a rollback transaction without persisting data; post-rollback checks confirmed the remote baseline stayed unchanged.
- Task 3 completed — remote migration `catalog_demo_coverage` was applied to project `kvbahsdjmhpukzmdttvq`; RLS/grants remained read-only for `authenticated` and denied to `anon`; datasource-shaped reads returned categories/items by `restaurant_id` and product details by `id`.
- Task 4 completed — datasource regression coverage now covers a non-burger `pasta_roma` catalog payload and the seeded non-burger product `sushi_zen_omakase_sampler`.
- Task 5 completed — docs, memory, technical debt, and Trello were reconciled after final validation evidence.
- Final validation — transaction-scoped Supabase read confirmed final catalog counts (13 categories, 16 items); Dart MCP datasource tests passed with 8 tests; Dart MCP analysis reported no errors; Trello Guard passed; `git diff --check` passed.
- Real Trello card `https://trello.com/c/TLHgmJ02` is reconciled with validated evidence and moved to `🎉 Done`.

## Sprint 7 Out of Scope

- Cart, checkout, orders, quantity, variants, add-ons, and special instructions.
- Favorites and sharing behavior.
- Persisted profile/address data.
- Storage-backed media.
- Realtime, ranking, pagination, recommendations, and analytics.
- New restaurants or Home taxonomy changes unless separately approved.

## Earlier Sprint

Sprint 6 - Product Details Read-Only (Closed)

## Previous Sprint Status

Closed (2026-06-03). All 9 tasks implemented and validated task-by-task; the real Trello card is fully checked and moved to `🎉 Done`. Consolidated regression matrix passed (45 tests). No new migration was needed; the feature reuses `restaurant_menu_items`.

## Sprint 6 Outcome

- Protected nested route `/restaurants/:restaurantId/products/:productId` opens a read-only product surface from the restaurant catalog, loaded on demand by stable product ID through a `FutureProvider.family<ProductDetails?, String>`.
- Dedicated `product_details` Clean Architecture feature (domain/data/presentation) mirroring `restaurant_details`; no dedicated ViewModel (read-only single load, per ADR-003).
- Not-found contract (Finding A): repository returns `ProductDetails?` — `null` renders the localized not-found state, exceptions render the error state; no exception-based control flow.
- Localized states (loading/error/not-found/success) via ARB + `AppLocalizations` (11 `productDetails*` keys); semantic theme APIs/tokens only.
- Commits `3d98b99`, `c57cb34`, `d25ada2`, `bd1a704`, `f02c46e`, `b857954`, `bf95ef7`, `d22423b` plus planning/docs commits on `feat/home`.
- Real Trello story closed with validated evidence: `https://trello.com/c/8amTB8F3`.
- Plan: `.ai/plans/2026-06-02-product-details-read-only-plan.md`. Governance: `docs/project-management/SPRINT_6.md`.
- Deferred (unchanged): cart, customization, quantity, variants/add-ons, favorites, sharing, Storage, Realtime, broad catalog seed expansion. Only `burger_artisan_collective` is seeded, so other products resolve to the localized not-found state by design.

## Earlier Sprint

Sprint 5 - Restaurant Details Remote Catalog

## Status (Sprint 5)

Closed.

## Active Focus

- protected `/restaurants/:restaurantId` route opened from Home restaurant cards
- dedicated `restaurant_details` Clean Architecture feature
- Supabase-backed read-only menu categories and items
- async Riverpod loading by stable restaurant ID
- local menu-category filtering
- localized and theme-safe details UI aligned with `docs/ux/prototypes/restaurant-details.png`

## Active Out of Scope

- product-details route
- product customization, variants, add-ons, quantity, and special instructions
- favorite and share behavior
- cart, checkout, orders, account, and persisted profile/address data
- Storage media, Realtime, pagination, ranking, and recommendations

## Sprint 5 Plan

- `.ai/plans/2026-06-02-restaurant-details-remote-catalog-plan.md`
- `docs/project-management/SPRINT_5.md`

## Active Progress

- Task 1 completed — immutable restaurant-details domain contracts.
- Task 2 completed — read-only remote catalog schema with explicit grants, RLS, authenticated read policies, indexes, constraints, and deterministic seeds.
- Task 3 completed — typed remote DTOs and Supabase datasource with filtered restaurant-ID queries, deterministic ordering, payload orchestration, and explicit remote exceptions.
- Task 4 completed — domain repository contract and DTO-to-domain mapping boundary.
- Task 5 completed — Riverpod family loading by stable restaurant ID, per-restaurant local category-selection state, and app-boundary composition.
- Task 6 completed — restaurant-details copy now lives in ARB catalogs with generated `AppLocalizations` accessors for async states, menu labels, metadata, navigation, and accessibility.
- Task 7 completed — localized restaurant-details UI, derived local category filtering, semantic presentation tokens, and delegable Home restaurant-card stable-ID callbacks.
- Task 8 completed — protected restaurant-details routing now lives in centralized `GoRouter`, authenticated users can reach `/restaurants/:restaurantId` from Home, and unauthenticated deep links redirect to sign-in.
- Task 9 completed — focused UI regression coverage for restaurant-details browsing and Home navigation; Tasks 7-9 committed task-by-task (`0ee841a`, `a123a29`, `d0590fd`); consolidated guard matrix passed with 49 tests.
- Task 10 completed — Sprint 5 docs, plan, feature/sprint memory, and the real Trello card were reconciled after verified parity. Six previously-incomplete card items were completed against real evidence; the card is fully checked and moved to `🎉 Done`.
- Real Trello story closed with validated implementation evidence: `https://trello.com/c/1cBjEupB`.
- 2026-06-02 post-sprint remote deployment — both versioned migrations were applied to the live project `flowdelivery-app` (ref `kvbahsdjmhpukzmdttvq`) via Supabase MCP `apply_migration`. `list_migrations`/`list_tables` confirm both migrations and all six RLS-enabled `public` tables with deterministic seed counts (categories 5, restaurants 4, links 8, promotions 1, menu categories 4, menu items 4). Catalog seeds cover only `burger_artisan_collective`; other restaurants resolve to the localized empty catalog state. Runbook in `docs/setup/SUPABASE_SETUP.md`; governance evidence in `docs/project-management/SPRINT_5.md`.

## Sprint

Sprint 4 — Home Discovery Interactions

## Status

Completed.

Sprint 4 starts from the validated remote-feed baseline and is limited to interactive search/category discovery on the authenticated Home feed.

## Focus

- interactive search and category discovery on top of the validated remote Home feed
- derived filtering state owned in Riverpod rather than widgets
- preserved `/home` route contract and existing remote datasource/repository boundaries
- localized discovery empty-results feedback only if interaction UX requires it
- Localization Guard and Theme Guard enforcement for new interaction states

## Current Priorities

- preserve the validated auth foundation and Sprint 2 Home baseline as the current baseline
- treat Sprint 4 as the active approved Home slice and execute only one approved task at a time
- keep profile/address persistence out of this Home slice
- keep restaurant details, destination tabs, ranking, pagination, Storage media, and Realtime deferred until separate approved slices
- keep Trello documentation, workflow artifacts, and real-card evidence aligned when Trello-governed work touches cards
- validate real Trello checklist parity with `trello_get_card_checklists` before using cards as delivery evidence
- keep Supabase outside widgets and ViewModels
- keep route policy at app level
- update documentation and memory only after validated implementation slices
- keep auth i18n centralized in Flutter gen-l10n ARB files and generated `AppLocalizations`
- keep the hardcoded copy guard test green when adding new UI placeholders or features
- keep ARB catalog parity and generated localization freshness guards green after ARB changes
- keep Theme Guard checklist and visual hardcoded constraints enforced for UI tasks
- keep design-system docs synchronized with implemented typography and locale choices

## Notes

- Sprint 2 (`docs/project-management/SPRINT_2.md`) is closed as the validated static Home baseline.
- Sprint 3 generated in `docs/project-management/SPRINT_3.md`.
- Sprint 4 generated in `docs/project-management/SPRINT_4.md`.
- Home remote technical plan registered in `.ai/plans/2026-06-01-home-remote-feed-plan.md`.
- Home discovery technical plan registered in `.ai/plans/2026-06-01-home-discovery-interactions-plan.md`.
- The next Home slice introduces interactive search/category discovery only; delivery-address persistence remains local/deferred.
- Active branch: `feat/home`.
- The previous real Trello story remains closed with validated implementation evidence: `https://trello.com/c/X3jAdpd2`.
- The Sprint 3 real Trello story is closed with validated implementation evidence: `https://trello.com/c/bzxIa3wx`.
- Sprint 3 validation includes focused datasource/repository/provider/widget tests, localization/theme guards, router regression coverage, and Trello checklist parity validation.
- Sprint 4 real Trello story is active with Scope, Acceptance Criteria, Dependencies, Validation, Localization Guard, and Theme Guard checklists: `https://trello.com/c/5EUe5qOp`.
- Sprint 4 Tasks 1-4 are validated. Task 4 added localized discovery no-match feedback and a clear-filters action that resets Riverpod discovery state plus the visible search field.
- Sprint 4 Trello parity after Task 4 is intentionally partial: Scope `5/6`, Validation `7/8`, Localization Guard `7/7`, Theme Guard `5/5`, Acceptance Criteria `5/8`, and Dependencies `6/6`. Global completion items remain open for Tasks 5-6.
- Sprint 4 Task 5 is validated: provider reset regression plus combined category/search no-match widget recovery are covered, focused Home suites passed with 22 tests, and the consolidated router/guard matrix passed with 41 tests.
- Sprint 4 Task 6 is complete: docs, plan, memory, technical-debt monitoring, and the real Trello story were reconciled after validation.
- Sprint 4 final real Trello parity is complete for `https://trello.com/c/5EUe5qOp`: Scope `6/6`, Validation `8/8`, Localization Guard `7/7`, Theme Guard `5/5`, Acceptance Criteria `8/8`, and Dependencies `6/6`.
- Use `.codex/workflows/` for repeatable execution.
- Use `.ai/context/` as project context.
- Use `.ai/agents/` for role-specific behavior.
- Sprint 0 foundation and governance completed.
- Sprint 1 generated in `docs/project-management/SPRINT_1.md` and is now closed.
- Authentication technical plan registered in `.ai/plans/2026-05-19-authentication-plan.md`.
- Theme guard technical plan registered in `.ai/plans/2026-05-22-theme-guard-uiux-standardization-plan.md`.
- Theme Guard status: Task 4 (priority auth slice normalization) and Task 5 (memory reconciliation) completed.
- Visual hardcoded guard test now strict (no baseline exception) and green.
- Post-review corrective pass completed: router coupling and forgot-password lifecycle consistency fixed with focused coverage.
- I18n pipeline guardrails now include hardcoded-copy, ARB catalog parity, placeholder parity, and generated localization freshness validation.
- Historical Sprint 1 password-recovery planning slice covered reset deep-link/session handling, reset-password route, new-password UI, Supabase password update, focused tests, and Supabase redirect manual QA notes.
- Password recovery completion automated slice implemented: reset-password route, new-password UI, ViewModel reset state, Supabase password update through datasource, ARB copy, and focused tests.
- Sprint 1 is closed; Trello sync debt reduction is now `Reduced / Monitoring`, so the next implementation requires an explicitly selected and approved product or governance slice.
- Recovery deliverability execution remains pending external QA inbox/provider availability.
- Auth hardening post-review implementation tasks completed (`.ai/plans/2026-05-26-auth-hardening-post-review-plan.md` Tasks 1-4) with focused test validation.
- Phased migration strategy from legacy provider usage to non-legacy Riverpod pattern documented with gates and rollback criteria (Task 5).
- Auth hardening consolidated focused suite executed and green (31 tests across auth ViewModel/pages/recovery redirect/router).
