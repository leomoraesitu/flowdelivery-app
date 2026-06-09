# Storage-Backed Catalog Media Plan

## Objective

Replace the placeholder branding image used by the four seeded restaurants and
their sixteen seeded products with deterministic, AI-generated catalog media
served from a public Supabase Storage bucket, without adding upload behavior to
the Flutter client.

## Architectural Context

Sprints 5-7 established a read-only browsing flow backed by Supabase tables.
The existing `image_asset_path` field is already present in the Home,
restaurant-details, and product-details contracts, but all seeded rows currently
point to the same bundled branding asset and presentation renders only through
`Image.asset`.

Sprint 8 keeps the existing field and domain property names to avoid an
unrelated cross-feature rename. For Storage-backed rows, `image_asset_path`
stores a stable object path under the `catalog-media` bucket. A shared data-layer
resolver converts that path into a public URL before presentation receives it.
A shared presentation widget renders either a local asset or a resolved remote
URL during the transition.

```text
AI-generated WebP files
|
v
Supabase Storage: catalog-media (public read)
|
v
Postgres image_asset_path (stable object path)
|
v
Shared public-media resolver in data layer
|
v
Existing DTO -> repository -> domain contracts
|
v
Shared media widget (asset or network, with fallback)
|
v
Home -> restaurant details -> product details
```

The Flutter client remains read-only. Upload, replacement, and deletion are
administrative deployment operations and must not require a service-role key in
the app.

## Approved Media Direction

- Coverage:
  - 4 restaurant cover images;
  - 16 product images;
  - Home promotion media remains unchanged.
- Source: AI-generated and reviewed before upload.
- Style: realistic food photography, natural lighting, clear subject, consistent
  visual treatment.
- Formats:
  - restaurant covers: WebP, 16:9;
  - products: WebP, 1:1.
- Versioned source location outside the Flutter asset bundle:
  - `supabase/seed-assets/catalog/restaurants/`;
  - `supabase/seed-assets/catalog/products/`.
- Storage bucket: `catalog-media`.
- Object naming:
  - `restaurants/<restaurant-id>/cover.webp`;
  - `products/<restaurant-id>/<product-id>.webp`.

## Scope

- define and version a media manifest for exactly 20 deterministic objects;
- generate, review, optimize, and version the 20 WebP files;
- create a public-read `catalog-media` bucket with explicit file constraints;
- keep client-side upload, update, and delete unavailable;
- add a new migration that updates existing restaurant and menu-item
  `image_asset_path` values to stable Storage object paths;
- introduce a shared public-media URL resolver outside presentation;
- inject the resolver into Home, restaurant-details, and product-details remote
  datasources;
- add a shared image renderer supporting local asset fallback and remote URLs;
- update the three existing browsing surfaces to use the shared renderer;
- validate remote object coverage, read access, database paths, datasource
  mapping, widget loading/error behavior, guards, and the complete read-only flow;
- reconcile docs, memory, technical debt, and Trello only after evidence exists.

## Out of Scope

- image upload, replacement, deletion, crop, or moderation in Flutter;
- user-owned media or private buckets;
- signed URLs;
- Home promotion media;
- additional restaurants or products;
- multiple image variants, responsive image sets, blur hashes, transformations,
  or an external CDN;
- cart, checkout, quantity, customization, variants, add-ons, favorites,
  sharing, Realtime, analytics, and recommendations;
- renaming `image_asset_path` or all `imageAssetPath` properties;
- changing restaurant/product copy, pricing, taxonomy, or navigation.

## Key Decisions and Tradeoffs

- Use a public bucket because restaurant and product catalog images are public
  content. Private objects and signed URLs add expiry and authorization
  complexity without protecting user data.
- Store stable object paths rather than complete public URLs. The bucket/project
  address remains an integration detail and can change without rewriting every
  row.
- Keep generated files under `supabase/seed-assets/`, not `assets/images/`.
  `pubspec.yaml` bundles the whole `assets/images/` tree, so placing 20 catalog
  files there would unnecessarily increase the Flutter artifact.
