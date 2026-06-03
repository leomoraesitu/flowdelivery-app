# Catalog Demo Coverage Plan

## Objective

Make the validated read-only browsing flow feel complete in demos by expanding deterministic catalog seed coverage beyond `burger_artisan_collective`, without adding cart, checkout, customization, Storage, Realtime, or new runtime UI behavior.

## Architectural Context

Sprint 5 delivered the protected restaurant catalog surface and Sprint 6 delivered protected product details. Both features are read-only and already load from Supabase through datasources/repositories. Sprint 7 is a data-readiness slice: it should add deterministic catalog seed data for the existing restaurant IDs and validate that the current app flow works across multiple restaurants.

```text
Home restaurants
↓
/restaurants/:restaurantId
↓
RestaurantDetailsPage
↓
RestaurantDetailsRepository
↓
RestaurantDetailsRemoteDatasource
↓
Supabase: restaurant_menu_categories + restaurant_menu_items
↓
/restaurants/:restaurantId/products/:productId
↓
ProductDetailsRepository
↓
Supabase: restaurant_menu_items by product id
```

No app feature boundary should change unless validation proves a real mismatch in the existing implementation. The planned work is primarily a Supabase migration plus focused tests/docs.

## Scope

- expand `restaurant_menu_categories` and `restaurant_menu_items` seeds for existing restaurants:
  - `pasta_roma`;
  - `sushi_zen`;
  - `taco_harbor`;
- keep existing `burger_artisan_collective` seed behavior stable;
- use deterministic IDs, sort order, names, descriptions, placeholder image assets, and prices;
- preserve explicit read-only grants, RLS, and existing table contracts;
- validate restaurant details and product details can load seeded data across more than one restaurant;
- reconcile Sprint 7 docs, memory, technical-debt monitoring, and Trello only after evidence exists.

## Out of Scope

- new product tables, variants, add-ons, quantity, special instructions, cart, checkout, orders, favorites, sharing, Storage media, Realtime, ranking, recommendations, and profile/address persistence;
- changing presentation copy or visual layout;
- replacing placeholder image assets with Storage-backed media;
- expanding Home restaurant/domain taxonomy beyond existing IDs unless explicitly approved.

## Key Decisions and Tradeoffs

- Use a dedicated follow-up migration instead of editing old migrations. Existing migrations are already applied remotely; a new migration keeps history linear and auditable.
- Seed only existing restaurants. Adding restaurants would touch Home taxonomy and discovery expectations, which is broader than demo coverage.
- Keep categories generic per restaurant and small. A demo needs enough variety to avoid empty states, not a production catalog.
- Keep placeholder image assets. This preserves the current asset contract and avoids pulling Storage/media scope into a data-readiness Sprint.
- Do not extract shared price formatting in this Sprint. The duplication noted in Sprint 6 remains accepted until a third consumer or a dedicated refactor is approved.

## Dependencies

- Sprint 5 and Sprint 6 closed and validated.
- Existing Supabase tables:
  - `public.restaurants`;
  - `public.restaurant_menu_categories`;
  - `public.restaurant_menu_items`.
- Existing remote project deployment runbook in `docs/setup/SUPABASE_SETUP.md`.
- Existing guards:
  - Localization Guard;
  - Theme Guard;
  - Trello Guard.

## Current Progress

- [x] Sprint 7 direction approved by user: `Catalog Demo Coverage`.
- [x] Task 1 - audit current seed baseline and expected counts (remote Supabase read-only SELECT confirmed 4 Home restaurants; only `burger_artisan_collective` has 4 menu categories and 4 menu items, 2026-06-03).
- [x] Task 2 - add deterministic catalog seed migration (`supabase/migrations/20260603183000_catalog_demo_coverage.sql`; 9 categories + 12 items for `pasta_roma`, `sushi_zen`, and `taco_harbor`; rollback smoke passed without persisting data, 2026-06-03).
- [x] Task 3 - validate SQL, RLS/read-only behavior, and datasource compatibility.
- [ ] Task 4 - add or update focused regression coverage for multi-restaurant catalog/product loading.
- [ ] Task 5 - reconcile docs, memory, technical debt, and Trello after validation.

## Validation Evidence

