# Current Feature

## Active Feature

Order History (Sprint 12 — In Progress)

## Active Status

Sprint 12 started on 2026-07-08. The slice adds a read-only order history for
authenticated users, proving the checkout write path can be read back through
RLS-scoped transactional data without leaking Supabase details into UI.

Task 1 is complete and pushed in commit `eb913cc`: `OrderHistoryEntry` and
`OrderHistoryStatus` model a read-only history row in pure Dart,
`OrderHistoryRepository` exposes `loadOrderHistory()` with empty-list success
semantics, and focused domain validation is green.

Task 2 is complete in the local worktree: the orders data layer now parses the
embedded order-history payload, resolves restaurant media through the shared
public-media resolver, maps remote failures/status drift to neutral domain
failures, and focused data validation is green.

## Sprint 12 Progress

- [x] Task 1 — domain: order history entity, status, repository contract
  (focused domain test + touched-file analysis green).
- [x] Task 2 — data: DTO, Supabase datasource, repository implementation
  (focused data tests + touched-file analysis green; Supabase read-only
  schema/RLS/embed-shape check green; real Trello parity updated to Scope
  `2/8`, Validation `3/7`, overall `5/41`).
- [ ] Task 3 — providers and app composition.
- [ ] Task 4 — ARB copy for order history.
- [ ] Task 5 — UI: OrdersPage states and order card.
- [ ] Task 6 — routing: protected `/orders` + Home bottom-nav wiring.
- [ ] Task 7 — full validation and regression matrix.
- [ ] Task 8 — docs, memory, technical debt, and Trello reconciliation.

## Architecture Notes (Sprint 12)

- Read path mirrors the validated read-only pattern:
  `OrdersPage` → `orderHistoryProvider` → `OrderHistoryRepository` →
  datasource → Supabase.
- No ViewModel for the initial listing slice: the page performs a single
  read with no user actions, following the ADR-003 precedent from product
  details.
- Empty history is success (`[]`), not an exception.
- The current domain status is intentionally honest: `placed` only. Tabs,
  tracking, cancellation, reorder, and order details remain out of scope.
- Supabase, embedded PostgREST payloads, and public media URL resolution
  belong to the future data layer, not the entity or UI.
- The Task 2 datasource owns the PostgREST embed shape and converts it to a
  flat DTO row: `restaurants(name, image_asset_path)` becomes restaurant
  metadata, and `order_items(quantity)` is summed into `itemCount`.
- Localization and Theme Guards are not applicable to Tasks 1-2 because they
  add no user-facing copy and no presentation styling.

## Previous Feature

Payments Foundation (Sprint 11 — Closed)

## Sprint 11 Status

Sprint 11 closed on 2026-07-07. The slice delivered persisted payment
foundation for checkout: `payments` table + atomic `create_order` payment
insert, payment domain types (`PaymentMethod`, `PaymentStatus`,
`PaymentSummary`), DTO/datasource/repository payment payload mapping,
localized payment copy in ARB catalogs, checkout payment method/status
rendering in ViewModel + UI, focused validation (72 tests) and consolidated
matrix validation (206 tests), and final Trello parity on
`https://trello.com/c/cQDUVgYR` in `🎉 Done`.

Task 1 is complete with commit `81afca3` (`payments` table + atomic
`create_order` evolution).

Task 2 is complete in the local worktree: checkout domain now models
`PaymentMethod`, `PaymentStatus`, and `PaymentSummary`; `OrderDraft`
includes `paymentMethod`; `PlacedOrder` includes a payment summary with a
pending-on-delivery default.

## Sprint 11 Progress

- [x] Task 1 — migration: `payments` foundation + atomic order/payment RPC
  (commit `81afca3`).
- [x] Task 2 — payment domain entities wired into checkout order contracts
  (validated locally with focused checkout tests).
- [x] Task 3 — DTO/datasource/repository mapping for payment payload
  (payment method forwarded to RPC, payment summary mapped in repository,
  invalid remote payment values mapped to domain failure; focused data tests
  green).
- [x] Task 4 — ARB copy for payment method/status
  (added payment status/method keys in pt_BR/pt/en, removed obsolete
  `cartCheckoutPlaceholder`, regenerated localizations, and localization
  guards green: ARB parity, generated freshness, no hardcoded UI strings).
- [x] Task 5 — ViewModel + checkout UI payment state
  (ViewModel now sends `PaymentMethod.cashOnDelivery` explicitly; checkout
  payment section renders localized method description; success state renders
  localized payment status; focused presentation tests + localization/theme
  guard tests green).
- [x] Task 6 — full validation and regression matrix
  (focused analyze on checkout/cart/routes/l10n green; focused regression
  suite green with 72 tests across checkout data/presentation, cart,
  router/auth-recovery, and localization/theme guards; consolidated
  `flutter test` matrix green with 206 tests).
- [x] Task 7 — docs/memory/technical-debt/Trello reconciliation
  (Sprint 11 docs updated, technical debt reconciled, and Trello checklist
  parity finalized with card moved to `🎉 Done`).

## Architecture Notes (Sprint 10)

- First write path: UI → `CheckoutViewModel` → `OrderRepository` →
  `OrderRemoteDatasource` → `.rpc('create_order')`. Atomicity lives in the
  Postgres function (single transaction, SECURITY INVOKER so RLS applies);
  subtotal/total are derived server-side from the submitted items.
