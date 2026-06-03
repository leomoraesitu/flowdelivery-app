# Technical Debt

## Active Items

### Session persistence classification policy

Status:
Policy active

Impact:
Low

Notes:
- Session persistence remains Planned Scope when it is outside the current sprint scope, has no active QA/production regression, and does not require recurring manual workarounds.
- Session persistence must be promoted to Technical Debt when there is a partially implemented flow causing inconsistency, recurring unexpected sign-out, auth redirect loops, loss of critical auth state, or frequent manual mitigation.
- Keep the current classification as Planned Scope / Monitoring while no reproducible regression exists.
- Reclassify immediately if session behavior starts impacting approved delivery scope or introduces security/compliance risks.

### Align generated documentation with implementation

Status:
Reduced / Monitoring

Impact:
Low

Notes:
- Several AI/project workflow files were created before feature implementation.
- Sprint 0 governance docs and local Trello artifacts were reconciled after theme, labels and Trello sync tasks.
- Future feature work must keep docs aligned with real code.
- Routing documentation remains reconciled with the deferred implementation decision.
- `docs/PROJECT_BOOTSTRAP.md` now separates implemented Supabase/Auth behavior from planned database, realtime, storage, Edge Functions, Google OAuth, role-based access, and secure-storage work.
- Historical `.ai/plans` remain as implementation records and should not be treated as current source of truth when they conflict with repository code.

### Keep auth documentation aligned with implementation

Status:
Reduced / Monitoring

Impact:
Low

Notes:
- `flutter_riverpod`, `go_router`, and `supabase_flutter` are already present in `pubspec.yaml`.
- Supabase initialization at app startup was implemented in Task 9.
- Auth dependency wiring now uses app-level provider overrides and an unconfigured repository fallback when Supabase Dart defines are absent.
- Sign-in UI was updated for prototype parity (`docs/ux/prototypes/auth-screen.png`) and must remain synchronized with auth page tests.
- `docs/PROJECT_BOOTSTRAP.md` now documents current auth support as email/password plus password recovery request, with Google OAuth, reset deep-link completion, profile synchronization, and role-based access marked as planned.
- Sprint 1 auth foundation is complete and validated; treat auth docs as closed-slice history plus regression baseline.
- Keep docs/memory synchronized with each validated implementation slice before reducing this debt further.

### Keep auth UI parity scoped to visual layer

Status:
Reduced / Monitoring

Impact:
Low

Notes:
- Sign-in UI now includes prototype-aligned visual affordances (forgot password, social providers, reports tab) as presentation-only elements.
- Do not treat these affordances as implemented auth capabilities until explicitly planned and approved.
- Future tasks should either wire real behavior or clearly keep these controls as non-functional placeholders.
- Shared auth presentation shell now centralizes repeated Sign In/Sign Up layout responsibilities; future UI changes should be made through the shared shell first.
- Password recovery is now wired end-to-end through datasource/repository/ViewModel and exposed in the forgot-password page.
- Password recovery stale feedback lifecycle issue identified in review was fixed with explicit state reset behavior and focused widget coverage.
- Social sign-in actions remain intentionally disabled with "coming soon" copy to prevent accidental scope confusion.
- Auth page widget tests now verify that social sign-in placeholders are visible but disabled and that the reports tab is visual copy, not a navigation action.
- Next approved auth increment should focus on social sign-in implementation or full recovery UX hardening (deep links/manual QA) with focused tests.

### Complete password recovery reset flow

Status:
Resolved / Monitoring

Impact:
Medium

Notes:
- Current implementation sends the Supabase recovery email and shows request feedback.
- Reset-password route, new-password UI, ViewModel reset state, repository/datasource password update support, ARB copy, and focused automated tests are implemented.
- Supabase password update calls remain in the datasource layer and routing policy remains in `lib/app/routes`.
- Supabase Auth URL configuration was applied for local reset redirects.
- Manual QA with a real Supabase recovery link validated that the web build lands on `/reset-password` and renders the reset-password UI.
- Remaining monitoring is limited to inbox/email-provider deliverability in non-local environments.

### Evolve i18n from static PT-BR catalogs to scalable localization pipeline

Status:
Reduced / Monitoring

Impact:
Low

Notes:
- Auth copy is centralized in Flutter gen-l10n ARB files: `lib/l10n/app_pt.arb`, `lib/l10n/app_pt_BR.arb`, and `lib/l10n/app_en.arb`.
- Generated access uses `AppLocalizations` from `lib/l10n/generated/app_localizations.dart`.
- Presentation maps auth failure codes to localized copy; data and domain stay localization-neutral.
- The repo now includes a guard test that blocks hardcoded user-facing copy in presentation and route files.
- `test/app/l10n/arb_catalog_parity_test.dart` validates ARB locale declarations, string-key parity, template descriptions, orphan metadata, template placeholder metadata, and translated placeholder parity.
- `test/app/l10n/generated_localizations_freshness_test.dart` validates that template ARB keys are exposed by generated `AppLocalizations` accessors.
- Ensure future features add copy through ARB files before adding UI code, then run hardcoded-copy, ARB parity, and generated freshness guards.
- Forgot-password stale placeholder/approval messaging drift was corrected in PT, PT-BR, and EN catalogs and validated with focused auth + l10n guard tests (19 tests passed).
- External translation platform integration remains deferred until the MVP UI surface grows enough to justify it.

### Continue Theme Guard normalization beyond auth slice

Status:
Reduced / Monitoring

Impact:
Low

