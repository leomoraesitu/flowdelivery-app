# Payments Plan — Sprint 11

## Objective

Add a payment foundation to FlowDelivery so every placed order has a persisted,
auditable payment record linked to the order. Sprint 11 keeps the current
customer-facing method as pay on delivery, but moves payment out of static UI
copy and into the domain/database contract.

This is a foundation slice, not a real card/gateway integration.

## Product Story

As an authenticated user, I can confirm checkout with pay on delivery and see
that the order has a payment status, so the app demonstrates a credible order
plus payment lifecycle without pretending to process real money online.

As a reviewer, I can inspect the code and database model and see that future
gateway work has a clean boundary: Flutter does not hold secret keys, payment
state is explicit, and payment records are scoped by the authenticated user.

## Architectural Context

Sprint 10 delivered:

```text
CheckoutPage
  ↓
CheckoutViewModel
  ↓
OrderRepository
  ↓
OrderRemoteDatasource
  ↓
create_order RPC
  ↓
orders + order_items
```

Payments should extend that write path without bypassing the established
Clean Architecture direction:

```text
CheckoutPage
  ↓ confirm selected payment method
CheckoutViewModel
  ↓ OrderDraft(paymentMethod)
OrderRepository
  ↓
OrderRemoteDatasource
  ↓ create_order RPC
Supabase Postgres
  ↓ atomic insert
orders + order_items + payments
```

The key decision is to keep order creation atomic. A successful checkout should
not create an order without its payment record, and it should not create a
payment record without the order.

## Current Payment Scope

Supported in Sprint 11:

- `cash_on_delivery` / pay on delivery only;
- persisted `payments` row per order;
- explicit payment status such as `pending_on_delivery`;
- checkout and success UI reading payment concepts from domain state rather
  than relying on static-only copy;
- RLS-protected user ownership for payment reads;
- tests for schema contract, DTO mapping, repository mapping, ViewModel draft
  creation, and UI rendering.

Prepared but not implemented:

- Stripe or another real gateway;
- card capture;
- PaymentIntent creation;
- webhooks;
- refunds;
- saved payment methods;
- disputes or reconciliation dashboards.

## External Docs Checked

- Stripe Payment Intents guidance: create payment objects server-side, pass
  only client-safe secrets to the client, use idempotency, and monitor webhooks
  for final payment outcomes.
- Stripe webhook guidance: use HTTPS endpoints, verify signatures, respond
  quickly, and test locally with Stripe CLI.
- Supabase Edge Functions secrets guidance: secret/service-role keys may live
  in Edge Functions but must never be used in browser/client Flutter code.

Implication for this sprint: no gateway secrets, SDK setup, or webhook handler
belong in Flutter. A future gateway slice should use a server/Edge Function
boundary and a webhook-driven payment status update path.

## Scope

- Add a `payments` table linked 1:1 with `orders`;
- Update the `create_order` RPC to insert the payment row atomically;
- Extend checkout domain models with payment method/status/value objects;
- Extend DTO/repository mapping so `PlacedOrder` includes payment summary;
- Update checkout UI copy and success state to show payment status;
- Preserve the current pay-on-delivery behavior as the only selectable method;
- Add ARB keys for new payment copy;
- Validate RLS, grants, guards, and focused tests;
- Reconcile docs/memory/Trello after implementation evidence exists.

## Out of Scope

- Real online payments or payment authorization/capture;
- Stripe SDK dependency in Flutter;
- Supabase Edge Functions implementation;
- Stripe webhook endpoint;
- secret management beyond documenting the future boundary;
- payment retries, refunds, cancellations, disputes, invoices, receipts;
- order history, order tracking, Realtime status updates;
- profile/address persistence;
- dynamic delivery fee, coupons, taxes, tips.

## Proposed Database Contract

Create `public.payments`:

```sql
payments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null unique references public.orders(id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  amount_in_cents integer not null check (amount_in_cents >= 0),
  currency text not null default 'BRL' check (currency = 'BRL'),
  method text not null check (method = 'cash_on_delivery'),
  provider text not null default 'offline' check (provider = 'offline'),
  status text not null default 'pending_on_delivery'
    check (status = 'pending_on_delivery'),
  provider_reference text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
)
```

RLS:

- `authenticated` can `SELECT` only own payment rows;
- `authenticated` can `INSERT` only own payment rows for own orders;
- `anon` has no grants/policies;
- no `UPDATE`/`DELETE` in this slice.

RPC:

- `create_order(...)` remains `SECURITY INVOKER`;
- the function inserts `orders`, `order_items`, and `payments` in one
  transaction;
- returned payload adds `payment_id`, `payment_method`, `payment_status`, and
  `payment_amount_in_cents`;
- no automatic retry in the datasource.

## Domain Contract

Add or extend pure-Dart domain types:

