# Sprint 5 - Restaurant Details Remote Catalog

## Objective

Deliver the first product-browsing slice by opening restaurant details from the validated Home feed and rendering a read-only Supabase-backed catalog.

Reference plan:

- `.ai/plans/2026-06-02-restaurant-details-remote-catalog-plan.md`

Reference prototype:

- `docs/ux/prototypes/restaurant-details.png`

## Status

Planned. Architecture approved. Awaiting explicit Task 1 implementation approval.

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

- [ ] Define immutable restaurant-details domain contracts.
- [ ] Add remote catalog schema.
- [ ] Add DTOs and remote datasource.
- [ ] Add repository mapping.
- [ ] Wire async Riverpod composition.
- [ ] Add protected restaurant-details route.
- [ ] Add restaurant-details UI and Home entry point.
- [ ] Add localized restaurant-details copy.
- [ ] Add focused regression coverage.
- [ ] Reconcile docs, memory, and Trello after validation.

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
- [ ] Explicit implementation approval for Task 1.

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
