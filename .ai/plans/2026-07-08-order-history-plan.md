# Order History Plan — Sprint 12

## Objective

Add a read-only order history so authenticated users can see the orders they
placed through checkout, closing the write→read loop started in Sprints 10
and 11. This is the project's first user-scoped read path over transactional
data: it must prove that RLS-scoped reads, PostgREST relational embedding,
and the established Clean Architecture read conventions compose cleanly.

This is a listing slice, not a tracking/lifecycle slice.

## Product Story

As an authenticated user, I can open a "Meus pedidos" page and see every
order I placed — restaurant, date, item count, total, and an honest status —
ordered from newest to oldest, so the app demonstrates a credible end-to-end
order flow.

As a reviewer, I can see that transactional data is read through the same
layered boundaries as the catalog (datasource → repository → provider → UI),
that RLS ownership is respected without any client-side filtering, and that
the UI never claims lifecycle behavior the database does not support.

## Architectural Context

Sprints 10–11 delivered the write path:

```text
CheckoutPage → CheckoutViewModel → OrderRepository →
OrderRemoteDatasource → create_order RPC →
orders + order_items + payments
```

Sprint 12 adds the first read path over that data, mirroring the validated
read-only conventions from `restaurant_details`/`product_details`:

```text
OrdersPage (loading / error / empty / success)
  ↓ watch
orderHistoryProvider (FutureProvider — no ViewModel, per ADR-003)
  ↓
OrderHistoryRepository
  ↓
SupabaseOrderHistoryDatasource
  ↓ single PostgREST select with embedding
orders + restaurants(name, image_asset_path) + order_items(quantity)
```

Key decisions:

- **No ViewModel.** The page performs a single read with no user actions
  (ADR-003 precedent from Sprint 6). A future Reorder/tracking slice is the
  moment a ViewModel becomes justified.
- **One embedded query, no N+1.** PostgREST resolves the `restaurants` FK
  embed and the `order_items` rows in the same request. Item count is the sum
  of `order_items.quantity`, computed in the datasource.
- **No new migration.** `orders` already has `restaurant_id`,
  `total_in_cents`, `status`, `created_at`, the
  `orders_user_created_at_idx (user_id, created_at desc)` index, and RLS
  `SELECT` scoped to `auth.uid()` (Sprint 10). `restaurants` already grants
  authenticated `SELECT` (Sprint 3).
- **Honest status.** The database constrains `status = 'placed'`. The UI
  renders a single localized "order placed" status chip. No fake
  Active/Completed/Cancelled states.
- **Shared media resolver reuse.** The restaurant cover path resolves to a
  public URL through the Sprint 8 shared data-layer resolver; widgets render
  it through the shared asset/network renderer and never touch Supabase.

## Prototype Deviations (proposed, need approval)

`docs/ux/prototypes/order-history.png` shows features the current data model
cannot honestly support. Proposed deviations:

- **All/Ongoing/Completed tabs — deferred.** Only one status exists.
- **Active Orders / Past Orders sections — deferred.** Single chronological
  list ordered by `created_at desc`.
- **Reorder button — deferred.** Requires cart-refill behavior and a
  product-availability contract; separate slice.
- **Search icon — deferred.** No search over history in this slice.
- **Status badges** render the single honest localized status for `placed`.

## Scope

- New `orders` feature module (`lib/features/orders/`) with
  domain/data/presentation layers.
- `OrderHistoryEntry` pure-Dart domain entity and
  `OrderHistoryRepository` contract.
- Supabase datasource with a single embedded query, deterministic
  `created_at desc` ordering, DTO parsing, and explicit remote exceptions.
- Repository mapping DTO→domain, invalid remote values mapped to a neutral
  domain failure (Sprint 11 precedent).
- `orderHistoryProvider` (`FutureProvider`) + composition-root wiring
  following the existing app-boundary override convention.
- Protected `/orders` route in centralized GoRouter.
- Home bottom-nav "Pedidos" tab wired to `/orders` (replacing the deferred
  no-op) with updated tests.
