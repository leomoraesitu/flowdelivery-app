# Sprint 12 - Order History

## Objective

Add a read-only order history page so authenticated users can see the orders
they placed through checkout, closing the write→read loop started in Sprints
10 and 11 with the project's first user-scoped read path over transactional
data.

Reference plan:

- `.ai/plans/2026-07-08-order-history-plan.md`

Real Trello story:

- `[FEAT] Order history (Sprint 12)` — `https://trello.com/c/v7eDZSQc`
  (board `FlowDelivery - Product Backlog`, list `🚧 In Progress`,
  start 2026-07-08, due 2026-07-10).

Epics:

- Backlog epic: `[EPIC] Sprint 12 — Order History` —
  `https://trello.com/c/SZmV5A9E`
  (board `FlowDelivery - Product Backlog`, list `🏔️ Epics`).
- Management epic: `[EPIC] Sprint 12 — Order History` —
  `https://trello.com/c/lxI7KBSX`
  (board `FlowDelivery - Project Management`, list `🏔️ Epics`).

## Status

Planned. Awaiting explicit approval before implementation.

## Sprint Goal

As a portfolio reviewer using FlowDelivery, I want placed orders to be
visible in an order history so the app demonstrates a credible end-to-end
order flow — write path and read path — over RLS-protected transactional
data.

## Story

As an authenticated user, I can open "Meus pedidos" and see every order I
placed — restaurant, date, item count, total, and an honest status — ordered
from newest to oldest.

## Estimate

- Story points: 5
- Confidence: Medium-High
- Main uncertainty: PostgREST embedded-payload DTO parsing and updating the
  Home bottom-nav no-op tests without destabilizing validated Home suites.

## Scope

- New `orders` feature module (domain/data/presentation) mirroring the
  validated read-only conventions.
- `OrderHistoryEntry` domain entity, `OrderHistoryStatus { placed }`, and
  `OrderHistoryRepository` contract.
- Supabase datasource with a single embedded query
  (`orders` + `restaurants` + `order_items(quantity)`), `created_at desc`
  ordering, and explicit remote exceptions.
- Repository DTO→domain mapping; unknown remote status → neutral domain
  failure.
- `orderHistoryProvider` (`FutureProvider`, no ViewModel per ADR-003) with
  composition-root override wiring.
- Protected `/orders` route; Home bottom-nav "Pedidos" tab wired to it.
- `OrdersPage` with localized loading/error/empty/success states and order
  cards using the shared media renderer and `formatPriceInCents`.
- New `orders*` ARB keys (pt_BR template, pt, en) with regenerated
  localizations.
- Focused tests, consolidated regression matrix, and all guards green.
- Docs/memory/technical-debt/Trello reconciliation after evidence exists.

## Backlog

- [ ] Task 1 - domain: order history entity, status, repository contract.
- [ ] Task 2 - data: DTO, Supabase datasource, repository implementation.
- [ ] Task 3 - providers and app composition.
- [ ] Task 4 - ARB copy for order history.
- [ ] Task 5 - UI: OrdersPage states and order card.
- [ ] Task 6 - routing: protected `/orders` + Home bottom-nav wiring.
- [ ] Task 7 - full validation and regression matrix.
- [ ] Task 8 - docs, memory, technical debt, and Trello reconciliation.

## Acceptance Criteria

- [ ] Authenticated users see only their own orders on `/orders`, newest
  first, with RLS ownership enforced server-side.
- [ ] History loads through one embedded PostgREST query (no N+1).
- [ ] Empty history renders the localized empty state as success.
- [ ] Unknown remote status values map to a neutral domain failure.
- [ ] No new migration and no write behavior are introduced.
- [ ] `/orders` is protected; unauthenticated deep links redirect to
  sign-in.
- [ ] The Home bottom-nav "Pedidos" tab navigates to `/orders`.
- [ ] Order cards show restaurant image/name, localized date, ICU-plural
  item count, formatted total, and the honest `placed` status chip.