- No retry anywhere in the chain (double-order risk); the ViewModel also
  guards re-entry while submitting.
- Error translation in three layers: `PostgrestException` →
  `OrderRemoteException` (data) → `OrderPlacementFailure` neutral code
  (domain) → localized copy (presentation only).
- `orderRepositoryProvider` lives in the ViewModel file (unconfigured
  `StateError` convention) to avoid a viewmodel↔providers circular import.
- The localized demo address is passed by the page into
  `placeOrder(deliveryAddress:)`; ViewModels cannot read
  `AppLocalizations`. The address persists as order content.
- Checkout widgets consume a presentation-only `CheckoutSummaryItem`; the
  cart is read exclusively through `cartProvider` (no cart entity imports
  in checkout widgets).
- Orders are immutable in this slice (no UPDATE/DELETE policies).

## Previous Feature

Cart — Carrinho Local (Sprint 9 — Closed)

## Sprint 9 Status

Sprint 9 closed on 2026-07-03. The slice delivered a session-local cart:
pure-Dart `CartItem`/`Cart` aggregates, `CartNotifier` as the domain
boundary (no repository/datasource), the protected `/cart` route,
`CartPage` empty/non-empty states with a disabled checkout CTA,
product-details add/quantity integration with the localized
single-restaurant confirmation dialog, hero-header cart badges, and the
shared `formatPriceInCents` extraction. All seven real Trello checklists
on `https://trello.com/c/VFGNIm0O` are complete and the card is in `Done`.

## Sprint 9 Progress

- [x] Task 1 — domain: `CartItem`, `Cart`, `CartNotifier`, providers
  (commit `809f06a`).
- [x] Task 2 — 21 `cart*` ARB keys across pt_BR/pt/en plus regenerated
  localizations (commit `ae13fb3`).
- [x] Task 3 — `CartPage` UI and shared price formatter extraction
  (commit `2a3fecc`).
- [x] Task 4 — protected `/cart` route with router guard tests
  (commit `77a3c3c`).
- [x] Task 5 — product-details cart actions and dialog (commit `be94b00`).
- [x] Task 6 — `CartBadgeButton` on catalog hero headers (commit `da920ac`).
- [x] Task 7 — notifier unit tests, cart/product widget tests, guards,
  consolidated 64-test matrix (commit `a5fe3ce`).
- [x] Task 8 — docs/memory/technical-debt/Trello reconciliation.

## Architecture Notes (Sprint 9)

- Cart is write-driven session state: `Notifier<Cart>` in Riverpod is the
  domain boundary; no repository/datasource layer exists for this feature.
- Restaurant-mismatch is expected business flow, signaled by the
  `CartAddResult` return enum — never by exception (Finding A precedent).
- Presentation sections are dumb (no `WidgetRef`); only pages and the
  cart-owned smart widgets (`CartBadgeButton`, `_CartActionArea`) watch
  providers, always through derived selectors (`cartItemCountProvider`,
  `cartItemProvider`) to scope rebuilds.
- `CartItem.restaurantName` was deliberately removed (approved deviation):
  the dialog copy does not interpolate it and `ProductDetails` cannot
  source it. Reintroduce only with a real data source if Checkout needs it.
- Cart state is session-only by design; totals reset on restart.

## Previous Feature

Storage-Backed Catalog Media (Sprint 8 — Closed)

## Sprint 8 Status

Sprint 8 closed on 2026-06-11. The slice delivered Storage-backed catalog
media, shared URL resolution, shared presentation rendering, focused automated
validation, and authenticated visual QA on representative mobile and wide
layouts. All seven real Trello checklists are complete, final evidence is
recorded, and the card is in `Done`.

## Sprint 8 Progress

- [x] Task 1 — lock a deterministic 20-object media manifest against existing
  remote restaurant/product IDs.
- [x] Task 2 — generate, review, optimize, and version realistic WebP media
  outside the Flutter asset bundle.
- [x] Task 3 — create and validate the public-read `catalog-media` Storage
  foundation without client mutation policies.
- [x] Task 4 — upload and verify all manifest objects.
- [x] Task 5 — update existing restaurant/product rows to stable Storage object
  paths through a new migration.
- [x] Task 6 — add a shared data-layer public-media resolver and app
  composition.
- [x] Task 7 — resolve paths in Home, restaurant-details, and product-details
  remote datasources.
- [x] Task 8 — add a shared asset/network renderer and update existing
  presentation surfaces.
- [x] Task 9 — validate Storage, database, datasource, widget, security,
  guard, and browsing-flow contracts.
- [x] Task 10 — reconcile docs, memory, technical debt, and Trello after
  evidence exists.

## Architecture Notes (Sprint 8)

- Public bucket `catalog-media` is appropriate only for public catalog content.
- Postgres stores stable object paths, not complete public URLs.
- Existing `image_asset_path`/`imageAssetPath` names remain unchanged to avoid an
  unrelated cross-feature contract rename.
- A shared data-layer resolver owns bucket/public-URL knowledge.
- Widgets do not call Supabase and use a shared asset/network renderer.
- Generated files live under `supabase/seed-assets/catalog/`, not
  `assets/images/`, so they are not bundled into Flutter.
