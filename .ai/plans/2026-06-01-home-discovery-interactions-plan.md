# Home Discovery Interactions Plan

## Objective

Add the first interactive restaurant-discovery behaviors to the authenticated Home feed by enabling category filtering and search over the already validated remote feed foundation, while preserving the approved `/home` route contract, semantic theme usage, localization guardrails, and the existing remote datasource/repository boundaries.

Reference prototype:

- `docs/ux/prototypes/home-feed.png`

## Approved Scope

This slice introduces the minimum interactive discovery behavior required to make the Home feed searchable and filterable without expanding into restaurant details, destination navigation, pagination, or new backend schema work.

Include:

- reuse the validated remote Home feed foundation from Sprint 3 as the only data source;
- define explicit discovery-state ownership for selected category and search query;
- derive filtered restaurant results from the remote Home feed without introducing widget-owned filtering logic;
- wire the existing Home search input and category chips to real interaction state;
- keep category labels localized via ARB + `AppLocalizations`;
- add localized empty-results feedback and a localized reset/clear affordance only if required by the approved UX;
- preserve the current `/home` route ownership, remote repository contract, and semantic theme/token discipline;
- validate provider, widget, router, localization guard, theme guard, and Trello-governance coverage.

Defer:

- new Supabase tables, migrations, grants, or RLS changes;
- server-driven ranking, pagination, or recommendation logic;
- restaurant details navigation and deep linking;
- browse, orders, account, cart, and checkout destination flows;
- profile/address persistence;
- Storage-backed media and Realtime updates.

## Architecture Decision

Keep the Sprint 3 remote feed foundation intact and add discovery as a presentation-facing state layer on top of it. The remote datasource and repository continue to return the Home feed aggregate; discovery state determines how that aggregate is filtered for rendering.

The flow for this slice becomes:

```text
HomePage
↓
Home discovery state/provider
↓
Derived filtered Home feed provider
↓
HomeRepository
↓
HomeRemoteDatasource
↓
Supabase
```

This keeps:

- Supabase access inside the datasource only;
- remote/domain mapping inside the repository layer;
- search/category selection state in Riverpod;
- widgets focused on composition and user interaction only.

## Discovery Contract

- Search operates on the already loaded remote Home restaurant collection and stays scoped to the current Home feed.
- Category filtering uses stable category IDs/slugs, while UI labels continue to come from ARB + `AppLocalizations`.
- Discovery state must support a deterministic "all categories" baseline and an empty search query baseline.
- Empty-results UI must distinguish "remote feed has no content" from "current search/filter produced no matches" if both states exist in the UX.
- The delivery-address placeholder remains local and must not influence discovery-state design.

## Dependencies

- Existing: Sprint 3 remote Home feed foundation
- Existing: `flutter_riverpod`
- Existing: `go_router`
- Existing: `AppLocalizations` ARB pipeline
- Existing: Theme Guard and Localization Guard suites
- Existing: Home remote datasource/repository/provider/widget test coverage
- New packages: none

## Implementation Tasks

### Task 1: Define Discovery State Ownership and Derived Feed Contract

Concept:

Before wiring interactions, define where search query and selected category live and expose a derived provider contract that presentation can read without embedding filtering logic inside widgets.

Files:

- Modify `lib/features/home/presentation/providers/home_feed_providers.dart`
- Modify or create focused Home provider tests

Checklist:

- [ ] Introduce explicit discovery state ownership for selected category and search query.
- [ ] Expose a derived filtered feed/view model contract for presentation.
- [ ] Keep filtering logic out of widgets.
- [ ] Preserve the current Home success rendering path when discovery state is at its default values.

Validation:

- Run focused provider tests.
- Run focused analyze on Home provider files.

Commit:

```text
refactor(home): define discovery feed state
```

### Task 2: Implement Search and Category Filtering Logic

Concept:

Use the validated remote Home feed aggregate from Sprint 3 and derive filtered restaurant results in a deterministic, testable provider path without broadening into new backend/schema work.

Files:

- Modify `lib/features/home/presentation/providers/home_feed_providers.dart`
- Modify focused Home provider tests

Checklist:

- [ ] Filter featured restaurants by selected category using stable category IDs/slugs.
- [ ] Filter featured restaurants by normalized search query.
- [ ] Keep the default state equivalent to the validated Sprint 3 success state.
- [ ] Keep provider behavior deterministic for combined search + category filtering.

Validation:

- Run focused provider tests for default, category, search, and combined-filter states.

Commit:

```text
feat(home): add discovery filtering logic
```

### Task 3: Wire Home Discovery Interactions in the UI

Concept:

The Home page should now drive the discovery state from the approved search input and category chips while preserving the current route contract and successful remote-feed composition.

Files:

- Modify `lib/features/home/presentation/pages/home_page.dart`
- Modify `lib/features/home/presentation/widgets/home_feed_header.dart`
- Modify `lib/features/home/presentation/widgets/home_feed_sections.dart`
- Modify focused Home widget tests

Checklist:

- [ ] Search input updates the approved discovery-state owner.
- [ ] Category chip selection updates the approved discovery-state owner.
- [ ] Selected-category UI remains deterministic and theme-safe.
- [ ] The successful Home layout remains structurally aligned with the approved prototype.

