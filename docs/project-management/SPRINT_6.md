# Sprint 6 - Product Details Read-Only

## Objective

Close the MVP "product browsing" area by opening a protected product-details route from the restaurant catalog and rendering a read-only product surface, without product customization or cart behavior.

Reference plan:

- `.ai/plans/2026-06-02-product-details-read-only-plan.md`

Reference prototype:

- `docs/ux/prototypes/product-details.png`

## Status

Planned. Awaiting per-task implementation approval.

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

- [ ] Define immutable product-details domain contract.
- [ ] Add DTO and remote datasource.
- [ ] Add repository mapping.
- [ ] Wire async Riverpod composition.
- [ ] Add localized product-details copy.
- [ ] Add product-details UI and delegable catalog entry callback.
- [ ] Add protected nested product-details route.
- [ ] Add focused regression coverage.
- [ ] Reconcile docs, memory, and Trello after validation.

## Acceptance Criteria

- [ ] Authenticated users can open a product from the restaurant catalog.
- [ ] Unauthenticated product deep links redirect to sign-in.
- [ ] Product data loads remotely by stable product ID.
- [ ] Loading, error, not-found, and success states use ARB + `AppLocalizations`.
- [ ] UI uses semantic theme APIs and app tokens.
- [ ] Supabase access stays inside datasource code.
- [ ] Focused test, analyze, guard, and Trello parity validation pass.

## Dependencies

- [ ] Sprint 5 restaurant details remote catalog completed and validated.
- [ ] Existing `restaurant_menu_items` table deployed remotely.
- [ ] Existing Riverpod, GoRouter, Supabase, localization, and theme foundations.
- [ ] Approved architecture and technical plan.
- [ ] Explicit per-task implementation approval.

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