- Upload/update/delete remain administrative; Flutter stays read-only.
- Home promotion media, private media, signed URLs, image editing, variants,
  transformations, and external CDN remain out of scope.

## Validation Notes (Sprint 8)

- Focused datasource, widget, router, guard, and analyzer validation is green.
- The real Trello card `https://trello.com/c/PXq6TWpP` has all seven
  checklists complete, includes final validation evidence, and is in `Done`.
- Authenticated visual QA confirmed all 4 restaurant covers, all 16 catalog
  product images, and representative product details at 1280x900 and 390x844.
- The consolidated Dart MCP validation matrix passed 73 tests and focused
  analysis returned `No errors`.

## Active Plan

- `.ai/plans/2026-06-08-storage-backed-catalog-media-plan.md`
- `docs/project-management/SPRINT_8.md`

## Closure Notes

- Wait for an explicitly approved next feature before implementation.
- Keep future media replacements versioned to avoid stale cache behavior.

## Previous Closed Feature

Catalog Demo Coverage (Sprint 7) is closed and remains documented in
`.ai/plans/2026-06-03-catalog-demo-coverage-plan.md`,
`docs/project-management/SPRINT_7.md`, and the real Trello story
`https://trello.com/c/TLHgmJ02`.

## Sprint 7 Outcome

Sprint 7 closed on 2026-06-03. It expanded deterministic catalog seed coverage
for `burger_artisan_collective`, `pasta_roma`, `sushi_zen`, and `taco_harbor`;
the migration was applied to the active remote Supabase project, read-only
contracts passed focused validation, datasource regression coverage proves
non-burger catalog/product parsing, and governance/Trello evidence was
reconciled.

## Sprint 7 Planned Work

- Task 1 — audit current seed baseline and expected target counts. Completed: remote baseline confirmed 4 Home restaurants, with menu coverage only for `burger_artisan_collective` (4 categories, 4 items).
- Task 2 — add a dedicated catalog demo seed migration for `pasta_roma`, `sushi_zen`, and `taco_harbor`. Completed: `supabase/migrations/20260603183000_catalog_demo_coverage.sql` adds 9 categories and 12 items and passed rollback smoke validation.
- Task 3 — validate Supabase read contracts, RLS/grants, and datasource compatibility. Completed: remote migration `catalog_demo_coverage` applied, all four Home restaurants now have non-empty menu data, RLS/grants remain read-only for `authenticated` and denied to `anon`, and datasource-shaped queries load categories/items by `restaurant_id` plus product details by `id`.
- Task 4 — add focused multi-restaurant catalog/product regression coverage where existing tests do not prove the expanded data path. Completed: datasource tests now cover a non-burger `pasta_roma` restaurant catalog and the seeded non-burger product `sushi_zen_omakase_sampler`.
- Task 5 — reconcile docs, memory, technical debt, and Trello after validation evidence exists. Completed: Sprint 7 docs/memory/technical debt were reconciled, Trello parity was confirmed on the real card, and the card was moved to `🎉 Done`.

## Architecture Notes (Sprint 7)

- Data-readiness slice only; no new runtime UI behavior is planned.
- Use a new migration rather than editing already-applied Sprint 5/6 migrations.
- Reuse existing `restaurant_menu_categories` and `restaurant_menu_items` table contracts.
- Keep placeholder asset paths until a Storage-backed media slice is separately approved.
- Keep cart, checkout, customization, variants/add-ons, quantity, favorites, sharing, Storage, and Realtime out of scope.

## Sprint 7 Plan

- `.ai/plans/2026-06-03-catalog-demo-coverage-plan.md`
- `docs/project-management/SPRINT_7.md`

## Sprint 7 Closure Notes

- Sprint 7 is closed. Wait for an explicitly approved next slice before implementation.
- Keep future catalog/media work data-first and scoped through a new approved plan.
- Storage-backed media, cart/checkout/customization, variants/add-ons, quantity, favorites, sharing, ranking, pagination, recommendations, and Realtime remain deferred.

## Previous Closed Feature

Product Details Read-Only (Sprint 6) is closed and remains documented in `.ai/plans/2026-06-02-product-details-read-only-plan.md`, `docs/project-management/SPRINT_6.md`, and the real Trello story `https://trello.com/c/8amTB8F3`.

## Sprint 6 Completed Work

## Sprint 6 Completed Work

- Task 1 — immutable `ProductDetails` domain entity (Flutter/Supabase-free, value equality).
- Task 2 — `ProductDetailsDto` + Supabase datasource: query by `id` (PK) with `maybeSingle()`, nullable loader, `null` for not-found, `ProductDetailsRemoteException` only for malformed/Postgrest/Format failures.
- Task 3 — `ProductDetailsRepository` returning `Future<ProductDetails?>`; impl maps DTO→entity and propagates `null`.
- Task 4 — `productDetailsProvider` (`FutureProvider.family<ProductDetails?, String>`) + app composition/override mirroring `restaurant_details`.
- Task 5 — 11 localized `productDetails*` ARB keys (pt_BR template + pt/en) and regenerated `AppLocalizations`.
- Task 6 — `ProductDetailsPage` + sections (hero/back, name, semantic price, description; loading/error/not-found/success); catalog menu card gained optional `onProductSelected`.
- Task 7 — protected nested route `/restaurants/:restaurantId/products/:productId` and router→page→sections callback threading; auth-open + unauth-redirect router tests.
- Task 8 — focused product UI widget tests (5 states) + catalog card-tap delegation test; consolidated matrix 45/45.
- Task 9 — docs/memory/Trello reconciled; card moved to `🎉 Done`.