```dart
enum PaymentMethod {
  cashOnDelivery,
}

enum PaymentStatus {
  pendingOnDelivery,
}

class PaymentSummary {
  final String id;
  final PaymentMethod method;
  final PaymentStatus status;
  final int amountInCents;
}

class PlacedOrder {
  final String id;
  final int totalInCents;
  final DateTime createdAt;
  final PaymentSummary payment;
}
```

`OrderDraft` should carry the selected `PaymentMethod`, defaulting to
`cashOnDelivery` for Sprint 11. Do not create a dedicated `PaymentRepository`
yet unless the implementation needs independent payment reads/writes. For this
slice, payment is part of the order placement transaction.

## Branch

Suggested branch:

`feat/payments-foundation`

## Estimate

- Story points: 8
- Confidence: Medium
- Main uncertainty: safely evolving the already-applied `create_order` RPC and
  updating all checkout tests without expanding into gateway scope.

## Tasks

### Task 1 — Migration: payments table + atomic order payment creation

**Goal:** Persist one payment record for every new order while preserving the
Sprint 10 atomic write path.

**File to create:**

- `supabase/migrations/<timestamp>_payments_foundation.sql`

**Work:**

- Create `payments` with named constraints and indexes;
- add explicit grants and RLS policies;
- replace/update `create_order(...)` so it inserts payment data atomically;
- extend the returned RPC payload with payment fields;
- keep `orders.payment_method` unchanged for backward-compatible history, or
  document its transitional duplication if retained.

**Validation:**

- Run migration SQL in a rollback transaction before applying;
- verify authenticated user can create an order and payment together;
- verify `anon` denial;
- verify cross-user payment read isolation;
- verify no orphan payment/order can be created through the public API;
- run Supabase advisors when available.

**Skills aplicáveis:**

- `supabase`
- `fd-supabase-architect`
- `fd-security-engineer`

**Localization Guard / Theme Guard:** not applicable.

### Task 2 — Domain: payment method/status and placed-order payment summary

**Goal:** Model payment state without Flutter or Supabase dependencies.

**Files likely to update/create:**

- `lib/features/checkout/domain/entities/order_draft.dart`
- `lib/features/checkout/domain/entities/placed_order.dart`
- optional `lib/features/checkout/domain/entities/payment_summary.dart`

**Work:**

- Add `PaymentMethod` and `PaymentStatus`;
- add `PaymentSummary`;
- extend `OrderDraft` with `paymentMethod`;
- extend `PlacedOrder` with `payment`;
- keep failure codes neutral and presentation-free.

**Validation:**

- focused Dart tests for equality/defaults if new standalone entities are added;
- analyze touched checkout domain files.

**Skills aplicáveis:**

- `fd-architect`
- `dart-add-unit-test`

**Localization Guard / Theme Guard:** not applicable.

### Task 3 — Data: DTO and repository mapping for payment payload

**Goal:** Map the extended RPC payload into domain objects without leaking
Supabase details upward.

**Files likely to update:**

- `lib/features/checkout/data/dtos/placed_order_dto.dart`
- `lib/features/checkout/data/datasources/order_remote_datasource.dart`
- `lib/features/checkout/data/repositories/order_repository_impl.dart`
- `test/features/checkout/data/order_remote_datasource_test.dart`
- `test/features/checkout/data/order_repository_impl_test.dart`

**Work:**

- Extend DTO parsing for `payment_id`, `payment_method`, `payment_status`, and
  `payment_amount_in_cents`;
- map remote string values to domain enums in the repository layer;
- keep malformed/unknown remote values as explicit remote/domain failures;
- ensure RPC payload sends the selected payment method.

**Validation:**

- datasource tests for list and map RPC payloads;
- malformed payment payload tests;
- repository mapping tests;
- analyze touched data files.

**Skills aplicáveis:**

- `fd-architect`
- `fd-code-reviewer`
- `dart-add-unit-test`

**Localization Guard / Theme Guard:** not applicable.

### Task 4 — ARB copy for payment status and method details

**Goal:** Add user-facing payment copy before updating widgets.

**Files to update:**

- `lib/l10n/app_pt_BR.arb`
- `lib/l10n/app_pt.arb`
- `lib/l10n/app_en.arb`

**Likely keys:**

- `checkoutPaymentStatusTitle`
- `checkoutPaymentStatusPendingOnDelivery`
- `checkoutPaymentMethodCashOnDeliveryDescription`
- `checkoutSuccessPaymentStatus`
- optional semantic labels/tooltips if the UI needs them.

**Also clean up:**

- Remove unused `cartCheckoutPlaceholder` if this task already touches all
  three ARB catalogs and regenerates localizations.

**Validation:**

- `flutter gen-l10n`;
- ARB catalog parity guard;
- generated localization freshness guard;
- hardcoded copy guard.

**Skills aplicáveis:**

- `flutter-setup-localization`
- `fd-code-reviewer`

**Localization Guard:** required.

