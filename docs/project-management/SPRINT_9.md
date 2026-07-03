# Sprint 9 - Cart (Carrinho Local)

## Objective

Add a session-local shopping cart to FlowDelivery, enabling authenticated users
to add products to the cart from the product details screen, review and adjust
their order, and see a running total — without any remote persistence or checkout
behavior.

Reference plan:

- `.ai/plans/2026-06-24-cart-plan.md`

Real Trello story:

- `[FEAT] Cart — Carrinho local (Sprint 9)` — `https://trello.com/c/VFGNIm0O`
  (board `FlowDelivery - Product Backlog`, list `🎉 Done`)

## Status

Closed (2026-07-03). All 8 tasks implemented, validated, and committed
task-by-task on `feat/cart`. Consolidated regression matrix passed with 64
tests. The real Trello card is fully checked and in `🎉 Done`.

Task commits: `809f06a` (domain), `ae13fb3` (ARB), `2a3fecc` (CartPage UI +
shared price formatter), `77a3c3c` (route/guard), `be94b00` (product-details
integration), `da920ac` (badge), `a5fe3ce` (tests).

Approved deviations from the plan:

- PT copy without accents, matching the existing catalog convention.
- Extra `cartClearAction` ARB key for the cart AppBar clear affordance.
- `CartItem.restaurantName` removed — the dialog copy does not interpolate
  it and `ProductDetailsPage` cannot source it (`ProductDetails` carries
  only `restaurantId`).
- Badge placed as a floating hero-header action (neither detail page has an
  AppBar); navigation callbacks injected by the router (`onOpenCart`).

## Sprint Goal

As a portfolio reviewer using FlowDelivery, I want to add products to a cart and
see my running order total so that the app demonstrates a credible, interactive
shopping experience beyond read-only browsing.

## Story

As an authenticated user, I can add a product to my cart from the product details
screen, view all cart items with quantities and prices, adjust quantities, remove
items, and see my order total — so that I can prepare an order before proceeding
to checkout.

## Estimate

- Story points: 8
- Confidence: High
- Main uncertainty: single-restaurant dialog UX clarity and badge scoping to avoid
  excessive rebuilds.

## Scope

- `CartItem` and `Cart` domain entities (pure Dart, immutable, value equality);
- `CartNotifier` (`Notifier<Cart>`) with add, remove, update-quantity, clear, and
  single-restaurant enforcement;
- `cartProvider` and derived `cartItemCountProvider`;
- Route `/cart` — protected, authenticated;
- `CartPage` — empty state and non-empty state (item list, quantity controls,
  subtotal per item, total, disabled checkout CTA);
- "Add to cart" action on `ProductDetailsPage` with in-cart quantity controls;
- Single-restaurant confirmation dialog when adding from a different restaurant;
- Cart item count badge on `RestaurantDetailsPage` and `ProductDetailsPage` AppBars;
- ARB copy for all cart strings (pt_BR template, pt, en);
- Localization Guard and Theme Guard compliance;
- Focused tests: CartNotifier unit tests + CartPage and ProductDetailsPage widget
  tests + router guard tests.

## Backlog

- [x] Task 1 - domain: CartItem, Cart entities, and CartNotifier.
- [x] Task 2 - ARB copy for all cart user-facing strings.
- [x] Task 3 - CartPage UI (empty and non-empty states).
- [x] Task 4 - route `/cart` and auth guard.
- [x] Task 5 - integrate ProductDetailsPage with CartNotifier.
- [x] Task 6 - cart badge in navigation area.
- [x] Task 7 - validation: CartNotifier unit tests, CartPage widget tests, guards.
- [x] Task 8 - reconcile docs, memory, technical debt, and Trello.

## Acceptance Criteria

- [x] `CartItem` and `Cart` are pure Dart with value equality and no Flutter or
  Supabase imports.
- [x] `CartNotifier` is tested in isolation without widgets.
- [x] Cart route `/cart` is protected; unauthenticated access redirects to sign-in.
- [x] `CartPage` renders the empty and non-empty states with localized copy.
- [x] Single-restaurant constraint is enforced with a localized confirmation dialog.
- [x] "Proceed to checkout" CTA is visible but disabled with placeholder copy.
- [x] All cart strings are in ARB files and consumed via `AppLocalizations`.
- [x] No hardcoded colors or spacing values in cart or updated presentation files.
- [x] All existing guard tests remain green.
- [x] Consolidated test matrix passes for all new and updated test files.

## Out of Scope

- Cart persistence across app restarts (`shared_preferences` or Supabase).
- Checkout, payment, order creation, and delivery estimation.
- Product customization (variants, add-ons, special instructions).
- Coupon and discount codes.
- Delivery fee display and address selection on the cart page.
- Favorites, profile, Realtime, and any other feature domain.

## Dependencies

- Sprint 8 delivery: `ProductDetails` entity with `id`, `restaurantId`, `name`,
  `priceInCents`, `imageAssetPath` — already available.
- `AppMediaImage` shared widget — already available (`lib/shared/presentation/widgets/`).
- App tokens (`AppSpacing`, `AppRadius`, `AppSizes`) — already available.
- GoRouter auth guard pattern — already established in `app_router.dart`.
- ARB pipeline with parity and freshness guards — already enforced.

## Localization Guard

- [x] All cart user-facing strings are defined in `app_pt_BR.arb` (template) with
  `@@description`.
- [x] All keys are present and translated in `app_pt.arb` and `app_en.arb`.
- [x] Placeholder metadata is consistent across all three catalogs.
- [x] `flutter gen-l10n` was run after every ARB change.
- [x] `arb_catalog_parity_test.dart` and `generated_localizations_freshness_test.dart`
  are green.
- [x] No hardcoded user-facing strings in any cart or updated presentation file.

## Theme Guard

- [x] No hardcoded `Color(...)`, `Colors.*`, or hex values in cart or updated files.
- [x] No hardcoded numeric spacing or radius values outside app token references.
- [x] All interactive elements use semantic `ColorScheme` roles.
- [x] `no_hardcoded_visual_values_test.dart` remains green.

## Risks

- Single-restaurant dialog must clearly communicate the intentional constraint to
  demo reviewers.
- `cartItemCountProvider` must be a derived selector to prevent full-page rebuilds
  on cart changes.
- Price formatting duplication — audit whether extracting to `lib/shared/` is
  warranted during Task 3.
- Cart badge placement must not conflict with existing AppBar affordances.

## Notes

- Prototype reference: `docs/ux/prototypes/cart.png`.
- Delivery address section visible in the prototype is deferred (Checkout sprint).
- Promo code section visible in the prototype is deferred (Checkout sprint).
- Delivery fee visible in the prototype is deferred (Checkout sprint).
- Cart is session-only; total resets on hot restart — expected and acceptable for
  this sprint.