- [ ] Supabase details stay inside datasource/repository layers.
- [ ] Localization Guard and Theme Guard remain green.
- [ ] Focused suites and the consolidated regression matrix pass.
- [ ] Docs, memory, technical debt, and Trello are reconciled only after
  validation evidence exists.

## Out of Scope

- Order status transitions, tracking, Realtime updates.
- Reorder, order cancellation, and the order details page.
- History tabs (All/Ongoing/Completed), filtering, search, pagination.
- Payment details rendering on history cards.
- Profile/address persistence, coupons, dynamic delivery fee.
- Any migration or write behavior.
- Removal of the transitional `orders.payment_method` duplication.

## Prototype Deviations

`docs/ux/prototypes/order-history.png` shows tabs, Active/Past sections,
Reorder buttons, and multiple status badges. The database constrains
`status = 'placed'`, so this sprint renders a single chronological list with
one honest localized status chip. Tabs, Reorder, sectioning, and search are
deferred to future approved slices.

## Dependencies

- Sprint 10 `orders`/`order_items` schema, RLS `SELECT` policies, and the
  `orders_user_created_at_idx` index.
- Sprint 3 `restaurants` authenticated read grants (FK embed).
- Sprint 8 shared public-media resolver and asset/network renderer.
- Shared `formatPriceInCents` (Sprint 9).
- ARB pipeline and localization/theme guard suites.
- Centralized GoRouter guard and router-injected callback convention.

## Localization Guard

- [ ] Every new user-facing history string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy in widgets, routes, dialogs, tooltips, or semantic
  labels.
- [ ] ARB catalog parity guard remains green after copy changes.
- [ ] New placeholders (including the ICU plural item count) are declared in
  template metadata and preserved across translated catalogs.
- [ ] Generated localization freshness guard remains green.

## Theme Guard

- [ ] UI uses only semantic theme APIs and app tokens.
- [ ] No `Color(0x...)` hardcoded values in feature presentation code.
- [ ] No direct `AppLightColors`/`AppDarkColors` usage outside
  `lib/app/theme`.
- [ ] No direct `Colors.*` usage when equivalent semantic `ColorScheme`
  roles exist.
- [ ] Visual hardcoded guard test remains green.

## Risks

- PostgREST embedded payload parsing is a new DTO shape; malformed-embed
  tests must cover it.
- Rewiring the bottom-nav no-op changes a validated Sprint 2 contract; Home
  suites must be updated deliberately.
- Copy and card design must not imply lifecycle behavior (tracking,
  completion, cancellation) that does not exist.
- A missing `restaurants` embed must be treated as a malformed payload, not
  a crash.
- Date formatting must go through the localized pipeline to keep guards
  green.

## Trello Governance

- Target board: `FlowDelivery - Product Backlog`.
- Current list: `🚧 In Progress` (moved by the owner on 2026-07-08 with
  start/due dates set — sprint start approved).
- Card title: `[FEAT] Order history (Sprint 12)`.
- Card URL: `https://trello.com/c/v7eDZSQc`.
- Backlog epic: `https://trello.com/c/SZmV5A9E` (list `🏔️ Epics`).
- Management epic: `https://trello.com/c/lxI7KBSX`
  (board `FlowDelivery - Project Management`, list `🏔️ Epics`).
- Labels: `feat`, `frontend`, `supabase`, `database`, `mvvm`, `qa`,
  `priority-medium`, `recruiter-portfolio`.
- Checklists created with planning parity: Scope (8), Acceptance
  Criteria (9), Dependencies (6), Validation (7), Localization Guard (6),
  Theme Guard (5) — 41 items, all unchecked by design.
- Checklist items are completed only after local implementation evidence
  exists; real parity is verified through the local Trello MCP before
  closure.

## Notes

- Suggested branch: `feat/order-history`.
- This slice deliberately has no ViewModel (single read, no user actions,
  ADR-003 precedent); Reorder is the future trigger for one.
- Retry on the error state is safe: the no-retry rule protects the checkout
  write path only.
