# Sprint 10 - Checkout (Pedido Persistido)

## Objective

Add a checkout flow to FlowDelivery so authenticated users can review their
cart on a dedicated `/checkout` page and confirm the order, persisting it to
Supabase — the project's first complete write path
(UI → ViewModel → Repository → Datasource → Supabase).

Reference plan:

- `.ai/plans/2026-07-06-checkout-plan.md`

Real Trello story:

- `[FEAT] Checkout — Pedido persistido (Sprint 10)` —
  `https://trello.com/c/yEdTwW5F`
  (board `FlowDelivery - Product Backlog`, list `✅ Ready`)

## Status

Planned. Awaiting explicit approval before Task 1 implementation.

## Sprint Goal

As a portfolio reviewer using FlowDelivery, I want to confirm an order from
the cart and see it persisted with a real order ID so that the app
demonstrates a credible, secure write path on top of the validated read-only
foundation.

## Story

As an authenticated user, I can open checkout from my cart, review my order
summary (items, subtotal, fixed delivery fee, total), see my delivery address
and payment method, and confirm the order — receiving a success confirmation
with my order ID while my cart is cleared.

## Estimate

- Story points: 13
- Confidence: Medium-High
- Main uncertainty: first write-path RLS/grants discipline and the atomic
  `create_order` function contract.

## Scope

- Migration: `orders` + `order_items` with explicit grants, RLS scoped to
  `auth.uid()`, constraints, and an atomic `create_order` Postgres function
  (SECURITY INVOKER) called via RPC;
- `OrderDraft`/`PlacedOrder` domain entities and `OrderRepository` contract
  with neutral failure codes;
- Order DTOs, `OrderRemoteDatasource` (RPC), `OrderRepositoryImpl`, and
  app-boundary composition;
- `CheckoutViewModel` (`Notifier<CheckoutState>`) with explicit
  idle/submitting/success/failure states, re-entry guard, and single cart
  clear on success;
- Protected `/checkout` route; `CartPage` checkout CTA enabled to navigate;
- `CheckoutPage` aligned with `docs/ux/prototypes/checkout.png`: order
  summary, localized demo delivery address, static "pay on delivery" payment
  method, confirm action, failure feedback with retry, success view with
  order ID;
- ARB copy for all checkout strings (pt_BR template, pt, en);
- Localization Guard and Theme Guard compliance;
- Focused tests: ViewModel unit tests, datasource/repository tests,
  CheckoutPage widget tests, CartPage CTA updates, router guard tests.

## Backlog

- [ ] Task 1 - migration: orders schema + atomic `create_order` function.
- [ ] Task 2 - domain: `OrderDraft`, `PlacedOrder`, `OrderRepository`.
- [ ] Task 3 - data: DTOs, RPC datasource, repository impl, composition.
- [ ] Task 4 - ARB copy for all checkout user-facing strings.
- [ ] Task 5 - `CheckoutViewModel` and providers.
- [ ] Task 6 - route `/checkout` + enable the CartPage CTA.
- [ ] Task 7 - `CheckoutPage` UI (summary, states, success).
- [ ] Task 8 - validation: unit, widget, router, and guard matrix.
- [ ] Task 9 - reconcile docs, memory, technical debt, and Trello.

## Acceptance Criteria

- [ ] `orders`/`order_items` exist with RLS and explicit grants; `anon` is
  denied; users cannot read other users' orders.
- [ ] Order creation is atomic through `create_order`; no partial inserts.
- [ ] Domain entities and repository contract are pure Dart with no
  Flutter/Supabase imports; failures are neutral codes mapped to copy only
  in presentation.
- [ ] `CheckoutViewModel` is tested without widgets, guards re-entry while
  submitting, and clears the cart exactly once on success.
- [ ] `/checkout` is protected; unauthenticated access redirects to sign-in.
- [ ] `CartPage` CTA navigates to `/checkout` when the cart is non-empty.
- [ ] `CheckoutPage` renders summary, submitting, failure, and success
  states with localized copy and the shared price formatter.
- [ ] All checkout strings are in ARB files consumed via `AppLocalizations`.
- [ ] No hardcoded colors or spacing values in new or updated presentation
  files.
- [ ] All existing guard tests remain green; the consolidated test matrix
  passes.

## Out of Scope

- Payment gateway integration (payment method is static "pay on delivery").
- Coupons, discounts, dynamic delivery fee, and distance calculation.
- Persisted profile/address data (address is a local demo placeholder).
- Order history (`/orders`), order tracking, Realtime, and status updates.
- Cart persistence across app restarts.
- Product customization, favorites, notifications, and analytics.
- Order editing or cancellation after placement.

## Dependencies

- Sprint 9 delivery: `Cart`/`CartItem`/`CartNotifier` and the disabled
  checkout CTA on `CartPage` — already available.
- Shared `formatPriceInCents` (`lib/shared/utils/price_formatter.dart`) —
  already available.
- App tokens and semantic theme APIs — already available.
- GoRouter auth guard pattern — already established.
- ARB pipeline with parity and freshness guards — already enforced.
- Remote Supabase project with seeded `restaurants` rows (FK target) —
  already deployed.

## Localization Guard

- [ ] All checkout user-facing strings are defined in `app_pt_BR.arb`
  (template) with `@` descriptions.
- [ ] All keys are present and translated in `app_pt.arb` and `app_en.arb`.
- [ ] Placeholder metadata is consistent across all three catalogs.
- [ ] `flutter gen-l10n` was run after every ARB change.
- [ ] `arb_catalog_parity_test.dart` and
  `generated_localizations_freshness_test.dart` are green.
- [ ] No hardcoded user-facing strings in any checkout or updated
  presentation file.

## Theme Guard

- [ ] No hardcoded `Color(...)`, `Colors.*`, or hex values in checkout or
  updated files.
- [ ] No hardcoded numeric spacing or radius values outside app token
  references.
- [ ] All interactive elements use semantic `ColorScheme` roles.
- [ ] `no_hardcoded_visual_values_test.dart` remains green.

## Risks

- First write path: RLS `INSERT` policies must be paired with explicit
  grants and validated against `anon` denial and cross-user reads.
- Partial-insert risk mitigated by the atomic `create_order` function; the
  datasource must not retry (double-order risk).
- Double-submit: confirm button disabled while submitting; ViewModel
  re-entry guard covered by unit tests.
- Server-side total validation inside `create_order` guards against
  client-math drift.
- Any Supabase read added in this slice must pass `ascending:` explicitly
  to `.order()`.

## Notes

- Prototype reference: `docs/ux/prototypes/checkout.png`.
- Fixed delivery fee is a domain constant this sprint; dynamic fees are a
  future slice.
- `CartItem.restaurantName` stays removed; `orders.restaurant_id` stores the
  reference and the summary renders item names only.
- Order history and tracking prototypes (`order-history.png`,
  `order-tracking.png`) belong to the next natural slice (Orders).