- `OrdersPage` with localized loading/error/empty/success states; order card
  with restaurant image/name, date, item count, total (shared
  `formatPriceInCents`), and status chip.
- New `orders*` ARB keys in pt_BR/pt/en; regenerated localizations.
- Focused tests + consolidated regression matrix; all guards green.
- Docs/memory/technical-debt/Trello reconciliation after evidence exists.

## Out of Scope

- Order status transitions, tracking, Realtime updates.
- Reorder, order cancellation, order details page.
- History tabs/filtering/search/pagination (dataset is small; the index
  already supports future pagination).
- Payment details rendering beyond what the list card needs (none planned).
- Profile/address persistence, coupons, dynamic delivery fee.
- Any migration or write behavior.

## Data Contract (read-only, existing schema)

Datasource query shape (PostgREST):

```text
orders
  ?select=id,total_in_cents,status,created_at,
          restaurants(name,image_asset_path),
          order_items(quantity)
  order by created_at desc
```

- RLS returns only the caller's rows; the client sends no user filter.
- `restaurants` embed follows the `orders.restaurant_id` FK.
- Item count = sum of embedded `order_items.quantity` (datasource-level).
- Missing/malformed embeds → `OrderHistoryRemoteException`.
- Unknown `status` values → neutral domain failure in the repository
  (Sprint 11 invalid-remote-value precedent).

## Domain Contract

```dart
class OrderHistoryEntry {
  final String id;
  final String restaurantName;
  final String restaurantImagePath; // resolved public URL
  final DateTime createdAt;
  final int itemCount;
  final int totalInCents;
  final OrderHistoryStatus status; // { placed }
}

abstract interface class OrderHistoryRepository {
  Future<List<OrderHistoryEntry>> loadOrderHistory();
}
```

- Empty history is a successful empty list, not a failure (Finding A: no
  exception-based control flow for expected states).
- Failures surface as a neutral domain failure; presentation maps it to
  localized copy.

## Branch

Suggested branch:

`feat/order-history`

## Estimate

- Story points: 5
- Confidence: Medium-High
- Main uncertainty: PostgREST embedded-payload parsing shape (FK embed +
  child rows in one DTO) and updating the Home bottom-nav no-op tests
  without destabilizing the validated Home suites.

## Tasks

### Task 1 — Domain: order history entity, status, and repository contract

**Goal:** Model the history entry without Flutter or Supabase dependencies.

**Files to create:**

- `lib/features/orders/domain/entities/order_history_entry.dart`
- `lib/features/orders/domain/repositories/order_history_repository.dart`
- `lib/features/orders/domain/failures/order_history_failure.dart` (neutral
  codes, if the slice needs more than a single generic failure)

**Work:**

- `OrderHistoryEntry` immutable with value equality;
- `OrderHistoryStatus { placed }` enum;
- repository contract returning `Future<List<OrderHistoryEntry>>`;
- document empty-list-is-success semantics.

**Validation:**

- focused entity equality/defaults tests;
- analyze touched domain files.

**Skills aplicáveis:** `fd-architect`, `dart-add-unit-test`.

**Localization Guard / Theme Guard:** not applicable.

### Task 2 — Data: DTO, Supabase datasource, repository implementation

**Goal:** Own the embedded query and map remote rows to domain without
leaking Supabase upward.

**Files to create:**

- `lib/features/orders/data/dtos/order_history_entry_dto.dart`
- `lib/features/orders/data/datasources/order_history_remote_datasource.dart`
- `lib/features/orders/data/repositories/order_history_repository_impl.dart`
- matching tests under `test/features/orders/data/`

**Work:**

- single select with `restaurants` embed and `order_items(quantity)`;
- deterministic `created_at desc` ordering;
- item count summed in the datasource;
- restaurant image path resolved through the shared public-media resolver
  (Sprint 8 convention — datasource-level resolution);
- explicit `OrderHistoryRemoteException` for Postgrest/malformed payloads;
- repository maps DTO→entity and unknown status→neutral domain failure.

**Validation:**

- datasource tests: success payload, empty list, malformed embed, unknown
  status, Postgrest failure;