- Keep the existing database column and Dart property names for this slice.
  Their asset-specific naming becomes accepted transitional debt; a rename
  should happen only in a dedicated contract migration.
- Resolve public URLs in a shared data-layer service injected into datasources.
  Widgets must not know bucket names or call Supabase.
- Use one shared renderer instead of duplicating `Image.asset`/`Image.network`
  branching across three features.
- Preserve local fixture/asset support so tests and unconfigured development
  fallback remain deterministic.
- Use immutable object names for this sprint. Replacing an image at the same path
  may require cache invalidation; future media updates should prefer versioned
  filenames unless a cache policy is explicitly designed.

## Dependencies

- Sprints 5-7 closed and deployed.
- Existing Supabase project and migrations.
- Existing restaurant IDs and 16 product IDs.
- `supabase_flutter` already present in `pubspec.yaml`.
- AI image generation capability and human visual review.
- Supabase MCP/CLI access for bucket, SQL, and object validation.
- Existing Localization Guard, Theme Guard, Trello Guard, and focused feature
  tests.

## Current Progress

- [x] Strategy approved: public Supabase Storage with stable paths in Postgres.
- [x] Coverage approved: 4 restaurant covers and 16 product images.
- [x] Source approved: AI-generated media.
- [x] Visual direction approved: realistic food photography.
- [x] Aspect ratios approved: restaurant 16:9 and product 1:1.
- [x] Task 1 - audit IDs, current image contracts, and lock the 20-object manifest.
- [x] Task 2 - generate, review, optimize, and version the media files.
- [x] Task 3 - create and validate the public-read Storage foundation.
- [x] Task 4 - upload and verify the deterministic object set.
- [x] Task 5 - migrate database rows to Storage object paths.
- [x] Task 6 - add the shared data-layer public-media resolver.
- [x] Task 7 - wire the resolver into the three remote datasources.
- [ ] Task 8 - add the shared asset/network renderer and update presentation.
- [ ] Task 9 - run focused and end-to-end validation.
- [ ] Task 10 - reconcile Sprint 8 governance and technical debt.

## Implementation Tasks

### Task 1: Lock the Media Manifest

Concept: establish a one-to-one mapping between existing database IDs, generated
files, and Storage object paths before creating or uploading media.

Files:

- Create `supabase/seed-assets/catalog/manifest.json`
- Modify `.ai/plans/2026-06-08-storage-backed-catalog-media-plan.md`

Responsibilities:

- list exactly 4 restaurant IDs and 16 product IDs already present in remote
  Supabase;
- define object path, aspect ratio, intended dimensions, MIME type, and prompt
  brief for each image;
- reject duplicate paths, missing IDs, or paths outside the approved prefixes;
- keep the promotion ID out of the manifest.

Validation:

- compare manifest IDs with transaction-scoped/read-only Supabase queries;
- parse the JSON manifest and assert 20 unique entries;
- `git diff --check`.

Applicable skills:

- `supabase`
- `fd-supabase-architect`
- `fd-product-owner`

Task 1 evidence (2026-06-08):

- Remote read-only Supabase query on project `kvbahsdjmhpukzmdttvq`
  confirmed exactly 4 target restaurant IDs and 16 target product IDs.
- The same query confirmed `weekend_pizza_party` as the Home promotion ID; it
  is explicitly excluded from the catalog-media target set.
- `supabase/seed-assets/catalog/manifest.json` records 20 unique media entries:
  4 restaurant covers at 1600x900 (16:9) and 16 product images at 1200x1200
  (1:1), all using `image/webp`.
- Object paths are deterministic and limited to:
  `restaurants/<restaurant-id>/cover.webp` and
  `products/<restaurant-id>/<product-id>.webp`.
- Individual prompt briefs are aligned with versioned restaurant cuisines and
  product descriptions.

### Task 2: Generate and Curate the WebP Media

Concept: treat generated media as deterministic delivery assets with explicit
review criteria, not as untracked external artifacts.

Files:

- Create files under `supabase/seed-assets/catalog/restaurants/`
- Create files under `supabase/seed-assets/catalog/products/`
- Modify `supabase/seed-assets/catalog/manifest.json`

