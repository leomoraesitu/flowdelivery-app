# Sprint 6 - Product Details Read-Only

## Objective

Close the MVP "product browsing" area by opening a protected product-details route from the restaurant catalog and rendering a read-only product surface, without product customization or cart behavior.

Reference plan:

- `.ai/plans/2026-06-02-product-details-read-only-plan.md`

Reference prototype:

- `docs/ux/prototypes/product-details.png`

## Status

Completed (2026-06-03). All 9 tasks implemented and validated task-by-task; the real Trello card is fully checked and moved to `🎉 Done` (https://trello.com/c/8amTB8F3). No new migration was required; the feature reuses `restaurant_menu_items`.

## Delivery Evidence

- Consolidated regression matrix: 45 tests green (product_details domain/datasource/repository/provider + 5 page widget tests; restaurant_details widget regression incl. catalog card-tap delegation; router 11; Localization Guard; Theme Guard; Trello Guard).
- `flutter analyze` clean on all touched files; `flutter gen-l10n` refreshed for 11 `productDetails*` keys.
- Task commits on `feat/home`: `3d98b99` (domain), `c57cb34` (datasource), `d25ada2` (repository), `bd1a704` (providers), `f02c46e` (localized copy), `b857954` (UI), `bf95ef7` (route), `d22423b` (tests).
- Not-found contract (Finding A): repository returns `ProductDetails?`; `null` → localized not-found state, exceptions → error state.

## Demo Data Follow-up

Only `burger_artisan_collective` is seeded in `restaurant_menu_items`, so products from other restaurants resolve to the localized not-found state by design. Broad catalog seed expansion remains a separate future data slice (out of scope here).

## Sprint Goal

Make catalog product cards navigable and expose a protected read-only product surface loaded on demand by stable product ID, reusing the existing `restaurant_menu_items` table without a new migration.

## Scope

- add protected `/restaurants/:restaurantId/products/:productId` navigation from the restaurant catalog;
- create a dedicated `product_details` Clean Architecture feature;
- reuse existing `restaurant_menu_items` rows and stable product IDs;
- load product details on demand by product ID;
- render localized loading, error, not-found, and success states;
- keep presentation on semantic theme APIs and app tokens;
- validate architecture, routing, UI, guards, and Trello parity.

## Backlog

- [x] Define immutable product-details domain contract.
- [x] Add DTO and remote datasource.
- [x] Add repository mapping.
- [x] Wire async Riverpod composition.
- [x] Add localized product-details copy.
- [x] Add product-details UI and delegable catalog entry callback.
- [x] Add protected nested product-details route.
- [x] Add focused regression coverage.
- [x] Reconcile docs, memory, and Trello after validation.

## Acceptance Criteria

- [x] Authenticated users can open a product from the restaurant catalog.
- [x] Unauthenticated product deep links redirect to sign-in.
- [x] Product data loads remotely by stable product ID.
- [x] Loading, error, not-found, and success states use ARB + `AppLocalizations`.
- [x] UI uses semantic theme APIs and app tokens.
- [x] Supabase access stays inside datasource code.
- [x] Focused test, analyze, guard, and Trello parity validation pass.

## Dependencies

- [x] Sprint 5 restaurant details remote catalog completed and validated.
- [x] Existing `restaurant_menu_items` table deployed remotely.
- [x] Existing Riverpod, GoRouter, Supabase, localization, and theme foundations.
- [x] Approved architecture and technical plan.
- [x] Explicit per-task implementation approval.

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

- focused domain, datasource, repository, provider, router, and widget tests;
- restaurant-details regression suite;
- Localization Guard, Theme Guard, and Trello Guard suites;
- focused analyze on touched files.

## Risks

- Prototype parity can pull add-to-cart, quantity, and customization behavior into this slice.
- Loading from the cached catalog instead of on demand would break cold deep links.
- Router protection can regress if the nested path is excluded from the protected-route classifier.
- New copy and styling can bypass guards if localization and widget work are combined without validation.

## Out of Scope

- Add-to-cart, quantity, customization, variants, add-ons, and special instructions.
- Favorite and share behavior.
- Cart, checkout, orders, and account flows.
- Persisted profile/address data.
- Broad catalog seed expansion for the other restaurants.
- Storage media, Realtime, pagination, ranking, and recommendations.
