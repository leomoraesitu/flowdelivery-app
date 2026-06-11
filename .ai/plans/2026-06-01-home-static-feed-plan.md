# Home Static Restaurant Feed Plan

## Objective

Implement the first Home slice as a protected, prototype-aligned restaurant feed using typed local fixture data, Riverpod wiring, centralized routing, Flutter gen-l10n copy, semantic theme APIs, and focused widget tests.

Reference prototype:

- `docs/ux/prototypes/home-feed.png`

## Approved Scope

This slice validates the Home visual composition and local data contract before introducing Supabase tables.

Include:

- protected `/home` route;
- typed local Home models;
- typed local fixture data;
- Home page composition;
- delivery address header;
- visual search field;
- category chips;
- promotional banner;
- featured restaurant cards;
- bottom navigation shell with Home selected;
- focused widget and routing tests;
- Localization Guard and Theme Guard validation.

Defer:

- Supabase schema, RLS, datasource, and repository;
- remote loading;
- functional search and category filtering;
- restaurant details navigation;
- profile, browse, orders, and account destination pages;
- production image hosting strategy;
- loading, empty, and error states for remote data.

## Architecture Decision

Use a presentation-first static slice with typed local fixtures. Do not create a fake repository or datasource merely to simulate remote data. Repository and datasource boundaries will be introduced in a later approved slice when the Supabase schema and remote behavior exist.

The flow for this slice is:

```text
HomePage
↓
Riverpod fixture provider
↓
Typed Home models
↓
Local fixture data
```

The future remote flow remains:

```text
HomePage
↓
Riverpod provider / Home ViewModel
↓
Repository
↓
Datasource
↓
Supabase
```

## Dependencies

- Existing: `flutter_riverpod`
- Existing: `go_router`
- Existing: Flutter gen-l10n ARB pipeline
- Existing: app theme tokens and semantic `ColorScheme`
- Existing: protected-route policy in `lib/app/routes`
- New packages: none

## Implementation Tasks

### Task 1: Define Typed Local Home Models

Concept:

Use immutable presentation-neutral models to describe the static feed. This establishes the minimum data contract without coupling the UI to raw maps or premature backend DTOs.

Files:

- Create `lib/features/home/domain/entities/home_category.dart`
- Create `lib/features/home/domain/entities/home_promotion.dart`
- Create `lib/features/home/domain/entities/home_restaurant.dart`

Checklist:

- [ ] Add immutable `HomeCategory`.
- [ ] Add immutable `HomePromotion`.
- [ ] Add immutable `HomeRestaurant`.
- [ ] Keep Flutter widgets, Supabase types, and JSON mapping out of domain entities.

Validation:

- Use Dart MCP `analyze_files` after `add_roots`.

Skills:

- `flutter-apply-architecture-best-practices`

Commit:

```text
feat(home): add typed restaurant feed models
```

### Task 2: Add Typed Fixture Data and Riverpod Provider

Concept:

Keep fixture ownership explicit and replaceable. The provider exposes typed read-only content to presentation and gives the next remote slice a clear replacement point.

Files:

- Create `lib/features/home/data/fixtures/home_feed_fixtures.dart`
- Create `lib/features/home/presentation/providers/home_feed_providers.dart`
- Create `test/features/home/presentation/home_feed_providers_test.dart`

Checklist:

- [ ] Add typed fixture categories, promotion, and restaurants aligned with the prototype.
- [ ] Expose fixtures through a read-only Riverpod provider.
- [ ] Verify the provider exposes deterministic typed data.
- [ ] Do not create repository or datasource abstractions in this static slice.

Validation:

- Use Dart MCP `run_tests` for `test/features/home/presentation/home_feed_providers_test.dart`.
- Use Dart MCP `analyze_files` on the created files.

Skills:

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

Commit:

```text
feat(home): provide static restaurant feed fixtures
```

### Task 3: Register the Protected Home Route

Concept:

Global route ownership stays in `lib/app/routes`. The Home page becomes the authenticated landing destination without implementing the complete tab shell route tree.

Files:

- Modify `lib/app/routes/app_routes.dart`
- Modify `lib/app/routes/app_router.dart`
- Modify `test/app/routes/app_router_test.dart`

Checklist:

- [ ] Add centralized Home route name and `/home` path.
- [ ] Redirect authenticated users from auth entry routes to `/home`.
- [ ] Redirect unauthenticated users away from `/home` to sign-in.
- [ ] Keep password-recovery route behavior unchanged.
- [ ] Avoid scattering literal route strings through widgets.

Validation:

- Use Dart MCP `run_tests` for `test/app/routes/app_router_test.dart`.
- Use Dart MCP `analyze_files` on the touched routing files.

Skills:

- `flutter-setup-declarative-routing`
- `flutter-add-widget-test`

Commit:

```text
feat(home): register protected home route
```

### Task 4: Add Localized Home Copy

Concept:

All Home user-facing copy must enter through ARB catalogs before the widgets consume it.

Files:

- Modify `lib/l10n/app_pt_BR.arb`
- Modify `lib/l10n/app_pt.arb`
- Modify `lib/l10n/app_en.arb`

Checklist:

- [ ] Add ARB keys for delivery address label, search hint, categories, banner, featured section, see-all action, restaurant metadata, and bottom navigation labels.
- [ ] Add template metadata descriptions and placeholder metadata where needed.
- [ ] Preserve key and placeholder parity across translated catalogs.
- [ ] Run Flutter gen-l10n through Dart MCP tooling.