Responsibilities:

- generate one realistic image per manifest entry;
- keep restaurant covers at 16:9 and product images at 1:1;
- convert final files to WebP;
- record final width, height, byte size, and SHA-256 checksum in the manifest;
- reject visible text, logos, watermarks, malformed food, inconsistent crops, and
  misleading product imagery;
- keep filenames and paths stable and lowercase.

Validation:

- automated dimension, MIME, file-size, checksum, and manifest parity check;
- manual review of all 20 images against product/restaurant identity;
- `git diff --check`.

Applicable skills:

- `imagegen`
- `fd-ux-reviewer`

Task 2 evidence (2026-06-08):

- Generated and manually reviewed 20 realistic catalog images with no visible
  text, logos, watermarks, malformed food, or misleading product identity.
- Versioned 4 restaurant covers at 1600x900 and 16 product images at 1200x1200,
  all encoded as WebP at quality 86 outside the Flutter asset bundle.
- Final files total 3,844,394 bytes, ranging from 89,032 to 270,636 bytes.
- `manifest.json` records the verified byte size and SHA-256 checksum for every
  file; automated path, count, MIME, dimension, size, and checksum parity passed.
- Final cropped/compressed WebPs passed contact-sheet review and
  `git diff --check`.

### Task 3: Add the Storage Foundation

Concept: provision public catalog reads while keeping all mutation outside the
Flutter client.

Files:

- Create `supabase/migrations/<timestamp>_catalog_media_storage_foundation.sql`
- Modify `docs/setup/SUPABASE_SETUP.md` only if the deployment/runbook needs new
  Storage instructions.

Responsibilities:

- create or reconcile bucket `catalog-media` as public;
- allow only `image/webp`;
- set a file-size limit appropriate for optimized catalog images;
- do not add authenticated-client `INSERT`, `UPDATE`, or `DELETE` policies;
- document that administrative uploads use approved tooling and never expose a
  service-role key to Flutter;
- preserve existing table RLS and grants.

Validation:

- rollback/local smoke where supported;
- inspect `storage.buckets` configuration;
- verify public download behavior and denied client mutations;
- run Supabase security advisors;
- `git diff --check`.

Applicable skills:

- `supabase`
- `supabase-postgres-best-practices`
- `fd-supabase-architect`
- `fd-security-engineer`

Task 3 evidence (2026-06-08):

- Applied remote migration `catalog_media_storage_foundation` to project
  `kvbahsdjmhpukzmdttvq`.
- `storage.buckets` confirms `catalog-media` is public, allows only
  `image/webp`, and limits each object to 1,048,576 bytes.
- `storage.objects` retains RLS and has zero object policies, including zero
  mutation policies; client `INSERT`, `UPDATE`, and `DELETE` remain denied.
- Security advisors reported no new issue; the existing unrelated
  `auth_leaked_password_protection` warning remains open.
- Public download smoke is deferred to Task 4 because no object has been
  uploaded yet.

### Task 4: Upload and Verify the Object Set

Concept: Storage deployment is complete only when every manifest object exists
and its bytes match the reviewed source file.

Files:

- Modify `supabase/seed-assets/catalog/manifest.json` only if deployment metadata
  is recorded.
- Modify `docs/setup/SUPABASE_SETUP.md` only if upload commands/runbook are added.

Responsibilities:

- upload exactly 20 WebP objects to `catalog-media`;
- use the manifest object paths without ad hoc renaming;
- verify content type, object size, and checksum where tooling permits;
- verify each public URL returns an image;
- avoid overwriting unrelated objects.

Validation:

- list objects grouped by approved prefix;
- compare remote object count/path set with the manifest;
- HTTP/public download smoke for representative restaurant and product objects;
- `git diff --check`.

Applicable skills:

- `supabase`
- `fd-supabase-architect`

Task 4 evidence (2026-06-08):

- Uploaded exactly 20 manifest objects to remote bucket `catalog-media`: 4
  restaurant covers and 16 product images totaling 3,844,394 bytes.