- Task 1: Supabase MCP read-only queries on project `kvbahsdjmhpukzmdttvq` confirmed existing restaurant IDs `burger_artisan_collective`, `pasta_roma`, `sushi_zen`, and `taco_harbor`; menu coverage exists only for `burger_artisan_collective` with 4 categories and 4 items.
- Task 2: `git diff --check` passed after creating `supabase/migrations/20260603183000_catalog_demo_coverage.sql`.
- Task 2: Supabase MCP rollback smoke executed the migration SQL inside `begin ... rollback` without errors; post-rollback checks confirmed remote baseline remained unchanged (`burger_artisan_collective` still 4 categories/4 items; new Sprint 7 item IDs count 0).
- Task 3: Supabase MCP applied remote migration `catalog_demo_coverage` to project `kvbahsdjmhpukzmdttvq`; remote migration history now includes `20260603184708 catalog_demo_coverage`.
- Task 3: Remote catalog counts are now 13 categories and 16 items: `burger_artisan_collective` remains 4 categories/4 items, and `pasta_roma`, `sushi_zen`, and `taco_harbor` each have 3 categories and 4 items.
- Task 3: RLS remains enabled on both menu tables; policies remain `SELECT` only for `authenticated`; grants remain `SELECT` only for `authenticated` and `service_role`; `anon` has no table `SELECT`; `authenticated` has no `INSERT`, `UPDATE`, or `DELETE`.
- Task 3: Datasource-shaped SQL confirmed categories/items load by `restaurant_id` and a seeded non-burger product (`sushi_zen_omakase_sampler`) loads by `id` with the columns expected by the existing datasources.
- Task 3: Supabase security advisors reported no new table/RLS issue; the only warning remains the unrelated Auth-level `auth_leaked_password_protection` advisory.
- Trello: real card `https://trello.com/c/TLHgmJ02` was updated with Task 1 and Task 2 evidence; Task 3 evidence still needs real-card reconciliation in the governance task after focused regression coverage exists.

## Implementation Tasks

### Task 1: Audit Current Seed Baseline

Concept: confirm the existing migration state and lock the expected Sprint 7 target before changing data.

Files:

- Inspect `supabase/migrations/20260601192000_home_remote_feed_foundation.sql`
- Inspect `supabase/migrations/20260602120000_restaurant_details_remote_catalog.sql`
- Modify `.ai/plans/2026-06-03-catalog-demo-coverage-plan.md` only if the audit finds a mismatch.

Responsibilities:

- Confirm the existing restaurant IDs remain:
  - `burger_artisan_collective`;
  - `pasta_roma`;
  - `sushi_zen`;
  - `taco_harbor`.
- Confirm the current catalog seed baseline remains 4 categories and 4 items for `burger_artisan_collective`.
- Define target coverage for Sprint 7:
  - keep `burger_artisan_collective` unchanged;
  - add at least 3 categories and 4 menu items for each of `pasta_roma`, `sushi_zen`, and `taco_harbor`;
  - expected final minimum: 13 menu categories and 16 menu items.

Validation:

- `git diff --check`
- If local Supabase is available, run a transaction-scoped SQL count query before implementation.

Applicable skills:

- `supabase`
- `supabase-postgres-best-practices`
- `dart-run-static-analysis`

### Task 2: Add Deterministic Catalog Seed Migration

Concept: add data only; do not change schema, policies, grants, or app code unless validation shows a contract gap.

Files:

- Create `supabase/migrations/<timestamp>_catalog_demo_coverage.sql`

Responsibilities:

- Use `insert ... values ... on conflict ... do update` for idempotent seeds.
- Add categories for:
  - `pasta_roma`: `popular`, `pastas`, `salads`;
  - `sushi_zen`: `popular`, `rolls`, `bowls`;
  - `taco_harbor`: `popular`, `tacos`, `sides`.
- Add at least 4 menu items per new restaurant.
- Keep IDs lowercase and stable.
- Use `assets/images/branding/logo-flowdelivery-light.png` until Storage media is approved.
- Keep all rows read-only through the existing table grants/RLS.

Example item shape:

```sql
insert into public.restaurant_menu_items (
  id,
  restaurant_id,
  category_id,
  name,
  description,
  image_asset_path,
  price_in_cents,
  sort_order
)
values (
  'pasta_roma_truffle_tagliatelle',
  'pasta_roma',
  'pastas',
  'Truffle Tagliatelle',
  'Fresh tagliatelle with parmesan cream, mushrooms, and truffle oil.',
  'assets/images/branding/logo-flowdelivery-light.png',
  1720,
  0
)
on conflict (id) do update
set
  restaurant_id = excluded.restaurant_id,
  category_id = excluded.category_id,
  name = excluded.name,
  description = excluded.description,
  image_asset_path = excluded.image_asset_path,
  price_in_cents = excluded.price_in_cents,
  sort_order = excluded.sort_order;
```