## Architecture Notes (Sprint 6)

- No new migration; reuses `restaurant_menu_items`.
- No dedicated ViewModel (read-only single load, per ADR-003).
- Not-found is modeled as `ProductDetails?` (`null`), keeping it out of exception-based control flow (Finding A).
- Route `restaurantId` is used only for back navigation/protection; product loads by `productId` alone (Finding C, accepted).

## Sprint 6 Plan

- `.ai/plans/2026-06-02-product-details-read-only-plan.md`
- `docs/project-management/SPRINT_6.md`
- Real Trello story (Done): `https://trello.com/c/8amTB8F3`

## Previous Closed Feature (Sprint 5)

Sprint 5 - Restaurant Details Remote Catalog is closed and remains documented in `.ai/plans/2026-06-02-restaurant-details-remote-catalog-plan.md`, `docs/project-management/SPRINT_5.md`, and the real Trello story `https://trello.com/c/1cBjEupB`.

## Feature

Home Discovery Interactions

## Status

Completed

## Current Step

Sprint 4 is closed. Wait for an explicitly approved next Home slice before implementation.

## Completed

- Home static feed scope approved: protected `/home`, typed local fixtures, prototype-aligned UI, Riverpod wiring, ARB copy, Theme Guard, and focused tests.
- Home technical plan generated in `.ai/plans/2026-06-01-home-static-feed-plan.md`.
- Task 1 completed — typed local Home entities finalized as immutable value models for category, promotion, and restaurant contracts without introducing repository/datasource abstractions.
- Task 2 completed — typed local Home feed fixtures and a read-only Riverpod provider now expose deterministic category, promotion, and featured-restaurant content without adding repository/datasource abstractions.
- Task 3 completed — `/home` is now the centralized protected authenticated destination, `/` is a root entry redirect, unauthenticated access to `/home` returns to sign-in, and reset-password recovery behavior remains unchanged.
- Task 4 completed — Home copy now lives in ARB catalogs with generated `AppLocalizations` accessors for address, search, categories, promo banner, featured section, restaurant metadata, and bottom navigation labels.
- Task 5 completed — `/home` now renders the approved static Home feed UI with responsive layout, localized presentation copy, semantic theme tokens, decorative asset fallbacks, and focused provider/router/guard validation.
- Task 6 completed — focused Home widget coverage now validates localized header/search copy, selected category state, promotion content, fixture restaurant rendering, selected Home navigation state, and deferred bottom-nav no-op behavior.
- Task 7 completed — Sprint 2, feature memory, and sprint memory were reconciled after validation; Trello parity was verified against the real card before final closure evidence was recorded.
- Sprint 2 project-management artifact generated in `docs/project-management/SPRINT_2.md`.
- Real Trello story `[FEAT] Home restaurant feed static UI` is synchronized with validated implementation evidence and guard parity (`https://trello.com/c/X3jAdpd2`).
- Home remains presentation-first: Supabase schema, repository, datasource, remote loading, search behavior, filters, and destination navigation are deferred.
- Sprint 3 planning approved — the next Home slice is a read-only Supabase-backed remote feed foundation with explicit grants, RLS, datasource/repository boundaries, async provider wiring, and focused validation.
- Home remote technical plan generated in `.ai/plans/2026-06-01-home-remote-feed-plan.md`.
- Sprint 3 project-management artifact generated in `docs/project-management/SPRINT_3.md`.
- Real Trello story `[FEAT] Home remote feed foundation` created in `✅ Ready` with Scope, Acceptance Criteria, Dependencies, Validation, Localization Guard, and Theme Guard checklists (`https://trello.com/c/bzxIa3wx`).
- Sprint 3 Task 1 completed — `HomeFeedContent` was promoted into the Home domain layer, `HomeRepository` now defines the feed contract, and the static Home provider reads through that repository boundary while keeping the validated UI behavior unchanged.
- Sprint 3 Task 2 completed — the Home remote feed Supabase foundation now has a migration for `restaurant_categories`, `restaurants`, `restaurant_category_links`, and `home_promotions`, with explicit `authenticated`/`service_role` `SELECT` grants, RLS read policies, and development seed data aligned with the current Home contract.
- Sprint 3 Task 3 completed — Home remote DTOs now parse Supabase rows into typed category, promotion, and restaurant payloads, and a dedicated Supabase datasource owns the Home feed queries, row orchestration, category-link aggregation, and explicit Home remote exceptions.
- Sprint 3 Task 4 completed — the Home repository is now asynchronous, the app composes a Supabase-backed Home datasource/repository at the composition root, and Riverpod now exposes an async Home feed provider with a fixture compatibility fallback so the validated UI remains stable while remote loading lands incrementally.
- Sprint 3 Task 5 completed — the Home page now renders explicit async loading, error, and empty states from the remote feed provider, all new copy is localized via ARB/AppLocalizations, and the new state UI uses semantic theme APIs/tokens without hardcoded palette values.
- Sprint 3 Task 6 completed — focused remote-feed regression coverage now proves remote success rendering in `HomePage`, preserves fixture compatibility fallback on async provider failure, and keeps datasource/repository/provider/widget coverage contract-oriented without touching production code.
- Sprint 3 Task 7 completed — Sprint 3 docs, feature/sprint memory, and the real Trello card were reconciled after final governance validation so the slice closes with implementation evidence, deferred scope notes, and checklist parity preserved.
- Sprint 4 planning approved — the next Home slice focuses on interactive discovery over the validated remote feed foundation, limited to search, category selection, localized empty-results behavior if needed, and focused provider/widget/guard validation.
- Home discovery technical plan generated in `.ai/plans/2026-06-01-home-discovery-interactions-plan.md`.
- Sprint 4 project-management artifact generated in `docs/project-management/SPRINT_4.md`.
- Sprint 4 Task 1 completed — Home discovery state ownership now lives in Riverpod through a dedicated discovery controller, and presentation can read a derived Home feed view contract that preserves the current unfiltered success behavior while decoupling widgets from future filter logic.
- Sprint 4 Task 2 completed — the derived Home discovery provider now applies deterministic category filtering plus normalized search matching over the existing remote feed aggregate, while keeping the default state behavior equivalent to the validated Sprint 3 success path.
- Sprint 4 Task 3 completed — the existing Home search input and category chips now drive the approved Riverpod discovery-state owner, the rendered restaurant set updates from the derived filtered feed contract, and the current successful Home layout remains structurally aligned with the approved prototype.
- Sprint 4 Task 4 completed — Home discovery now distinguishes a remote feed with content from an active search/filter combination with no matches, renders localized recovery feedback through ARB/AppLocalizations, and exposes a clear-filters action that resets the Riverpod discovery state plus the visible search field.
- Sprint 4 real Trello story `[FEAT] Home discovery interactions` was partially synchronized after Task 4 validation (`https://trello.com/c/5EUe5qOp`): Scope is `5/6`, Validation is `7/8`, Localization Guard is `7/7`, Theme Guard is `5/5`, Acceptance Criteria is `5/8`, and Dependencies is `6/6`; remaining global completion items stay open for Tasks 5-6.
- Sprint 4 Task 5 completed — focused provider regression coverage now proves discovery `reset()` restores the full-feed baseline after combined filters produce no matches, and Home widget coverage proves combined category + search no-match recovery restores restaurants, the empty search field, and the selected `Todos` chip.
- Sprint 4 Task 6 completed — Sprint 4 docs, plan, feature/sprint memory, technical-debt monitoring notes, and the real Trello card were reconciled after the consolidated regression matrix passed; final real-card parity is complete.
- Start Feature (teacher mode) for Theme Guard and UI/UX standardization
- technical plan generated in `.ai/plans/2026-05-22-theme-guard-uiux-standardization-plan.md`
- Task 1 completed — visual governance audit baseline documented in `.ai/plans/2026-05-22-theme-guard-uiux-standardization-plan.md`
- Task 2 completed — canonical Theme Guard contract verified and normalized across docs/templates/commands
- Task 3 completed — visual hardcoded guard test added and validated (`test/app/theme/no_hardcoded_visual_values_test.dart`)
- Task 4 completed — auth presentation slice normalized to semantic color APIs and visual guard baseline exception removed
- Task 5 completed — memory artifacts reconciled with strict Theme Guard enforcement and residual debt notes
- Post-review corrective pass completed — router/provider coupling, password-recovery lifecycle state, and remaining semantic color alignments fixed with focused tests and analyze green
- Project-management docs synchronized with Theme Guard parity updates (`DEFINITION_OF_DONE.md`, `PROJECT_MANAGEMENT_STANDARD.md`, `SPRINT_1.md`, `TRELLO_WORKFLOW.md`, `trello-map.md`)
- Trello JSON templates synchronized with Theme Guard checklist parity (`workflow`, `backlog`, `bug-triage`, `sprint`, `tech-debt`, `release`)
- Real Trello updates completed on board `FlowDelivery - Project Management`: governance/docs cards commented and moved to archive-equivalent done list
- Real Trello updates completed on board `FlowDelivery - Product Backlog`: Sprint 1/Auth epic status comments posted and Theme Guard architecture card moved from `✅ Ready` to `🎉 Done`
- Lightweight Trello/docs checklist parity guard added and committed (`a3c2291`)
- i18n pipeline plan generated in `docs/project-management/I18N_PIPELINE_PLAN.md`
- Product Backlog Trello card `[DEBT] Add ARB catalog parity guard` created and updated with real checklists plus validation evidence
- ARB catalog parity guard added in `test/app/l10n/arb_catalog_parity_test.dart`
- ARB catalog parity guard validates locale declarations, catalog key parity, template descriptions, and orphan metadata
- ARB catalog parity guard committed and pushed (`c7bf183`)
- Project-management docs generated for scalable i18n pipeline phase 2 (`docs/project-management/I18N_PIPELINE_PLAN.md`, `docs/project-management/DEFINITION_OF_DONE.md`)
- Product Backlog Trello card `[DEBT] Evolve i18n pipeline guardrails` created in `📥 Backlog` with real Scope, Acceptance Criteria, and Validation checklists
- Generated localization freshness guard added in `test/app/l10n/generated_localizations_freshness_test.dart`
- ARB catalog parity guard hardened to validate template placeholder metadata and translated placeholder parity
- I18n guard validation passed for hardcoded-copy, ARB catalog parity, and generated localization freshness tests
- Password recovery completion planning started for reset deep-link/session handling, reset-password route, new-password UI, Supabase password update, focused tests, and docs/Trello governance.
- Password recovery implementation slice completed: repository/datasource `updatePassword`, ViewModel reset state, `/reset-password` route, reset UI validation/feedback, ARB copy, generated localization update, and focused automated tests.
- Password recovery web redirect hardening completed: path URL strategy enabled, Supabase recovery requests now use explicit `/reset-password` redirect URLs, authenticated recovery sessions stay on the reset route, and real Supabase recovery-link QA validated the release web build renders the reset-password UI.
- Non-local mailbox deliverability runbook added in `docs/setup/SUPABASE_SETUP.md` and `docs/qa/QA_STRATEGY.md` for recovery email validation with external providers.
- Non-local mailbox deliverability runbook executed successfully with Outlook (Hotmail) QA inbox evidence: email arrival confirmed, recovery link target reached `http://localhost:3000/reset-password?...`, and password update completed with success feedback.
- Trello governance parity validation re-executed with `flutter test test/app/project_management/trello_guard_checklists_test.dart` and remains green (2 tests passed).
- Real Trello parity check executed via local `trello-desktop-mcp` for card `[DEBT] Evolve i18n pipeline guardrails` (`https://trello.com/c/BS6n5o0w`): checklists `Scope` (5/5), `Acceptance Criteria` (5/5), and `Validation` (4/4) are complete.
- Trello evidence comment added to the same card with the parity-check summary and local guard validation.
- Auth hardening post-review Tasks 1-4 completed: sign-out failure contract/state handling, explicit environment-based recovery redirect origin, granular reset-page selectors to reduce rebuild scope, and focused sign-out failure unit coverage.
- Auth provider migration strategy approved as phased rollout in `.ai/plans/2026-05-26-auth-hardening-post-review-plan.md` (parallel introduction, slice cutover, legacy removal) with validation gates and rollback criteria.
- Forgot-password copy consistency aligned with current implementation in `lib/l10n/app_pt.arb`, `lib/l10n/app_pt_BR.arb`, and `lib/l10n/app_en.arb`, with generated localizations refreshed.
- End-day focused validation after localization copy alignment passed: `test/features/auth/presentation/auth_pages_test.dart`, `test/app/l10n/arb_catalog_parity_test.dart`, and `test/app/l10n/generated_localizations_freshness_test.dart` (19 tests passed).
- Trello sync debt reduction reconciled in memory: versioned workflow docs already require real Trello parity checks, technical debt is classified as `Reduced / Monitoring`, and future Trello-governed work must validate real checklist state before using cards as delivery evidence.
- Auth UI placeholder parity reconciled in memory: `test/features/auth/presentation/auth_pages_test.dart` already verifies social auth placeholders are visible but disabled and the reports tab is visual copy rather than navigation; technical debt remains `Reduced / Monitoring`.
- Theme Guard future slices reconciled in memory: `home`, `feed`, and `cart` presentation slices still do not exist, no placeholder modules were created, and the global visual guard covers future `lib/features/**/presentation/**/*.dart` files as soon as approved slices add them.