- Remote `storage.objects` paths, MIME types, and byte sizes match the
  versioned manifest.
- Publicly downloaded all 20 objects and verified HTTP success, `image/webp`,
  byte size, and SHA-256 with `errors=0`.
- A duplicate upload returned `409 Duplicate`, confirming overwrite remained
  disabled and the existing object was preserved.
- Security advisors reported no new issue; the unrelated existing
  `auth_leaked_password_protection` warning remains open.

### Task 5: Point Catalog Rows to Storage Paths

Concept: database rows reference stable object paths; they do not embed complete
project URLs.

Files:

- Create `supabase/migrations/<timestamp>_catalog_media_paths.sql`

Responsibilities:

- update the 4 existing `restaurants.image_asset_path` values;
- update the 16 existing `restaurant_menu_items.image_asset_path` values;
- use explicit IDs and manifest paths;
- fail validation if any expected row is missing;
- leave `home_promotions.image_asset_path` unchanged;
- do not edit migrations already applied in Sprints 3, 5, or 7.

Validation:

- transaction-scoped SQL smoke before permanent application;
- assert 4 restaurant paths and 16 product paths use approved prefixes;
- assert no target row still uses the branding placeholder;
- assert the Home promotion remains unchanged;
- `git diff --check`.

Applicable skills:

- `supabase`
- `supabase-postgres-best-practices`
- `fd-supabase-architect`

Task 5 evidence (2026-06-08):

- Transaction-scoped remote smoke completed without exception and `ROLLBACK`
  preserved all 4 restaurant and 16 product placeholder paths.
- Applied remote migration `catalog_media_paths` after validating all target
  rows, product ownership, and the 20 required Storage objects.
- Exact post-migration parity is 4/4 restaurant paths and 16/16 product paths,
  with zero target rows retaining the branding placeholder.
- `weekend_pizza_party` remains unchanged on its bundled asset path.
- Security advisors reported no new issue; the unrelated existing
  `auth_leaked_password_protection` warning remains open.

### Task 6: Add a Shared Public-Media Resolver

Concept: bucket knowledge belongs in the data/integration layer, not in widgets
or domain entities.

Files:

- Create `lib/shared/data/media/public_media_url_resolver.dart`
- Create `test/shared/data/media/public_media_url_resolver_test.dart`
- Modify `lib/app/di/app_providers.dart`

Responsibilities:

- define a small resolver contract that receives the stored
  `image_asset_path`;
- preserve local `assets/` paths unchanged;
- convert approved Storage object paths to public URLs for `catalog-media`;
- reject blank or unsupported paths with a typed/explicit failure;
- provide the resolver through app-level Riverpod composition;
- avoid adding a ViewModel or use case because this is integration mapping, not
  mutable UI orchestration.

Validation:

- TDD coverage for local asset passthrough, restaurant path resolution, product
  path resolution, and invalid input;
- Dart MCP focused analysis and tests after `add_roots`;
- `git diff --check`.

Applicable skills:

- `dart-add-unit-test`
- `dart-run-static-analysis`
- `fd-architect`
- `fd-supabase-architect`

Task 6 evidence (2026-06-08):

- Added a shared resolver contract and Supabase implementation under
  `shared/data`, with app-level Riverpod composition.
- Local `assets/` paths remain unchanged; approved `restaurants/` and
  `products/` paths resolve through `catalog-media`.
- Blank and unsupported paths raise an explicit typed failure.
- TDD RED was observed before implementation; the focused suite then passed 6
  tests covering local passthrough, both remote prefixes, both failure modes,
  and provider composition.
- Dart MCP focused analysis returned `No errors`; `pubspec.lock` remained
  unchanged and `git diff --check` passed.

### Task 7: Resolve Media in Existing Remote Datasources

Concept: keep existing DTO/domain contracts stable while ensuring remote rows
carry renderable references before reaching repositories.

Files:

- Modify `lib/features/home/data/datasources/home_remote_datasource.dart`
- Modify `lib/features/restaurant_details/data/datasources/restaurant_details_remote_datasource.dart`
- Modify `lib/features/product_details/data/datasources/product_details_remote_datasource.dart`

