# Sprint 4 - Home Discovery Interactions

## Objective

Deliver the next Home slice by adding interactive restaurant discovery on top of the validated remote feed foundation while preserving the approved `/home` route contract, localization discipline, semantic theme usage, and the existing datasource/repository boundaries.

Reference plan:

- `.ai/plans/2026-06-01-home-discovery-interactions-plan.md`

Reference prototype:

- `docs/ux/prototypes/home-feed.png`

## Status

Planned / Approved.

Sprint 4 starts from the validated Sprint 3 remote-feed baseline and is limited to interactive search/category discovery on the authenticated Home feed.

## Sprint Goal

Make the Home feed discoverable through search and category selection without opening restaurant details, new navigation destinations, or new backend schema work.

## Scope

- reuse the validated remote Home feed foundation from Sprint 3;
- define explicit discovery-state ownership for selected category and search query;
- add derived filtering logic for the Home restaurant list;
- wire search input and category chips to real interaction state;
- add localized empty-results feedback only if interaction UX requires it;
- preserve the `/home` route contract, current successful composition, and semantic theme/token discipline;
- validate the discovery slice with focused provider/widget/router/guard/Trello suites.

## Backlog

- [ ] Define discovery state ownership and derived feed contract.
- [ ] Implement search and category filtering logic.
- [ ] Wire Home discovery interactions in the UI.
- [ ] Add localized discovery empty-results feedback.
- [ ] Add focused discovery regression coverage.
- [ ] Reconcile docs, memory, and Trello after validation.

## Acceptance Criteria

- [ ] `/home` keeps its protected authenticated route contract.
- [ ] Search and category selection work against the validated remote Home feed foundation.
- [ ] Discovery state ownership lives outside widgets and outside Supabase/datasource code.
- [ ] The default Home success state remains equivalent to Sprint 3 when no discovery filters are active.
- [ ] Discovery empty-results feedback is localized through ARB catalogs and `AppLocalizations`.
- [ ] Presentation styling for discovery interactions uses semantic theme APIs and app tokens only.
- [ ] Focused provider, widget, localization guard, theme guard, router, and governance validation pass.
- [ ] Trello checklist state reflects implementation evidence only.

## Dependencies

- [x] Sprint 3 remote Home feed foundation is completed and validated.
- [x] Existing Riverpod, GoRouter, localization, and theme guardrails.
- [x] Existing Home remote datasource/repository/provider/widget coverage.
- [x] Approved plan: `.ai/plans/2026-06-01-home-discovery-interactions-plan.md`.
- [ ] Implementation approval for Task 1.

## Localization Guard Checklist

- [ ] Every new user-facing string has an ARB key.
- [ ] UI reads strings through `AppLocalizations`.
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`.
- [ ] ARB catalog parity guard remains green after copy changes.
- [ ] New placeholders are declared in template metadata and preserved across translated catalogs.
- [ ] New placeholders and route placeholders are covered by the guard tests.
- [ ] Generated localization freshness guard remains green after ARB changes.

## Theme Guard Checklist

- [ ] UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`).
- [ ] No `Color(0x...)` hardcoded values exist in feature presentation code.
- [ ] No direct `AppLightColors` or `AppDarkColors` usage exists outside `lib/app/theme`.
- [ ] No direct `Colors.*` usage exists in feature presentation when semantic `ColorScheme` roles apply.
- [ ] Visual hardcoded guard test remains green after UI changes.

## Validation Plan

- `flutter test test/features/home/presentation/home_feed_providers_test.dart`
- `flutter test test/features/home/presentation/home_feed_async_providers_test.dart`
- `flutter test test/features/home/presentation/home_page_test.dart`
- `flutter test test/app/routes/app_router_test.dart`
- `flutter test test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/l10n/arb_catalog_parity_test.dart test/app/l10n/generated_localizations_freshness_test.dart`
- `flutter test test/app/theme/no_hardcoded_visual_values_test.dart`
- `flutter test test/app/project_management/trello_guard_checklists_test.dart`
- focused `flutter analyze` on touched Home, localization, and test files

## Technical Notes

- Reuse the remote Home feed aggregate from Sprint 3; do not add schema or migration work in this slice.
- Keep category labels localized in ARB and use stable category IDs/slugs for selection/filtering.
- Keep discovery state in Riverpod and keep widgets free of filtering algorithms.
- Preserve the local delivery-address placeholder until a dedicated profile/address slice exists.

## Risks

- Discovery work can expand quickly into ranking, pagination, and recommendation behavior if not constrained.
- Search normalization can become inconsistent if provider tests do not pin the intended behavior.
- New empty-results copy or selected-state styling can bypass localization/theme guardrails if added ad hoc.
- Home interaction work can accidentally open new navigation destinations if route scope is not kept explicit.

## Out of Scope

- New Supabase schema, migrations, grants, or RLS updates.
- Server-driven search, ranking, pagination, or recommendation logic.
- Restaurant details navigation and deep linking.
- Browse, orders, account, cart, and checkout flows.
- Profile/address persistence.
- Storage-backed media and Realtime updates.

## Suggested Commits

```text
refactor(home): define discovery feed state
feat(home): add discovery filtering logic
feat(home): wire discovery interactions
feat(home): add discovery empty results state
test(home): cover discovery interactions
docs(home): record discovery validation
```
