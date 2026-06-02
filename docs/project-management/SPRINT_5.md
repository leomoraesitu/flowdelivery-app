# Sprint 5 - Restaurant Details Remote Catalog

## Objective

Deliver the first product-browsing slice by opening restaurant details from the validated Home feed and rendering a read-only Supabase-backed catalog.

Reference plan:

- `.ai/plans/2026-06-02-restaurant-details-remote-catalog-plan.md`

Reference prototype:

- `docs/ux/prototypes/restaurant-details.png`

## Status

In progress. Tasks 1-4 completed. Awaiting explicit Task 5 implementation approval.

## Sprint Goal

Make restaurant cards navigable and expose a protected read-only menu without expanding into product customization or cart behavior.

## Scope

- add protected `/restaurants/:restaurantId` navigation from Home;
- create a dedicated `restaurant_details` feature;
- reuse existing restaurant IDs and restaurant table;
- add remote menu categories and menu items with grants, RLS, and deterministic seeds;
- load details and catalog on demand;
- filter loaded products by menu category;
- render localized async states and prototype-aligned success UI;
- validate schema, architecture, routing, UI, guards, and Trello parity.

## Backlog

- [x] Define immutable restaurant-details domain contracts.
- [x] Add remote catalog schema.
- [x] Add DTOs and remote datasource.
- [x] Add repository mapping.
- [ ] Wire async Riverpod composition.
- [ ] Add protected restaurant-details route.
- [ ] Add restaurant-details UI and Home entry point.
- [ ] Add localized restaurant-details copy.
- [ ] Add focused regression coverage.
- [ ] Reconcile docs, memory, and Trello after validation.

## Current Progress

- Task 1 completed — immutable `RestaurantDetails`, `RestaurantMenuCategory`, and `RestaurantMenuItem` value models now define the read-only catalog domain boundary.
- TDD RED was observed before implementation because the three entity files were absent.
- Focused Dart MCP validation passed with 3 domain tests, no analyze errors, and a clean `git diff --check`.
- Task 2 completed — versioned Supabase migration now adds read-only menu categories and items with explicit grants, RLS, policies, indexes, constraints, and deterministic seeds.
- Transaction-scoped Supabase MCP smoke validation passed and rolled back cleanly: 4 categories, 4 items, RLS enabled, authenticated read policies present, `anon` denied, and authenticated writes denied.
- Task 3 completed — typed DTOs now parse restaurant, menu-category, and menu-item rows, while the Supabase datasource owns filtered queries by restaurant ID, deterministic ordering, payload orchestration, and explicit remote exceptions.
- Task 3 followed TDD: the focused datasource test failed first because the DTO and datasource files were absent, then passed with 3 tests after the minimal implementation.
- Dart MCP focused analysis reported no errors and `git diff --check` remained clean.
- Task 4 completed — the domain repository contract now exposes loading by stable restaurant ID, while its data-layer implementation maps remote DTOs into immutable restaurant-details entities.
- Task 4 followed TDD: the focused repository test failed first because the implementation file was absent, then passed after the minimal mapping boundary was added.
- Dart MCP restaurant-details data regression validation passed with 4 tests, focused analysis reported no errors, and `git diff --check` remained clean.

## Acceptance Criteria

- [ ] Authenticated users can open restaurant details from Home.
- [ ] Unauthenticated details deep links redirect to sign-in.
- [ ] Catalog data loads remotely by stable restaurant ID.
- [ ] Menu-category filters work locally and deterministically.
- [ ] Async and empty states use ARB + `AppLocalizations`.
- [ ] UI uses semantic theme APIs and app tokens.
- [ ] Supabase access stays inside datasource code.
- [ ] Focused test, analyze, guard, and Trello parity validation pass.

## Dependencies

- [x] Sprint 4 Home discovery interactions completed and validated.
- [x] Existing restaurants table and stable Home restaurant IDs.
- [x] Existing Riverpod, GoRouter, Supabase, localization, and theme foundations.
- [x] Approved architecture and technical plan.
- [x] Explicit implementation approval for Tasks 1-3.
- [x] Explicit implementation approval for Task 4.
- [ ] Explicit implementation approval for Task 5.

## Localization Guard Checklist

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded user-facing copy exists in presentation or route UI.
- [ ] Template metadata and placeholders remain aligned.
- [ ] ARB parity and generated freshness guards remain green.

## Theme Guard Checklist

- [ ] UI uses semantic theme APIs and app tokens.
- [ ] No `Color(0x...)` exists in feature presentation.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage exists outside theme.
- [ ] No direct `Colors.*` usage bypasses semantic roles.
- [ ] Visual guard remains green.

## Validation Plan

- transaction-scoped Supabase SQL smoke test;
- focused domain, datasource, repository, provider, router, and widget tests;
- Home regression suite;
- Localization Guard, Theme Guard, and Trello Guard suites;
- focused analyze on touched files.

## Risks

- Schema scope can drift into product customization.
- Router protection can remain incomplete if only `/home` is treated as authenticated.
- Prototype parity can pull cart, favorite, and share behavior into this slice.
- Catalog UI can accumulate widget-owned filtering logic if Riverpod boundaries are not kept explicit.

## Out of Scope

- Product-details navigation.
- Product customization, variants, add-ons, quantities, and special instructions.
- Favorite and share behavior.
- Cart, checkout, orders, and account flows.
- Persisted profile/address data.
- Storage media, Realtime, pagination, ranking, and recommendations.