Responsibilities:

- inject the shared resolver into each Supabase datasource;
- resolve restaurant and product `image_asset_path` values after row loading and
  before DTO parsing;
- leave Home promotion asset paths unchanged;
- preserve test row-loader seams;
- map resolver failures to each feature's existing remote exception contract;
- keep repositories and domain entities Supabase-free.

Validation:

- focused datasource tests proving resolved restaurant and product URLs;
- regression test proving Home promotion local asset passthrough;
- existing malformed-row and not-found contracts remain green;
- Dart MCP focused analysis and tests after `add_roots`;
- `git diff --check`.

Applicable skills:

- `dart-add-unit-test`
- `dart-run-static-analysis`
- `fd-architect`
- `fd-supabase-architect`

Task 7 evidence (2026-06-08):

- Injected the shared resolver into Home, restaurant-details, and
  product-details Supabase datasources through app-level Riverpod composition.
- Restaurant and product rows now resolve `image_asset_path` before DTO parsing;
  Home promotion paths remain unchanged.
- Resolver failures map to each feature's existing remote exception contract,
  while malformed rows and not-found behavior remain intact.
- TDD RED was observed for the missing constructor dependency; the focused
  datasource suite then passed 14 tests.
- The combined resolver and datasource regression suite passed 20 tests, and
  Dart MCP focused analysis returned `No errors`.

### Task 8: Render Local and Remote Media Consistently

Concept: presentation chooses the Flutter image provider, but it must not know
Supabase bucket or object-path rules.

Files:

- Create `lib/shared/presentation/widgets/app_media_image.dart`
- Create `test/shared/presentation/widgets/app_media_image_test.dart`
- Modify the relevant image sections in Home, restaurant details, and product
  details in separately approved substeps of no more than three files.

Responsibilities:

- render `Image.asset` for local asset references;
- render `Image.network` for resolved HTTP(S) URLs;
- expose `fit`, dimensions, semantic exclusion/label behavior, and a consistent
  error fallback API;
- provide a stable loading state that does not shift layout;
- replace duplicated image branching in the three existing browsing surfaces;
- preserve current aspect-ratio/layout constraints and accessible semantics.

Validation:

- widget tests for local asset, remote loading/success, and remote error fallback;
- focused Home, restaurant-details, and product-details widget tests;
- Localization Guard: no new copy is expected; if copy appears, add ARB keys and
  run hardcoded-copy, parity, and generated-freshness guards;
- Theme Guard: use semantic colors/tokens and keep visual hardcoded guard green;
- Dart MCP focused analysis and tests after `add_roots`;
- `git diff --check`.

Applicable skills:

- `flutter-add-widget-test`
- `flutter-build-responsive-layout`
- `dart-run-static-analysis`
- `fd-ux-reviewer`

### Task 9: Validate the Complete Media Flow

Concept: prove that reviewed objects, database paths, URL resolution, and all
three Flutter surfaces agree.

Files:

- Modify focused tests only where missing evidence is identified.
- Modify `docs/qa/QA_STRATEGY.md` only if a reusable media QA procedure is added.

Responsibilities:

- validate Home shows four distinct restaurant covers;
- validate every restaurant menu resolves four product images;
- validate product details resolves the selected product image;
- validate missing/broken remote media falls back without crashing;
- validate an unconfigured/test fixture path still renders local assets;
- confirm no Flutter code contains service-role credentials or performs Storage
  mutations.

Validation:

- remote object/manifest/database parity checks;
- focused datasource, repository/provider, and widget suites;
- router regression tests for the browsing path;
- Localization Guard, Theme Guard, and Trello Guard;
- consolidated relevant Flutter test matrix via Dart MCP;
- `git diff --check`.

Applicable skills:

- `fd-qa-engineer`
- `fd-security-engineer`
- `dart-run-static-analysis`
- `flutter-add-widget-test`

### Task 10: Reconcile Sprint 8 Governance