- repository mapping tests;
- transaction-scoped Supabase MCP read check confirming the embedded query
  shape returns only the caller's rows (no persisted changes);
- analyze touched data files.

**Skills aplicáveis:** `fd-supabase-architect`, `fd-code-reviewer`,
`dart-add-unit-test`, `supabase`.

**Localization Guard / Theme Guard:** not applicable.

### Task 3 — Providers and app composition

**Goal:** Expose the history read through Riverpod with the established
composition-root override convention.

**Files to create/update:**

- `lib/features/orders/presentation/providers/order_history_providers.dart`
- `lib/app/di/app_providers.dart`
- provider tests under `test/features/orders/presentation/`

**Work:**

- `orderHistoryProvider` as `FutureProvider<List<OrderHistoryEntry>>`
  (no ViewModel, ADR-003);
- unconfigured-`StateError` presentation provider + app-boundary override,
  mirroring the checkout/details convention;
- no fixture fallback: history has a legitimate empty state.

**Validation:**

- provider tests for success/failure propagation and override wiring;
- analyze touched files.

**Skills aplicáveis:** `fd-architect`, `dart-add-unit-test`.

**Localization Guard / Theme Guard:** not applicable.

### Task 4 — ARB copy for order history

**Goal:** Add all user-facing history copy before widgets exist.

**Files to update:**

- `lib/l10n/app_pt_BR.arb` (template, with descriptions)
- `lib/l10n/app_pt.arb`
- `lib/l10n/app_en.arb`

**Likely keys (no-accent PT per catalog convention):**

- `ordersPageTitle`
- `ordersStatusPlaced`
- `ordersItemCount` (ICU plural, `cartItemCount` precedent)
- `ordersTotalLabel`
- `ordersEmptyTitle` / `ordersEmptyMessage` / `ordersEmptyAction`
- `ordersErrorTitle` / `ordersErrorMessage` / `ordersRetryAction`
  (retry re-triggers the provider read; a read retry is safe — the no-retry
  rule protects the write path only)
- `ordersLoadingSemanticLabel` if the loading state needs semantics.

**Validation:**

- `flutter gen-l10n`;
- ARB catalog parity guard, generated freshness guard, hardcoded copy guard.

**Skills aplicáveis:** `flutter-setup-localization`, `fd-code-reviewer`.

**Localization Guard:** required. **Theme Guard:** not applicable.

### Task 5 — UI: OrdersPage states and order card

**Goal:** Render the honest history list per the approved prototype subset.

**Files to create:**

- `lib/features/orders/presentation/pages/orders_page.dart`
- `lib/features/orders/presentation/widgets/order_history_sections.dart`
- `test/features/orders/presentation/orders_page_test.dart`

**Work:**

- loading/error/empty/success states from `orderHistoryProvider`;
- order card: restaurant cover through the shared asset/network renderer,
  restaurant name, localized date, ICU-plural item count, total through
  shared `formatPriceInCents`, localized `placed` status chip;
- sections stay dumb (no `WidgetRef`); only the page watches providers;
- semantic theme APIs and app tokens only;
- error state exposes the localized retry action (provider refresh).

**Validation:**

- widget tests for the four states + card content rendering;
- Localization Guard and Theme Guard suites green.

**Skills aplicáveis:** `fd-flutter-teacher`, `flutter-add-widget-test`,
`flutter-build-responsive-layout`.

**Localization Guard:** required. **Theme Guard:** required.

### Task 6 — Routing: protected `/orders` + Home bottom-nav wiring

**Goal:** Make order history reachable through centralized routing.

**Files to update:**

- `lib/app/routes/` (protected `/orders` route)
- Home bottom-nav wiring (router-injected callback convention, like
  `onOpenCart`)
- `test/app/routes/app_router_test.dart`
- affected Home widget tests

**Work:**

- protected `/orders` under the centralized GoRouter guard;
- wire the Home bottom-nav "Pedidos" tab to navigate to `/orders`,
  intentionally replacing the Sprint 2 deferred no-op (tests updated to the
  new contract);
- keep other bottom-nav tabs as deferred no-ops.

**Validation:**