Validation:

- SQL smoke test in a rollback transaction when possible.
- `git diff --check`.

Applicable skills:

- `supabase`
- `supabase-postgres-best-practices`

### Task 3: Validate Supabase Read Contracts

Concept: prove the data expands demo coverage without loosening permissions or changing app boundaries.

Files:

- Modify `docs/setup/SUPABASE_SETUP.md` only if the remote deployment/runbook changes.

Responsibilities:

- Confirm `authenticated` can read seeded rows.
- Confirm `anon` remains denied.
- Confirm write attempts remain denied for `authenticated`.
- Confirm each restaurant returns at least one category and one menu item through the existing datasource query shape.
- Confirm product details can load a seeded product by `id` alone.

Suggested SQL checks:

```sql
select restaurant_id, count(*) as category_count
from public.restaurant_menu_categories
group by restaurant_id
order by restaurant_id;

select restaurant_id, count(*) as item_count
from public.restaurant_menu_items
group by restaurant_id
order by restaurant_id;
```

Validation:

- Supabase MCP or local SQL smoke test.
- Security advisors if remote schema/data deployment is performed.

Applicable skills:

- `supabase`
- `supabase-postgres-best-practices`

### Task 4: Add Focused Regression Coverage

Concept: pin the expected multi-restaurant catalog behavior at the existing datasource/repository/provider layer before using it as demo evidence.

Files:

- Modify `test/features/restaurant_details/data/restaurant_details_remote_datasource_test.dart` if the current datasource fixture coverage only proves one restaurant.
- Modify `test/features/product_details/data/product_details_remote_datasource_test.dart` if product fixture coverage only proves the original burger item.
- Modify `test/features/restaurant_details/presentation/restaurant_details_page_test.dart` only if widget coverage needs one multi-restaurant navigation assertion.

Responsibilities:

- Prove `restaurant_details` can parse and order categories/items for a non-burger restaurant.
- Prove `product_details` can parse a seeded non-burger item.
- Avoid UI changes unless the current UI fails with the expanded dataset.

Validation:

- focused datasource/repository/provider/widget tests touched by this task;
- relevant router tests if navigation assertions are added;
- Localization Guard only if UI copy changes, which is not expected;
- Theme Guard only if UI changes, which is not expected.

Applicable skills:

- `dart-add-unit-test`
- `flutter-add-widget-test`
- `dart-run-static-analysis`

### Task 5: Reconcile Sprint 7 Governance

Concept: record completion only after implementation and validation evidence exists.

Files:

- Modify `docs/project-management/SPRINT_7.md`
- Modify `.ai/memory/current_feature.md`
- Modify `.ai/memory/current_sprint.md`
- Modify `.ai/memory/technical_debt.md`

Responsibilities:

- Update Sprint 7 task checkboxes based on evidence.
- Move the catalog seed item out of active debt monitoring only if demo coverage is actually implemented and validated.
- If a real Trello card is created for Sprint 7, validate real checklist parity before using it as delivery evidence.
- Add a concise validation summary with commands/results.

Validation:

- `flutter test test/app/project_management/trello_guard_checklists_test.dart`
- `git diff --check`

Applicable skills:

- `dart-run-static-analysis`

## Acceptance Criteria

- [ ] Existing `burger_artisan_collective` catalog behavior remains unchanged.
- [ ] `pasta_roma`, `sushi_zen`, and `taco_harbor` each have deterministic menu categories and items.
- [ ] Restaurant details loads non-empty catalogs for all existing restaurants.
- [ ] Product details loads seeded non-burger products by stable product ID.
- [ ] Supabase remains read-only for authenticated clients and inaccessible to `anon` where previously denied.
- [ ] No new UI copy, hardcoded visual values, or business logic is introduced without guard validation.
- [ ] Focused tests and SQL smoke validation pass.
- [ ] Docs, memory, technical debt, and Trello evidence are reconciled only after validation.

## Risks

- Seed expansion can accidentally become schema expansion. Keep this Sprint data-only unless a real blocker appears.
- Demo data can drift from domain constraints if IDs, category links, or sort orders are inconsistent.
- Updating old applied migrations would make remote history ambiguous; use a new migration.
- Trello evidence can become stale if checklist parity is assumed from docs instead of checked against the real card.

## Suggested Commits

```text
docs(sprint): plan catalog demo coverage
feat(data): expand catalog demo seeds
test(catalog): cover multi-restaurant demo data
docs(sprint): record catalog demo validation
```