**Theme Guard:** not applicable unless UI style changes in same task.

### Task 5 — ViewModel and checkout UI payment state

**Goal:** Show payment method/status as real checkout state while keeping the
UI dumb.

**Files likely to update:**

- `lib/features/checkout/presentation/viewmodels/checkout_view_model.dart`
- `lib/features/checkout/presentation/pages/checkout_page.dart`
- `lib/features/checkout/presentation/widgets/checkout_sections.dart`
- `test/features/checkout/presentation/checkout_view_model_test.dart`
- `test/features/checkout/presentation/checkout_page_test.dart`

**Work:**

- Build `OrderDraft(paymentMethod: PaymentMethod.cashOnDelivery)` in the
  ViewModel;
- render payment method description in the checkout payment section;
- render payment status in the success section;
- avoid putting payment rules in widgets;
- keep confirm disabled/re-entry behavior unchanged.

**Validation:**

- ViewModel tests prove the payment method is passed to the repository;
- page tests prove payment status/method copy is rendered;
- Localization Guard and Theme Guard remain green.

**Skills aplicáveis:**

- `fd-flutter-teacher`
- `fd-architect`
- `flutter-add-widget-test`

**Localization Guard:** required.

**Theme Guard:** required if visual styling changes.

### Task 6 — Full validation and regression matrix

**Goal:** Prove the payment foundation did not regress checkout/cart/router
behavior.

**Validation targets:**

- focused checkout domain/data/presentation tests;
- l10n guards;
- theme guard;
- router/cart checkout regressions if touched;
- full consolidated test matrix used by the project;
- focused analyzer for touched files.

**Skills aplicáveis:**

- `fd-qa-engineer`
- `fd-code-reviewer`
- `dart-run-static-analysis`

### Task 7 — Docs, memory, technical debt, and Trello reconciliation

**Goal:** Persist implementation evidence only after validation passes.

**Files likely to update:**

- `docs/project-management/SPRINT_11.md`
- `docs/setup/SUPABASE_SETUP.md`
- `.ai/memory/current_feature.md`
- `.ai/memory/current_sprint.md`
- `.ai/memory/technical_debt.md`

**Trello:**

- Create/update real card `[FEAT] Payments foundation (Sprint 11)`;
- add Scope, Acceptance Criteria, Dependencies, Localization Guard, Theme Guard,
  and Validation checklists;
- only complete checklist items after local evidence exists;
- verify real Trello checklist parity before closure.

**Skills aplicáveis:**

- `fd-product-owner`
- `fd-trello-manager`
- `fd-code-reviewer`

## Acceptance Criteria

- [ ] Every new order creates exactly one linked payment row in the same
  transaction as `orders` and `order_items`.
- [ ] `payments` has RLS enabled, explicit grants, `anon` denial, and
  cross-user read isolation.
- [ ] Payment concepts are represented by pure-Dart domain types.
- [ ] Supabase RPC/data details stay inside datasource/repository layers.
- [ ] `PlacedOrder` includes a payment summary mapped from the RPC response.
- [ ] Checkout success UI shows payment status using ARB copy.
- [ ] No real card/gateway/secret handling is introduced in Flutter.
- [ ] Localization Guard and Theme Guard remain green.
- [ ] Focused checkout tests and the consolidated regression matrix pass.
- [ ] Docs/memory/Trello are reconciled only after validation evidence exists.

## Risks

- Evolving an already-applied RPC can break checkout if DTO and SQL return
  payloads drift.
- Keeping both `orders.payment_method` and `payments.method` creates temporary
  duplication; document it clearly or remove the old field only in a separately
  approved migration if the blast radius is acceptable.
- Payment naming can imply real processing. UI copy must be honest:
  "payment pending on delivery", not "paid".
- Adding a real gateway too early would require Edge Functions, webhooks,
  secrets, idempotency, and manual QA beyond this sprint.
- Any future `UPDATE` to payment status needs both `USING` and `WITH CHECK`
  RLS policies, or a carefully designed server-side webhook path.

## Technical Debt Watch

- `cartCheckoutPlaceholder` is still an accepted unused ARB key after Sprint 10;
  remove it in Task 4 if ARBs are already being edited.
- `orders.payment_method` may become transitional duplication after the
  `payments` table exists. Do not remove it during Task 1 unless the migration
  and DTO blast radius are explicitly approved.
- Payment gateway integration should become a separate Sprint/ADR candidate if
  Stripe or another provider is selected.

## Future Gateway Slice Notes

If a later sprint implements Stripe:

- create payment intent/session server-side, not in Flutter;
- keep `STRIPE_SECRET_KEY` and webhook signing secret in Supabase Edge Function
  secrets or another server environment;
- store gateway IDs and status in `payments`;
- update status from verified webhooks;
- design idempotency around the order/payment ID;
- never store card details, sensitive PII, or secret keys in app data.
