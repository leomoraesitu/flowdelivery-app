# FlowDelivery — QA Strategy

## Objective

Define the baseline quality strategy for Sprint 0 and future development.

## Validation Layers

### Static Analysis

Run:

```bash
flutter analyze
```

Expected result:

- no analyzer errors
- no critical warnings

### Automated Tests

Run:

```bash
flutter test
```

Expected result:

- all tests pass

### Manual QA

Manual QA should validate:

- main user flow
- loading states
- empty states
- error states
- responsive behavior when applicable
- external-provider behavior when applicable (for auth recovery, include
	inbox/email-provider deliverability on a non-local QA mailbox)

## Evidence

For UI tasks, attach evidence when useful:

- screenshots
- screen recordings
- notes about tested devices

## Definition of Done Alignment

A task should not move to Done unless the applicable criteria in `docs/project-management/DEFINITION_OF_DONE.md` are satisfied.

## Reusable Procedure — Storage-Backed Catalog Media Visual QA

Use this procedure to manually validate catalog media served from the public
`catalog-media` Supabase Storage bucket across the read-only browsing flow
(Home -> restaurant details -> product details). It was defined for Sprint 8
(`.ai/plans/2026-06-08-storage-backed-catalog-media-plan.md`, Task 9) and should
be reused whenever catalog media or the shared media renderer changes.

### Objective

Prove that reviewed Storage objects, database `image_asset_path` values, the
shared public-media URL resolver, and all three Flutter surfaces agree on
**mobile** and **wide** layouts, with no crash and a stable fallback.

### Pre-flight

- Build against the remote Supabase project (`kvbahsdjmhpukzmdttvq`) with
	`--dart-define` for `APP_ENV`, `SUPABASE_URL`, and `SUPABASE_ANON_KEY`.
- Sign in with a valid account (`/home` is a protected route).
- Run online so remote images load through `Image.network`.
- Start cold (or hot-restart) to exercise real loading states.
- Public URL base: `{SUPABASE_URL}/storage/v1/object/public/catalog-media/<objectPath>`.

Run every scenario twice:

- Mobile — narrow phone (for example 390x844).
- Wide — tablet/web at least 1024 wide.

### 1. Home — 4 restaurant covers (16:9)

Open `/home` and confirm each cover loads, is distinct, and matches the cuisine.

| Restaurant | Object path | Expected | Mobile | Wide |
|------------|-------------|----------|--------|------|
| burger_artisan_collective | `restaurants/burger_artisan_collective/cover.webp` | Truffle cheeseburger + fries | [ ] | [ ] |
| pasta_roma | `restaurants/pasta_roma/cover.webp` | Trattoria, pasta/tomato/basil | [ ] | [ ] |
| sushi_zen | `restaurants/sushi_zen/cover.webp` | Nigiri/maki, clean ceramics | [ ] | [ ] |
| taco_harbor | `restaurants/taco_harbor/cover.webp` | Colorful tacos, lime/salsa | [ ] | [ ] |

Also check: 16:9 preserved, no distortion/odd crop, no layout shift while
loading, no text/logo/watermark.

### 2. Restaurant details — 4 product images per restaurant (1:1)

For each restaurant, open `/restaurants/:restaurantId` and confirm the four menu
images load with the correct subject (no placeholder, no swapped image).

- burger_artisan_collective — Mobile [ ] Wide [ ]: signature_truffle,
	spicy_nashville_chicken, sweet_potato_crisp, artisan_milkshake
- pasta_roma — Mobile [ ] Wide [ ]: pasta_roma_nonna_lasagna,
	pasta_roma_truffle_tagliatelle, pasta_roma_pomodoro_rigatoni,
	pasta_roma_caprese_salad
- sushi_zen — Mobile [ ] Wide [ ]: sushi_zen_omakase_sampler,
	sushi_zen_salmon_avocado_roll, sushi_zen_spicy_tuna_roll,
	sushi_zen_chirashi_bowl
- taco_harbor — Mobile [ ] Wide [ ]: taco_harbor_al_pastor,
	taco_harbor_shrimp_tacos, taco_harbor_carne_asada_tacos,
	taco_harbor_elote_cup

### 3. Product details — selected product image

Open the product detail for at least one product per restaurant (ideally all 16)
and confirm the hero image loads the correct subject.

| Restaurant | Sample product | Mobile | Wide |
|------------|----------------|--------|------|
| burger_artisan_collective | signature_truffle | [ ] | [ ] |
| pasta_roma | pasta_roma_nonna_lasagna | [ ] | [ ] |
| sushi_zen | sushi_zen_omakase_sampler | [ ] | [ ] |
| taco_harbor | taco_harbor_al_pastor | [ ] | [ ] |

Full 16/16 coverage is recommended to exercise every manifest object.

### 4. Resilience / fallback (negative cases)

| Scenario | How to simulate | Expected |
|----------|-----------------|----------|
| Broken remote media | Airplane mode / block Storage host mid-load | Theme-safe fallback (context icon), no crash, stable layout |
| Slow loading | Throttle the network | Loading placeholder without layout shift |
| Local fixture/asset | Unconfigured build (no Supabase `--dart-define`) | Home promotion and local fixtures still render via `Image.asset` |
| Home promotion | Inspect promo banner | Unchanged (still a local asset, out of scope) |

### 5. Security confirmation (no new code)

- Flutter contains no service-role or secret key.
- Flutter performs no Storage upload/update/delete (read-only).
- Bucket serves public catalog media only.

### Exit criteria

- 4/4 covers and 16/16 products (menu + detail) render on mobile and wide.
- Broken-media fallback and local-asset fallback validated without crash.
- Security confirmed.
- Evidence (notes + screenshots) recorded; then reconcile the real Trello card
	and the Sprint 8 governance artifacts before any closing commit.
