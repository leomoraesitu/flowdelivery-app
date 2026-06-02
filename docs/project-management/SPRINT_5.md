# Sprint 5 - Restaurant Details Remote Catalog

## Objective

Deliver the first product-browsing slice by opening restaurant details from the validated Home feed and rendering a read-only Supabase-backed catalog.

Reference plan:

- `.ai/plans/2026-06-02-restaurant-details-remote-catalog-plan.md`

Reference prototype:

- `docs/ux/prototypes/restaurant-details.png`

## Status

Closed.

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
- [x] Wire async Riverpod composition.
- [x] Add protected restaurant-details route.
- [x] Add restaurant-details UI and delegable Home entry callback.
- [x] Add localized restaurant-details copy.
- [x] Add focused regression coverage.
- [x] Reconcile docs, memory, and Trello after validation.

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
- Dart MCP restaurant-details data regression validation passed with 4 tests, focused analysis reported no errors and `git diff --check` remained clean.
- Task 5 completed — Riverpod now exposes restaurant-details loading by stable restaurant ID, owns selected category state independently per restaurant, and composes the Supabase datasource plus repository at the app boundary.
- Task 5 followed TDD: the focused provider test failed first because the provider file was absent, then passed with 3 tests after the minimal implementation.
- Dart MCP restaurant-details domain/data/provider regression validation passed with 10 tests, focused analysis reported no errors and `git diff --check` remained clean.
- Task 6 completed — restaurant-details copy now lives in ARB catalogs with generated `AppLocalizations` accessors for navigation, async states, retry, empty state, menu labels, metadata, and accessibility.
- Task 6 Localization Guard passed: hardcoded-copy, ARB catalog parity, and generated freshness suites reported 9 passing tests; generated localization analysis reported no errors and `git diff --check` remained clean.
- Task 7 completed — restaurant-details presentation now renders localized async and success states, applies deterministic Riverpod-owned local category filtering, uses semantic theme APIs and app tokens, and exposes optional Home restaurant-card stable-ID callbacks for Task 8 route wiring.
- Task 7 followed TDD: the focused provider test failed first because derived view data did not exist, then passed after the minimal filtering contract landed.
- Dart MCP Home/widget, restaurant-details domain/data/provider, Localization Guard, and Theme Guard matrix passed with 31 tests; focused analysis reported no errors and `git diff --check` remained clean.
- Task 8 completed — centralized GoRouter now protects `/restaurants/:restaurantId`, resolves the route parameter into `RestaurantDetailsPage`, redirects unauthenticated deep links to sign-in, and keeps Home card navigation delegated through the router policy.
- Task 8 validation passed with focused router/widget coverage and focused analysis on the touched routing files.
- Task 9 completed — focused UI regression coverage now proves restaurant-details loading, error, empty, success, category filtering, and back-navigation behavior; Home widget coverage now proves navigation callbacks when restaurant cards are tapped; and domain entities now support `const` constructor for immutable test fixtures.
- Task 9 validation passed with focused restaurant-details/Home widget suites, Localization Guard, Theme Guard, and Trello Guard; the consolidated matrix reported 49 passing tests; focused analysis reported no errors and `git diff --check` remained clean.
- Tasks 7-9 were committed task-by-task on branch `feat/home`: `0ee841a` (catalog UI), `a123a29` (route deep link), `d0590fd` (regression coverage).
- Task 10 completed — Sprint 5 docs, plan, feature/sprint memory, and the real Trello card were reconciled after final governance validation. Real card parity was verified via MCP: the prior "closed" claim was inaccurate, six items were still incomplete (Scope deep-link, three Acceptance Criteria, two Validation), and each was completed against real evidence before the card was moved to `🎉 Done` with a closure comment.

## Acceptance Criteria

- [x] Authenticated users can open restaurant details from Home.
- [x] Unauthenticated details deep links redirect to sign-in.
- [x] Catalog data loads remotely by stable restaurant ID.
- [x] Menu-category filters work locally and deterministically.
- [x] Async and empty states use ARB + `AppLocalizations`.
- [x] UI uses semantic theme APIs and app tokens.
- [x] Supabase access stays inside datasource code.
- [x] Focused test, analyze, guard, and Trello parity validation pass.

## Dependencies

- [x] Sprint 4 Home discovery interactions completed and validated.
- [x] Existing restaurants table and stable Home restaurant IDs.
- [x] Existing Riverpod, GoRouter, Supabase, localization, and theme foundations.
- [x] Approved architecture and technical plan.
- [x] Explicit implementation approval for Tasks 1-3.
- [x] Explicit implementation approval for Task 4.
- [x] Explicit implementation approval for Task 5.
- [x] Explicit implementation approval for Task 6.
- [x] Explicit implementation approval for Task 7.
- [x] Explicit implementation approval for Task 8.
- [x] Explicit implementation approval for Task 9.

## Localization Guard Checklist

- [x] Every new user-facing string has an ARB key.
- [x] UI reads strings through `AppLocalizations`.
- [x] No hardcoded user-facing copy exists in presentation or route UI.
- [x] Template metadata and placeholders remain aligned.
- [x] ARB parity and generated freshness guards remain green.

## Theme Guard Checklist

- [x] UI uses semantic theme APIs and app tokens.
- [x] No `Color(0x...)` exists in feature presentation.
- [x] No direct `AppLightColors` or `AppDarkColors` usage exists outside theme.
- [x] No direct `Colors.*` usage bypasses semantic roles.
- [x] Visual guard remains green.

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