- architecture context
- Riverpod decision
- Supabase decision
- GoRouter decision
- Codex guardrails
- reusable workflows
- routing conventions documented
- runtime navigation explicitly deferred until approved feature work
- feature planning workflow completed
- architecture approved
- technical plan generated in `.ai/plans/2026-05-19-authentication-plan.md`
- Sprint 1 generated in `docs/project-management/SPRINT_1.md`
- Task 1 — add auth dependencies intentionally
- Task 2 — centralize Supabase environment configuration
- Task 3 — model auth domain boundaries
- Task 4 — add auth state and ViewModel
- Task 5 — add Supabase datasource and repository implementation
- Task 6 — wire Riverpod providers
- Task 7 — add declarative routing and auth guard
- Task 8 — add Sign In and Sign Up UI
- Task 9 — initialize Supabase at app startup
- architecture alignment: created `lib/app/app.dart` as root app shell and kept `lib/main.dart` for bootstrap only
- Task 10 — Step 1: update current feature memory
- Task 10 — Step 2: update technical debt
- Task 10 — Step 3: update Supabase setup docs
- Task 10 — Step 4: run final focused validation
- Post-Sprint 1 stabilization — align Sign In UI/UX with `docs/ux/prototypes/auth-screen.png`
- Post-Sprint 1 stabilization — update auth page widget test for scroll visibility of the primary button
- Post-Sprint 1 stabilization validation — auth pages widget tests passed after UI update
- Post-Sprint 1 stabilization — extracted shared auth UI shell for Sign In and Sign Up pages
- Post-Sprint 1 stabilization — refined auth visual feedback states with reusable status banners
- Post-Sprint 1 stabilization — added forgot password route and page as a controlled UI entry point
- Post-Sprint 1 stabilization — disabled social sign-in and recovery primary action with explicit "coming soon" microcopy
- Post-Sprint 1 stabilization — implemented functional password recovery flow at repository/datasource/viewmodel boundaries
- Post-Sprint 1 stabilization — connected forgot password UI to real recovery request with success/error feedback
- Post-Sprint 1 stabilization — configured auth flow locale and copy in PT-BR
- Post-Sprint 1 stabilization — installed and applied Google Fonts for primary/secondary/mono typography tokens
- Post-Sprint 1 stabilization — translated user-safe auth runtime errors to PT-BR
- Post-Sprint 1 stabilization — centralized auth UI and auth error copy in Flutter gen-l10n ARB files and generated `AppLocalizations`
- Post-Sprint 1 stabilization — added a guard test that blocks hardcoded user-facing copy in presentation and route files
- Post-Sprint 1 stabilization validation — focused auth suites remain green after i18n refactor (17 tests)
- Post-Sprint 1 governance hardening — Localization Guard and Theme Guard workflows/templates aligned in project-management and Trello artifacts

