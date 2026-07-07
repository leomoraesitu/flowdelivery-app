# Sprint 11 - Payments Foundation

## Objective

Add a payment foundation to FlowDelivery so every placed order has a persisted,
auditable payment record linked to the order. Sprint 11 keeps the
customer-facing method as pay on delivery, but moves payment from static UI
copy into the domain and database contract.

Reference plan:

- `.ai/plans/2026-07-07-payments-plan.md`

Real Trello story:

- `[FEAT] Payments foundation (Sprint 11)` —
  `https://trello.com/c/cQDUVgYR`
  (board `FlowDelivery - Product Backlog`, list `✅ Ready`).

## Status

Planned / Ready. The feature branch is `feat/payments-foundation`. No
implementation tasks have been completed yet.

## Sprint Goal

As a portfolio reviewer using FlowDelivery, I want each checkout order to have
a clear payment record and status so the app demonstrates a credible
order-plus-payment lifecycle without pretending to process real online
payments.

## Story

As an authenticated user, I can confirm checkout with pay on delivery and see
that the order has a payment status, while the system persists a payment row
linked to my order.

## Estimate

- Story points: 8
- Confidence: Medium
- Main uncertainty: safely evolving the already-applied `create_order` RPC and
  updating checkout tests without expanding into real gateway scope.

## Scope

- Add a `payments` table linked 1:1 with `orders`.
- Update the `create_order` RPC to insert the payment row atomically.
- Extend checkout domain models with payment method/status/value objects.
- Extend DTO/repository mapping so `PlacedOrder` includes a payment summary.
- Update checkout UI copy and success state to show payment status.
- Preserve `cash_on_delivery` / pay on delivery as the only selectable method.
- Add ARB keys for new payment copy.
- Validate RLS, grants, guards, and focused tests.
- Reconcile docs, memory, technical debt, and Trello after implementation
  evidence exists.

## Backlog

- [ ] Task 1 - migration: `payments` table + atomic order payment creation.
- [ ] Task 2 - domain: payment method/status and placed-order payment summary.
- [ ] Task 3 - data: DTO and repository mapping for payment payload.
- [ ] Task 4 - ARB copy for payment status and method details.
- [ ] Task 5 - ViewModel and checkout UI payment state.
- [ ] Task 6 - full validation and regression matrix.
- [ ] Task 7 - docs, memory, technical debt, and Trello reconciliation.

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
- [ ] Docs, memory, technical debt, and Trello are reconciled only after
  validation evidence exists.

## Out of Scope

- Real online payments or payment authorization/capture.
- Stripe SDK dependency in Flutter.
- Supabase Edge Functions implementation.
- Stripe webhook endpoint.
- Secret management beyond documenting the future boundary.
- Payment retries, refunds, cancellations, disputes, invoices, receipts.
- Order history, order tracking, Realtime status updates.
- Profile/address persistence.
- Dynamic delivery fee, coupons, taxes, tips.

## Dependencies

- Sprint 10 checkout order persistence and `create_order` RPC.
- Existing `orders` and `order_items` RLS/grants discipline.
- Shared checkout ViewModel, repository, datasource, and tests.
- ARB pipeline and generated localization freshness guard.
- Theme Guard and app design tokens.
- Remote Supabase project access for migration smoke validation and apply.

## Localization Guard

- [ ] Every new user-facing payment string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded payment/status copy is introduced in widgets, routes,
  dialogs, snackbars, tooltips, or semantic labels.
- [ ] ARB catalog parity guard remains green after copy changes.
- [ ] New placeholders are declared in template metadata and preserved across
  translated catalogs.
- [ ] New placeholders and route placeholders are covered by guard tests when
  applicable.
- [ ] Generated localization freshness guard remains green after ARB changes.

## Theme Guard

- [ ] UI uses only semantic theme APIs and app tokens.
- [ ] No `Color(0x...)` hardcoded values in feature presentation code.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage outside
  `lib/app/theme`.
- [ ] No direct `Colors.*` hardcoded usage in feature presentation when
  equivalent semantic `ColorScheme` roles exist.
- [ ] Visual hardcoded guard test remains green after UI changes.

## Risks

- Evolving an already-applied RPC can break checkout if DTO and SQL payloads
  drift.
- Keeping both `orders.payment_method` and `payments.method` creates temporary
  duplication; document it clearly or remove the old field only with explicit
  approval.
- Payment wording can imply real processing. UI copy must say payment is
  pending on delivery, not paid.
- A real gateway would require Edge Functions, webhooks, secrets, idempotency,
  and manual QA beyond this sprint.
- Future payment status updates will require careful RLS or server-side webhook
  design.

## Trello Governance

- Target board: `FlowDelivery - Product Backlog`.
- Current list: `✅ Ready` before implementation starts.
- Card title: `[FEAT] Payments foundation (Sprint 11)`.
- Card URL: `https://trello.com/c/cQDUVgYR`.
- Labels: `feat`, `backend`, `frontend`, `supabase`, `database`, `security`,
  `mvvm`, `qa`, `priority-medium`, `recruiter-portfolio`.
- Real Trello checklist parity was verified after card creation through the
  local Trello MCP server.
- Checklist items must be completed only after local implementation evidence
  exists.

## Notes

- This is a foundation slice, not a gateway slice.
- Future Stripe work should use a server/Edge Function boundary, verified
  webhooks, idempotency keyed by order/payment ID, and no secret keys in
  Flutter.