- router tests: authenticated open + unauthenticated redirect for `/orders`;
- Home widget test updated for the new tab behavior;
- analyze touched files.

**Skills aplicáveis:** `flutter-setup-declarative-routing`, `fd-architect`.

**Localization Guard / Theme Guard:** only if copy/styling changes.

### Task 7 — Full validation and regression matrix

**Goal:** Prove the read slice did not regress checkout/cart/Home/router
behavior.

**Validation targets:**

- focused orders domain/data/presentation suites;
- Home + router + cart + checkout regression suites;
- l10n guards, Theme Guard, Trello Guard;
- consolidated `flutter test` matrix;
- focused analyzer on every touched slice;
- Dart MCP `add_roots` before Dart validation (project rule).

**Skills aplicáveis:** `fd-qa-engineer`, `dart-run-static-analysis`.

### Task 8 — Docs, memory, technical debt, and Trello reconciliation

**Goal:** Persist evidence only after validation passes.

**Files likely to update:**

- `docs/project-management/SPRINT_12.md`
- `.ai/memory/current_feature.md`
- `.ai/memory/current_sprint.md`
- `.ai/memory/technical_debt.md`
- `README.md` if the feature list changes.

**Trello:**

- Real card created in `✅ Ready`: `[FEAT] Order history (Sprint 12)` —
  `https://trello.com/c/v7eDZSQc` — with Scope, Acceptance Criteria,
  Dependencies, Validation, Localization Guard, and Theme Guard checklists
  (41 items, all unchecked at planning);
- complete items only after local evidence; verify real parity before
  closure.

**Skills aplicáveis:** `fd-product-owner`, `fd-trello-manager`.

## Acceptance Criteria

- [ ] Authenticated users see their own orders on `/orders`, newest first;
  RLS ownership is enforced server-side with no client-side user filter.
- [ ] The history loads through one embedded PostgREST query (no N+1).
- [ ] Empty history renders the localized empty state as success, not error.
- [ ] Unknown remote status values map to a neutral domain failure.
- [ ] No new migration; no write behavior introduced.
- [ ] `/orders` is protected; unauthenticated deep links redirect to sign-in.
- [ ] The Home bottom-nav "Pedidos" tab navigates to `/orders`.
- [ ] Order cards show restaurant image/name, localized date, ICU-plural item
  count, formatted total, and the honest `placed` status chip.
- [ ] Supabase details stay inside datasource/repository layers; widgets use
  the shared media renderer.
- [ ] Localization Guard and Theme Guard remain green.
- [ ] Focused suites and the consolidated regression matrix pass.
- [ ] Docs/memory/Trello reconciled only after validation evidence exists.

## Risks

- PostgREST embedded payload parsing (FK embed + child rows) is a new DTO
  shape for this codebase; malformed-payload tests must cover it.
- Rewiring the bottom-nav no-op changes a validated Sprint 2 contract;
  Home suites must be updated deliberately, not patched to pass.
- The prototype promises tabs/Reorder/tracking; copy and card design must not
  imply lifecycle behavior that does not exist yet.
- Restaurant rows are referenced by FK without `on delete cascade`; if
  catalog seeds are ever removed, embeds could return null — the DTO should
  treat a missing embed as malformed rather than crash.
- Date formatting must go through the localized pipeline (no hardcoded
  formats) to keep guards green.

## Technical Debt Watch

- `orders.payment_method` transitional duplication (Sprint 11) is untouched
  by this read slice; removal still needs a separately approved migration.
- Bottom-nav tabs other than Home/Pedidos remain deferred no-ops; promote
  them only through approved slices.
- If item counts ever need server-side aggregation (large orders), consider
  a PostgREST aggregate or view in a future slice; current cart sizes make
  client-side summing acceptable.

## Future Slice Notes

- Order details page (`/orders/:orderId`) reusing `order_items` +
  `payments` reads.
- Reorder (cart refill + availability contract) — the moment this feature
  gains a ViewModel.
- Status transitions + tracking UI + Realtime, gated by a migration that
  relaxes `orders_status_supported` and adds an update path with proper RLS.