Notes:
- Theme Guard contract is now enforced by `test/app/theme/no_hardcoded_visual_values_test.dart` with strict rules (no temporary baseline exception).
- First priority normalization slice is complete: `lib/features/auth/presentation/widgets/auth_page_shell.dart`.
- Recommended next slice selection order (when these modules exist): `home` -> `feed` -> `cart`.
- Follow-up audit (2026-05-22): these feature modules were not present in the workspace.
- Follow-up audit (2026-05-26): `home`, `feed`, and `cart` still do not exist under `lib/features` or `test/features`.
- Follow-up audit (2026-05-27): `home`, `feed`, and `cart` still do not exist under `lib/features` or `test/features`.
- The visual hardcoded guard scans all feature presentation files under `lib/features/**/presentation/**/*.dart`, so future slices are covered as soon as they add presentation code.
- Post-review cleanup removed remaining non-semantic auth presentation usages (`Colors.white` and `shadow.withAlpha(30)`) in favor of `ColorScheme` semantic roles.
- Validation follow-up (2026-05-27): `flutter test test/app/theme/no_hardcoded_visual_values_test.dart` passed.
- Keep incremental refactors per slice and validate with focused tests plus `flutter analyze` on touched files.
- Home is now the selected first presentation slice through `.ai/plans/2026-06-01-home-static-feed-plan.md`.
- Home presentation now exists and the discovery empty-results UI introduced in Sprint 4 Task 4 remains on semantic theme APIs and app tokens.
- Sprint 4 Task 4 validation kept `test/app/theme/no_hardcoded_visual_values_test.dart` green; keep this debt in monitoring for future Home, feed, and cart UI slices.
- Sprint 4 closed with the consolidated router/guard regression matrix green (41 tests), so Home remains a validated Theme Guard baseline for future presentation increments.

### Reduce manual synchronization between docs and Trello artifacts

Status:
Reduced / Monitoring

Impact:
Low

Notes:
- Theme Guard checklist parity required coordinated updates across markdown docs, Trello JSON templates, and real Trello cards.
- Manual synchronization increased risk of transient inconsistency (one template was temporarily patched in the wrong section and then corrected in the same session).
- Lightweight local parity check added in `test/app/project_management/trello_guard_checklists_test.dart`.
- The check validates `DEFINITION_OF_DONE.md` against `TRELLO_WORKFLOW.md` and existing guard checklists in `docs/project-management/trello/templates/*.json`.
- `docs/project-management/TRELLO_WORKFLOW.md` now requires a real Trello parity check with `trello_get_card_checklists` when a card is created, updated, moved to a done-equivalent list, or used as delivery evidence.
- Checklist item state changes should use `trello_update_checklist_item_state` only after local implementation evidence exists.
- Keep Trello board updates explicit, scoped to intended cards, and documented with a short card comment when they are used to close work.
- Follow-up validation (2026-05-27): `flutter test test/app/project_management/trello_guard_checklists_test.dart` passed (2 tests).
- This debt remains `Reduced / Monitoring` because the repo can guard versioned artifacts, but cannot prove external Trello state without MCP/API access and human-supervised validation.
- Sprint 4 Task 4 external parity was verified against `[FEAT] Home discovery interactions` (`https://trello.com/c/5EUe5qOp`) after local validation. Only evidence-backed items were completed; Task 5 regression coverage and Task 6 final reconciliation remain open.
- Sprint 4 final parity was rechecked after Task 5 validation and Task 6 reconciliation. The real card now has Scope `6/6`, Validation `8/8`, Localization Guard `7/7`, Theme Guard `5/5`, Acceptance Criteria `8/8`, and Dependencies `6/6`, with a final evidence comment recorded.

### Product details slice — seed coverage and accepted minor debts (Sprint 6 / Sprint 7)

Status:
Selected Planned Slice / Monitoring

Impact:
Low

Notes:
- Partial catalog seed: only `burger_artisan_collective` has rows in `restaurant_menu_items`, so product deep links for other restaurants resolve to the localized not-found state. This is by-design demo behavior, not a regression — classified as Planned Scope. Promote to a product slice when broader seed/data is approved.
- Sprint 7 has been approved as `Catalog Demo Coverage` to address the seed coverage item through deterministic data expansion for `pasta_roma`, `sushi_zen`, and `taco_harbor`. Keep this item in monitoring until the migration, SQL smoke validation, focused regression coverage, and documentation reconciliation are complete.
- Sprint 7 Tasks 1-2 are complete: the baseline was audited against remote Supabase and `supabase/migrations/20260603183000_catalog_demo_coverage.sql` was created with deterministic idempotent seeds for the three unseeded restaurants. Rollback smoke validation passed, but the data has not been applied permanently yet, so the item remains active monitoring.
- Finding D (accepted): price formatting (`_formatPrice`, `NumberFormat` by locale) is duplicated between `lib/features/restaurant_details/presentation/widgets/restaurant_details_sections.dart` and `lib/features/product_details/presentation/widgets/product_details_sections.dart`. Extract to `lib/shared/` only if a third consumer appears, to avoid premature refactor.
- Finding C (accepted): the route `restaurantId` in `/restaurants/:restaurantId/products/:productId` is used only for back navigation/protection; the product loads by `productId` (PK) alone, so a mismatched `restaurantId` still resolves the product. No cross-integrity validation in this read-only slice.
- After Sprint 7 validation, reclassify the seed item to resolved/monitoring if all existing seeded restaurants have non-empty catalogs and product details coverage. Reclassify to Technical Debt only if not-found-on-real-data starts affecting approved demo/QA scope after Sprint 7.

## Rules

- Do not fix unrelated debt during feature work without confirmation.
- Convert debt into Trello cards when it affects delivery.
- Classify session persistence items as Planned Scope first, and escalate to Technical Debt only when impact is recurring or workaround-driven.