Validation:

- Re-run focused Home page/widget tests.
- Re-run router regression if widget composition changes affect route expectations.

Commit:

```text
feat(home): wire discovery interactions
```

### Task 4: Add Localized Discovery Empty-Results Feedback

Concept:

Interactive discovery introduces a new user-facing state when the remote feed exists but the current search/filter combination yields no matches. Add only the minimum localized UX needed for recovery.

Files:

- Modify `lib/features/home/presentation/pages/home_page.dart`
- Modify `lib/l10n/app_pt_BR.arb`
- Modify `lib/l10n/app_pt.arb`
- Modify `lib/l10n/app_en.arb`
- Update generated localization files after gen-l10n
- Modify focused Home widget tests

Checklist:

- [ ] Render a localized empty-results state for the active discovery query.
- [ ] Add a localized clear/reset affordance if required by the approved UX.
- [ ] Keep Sprint 3 remote-loading, remote-empty, and remote-error states intact.
- [ ] Continue using semantic theme roles and app tokens only.

Localization Guard:

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`.
- [ ] ARB catalog parity guard remains green after copy changes.
- [ ] New placeholders are declared in template metadata and preserved across translated catalogs.
- [ ] New placeholders and route placeholders are covered by the guard tests.
- [ ] Generated localization freshness guard remains green after ARB changes.

Theme Guard:

- [ ] UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`).
- [ ] No `Color(0x...)` hardcoded values in feature presentation code.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage outside `lib/app/theme`.
- [ ] No direct `Colors.*` hardcoded usage in feature presentation when equivalent semantic `ColorScheme` roles exist.
- [ ] Visual hardcoded guard test remains green after UI changes.

Validation:

- Run `flutter test` for localization and theme guard suites.
- Re-run focused Home page/widget tests.

Commit:

```text
feat(home): add discovery empty results state
```

### Task 5: Add Focused Discovery Regression Coverage

Concept:

The new interaction layer needs regression coverage that keeps provider logic, widget rendering, and localization/theme guarantees independent and deterministic.

Files:

- Modify `test/features/home/presentation/home_feed_async_providers_test.dart`
- Modify `test/features/home/presentation/home_feed_providers_test.dart`
- Modify `test/features/home/presentation/home_page_test.dart`
- Create any additional focused Home test files required by Tasks 1-4

Checklist:

- [ ] Verify the default state still renders the validated remote Home feed.
- [ ] Verify category filtering changes the rendered restaurant set deterministically.
- [ ] Verify search filtering changes the rendered restaurant set deterministically.
- [ ] Verify combined search + category filtering and localized empty-results behavior.
- [ ] Keep provider tests independent from widget layout assertions.

Validation:

- Run focused Home provider/widget suites.
- Re-run router, localization guard, theme guard, and Trello guard suites as applicable.

Commit:

```text
test(home): cover discovery interactions
```

### Task 6: Reconcile Documentation, Memory, and Trello After Validation

Concept:

Only after the discovery slice is validated should project records and the real Trello story advance. Documentation must reflect implemented behavior, not the intended design.

Files:

- Modify `docs/project-management/SPRINT_4.md`
- Modify `.ai/memory/current_feature.md`
- Modify `.ai/memory/current_sprint.md`
- Update the real Trello card after parity verification

Checklist:

- [ ] Record completed tasks and validation evidence.
- [ ] Keep deferred details/navigation/pagination/profile scope explicit.
- [ ] Confirm Trello checklist state matches validated implementation only.
- [ ] Add a Trello evidence comment after real-card parity verification.

Validation:

- Review documentation against implemented code.
- Run `flutter test test/app/project_management/trello_guard_checklists_test.dart`.

Commit:

```text
docs(home): record discovery validation
```

## Acceptance Criteria

- [ ] `/home` keeps its protected authenticated route contract.
- [ ] Search and category selection work against the validated remote Home feed foundation.
- [ ] Discovery state ownership lives outside widgets and outside Supabase/datasource code.
- [ ] The default Home success state remains equivalent to Sprint 3 when no discovery filters are active.
- [ ] Discovery empty-results feedback is localized through ARB + `AppLocalizations`.
- [ ] Presentation styling for discovery interactions uses semantic theme APIs and app tokens only.
- [ ] Focused provider, widget, localization guard, theme guard, router, and documentation/Trello parity validation pass.

## Risks

- Discovery logic can accidentally expand into ranking, pagination, or recommendation behavior if filtering rules are not tightly bounded.
- Widgets can become stateful and harder to test if search/filter state leaks out of Riverpod.
- New empty-results copy can bypass localization or theme guardrails if added ad hoc.
- Search semantics can become unstable if normalization rules are not made explicit in provider tests.

## Out of Scope

- New Supabase schema, migrations, grants, or RLS work.
- Server-side search, ranking, pagination, or recommendation systems.
- Restaurant detail flows and deep linking.
- Browse, orders, account, cart, and checkout destination flows.
- Profile/address persistence.
- Storage media hosting and Realtime updates.

## Suggested Commits

```text
refactor(home): define discovery feed state
feat(home): add discovery filtering logic
feat(home): wire discovery interactions
feat(home): add discovery empty results state
test(home): cover discovery interactions
docs(home): record discovery validation
```