Localization Guard:

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`.
- [ ] ARB catalog parity guard remains green after copy changes.
- [ ] New placeholders are declared in template metadata and preserved across translated catalogs.
- [ ] New placeholders and route placeholders are covered by the guard tests.
- [ ] Generated localization freshness guard remains green after ARB changes.

Validation:

- Use Dart MCP `run_tests` for:
  - `test/app/l10n/no_hardcoded_ui_strings_test.dart`
  - `test/app/l10n/arb_catalog_parity_test.dart`
  - `test/app/l10n/generated_localizations_freshness_test.dart`

Skills:

- `flutter-setup-localization`

Commit:

```text
feat(home): add localized restaurant feed copy
```

### Task 5: Build the Home Page Composition

Concept:

The page owns composition only. Extract visual sections into focused widgets so the prototype can evolve without turning the page into a large rendering file.

Files:

- Create `lib/features/home/presentation/pages/home_page.dart`
- Create `lib/features/home/presentation/widgets/home_feed_header.dart`
- Create `lib/features/home/presentation/widgets/home_feed_sections.dart`

Checklist:

- [ ] Render the delivery address header and visual search field.
- [ ] Render category chips with the first category visually selected.
- [ ] Render the promotional banner.
- [ ] Render featured restaurant cards from the fixture provider.
- [ ] Render bottom navigation with Home selected and remaining items non-functional.
- [ ] Consume localized copy exclusively through `AppLocalizations`.
- [ ] Use semantic theme roles and app tokens.

Localization Guard:

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded user-facing copy exists in presentation.
- [ ] Localization guard tests remain green.

Theme Guard:

- [ ] UI uses `Theme.of(context)` and tokens (`AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`) when applicable.
- [ ] No `Color(0x...)` hardcoded values exist in presentation.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage exists outside `lib/app/theme`.
- [ ] No direct `Colors.*` usage exists when semantic `ColorScheme` roles apply.
- [ ] Visual hardcoded guard test remains green.

Validation:

- Use Dart MCP `analyze_files` on created presentation files.
- Use Dart MCP `run_tests` for:
  - `test/app/l10n/no_hardcoded_ui_strings_test.dart`
  - `test/app/theme/no_hardcoded_visual_values_test.dart`

Skills:

- `flutter-build-responsive-layout`
- `flutter-add-widget-test`

Commit:

```text
feat(home): create static restaurant feed page
```

### Task 6: Add Focused Home Widget Coverage

Concept:

Widget tests verify the approved static contract without asserting pixel-level details. The tests protect structure, copy flow, selected state, and fixture rendering.

Files:

- Create `test/features/home/presentation/home_page_test.dart`

Checklist:

- [ ] Verify the localized header and search hint render.
- [ ] Verify category chips render and the initial category is selected.
- [ ] Verify promotion copy renders.
- [ ] Verify fixture restaurant names render.
- [ ] Verify Home bottom-navigation item is selected.
- [ ] Verify deferred navigation items remain non-functional.

Validation:

- Use Dart MCP `run_tests` for `test/features/home/presentation/home_page_test.dart`.
- Re-run Home provider, router, localization guard, and theme guard suites.

Skills:

- `flutter-add-widget-test`

Commit:

```text
test(home): cover static restaurant feed page
```

### Task 7: Reconcile Documentation and Memory After Validation

Concept:

Update project records only after implementation evidence exists. Do not mark Trello checklist items complete during planning.

Files:

- Modify `docs/project-management/SPRINT_2.md`
- Modify `.ai/memory/current_feature.md`
- Modify `.ai/memory/current_sprint.md`

Checklist:

- [ ] Record completed tasks and validation evidence.
- [ ] Keep deferred Supabase integration explicit.
- [ ] Update the real Trello card checklist states only for validated items.
- [ ] Add a Trello evidence comment after parity verification.

Validation:

- Review documentation against implemented code.
- Run `flutter test test/app/project_management/trello_guard_checklists_test.dart` through Dart MCP.

Skills:

- `dart-run-static-analysis`

Commit:

```text
docs(home): record static restaurant feed validation
```

## Acceptance Criteria

- [ ] `/home` exists as a protected authenticated route.
- [ ] Home renders the approved static restaurant-feed composition.
- [ ] Local fixture data is typed and exposed through Riverpod.
- [ ] No repository or datasource abstraction is added before remote behavior exists.
- [ ] Search, filters, bottom-tab destinations, and restaurant details remain visibly deferred or non-functional.
- [ ] All user-facing copy comes from ARB catalogs through `AppLocalizations`.
- [ ] Presentation styling uses semantic theme APIs and app tokens.
- [ ] Focused provider, routing, widget, localization guard, and theme guard tests pass.
- [ ] Documentation and Trello reflect validated implementation only.

## Risks

- Static fixtures can accidentally become permanent if the future Supabase slice is not planned explicitly.
- A large Home page can become difficult to maintain if visual sections are not extracted early.
- Prototype images need an explicit asset or remote-hosting strategy during implementation.
- Adding the full authenticated shell prematurely would broaden the route scope beyond this slice.
- Hardcoded copy or colors can bypass design-system guardrails if introduced during visual iteration.

## Out of Scope

- Supabase tables, migrations, RLS, seed data, and remote queries.
- Repository, datasource, DTO, and remote error mapping.
- Functional search and filtering.
- Restaurant details page.
- Full authenticated `StatefulShellRoute`.
- Browse, orders, account, cart, and checkout flows.
- Screenshot golden tests.

