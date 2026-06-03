# Sprint 7 - Catalog Demo Coverage

## Objective

Expand deterministic restaurant catalog seed coverage so the validated read-only browsing flow supports a stronger portfolio demo across all existing Home restaurants.

Reference plan:

- `.ai/plans/2026-06-03-catalog-demo-coverage-plan.md`

## Status

In Progress.

## Sprint Goal

Make Home -> restaurant details -> product details feel complete for every existing seeded restaurant, without adding cart, checkout, customization, Storage, Realtime, or new UI behavior.

## Scope

- add deterministic menu categories and menu items for:
  - `pasta_roma`;
  - `sushi_zen`;
  - `taco_harbor`;
- preserve the existing `burger_artisan_collective` catalog;
- keep seed rows idempotent with stable lowercase IDs and deterministic sort order;
- use the existing placeholder asset path until Storage media is approved;
- validate read-only Supabase access and current datasource/repository compatibility;
- add focused regression coverage where current tests do not prove multi-restaurant catalog/product loading;
- reconcile docs, memory, technical debt, and Trello evidence after validation.

## Backlog

- [x] Audit current seed baseline and expected target counts.
- [x] Add deterministic catalog demo seed migration.
- [x] Validate Supabase read contracts, RLS, grants, and datasource compatibility.
- [ ] Add focused multi-restaurant catalog/product regression coverage.
- [ ] Reconcile docs, memory, technical debt, and Trello after validation.

## Current Progress

- Task 1 completed — local migrations and remote Supabase read-only queries confirmed the seed baseline: all four Home restaurants exist, while only `burger_artisan_collective` currently has menu coverage (4 categories and 4 items). The Sprint 7 target remains valid: add at least 3 categories and 4 menu items for each of `pasta_roma`, `sushi_zen`, and `taco_harbor`.
- Task 2 completed — `supabase/migrations/20260603183000_catalog_demo_coverage.sql` adds deterministic idempotent seeds for the three unseeded restaurants: 9 menu categories and 12 menu items total, preserving the existing `burger_artisan_collective` rows and existing table/grant/RLS contracts.
- Task 2 validation passed — `git diff --check` reported no errors; Supabase MCP executed the migration SQL inside a rollback transaction without persisting data; post-rollback checks confirmed the remote baseline remained unchanged.
- Task 3 completed — Supabase MCP applied remote migration `catalog_demo_coverage` to project `kvbahsdjmhpukzmdttvq`; migration history now includes `20260603184708 catalog_demo_coverage`.
- Task 3 validation passed — remote catalog counts are now 13 categories and 16 items; every existing Home restaurant has non-empty catalog data, `burger_artisan_collective` remains 4 categories/4 items, RLS remains enabled, `authenticated` retains read-only access, `anon` remains denied, and datasource-shaped queries load categories/items by `restaurant_id` plus a seeded non-burger product by `id`.
- Task 3 security validation passed — Supabase security advisors reported no new table/RLS issue; the only warning remains the unrelated Auth-level `auth_leaked_password_protection` advisory.
- Real Trello card `https://trello.com/c/TLHgmJ02` was updated with Task 1 and Task 2 evidence. Task 3 evidence still needs real-card reconciliation in the governance task after focused regression coverage exists.

## Acceptance Criteria

- [x] Existing `burger_artisan_collective` behavior remains unchanged after definitive validation/application.
- [x] `pasta_roma`, `sushi_zen`, and `taco_harbor` each have non-empty menu categories and menu items.
- [ ] Restaurant details can render a non-empty catalog for each existing Home restaurant.
- [ ] Product details can load seeded products from non-burger restaurants by stable product ID.
- [x] Supabase access remains read-only for authenticated clients and denied to `anon` as designed.
- [ ] No cart, checkout, customization, variants, add-ons, quantity, favorites, sharing, Storage, or Realtime behavior is introduced.
- [ ] Focused tests, SQL smoke validation, and guard checks pass.

## Dependencies

- [x] Sprint 5 restaurant details remote catalog completed and deployed.
- [x] Sprint 6 product details read-only completed and validated.
- [x] Existing restaurant IDs in `public.restaurants`.
- [x] Existing menu tables, grants, RLS, and datasource/repository boundaries.
- [x] User approval for Sprint 7 direction.
- [x] Explicit per-task implementation approval.

## Localization Guard Checklist

- [ ] No new user-facing copy is expected.
- [ ] If copy becomes necessary, every string must be added through ARB + `AppLocalizations`.
- [ ] Hardcoded-copy, ARB parity, and generated freshness guards remain green if localization changes.

## Theme Guard Checklist

- [ ] No visual changes are expected.
- [ ] If UI changes become necessary, use semantic theme APIs and app tokens.
- [ ] Visual hardcoded guard remains green if presentation files change.

## Validation Plan

- transaction-scoped Supabase SQL smoke test where available;
- focused datasource/repository/provider tests touched by the seed expansion;
- restaurant-details and product-details regression coverage where needed;
- Localization Guard and Theme Guard only if UI/localization changes occur;
- Trello Guard and real Trello parity if a Sprint 7 card is used as evidence;
- `git diff --check`.

## Risks

- Seed expansion can drift into schema/product modeling if variants or options are introduced.
- Demo data can accidentally violate lowercase ID, FK, or sort-order constraints.
- Updating historical applied migrations would make deployment history ambiguous.
- External Trello state can drift from docs if real checklist parity is not revalidated.

## Out of Scope

- Cart, checkout, orders, quantity, variants, add-ons, and special instructions.
- Favorites and sharing behavior.
- Persisted profile/address data.
- Storage-backed media.
- Realtime, ranking, pagination, recommendations, and analytics.
- New restaurants or Home taxonomy changes unless separately approved.