## Pending / Deferred

- The Home remote-feed foundation slice is complete; future Home work requires a new explicitly approved slice.
- The Home discovery-interactions slice is complete; future Home work requires a new explicitly approved slice.
- Keep the Home implementation incremental and limited to the approved discovery-interactions slice.
- Keep profile/address persistence out of the discovery slice; the delivery-address placeholder remains local.
- Keep restaurant details, destination navigation, ranking, pagination, Storage-backed media, and Realtime out of scope until separate approved slices exist.
- Keep real Trello checklist item states manually aligned through the documented MCP workflow when cards are touched by active work.
- Preserve auth UI placeholder tests when touching sign-in/sign-up shell affordances, or promote placeholders through an approved feature plan before making them interactive.
- Keep future `home`, `feed`, and `cart` presentation slices on semantic theme APIs and app tokens from their first approved implementation task.
- Keep explicit Data API grants and RLS paired in any future Supabase Home migration because public-table exposure must not be assumed.

## Notes

Use `docs/architecture/ROUTING_CONVENTIONS.md` when planning future auth redirects and protected routes.
For Trello-governed work, follow `docs/project-management/TRELLO_WORKFLOW.md`: validate real card checklist parity with `trello_get_card_checklists` and add evidence comments when cards are used to close work.
Task 10 validation completed with Dart MCP:
- `analyze_files`: No errors.
- `run_tests`: All tests passed.
Post-Sprint stabilization validation:
- `test/features/auth/presentation/auth_pages_test.dart`: passed after UI parity update.
- `test/app/routes/app_router_test.dart`: passed with forgot-password route coverage.
- Focused auth validation suite: 22 tests passed for domain/data/presentation/providers/router slices.
- PT-BR/i18n stabilization validation:
- `test/features/auth/presentation/auth_pages_test.dart`: passed.
- `test/features/auth/presentation/auth_view_model_test.dart`: passed.
- `test/features/auth/data/auth_repository_impl_test.dart`: passed.
Theme Guard/UI-UX standardization validation:
- `flutter test test/app/theme/no_hardcoded_visual_values_test.dart`: passed with strict rules (no baseline exception).
- `flutter analyze lib/features/auth/presentation/widgets/auth_page_shell.dart`: no issues.
- Follow-up audit after approval: no `home/feed/cart` feature presentation slices exist yet; current `lib/features/**/presentation/**/*.dart` remains compliant.
Post-review corrective validation:
- `flutter test test/app/routes/app_router_test.dart test/features/auth/presentation/auth_view_model_test.dart test/features/auth/presentation/auth_pages_test.dart test/features/auth/presentation/auth_providers_test.dart test/app/theme/no_hardcoded_visual_values_test.dart`: passed.
- `flutter analyze` on updated auth presentation/viewmodel/router test files: no issues.
Auth hardening post-review consolidated validation:
- `flutter test test/features/auth/presentation/auth_view_model_test.dart test/features/auth/presentation/auth_pages_test.dart test/app/routes/auth_recovery_redirect_test.dart test/app/routes/app_router_test.dart`: 31 tests passed.
Trello/docs parity validation:
- `test/app/project_management/trello_guard_checklists_test.dart`: added and committed in `a3c2291`.
ARB catalog parity validation:
- Dart MCP `add_roots` executed before Dart validation.
- `test/app/l10n/no_hardcoded_ui_strings_test.dart` and `test/app/l10n/arb_catalog_parity_test.dart`: 5 tests passed.
- Dart MCP `analyze_files` on `test/app/l10n/arb_catalog_parity_test.dart`: no errors.
Scalable i18n pipeline validation:
- Dart MCP `add_roots` executed before Dart validation.
- `test/app/l10n/no_hardcoded_ui_strings_test.dart`, `test/app/l10n/arb_catalog_parity_test.dart`, and `test/app/l10n/generated_localizations_freshness_test.dart`: 9 tests passed.
- Dart MCP `analyze_files` on updated i18n guard tests: no errors.
Home static UI validation:
- `flutter analyze` on updated Home fixture/presentation/router test files: no issues.
- `flutter test test/features/home/presentation/home_feed_providers_test.dart test/app/routes/app_router_test.dart test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/theme/no_hardcoded_visual_values_test.dart`: all tests passed.
Home widget coverage validation:
- `flutter test test/features/home/presentation/home_page_test.dart test/features/home/presentation/home_feed_providers_test.dart test/app/routes/app_router_test.dart test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/theme/no_hardcoded_visual_values_test.dart`: all tests passed.
- `flutter analyze test/features/home/presentation/home_page_test.dart`: no issues.
Sprint 2 closure validation:
- `flutter test test/app/project_management/trello_guard_checklists_test.dart`: passed.
- Sprint 3 Task 1 validation:
- `dart analyze lib/features/home test/features/home`: no issues.
- `flutter test test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart`: all tests passed.
- Sprint 3 Task 2 validation:
- Transaction-scoped Supabase SQL smoke test confirmed the new Home tables, authenticated read policies, `SELECT`-only grants for `authenticated` and `service_role`, and development seed counts (`5` categories, `4` restaurants, `8` links, `1` promotion) without persisting changes to the shared project.
- Sprint 3 Task 3 validation:
- `dart analyze lib/features/home/data/dtos lib/features/home/data/datasources test/features/home/data`: no issues.
- `flutter test test/features/home/data/home_remote_datasource_test.dart`: all tests passed.
- Sprint 3 Task 4 validation:
- `dart analyze lib/features/home/domain/repositories/home_repository.dart lib/features/home/data/repositories/home_repository_impl.dart lib/features/home/presentation/providers/home_feed_providers.dart lib/app/di/app_providers.dart test/features/home/data/home_repository_impl_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart test/app/routes/app_router_test.dart`: no issues.
- `flutter test test/features/home/data/home_repository_impl_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart test/app/routes/app_router_test.dart`: all tests passed.
- Sprint 3 Task 5 validation:
- `flutter gen-l10n`: generated localizations refreshed for new Home async-state copy.
- `dart analyze lib/features/home/presentation/pages/home_page.dart test/features/home/presentation/home_page_test.dart lib/l10n/generated test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart test/app/l10n/generated_localizations_freshness_test.dart test/app/theme/no_hardcoded_visual_values_test.dart test/app/routes/app_router_test.dart`: no issues.
- `flutter test test/features/home/presentation/home_page_test.dart test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart test/app/l10n/generated_localizations_freshness_test.dart test/app/theme/no_hardcoded_visual_values_test.dart test/app/routes/app_router_test.dart`: all tests passed.
- Sprint 3 Task 6 validation:
- `dart analyze test/features/home/presentation/home_page_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/data/home_repository_impl_test.dart test/features/home/data/home_remote_datasource_test.dart test/features/home/presentation/home_feed_providers_test.dart`: no issues.
- `flutter test test/features/home/data/home_remote_datasource_test.dart test/features/home/data/home_repository_impl_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart test/app/routes/app_router_test.dart test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/theme/no_hardcoded_visual_values_test.dart`: all tests passed.
- Sprint 3 Task 7 validation:
- `flutter test test/app/project_management/trello_guard_checklists_test.dart`: passed after final documentation/Trello reconciliation.
- Sprint 4 Task 1 validation:
- `dart analyze lib/features/home/presentation/providers/home_feed_providers.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_feed_async_providers_test.dart`: no issues.
- `flutter test test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_feed_async_providers_test.dart`: all tests passed.
- Sprint 4 Task 2 validation:
- `dart analyze lib/features/home/presentation/providers/home_feed_providers.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_feed_async_providers_test.dart`: no issues.
- `flutter test test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_feed_async_providers_test.dart`: all tests passed.
- Sprint 4 Task 3 validation:
- `dart analyze lib/features/home/presentation/pages/home_page.dart lib/features/home/presentation/widgets/home_feed_header.dart lib/features/home/presentation/widgets/home_feed_sections.dart test/features/home/presentation/home_page_test.dart`: no issues.
- `flutter test test/features/home/presentation/home_page_test.dart`: all tests passed.
- Sprint 4 Task 4 validation:
- TDD RED confirmed before implementation: the new Home widget test failed because the localized discovery empty-results card did not exist yet.
- `flutter gen-l10n`: generated localizations refreshed for the Home discovery empty-results title, message, and clear-filters action.
- Dart MCP `analyze_files` on the touched Home presentation/provider files, generated localizations, and focused Home widget test: no errors.
- Dart MCP `run_tests` for `test/features/home/presentation/home_page_test.dart`, the three localization guards, and `test/app/theme/no_hardcoded_visual_values_test.dart`: 19 tests passed.
- `git diff --check`: no errors.
- Real Trello parity check executed for `[FEAT] Home discovery interactions` (`https://trello.com/c/5EUe5qOp`) after Task 4; only evidence-backed checklist items were completed and a validation comment was added.
- Sprint 4 Task 5 validation:
- Dart MCP `analyze_files` on `test/features/home/presentation/home_feed_providers_test.dart` and `test/features/home/presentation/home_page_test.dart`: no errors.
- Dart MCP `run_tests` for Home provider, async-provider, and widget suites: 22 tests passed.
- Dart MCP consolidated `run_tests` for Home provider/widget suites, `test/app/routes/app_router_test.dart`, localization guards, Theme Guard, and Trello Guard: 41 tests passed.
- `git diff --check`: no errors.
- Sprint 4 Task 6 validation:
- Real Trello parity rechecked for `[FEAT] Home discovery interactions` (`https://trello.com/c/5EUe5qOp`); all six checklists are complete and final evidence comment was added.
- `flutter test test/app/project_management/trello_guard_checklists_test.dart`: passed as part of the consolidated 41-test matrix.
