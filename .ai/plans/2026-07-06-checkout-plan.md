# Checkout Plan — Sprint 10

## Objective

Add a checkout flow to FlowDelivery so authenticated users can review their
cart on a dedicated `/checkout` page and confirm the order, persisting it to
Supabase — the project's first complete write path
(UI → ViewModel → Repository → Datasource → Supabase INSERT).

## Architectural Context

Sprint 9 delivered a session-local cart with `CartNotifier` (`Notifier<Cart>`)
as the domain boundary and a disabled checkout CTA on `CartPage`. Every
Supabase interaction so far is read-only (`SELECT` for `authenticated`).

Checkout introduces the first write capability:

```text
CheckoutPage
  ↓ confirm
CheckoutViewModel (Notifier<CheckoutState>)   ← loading / error / success
  ↓ placeOrder(draft)
OrderRepository (domain contract)
  ↓
OrderRemoteDatasource
  ↓ .rpc('create_order', ...)
Supabase Postgres  ← atomic insert into orders + order_items
```

Unlike the cart (pure session state, no data layer), checkout is a real
persistence feature and therefore gets the full Clean Architecture chain and a
dedicated ViewModel (write action with explicit submitting/error/success
states — ADR-003's "no ViewModel for read-only single load" does not apply).

### Atomicity Decision

An order spans two tables (`orders` + `order_items`). Two sequential client
inserts could leave a partial order on failure. The plan uses a Postgres
function `create_order(...)` (SECURITY INVOKER, so RLS still applies) called
via `.rpc()` from the datasource. The function inserts the order row and all
item rows in one transaction and returns the created order.

### Sprint 9 Carry-Over Decisions

- Cart persistence across restarts stays deferred (Planned Scope): with the
  order persisted, cart loss on restart no longer hurts the demo.
- `CartItem.restaurantName` stays removed. The order summary renders item
  names only; `orders.restaurant_id` stores the reference. Reintroduce the
  name only if a future slice needs it with a real data source.

## Scope

- Migration: `orders` and `order_items` tables with explicit grants, RLS
  (`INSERT`/`SELECT` scoped to `auth.uid()`), constraints, and the
  `create_order` function for atomic order creation;
- `Order`/`OrderDraft` domain entities and `OrderRepository` contract;
- Order DTOs, `OrderRemoteDatasource` (RPC call), `OrderRepositoryImpl`,
  app-level composition;
- `CheckoutViewModel` with explicit idle/submitting/success/error state;
- Protected `/checkout` route; `CartPage` checkout CTA enabled to navigate;
- `CheckoutPage` aligned with `docs/ux/prototypes/checkout.png`: order
  summary (items, quantities, subtotal, fixed delivery fee, total), local
  demo delivery address, static "pay on delivery" payment method, confirm
  button, success state with order ID, cart cleared on success;
- ARB copy for all checkout strings (pt_BR template, pt, en);
- Localization Guard and Theme Guard compliance;
- Focused tests: ViewModel unit tests, datasource/repository tests,
  CheckoutPage widget tests, router guard tests.

## Out of Scope

- Payment gateway integration (payment method is static "pay on delivery");
- Coupons, discounts, dynamic delivery fee, distance calculation;
- Persisted profile/address data (address is a local demo placeholder);
- Order history (`/orders` route), order tracking, Realtime, status updates;
- Cart persistence across restarts (`shared_preferences` or Supabase);
- Product customization, favorites, notifications, analytics;
- Order editing/cancellation after placement.

## Risks

- First write path: RLS `INSERT` policies must be paired with explicit grants
  and validated against `anon` denial — write security is new territory.
- Partial-insert risk is mitigated by the `create_order` function; the
  datasource must treat RPC failure as a single atomic failure (no retry
  loops that could duplicate orders).
- Double-submit: the confirm button must be disabled while submitting.
- Price integrity: totals are computed in the domain from cart state, and the
  function re-derives/validates totals server-side from the submitted items
  (defense in depth without trusting only client math).
- `.order()` reads (if any) must pass `ascending:` explicitly.

## Branch

`feat/checkout` — created from `develop`.

## Tasks

---

### Task 1 — Migration: orders schema + atomic create_order function

**Goal:** Create the write-side database foundation with the same
grants+RLS discipline as the read-only migrations.

**File to create:**
- `supabase/migrations/<timestamp>_checkout_orders_foundation.sql`

**Schema (contract, refine during implementation):**

```sql
orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id),
  restaurant_id text not null references public.restaurants(id),
  subtotal_in_cents integer not null check (subtotal_in_cents >= 0),
  delivery_fee_in_cents integer not null check (delivery_fee_in_cents >= 0),
  total_in_cents integer not null check (total_in_cents >= 0),
  payment_method text not null check (payment_method = 'cash_on_delivery'),
  delivery_address text not null,
  status text not null default 'placed' check (status = 'placed'),
  created_at timestamptz not null default now()
)

order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id text not null,
  product_name text not null,          -- snapshot at purchase time
  unit_price_in_cents integer not null check (unit_price_in_cents >= 0),
  quantity integer not null check (quantity >= 1)
)
```

**Security:**
- Enable RLS on both tables.
- `authenticated`: `INSERT` with `with check (user_id = auth.uid())` on
  `orders`; `order_items` insertable only for own orders; `SELECT` scoped to
  own orders. Explicit `GRANT` statements paired with every policy.
- `anon`: no grants, no policies (verify denial).
- `create_order(restaurant_id, delivery_address, items jsonb) returns ...`:
  SECURITY INVOKER, single transaction, validates non-empty items and
  server-side total consistency, returns the created order id/summary.

**Validation:**
- Supabase MCP: run migration SQL in a rollback transaction first (Sprint 7
  precedent), then `apply_migration` to the remote project.
- Verify: `authenticated` can create and read own orders via `create_order`;
  `anon` is denied; a user cannot read another user's orders.

**Localization Guard / Theme Guard:** none (SQL only).

---

### Task 2 — Domain: OrderDraft, Order, and OrderRepository contract

**Goal:** Define the checkout domain without Flutter/Supabase imports.

**Files to create:**
- `lib/features/checkout/domain/entities/order_draft.dart`
- `lib/features/checkout/domain/entities/placed_order.dart`
- `lib/features/checkout/domain/repositories/order_repository.dart`

**Contracts:**

```dart
// OrderDraft — built from Cart + checkout inputs; immutable, value equality
class OrderDraft {
  final String restaurantId;
  final List<OrderDraftItem> items;   // productId, name, unitPriceInCents, quantity
  final int subtotalInCents;
  final int deliveryFeeInCents;       // fixed app constant this sprint
  final int totalInCents;
  final String deliveryAddress;
}

// PlacedOrder — result of a successful placement
class PlacedOrder {
  final String id;
  final int totalInCents;
  final DateTime createdAt;
}

abstract interface class OrderRepository {
  Future<PlacedOrder> placeOrder(OrderDraft draft);
}
```

- Failures surface as a dedicated exception with a neutral code
  (e.g. `OrderPlacementException(code)`), mapped to copy only in
  presentation (Finding A: no business flow via exceptions — but a failed
  INSERT is an error, not business flow, so an exception is correct here).
- Fixed delivery fee lives as a domain constant (single source), not in UI.

**Validation:** `dart analyze lib/features/checkout` + unit tests (Task 8).
**Localization Guard / Theme Guard:** none (pure domain).

---

### Task 3 — Data: DTOs, RPC datasource, repository impl, composition

**Goal:** Implement the write data layer and compose it at the app boundary.

**Files to create:**
- `lib/features/checkout/data/dtos/placed_order_dto.dart`
- `lib/features/checkout/data/datasources/order_remote_datasource.dart`
- `lib/features/checkout/data/repositories/order_repository_impl.dart`

**Files to update:**
- `lib/app/di/app_providers.dart` (composition, mirroring existing features)

**Rules:**
- Datasource owns the `.rpc('create_order', params: ...)` call and payload
  shaping (items serialized as jsonb); it maps Postgrest/Format failures to
  explicit remote exceptions (mirroring existing datasource conventions).
- Repository maps DTO → `PlacedOrder` and remote exceptions → domain
  exception codes. No retry logic (double-order risk).
- No Supabase types leak above the datasource.

**Validation:**
- `dart analyze lib/features/checkout lib/app/di`
- Datasource/repository tests with fake RPC loaders (Task 8).

**Localization Guard / Theme Guard:** none (data layer).

---

### Task 4 — ARB copy for all checkout strings

**Goal:** Add all checkout user-facing strings to the three catalogs before
any widget references them (no-accent PT copy per catalog convention).

**Files to update:**
- `lib/l10n/app_pt_BR.arb` (template, with `@` descriptions)
- `lib/l10n/app_pt.arb`
- `lib/l10n/app_en.arb`

**Keys (approximate — refine during implementation):**
`checkoutTitle`, `checkoutDeliveryAddressTitle`, `checkoutDemoAddress`,
`checkoutPaymentTitle`, `checkoutPaymentCashOnDelivery`,
`checkoutSummaryTitle`, `checkoutSubtotal`, `checkoutDeliveryFee`,
`checkoutTotal`, `checkoutConfirmAction`, `checkoutSubmitting`,
`checkoutErrorTitle`, `checkoutErrorMessage`, `checkoutRetryAction`,
`checkoutSuccessTitle`, `checkoutSuccessMessage` (with order-id placeholder),
`checkoutSuccessBackToHome`, plus semantic labels as needed.

**After adding keys:** `flutter gen-l10n`, then ARB parity + generated
freshness guards.

---

### Task 5 — CheckoutViewModel and providers

**Goal:** Own the checkout submission state in Riverpod, outside widgets.

**Files to create:**
- `lib/features/checkout/presentation/viewmodels/checkout_view_model.dart`
- `lib/features/checkout/presentation/providers/checkout_providers.dart`

**Contract:**

```dart
sealed class CheckoutState {}         // idle | submitting | success(PlacedOrder) | failure(code)

class CheckoutViewModel extends Notifier<CheckoutState> {
  Future<void> placeOrder();          // builds OrderDraft from cartProvider,
                                      // guards re-entry while submitting,
                                      // clears cart via CartNotifier on success
}
```

- Draft building (cart → `OrderDraft`, fee, totals) lives here, not in UI.
- On success: `ref.read(cartProvider.notifier).clear()` exactly once.
- Re-entry guard: `placeOrder()` is a no-op while submitting.

**Validation:** widget-free ViewModel unit tests with a fake repository
(success, failure code mapping, re-entry guard, cart cleared once).

---

### Task 6 — Route /checkout + enable the CartPage CTA

**Goal:** Register `/checkout` as protected and turn the placeholder CTA into
real navigation.

**Files to update:**
- `lib/app/routes/app_routes.dart` — `checkoutName`, `checkoutPath`
- `lib/app/routes/app_router.dart` — `GoRoute`, protected-route coverage
- `lib/features/cart/presentation/pages/cart_page.dart` (and/or sections) —
  enable the checkout CTA when the cart is non-empty; remove placeholder
  microcopy behavior

**Validation:**
- Router tests: authenticated reaches `/checkout`; unauthenticated redirects
  to sign-in.
- Cart widget test updates: CTA enabled when non-empty, triggers navigation
  callback; existing disabled-CTA assertions updated intentionally.

---

### Task 7 — CheckoutPage UI (summary, states, success)

**Goal:** Build `CheckoutPage` aligned with `docs/ux/prototypes/checkout.png`
with dumb sections and a single smart page.

**Files to create:**
- `lib/features/checkout/presentation/pages/checkout_page.dart`
- `lib/features/checkout/presentation/widgets/checkout_sections.dart`

**UI structure:**

```
CheckoutPage (Scaffold)
├── Header: back + localized title
├── Delivery address card (localized demo address)
├── Payment method card (static "pay on delivery", selected, non-interactive)
├── Order summary: item rows (name, qty, price via formatPriceInCents),
│   subtotal, delivery fee, total
├── Confirm button: idle → enabled; submitting → disabled + progress;
│   empty cart → page redirects/renders empty-safe state
├── [failure] localized error feedback + retry
└── [success] success view with order ID + back-to-home action
```

**Rules:**
- Sections are dumb (no `WidgetRef`); the page watches
  `checkoutViewModelProvider` and derived cart selectors only.
- Prices via shared `formatPriceInCents`; strings via `AppLocalizations`;
  visuals via semantic `ColorScheme` + app tokens.

**Validation:** CheckoutPage widget tests (summary render, submitting
disables button, failure feedback, success view + cart cleared).

---

### Task 8 — Validation: unit, widget, router, and guard matrix

**Goal:** Prove the full slice and keep every existing suite green.

**Tests to add/extend:**
- `test/features/checkout/presentation/checkout_view_model_test.dart`
- `test/features/checkout/data/order_remote_datasource_test.dart`
- `test/features/checkout/data/order_repository_impl_test.dart`
- `test/features/checkout/presentation/checkout_page_test.dart`
- `test/features/cart/presentation/cart_page_test.dart` (CTA behavior)
- `test/app/routes/app_router_test.dart` (`/checkout` guard)

**Guards:** hardcoded-copy, ARB parity, generated freshness, Theme Guard,
Trello Guard — all green.

**Consolidated command:**
```bash
flutter test \
  test/features/checkout/ \
  test/features/cart/ \
  test/app/routes/app_router_test.dart \
  test/app/l10n/ \
  test/app/theme/no_hardcoded_visual_values_test.dart \
  test/app/project_management/trello_guard_checklists_test.dart
```

Run Dart/Flutter commands through Dart MCP (`add_roots` first).

---

### Task 9 — Reconcile docs, memory, technical debt, and Trello

**Goal:** Close Sprint 10 with governance evidence.

- Update `.ai/memory/current_feature.md`, `.ai/memory/current_sprint.md`,
  `.ai/memory/technical_debt.md` (write-path precedent, cart persistence
  status, any accepted deviations).
- Update `docs/project-management/SPRINT_10.md` with final status.
- Update `docs/setup/SUPABASE_SETUP.md` with the orders migration runbook.
- Validate real Trello checklist parity via MCP before moving the card to
  `🎉 Done`; record final validation evidence as a card comment.

## Acceptance Criteria

- `orders`/`order_items` exist with RLS + explicit grants; `anon` is denied;
  users cannot read others' orders; creation is atomic via `create_order`.
- Domain entities and repository contract are pure Dart (no Flutter/Supabase
  imports); failures are neutral codes mapped to copy only in presentation.
- `CheckoutViewModel` is tested without widgets, guards re-entry, and clears
  the cart exactly once on success.
- `/checkout` is protected; unauthenticated access redirects to sign-in.
- `CartPage` CTA navigates to `/checkout` when the cart is non-empty.
- `CheckoutPage` renders summary/submitting/failure/success states with
  localized copy and the shared price formatter.
- All checkout strings live in ARB catalogs consumed via `AppLocalizations`.
- No hardcoded visual values in new or updated presentation files.
- All existing guard tests remain green; consolidated matrix passes.

## Deferred

- Order history (`/orders`), tracking, Realtime, status transitions — next
  natural slice (Orders).
- Payment gateway, coupons, dynamic delivery fee.
- Persisted profile/address data.
- Cart persistence across restarts (Planned Scope / Monitoring).
- `CartItem.restaurantName` reintroduction (only with a real data source).