Concept: close the sprint only after remote deployment and runtime validation
evidence exist.

Files:

- Modify `docs/project-management/SPRINT_8.md`
- Modify `.ai/memory/current_feature.md`
- Modify `.ai/memory/current_sprint.md`
- Modify `.ai/memory/technical_debt.md`

Responsibilities:

- record task completion and exact validation evidence;
- classify the `image_asset_path` naming mismatch as accepted monitoring debt;
- record cache/versioning guidance for future image replacement;
- validate real Trello checklist parity if a Sprint 8 card is used as evidence;
- keep deferred media capabilities explicit.

Validation:

- Trello Guard;
- real Trello parity check when applicable;
- `git diff --check`.

Applicable skills:

- `fd-product-owner`
- `fd-trello-manager`
- `fd-code-reviewer`

## Acceptance Criteria

- [ ] Exactly 4 restaurant covers and 16 product images are generated, reviewed,
  optimized as WebP, and represented in the versioned manifest.
- [ ] Restaurant covers are 16:9 and product images are 1:1.
- [ ] The 20 approved files are stored under `supabase/seed-assets/catalog/` and
  are not included in the Flutter asset bundle.
- [ ] Public bucket `catalog-media` serves the approved objects.
- [ ] The Flutter client has no Storage mutation behavior and contains no
  privileged key.
- [ ] Postgres stores stable Storage object paths, not complete public URLs.
- [ ] All 4 restaurant rows and all 16 product rows reference valid manifest
  objects.
- [ ] Home promotion media remains unchanged.
- [ ] Home, restaurant details, and product details render Storage-backed images.
- [ ] Local fixture/asset fallback continues to work.
- [ ] Broken remote media renders a stable, theme-safe fallback without crashing.
- [ ] Supabase remains isolated from widgets and domain entities.
- [ ] Focused tests, security checks, guards, and the consolidated regression
  matrix pass.
- [ ] Docs, memory, technical debt, and Trello evidence are reconciled only after
  validation.

## Localization Guard Checklist

- [ ] No new user-facing copy is planned.
- [ ] If copy becomes necessary, each string is added through ARB catalogs.
- [ ] UI consumes `AppLocalizations`.
- [ ] No hardcoded text is introduced in presentation.
- [ ] Hardcoded-copy, ARB parity, and generated freshness guards remain green.

## Theme Guard Checklist

- [ ] Shared loading and error fallbacks use `Theme.of(context)` and app tokens.
- [ ] No `Color(0x...)` is introduced in presentation.
- [ ] No direct `AppLightColors`/`AppDarkColors` usage is introduced outside
  `lib/app/theme`.
- [ ] Existing layout dimensions remain stable while network images load.
- [ ] Visual hardcoded guard remains green.

## Risks

- AI imagery can be visually inconsistent or misleading. Mitigation: locked
  prompts, manifest metadata, and human review before upload.
- Committing 20 images can increase repository size. Mitigation: WebP
  optimization, explicit file-size limits, and exclusion from the Flutter bundle.
- Public objects can be enumerated if paths are known. This is acceptable for
  public catalog content; never reuse this model for user/private media.
- Replacing files at unchanged URLs can show stale CDN/browser cache. Prefer
  versioned filenames for future replacements.
- The `image_asset_path` name becomes less precise when it stores Storage paths.
  Keep as accepted debt to avoid a broad contract rename in this sprint.
- Resolving URLs separately in three datasources can drift. Mitigation: one
  shared resolver with focused contract tests.
- Network images introduce loading and failure states absent from asset-only
  rendering. Mitigation: stable dimensions, loading behavior, fallback widget,
  and widget tests.
- Storage deployment can drift from versioned assets. Mitigation: manifest,
  checksum/path parity validation, and explicit deployment evidence.

## Suggested Commits

```text
docs(sprint): plan storage-backed catalog media
feat(media): add catalog media manifest and assets
feat(storage): provision public catalog media
feat(data): resolve catalog media URLs
feat(ui): render storage-backed catalog media
test(media): validate catalog media flow
docs(sprint): record storage media validation
```
