# Technical Debt

## Active Items

### Align generated documentation with implementation

Status:
Monitoring

Impact:
Low

Notes:
- Several AI/project workflow files were created before feature implementation.
- Sprint 0 governance docs and local Trello artifacts were reconciled after theme, labels and Trello sync tasks.
- Future feature work must keep docs aligned with real code.
- Routing documentation remains reconciled with the deferred implementation decision.

### Keep auth documentation aligned with implementation

Status:
Monitoring

Impact:
Low

Notes:
- `flutter_riverpod`, `go_router`, and `supabase_flutter` are already present in `pubspec.yaml`.
- Supabase initialization at app startup was implemented in Task 9.
- Auth dependency wiring now uses app-level provider overrides and an unconfigured repository fallback when Supabase Dart defines are absent.
- Sign-in UI was updated for prototype parity (`docs/ux/prototypes/auth-screen.png`) and must remain synchronized with auth page tests.
- Keep docs/memory synchronized with each validated implementation slice.

### Keep auth UI parity scoped to visual layer

Status:
Monitoring

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
- Next approved auth increment should focus on social sign-in implementation or full recovery UX hardening (deep links/manual QA) with focused tests.

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
- External translation platform integration remains deferred until the MVP UI surface grows enough to justify it.

### Continue Theme Guard normalization beyond auth slice

Status:
Monitoring

Impact:
Low

Notes:
- Theme Guard contract is now enforced by `test/app/theme/no_hardcoded_visual_values_test.dart` with strict rules (no temporary baseline exception).
- First priority normalization slice is complete: `lib/features/auth/presentation/widgets/auth_page_shell.dart`.
- Recommended next slice selection order (when these modules exist): `home` -> `feed` -> `cart`.
- Follow-up audit (2026-05-22): these feature modules are not present yet in the current workspace.
- Post-review cleanup removed remaining non-semantic auth presentation usages (`Colors.white` and `shadow.withAlpha(30)`) in favor of `ColorScheme` semantic roles.
- Keep incremental refactors per slice and validate with focused tests plus `flutter analyze` on touched files.

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
- This debt remains `Reduced / Monitoring` because the repo can guard versioned artifacts, but cannot prove external Trello state without MCP/API access and human-supervised validation.

## Rules

- Do not fix unrelated debt during feature work without confirmation.
- Convert debt into Trello cards when it affects delivery.
