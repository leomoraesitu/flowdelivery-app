# Sprint 8 - Storage-Backed Catalog Media

## Objective

Replace catalog placeholder branding with consistent, realistic
Supabase Storage media for all existing restaurants and products.

Reference plan:

- `.ai/plans/2026-06-08-storage-backed-catalog-media-plan.md`

## Status

Closed on 2026-06-11. The runtime slice, automated validation, and
authenticated mobile/wide visual QA are complete. All seven real Trello
checklists are complete, final evidence is recorded, and
`https://trello.com/c/PXq6TWpP` is in `Done`.

## Sprint Goal

Make Home -> restaurant details -> product details visually credible for all
existing seeded catalog entries by serving 4 restaurant covers and 16 product
images from a public read-only Supabase Storage bucket.

## Story

As a portfolio reviewer browsing FlowDelivery, I want each restaurant and product
to display relevant, consistent food photography so that the complete read-only
catalog flow feels intentional and production-oriented.

## Estimate

- Story points: 8
- Confidence: Medium
- Main uncertainty: AI media generation/curation and remote Storage deployment
  parity.

## Scope

- generate and review 4 restaurant covers and 16 product images;
- use realistic food photography with natural lighting;
- use WebP, 16:9 for restaurant covers, and 1:1 for products;
- keep final files versioned under `supabase/seed-assets/catalog/`, outside the
  Flutter asset bundle;
- create a public-read `catalog-media` Storage bucket;
- keep upload/update/delete administrative and outside Flutter;
- store stable object paths in existing `image_asset_path` columns;
- resolve public URLs in a shared data-layer service;
- support local assets and remote images through a shared presentation widget;
- integrate Home, restaurant details, and product details;
- preserve loading/error fallback, accessibility, Localization Guard, and Theme
  Guard behavior;
- reconcile governance only after remote and runtime validation.

## Backlog

- [x] Task 1 - lock the 20-object media manifest against existing remote IDs.
- [x] Task 2 - generate, curate, optimize, and version the 20 WebP files.
- [x] Task 3 - create and validate the public-read Storage foundation.
- [x] Task 4 - upload and verify all manifest objects.
- [x] Task 5 - migrate restaurant and product rows to Storage object paths.
- [x] Task 6 - add and compose the shared public-media resolver.
- [x] Task 7 - resolve media through Home, restaurant-details, and
  product-details datasources.
- [x] Task 8 - add the shared asset/network renderer and update presentation.
- [x] Task 9 - validate the complete remote media flow and regressions.
- [x] Task 10 - reconcile docs, memory, technical debt, and Trello.

## Acceptance Criteria

- [x] Exactly 20 reviewed WebP files exist: 4 restaurant covers and 16 product
  images.
- [x] Restaurant covers use 16:9 and product images use 1:1.
- [x] Generated files are versioned outside `assets/images/` and do not
  increase the Flutter asset bundle.
- [x] `catalog-media` supports public reads for approved catalog objects.
- [x] Flutter exposes no upload/update/delete behavior and no privileged key.
- [x] Database rows store stable object paths rather than complete public URLs.
- [x] All restaurant and product paths match the versioned manifest and
  existing database IDs.
- [x] Home promotion media remains unchanged.
- [x] Home renders four distinct restaurant covers.
- [x] Restaurant details renders the four product images for each restaurant.
- [x] Product details renders the selected product image.
- [x] Local fixture assets remain supported.
- [x] Remote loading and failure preserve layout and show a theme-safe fallback.
- [x] Supabase bucket knowledge remains outside widgets and domain entities.
- [x] Focused tests, security checks, guards, and regression validation pass.

## Dependencies

- [x] Sprints 5-7 closed and deployed.
- [x] Four existing restaurant IDs and sixteen existing product IDs.
- [x] `supabase_flutter` already installed.
- [x] Architecture approved: public bucket, stable paths, shared resolver.
- [x] Media direction approved: AI-generated realistic photography.
- [x] Aspect ratios approved: restaurant 16:9, product 1:1.
- [x] Explicit approval before each implementation task.
- [x] Supabase MCP/CLI access for deployment and validation.
- [x] Human visual approval of generated media before upload.

## Localization Guard Checklist

- [x] No new user-facing copy is expected.
- [x] Any necessary copy is added through ARB + `AppLocalizations`.
- [x] No hardcoded presentation strings are introduced.
- [x] Hardcoded-copy, ARB parity, and generated freshness guards remain green.

## Theme Guard Checklist

- [x] Loading and error fallbacks use semantic theme APIs and app tokens.
- [x] Image containers retain stable dimensions during network loading.
- [x] No hardcoded presentation colors are introduced.
- [x] Visual hardcoded guard remains green.

## Security Checklist

- [x] The bucket contains public catalog media only.
- [x] Flutter contains no service-role or secret key.
- [x] Flutter performs no Storage mutation.
- [x] No authenticated-client mutation policy is added for catalog media.
- [x] Public object access is validated separately from table RLS/grants.
- [x] Supabase security advisors show no new relevant issue.

## Validation Plan

- manifest parse, uniqueness, dimensions, MIME, size, and checksum checks;
- remote Storage object/path parity and public download smoke;
- transaction-scoped SQL validation before applying path updates;
- datasource tests for URL resolution and failure mapping;
- shared widget tests for asset, network, loading, and error behavior;
- focused Home, restaurant-details, and product-details tests;
- browsing-route regression tests;
- Localization Guard, Theme Guard, Trello Guard, and `git diff --check`;
- manual visual QA for all 20 images on representative mobile and wide layouts.

Task 9 validation evidence (2026-06-11):

- Dart MCP focused analysis: `No errors`.
- Consolidated focused matrix: 73 tests passed.
- Remote parity: 4 restaurant paths, 16 product paths, and 20 WebP objects.
- Authenticated Chrome QA: 1280x900 and 390x844.
- Visual coverage: 4/4 covers, 16/16 menu images, and representative product
  details for Burger, Pasta, Sushi, and Taco.
- No persistent fallback, crash, overflow, or layout shift was found.
- Real Trello closure: all seven checklists complete, final evidence comment
  recorded, and the card moved to `Done`.

## Risks

- Generated media may be inconsistent or contain visual artifacts.
- Repository size may grow if WebP optimization limits are not enforced.
- Public object URLs are unsuitable for future private/user media.
- Replacing an object at the same URL may retain stale CDN/browser cache.
- Existing `image_asset_path` naming becomes transitional debt for remote paths.
- Network loading can introduce layout shifts or weak fallback behavior.
- Remote Storage objects can drift from the versioned manifest.
- Future media replacements should use versioned filenames to avoid stale cache
  behavior.

## Out of Scope

- Home promotion media.
- In-app upload, replacement, deletion, crop, or moderation.
- User/private media and signed URLs.
- Responsive image variants, transformations, blur hashes, or external CDN.
- Renaming existing image database/Dart contracts.
- New restaurants, products, categories, copy, pricing, or navigation.
- Cart, checkout, orders, customization, quantity, variants, add-ons, favorites,
  sharing, Realtime, recommendations, and analytics.
