# Current Feature

## Feature

Home Remote Feed Foundation

## Status

In Progress

## Current Step

Execute only Task 5 from `.ai/plans/2026-06-01-home-remote-feed-plan.md` after explicit implementation approval.

## Completed

- Home static feed scope approved: protected `/home`, typed local fixtures, prototype-aligned UI, Riverpod wiring, ARB copy, Theme Guard, and focused tests.
- Home technical plan generated in `.ai/plans/2026-06-01-home-static-feed-plan.md`.
- Task 1 completed — typed local Home entities finalized as immutable value models for category, promotion, and restaurant contracts without introducing repository/datasource abstractions.
- Task 2 completed — typed local Home feed fixtures and a read-only Riverpod provider now expose deterministic category, promotion, and featured-restaurant content without adding repository/datasource abstractions.
- Task 3 completed — `/home` is now the centralized protected authenticated destination, `/` is a root entry redirect, unauthenticated access to `/home` returns to sign-in, and reset-password recovery behavior remains unchanged.
- Task 4 completed — Home copy now lives in ARB catalogs with generated `AppLocalizations` accessors for address, search, categories, promo banner, featured section, restaurant metadata, and bottom navigation labels.
- Task 5 completed — `/home` now renders the approved static Home feed UI with responsive layout, localized presentation copy, semantic theme tokens, decorative asset fallbacks, and focused provider/router/guard validation.
- Task 6 completed — focused Home widget coverage now validates localized header/search copy, selected category state, promotion content, fixture restaurant rendering, selected Home navigation state, and deferred bottom-nav no-op behavior.
- Task 7 completed — Sprint 2, feature memory, and sprint memory were reconciled after validation; Trello parity was verified against the real card before final closure evidence was recorded.
- Sprint 2 project-management artifact generated in `docs/project-management/SPRINT_2.md`.
- Real Trello story `[FEAT] Home restaurant feed static UI` is synchronized with validated implementation evidence and guard parity (`https://trello.com/c/X3jAdpd2`).
- Home remains presentation-first: Supabase schema, repository, datasource, remote loading, search behavior, filters, and destination navigation are deferred.
- Sprint 3 planning approved — the next Home slice is a read-only Supabase-backed remote feed foundation with explicit grants, RLS, datasource/repository boundaries, async provider wiring, and focused validation.
- Home remote technical plan generated in `.ai/plans/2026-06-01-home-remote-feed-plan.md`.
- Sprint 3 project-management artifact generated in `docs/project-management/SPRINT_3.md`.
- Real Trello story `[FEAT] Home remote feed foundation` created in `✅ Ready` with Scope, Acceptance Criteria, Dependencies, Validation, Localization Guard, and Theme Guard checklists (`https://trello.com/c/bzxIa3wx`).
- Sprint 3 Task 1 completed — `HomeFeedContent` was promoted into the Home domain layer, `HomeRepository` now defines the feed contract, and the static Home provider reads through that repository boundary while keeping the validated UI behavior unchanged.
- Sprint 3 Task 2 completed — the Home remote feed Supabase foundation now has a migration for `restaurant_categories`, `restaurants`, `restaurant_category_links`, and `home_promotions`, with explicit `authenticated`/`service_role` `SELECT` grants, RLS read policies, and development seed data aligned with the current Home contract.
- Sprint 3 Task 3 completed — Home remote DTOs now parse Supabase rows into typed category, promotion, and restaurant payloads, and a dedicated Supabase datasource owns the Home feed queries, row orchestration, category-link aggregation, and explicit Home remote exceptions.
- Sprint 3 Task 4 completed — the Home repository is now asynchronous, the app composes a Supabase-backed Home datasource/repository at the composition root, and Riverpod now exposes an async Home feed provider with a fixture compatibility fallback so the validated UI remains stable while remote loading lands incrementally.
- Start Feature (teacher mode) for Theme Guard and UI/UX standardization
- technical plan generated in `.ai/plans/2026-05-22-theme-guard-uiux-standardization-plan.md`
- Task 1 completed — visual governance audit baseline documented in `.ai/plans/2026-05-22-theme-guard-uiux-standardization-plan.md`
- Task 2 completed — canonical Theme Guard contract verified and normalized across docs/templates/commands
- Task 3 completed — visual hardcoded guard test added and validated (`test/app/theme/no_hardcoded_visual_values_test.dart`)
- Task 4 completed — auth presentation slice normalized to semantic color APIs and visual guard baseline exception removed
- Task 5 completed — memory artifacts reconciled with strict Theme Guard enforcement and residual debt notes
- Post-review corrective pass completed — router/provider coupling, password-recovery lifecycle state, and remaining semantic color alignments fixed with focused tests and analyze green
- Project-management docs synchronized with Theme Guard parity updates (`DEFINITION_OF_DONE.md`, `PROJECT_MANAGEMENT_STANDARD.md`, `SPRINT_1.md`, `TRELLO_WORKFLOW.md`, `trello-map.md`)
- Trello JSON templates synchronized with Theme Guard checklist parity (`workflow`, `backlog`, `bug-triage`, `sprint`, `tech-debt`, `release`)
- Real Trello updates completed on board `FlowDelivery - Project Management`: governance/docs cards commented and moved to archive-equivalent done list
- Real Trello updates completed on board `FlowDelivery - Product Backlog`: Sprint 1/Auth epic status comments posted and Theme Guard architecture card moved from `✅ Ready` to `🎉 Done`
- Lightweight Trello/docs checklist parity guard added and committed (`a3c2291`)
- i18n pipeline plan generated in `docs/project-management/I18N_PIPELINE_PLAN.md`
- Product Backlog Trello card `[DEBT] Add ARB catalog parity guard` created and updated with real checklists plus validation evidence
- ARB catalog parity guard added in `test/app/l10n/arb_catalog_parity_test.dart`
- ARB catalog parity guard validates locale declarations, catalog key parity, template descriptions, and orphan metadata
- ARB catalog parity guard committed and pushed (`c7bf183`)
- Project-management docs generated for scalable i18n pipeline phase 2 (`docs/project-management/I18N_PIPELINE_PLAN.md`, `docs/project-management/DEFINITION_OF_DONE.md`)
- Product Backlog Trello card `[DEBT] Evolve i18n pipeline guardrails` created in `📥 Backlog` with real Scope, Acceptance Criteria, and Validation checklists
- Generated localization freshness guard added in `test/app/l10n/generated_localizations_freshness_test.dart`
- ARB catalog parity guard hardened to validate template placeholder metadata and translated placeholder parity
- I18n guard validation passed for hardcoded-copy, ARB catalog parity, and generated localization freshness tests
- Password recovery completion planning started for reset deep-link/session handling, reset-password route, new-password UI, Supabase password update, focused tests, and docs/Trello governance.
- Password recovery implementation slice completed: repository/datasource `updatePassword`, ViewModel reset state, `/reset-password` route, reset UI validation/feedback, ARB copy, generated localization update, and focused automated tests.
- Password recovery web redirect hardening completed: path URL strategy enabled, Supabase recovery requests now use explicit `/reset-password` redirect URLs, authenticated recovery sessions stay on the reset route, and real Supabase recovery-link QA validated the release web build renders the reset-password UI.
- Non-local mailbox deliverability runbook added in `docs/setup/SUPABASE_SETUP.md` and `docs/qa/QA_STRATEGY.md` for recovery email validation with external providers.
- Non-local mailbox deliverability runbook executed successfully with Outlook (Hotmail) QA inbox evidence: email arrival confirmed, recovery link target reached `http://localhost:3000/reset-password?...`, and password update completed with success feedback.
- Trello governance parity validation re-executed with `flutter test test/app/project_management/trello_guard_checklists_test.dart` and remains green (2 tests passed).
- Real Trello parity check executed via local `trello-desktop-mcp` for card `[DEBT] Evolve i18n pipeline guardrails` (`https://trello.com/c/BS6n5o0w`): checklists `Scope` (5/5), `Acceptance Criteria` (5/5), and `Validation` (4/4) are complete.
- Trello evidence comment added to the same card with the parity-check summary and local guard validation.
- Auth hardening post-review Tasks 1-4 completed: sign-out failure contract/state handling, explicit environment-based recovery redirect origin, granular reset-page selectors to reduce rebuild scope, and focused sign-out failure unit coverage.
- Auth provider migration strategy approved as phased rollout in `.ai/plans/2026-05-26-auth-hardening-post-review-plan.md` (parallel introduction, slice cutover, legacy removal) with validation gates and rollback criteria.
- Forgot-password copy consistency aligned with current implementation in `lib/l10n/app_pt.arb`, `lib/l10n/app_pt_BR.arb`, and `lib/l10n/app_en.arb`, with generated localizations refreshed.
- End-day focused validation after localization copy alignment passed: `test/features/auth/presentation/auth_pages_test.dart`, `test/app/l10n/arb_catalog_parity_test.dart`, and `test/app/l10n/generated_localizations_freshness_test.dart` (19 tests passed).
- Trello sync debt reduction reconciled in memory: versioned workflow docs already require real Trello parity checks, technical debt is classified as `Reduced / Monitoring`, and future Trello-governed work must validate real checklist state before using cards as delivery evidence.
- Auth UI placeholder parity reconciled in memory: `test/features/auth/presentation/auth_pages_test.dart` already verifies social auth placeholders are visible but disabled and the reports tab is visual copy rather than navigation; technical debt remains `Reduced / Monitoring`.
- Theme Guard future slices reconciled in memory: `home`, `feed`, and `cart` presentation slices still do not exist, no placeholder modules were created, and the global visual guard covers future `lib/features/**/presentation/**/*.dart` files as soon as approved slices add them.

- architecture context
- Riverpod decision
- Supabase decision
- GoRouter decision
- Codex guardrails
- reusable workflows
- routing conventions documented
- runtime navigation explicitly deferred until approved feature work
- feature planning workflow completed
- architecture approved
- technical plan generated in `.ai/plans/2026-05-19-authentication-plan.md`
- Sprint 1 generated in `docs/project-management/SPRINT_1.md`
- Task 1 — add auth dependencies intentionally
- Task 2 — centralize Supabase environment configuration
- Task 3 — model auth domain boundaries
- Task 4 — add auth state and ViewModel
- Task 5 — add Supabase datasource and repository implementation
- Task 6 — wire Riverpod providers
- Task 7 — add declarative routing and auth guard
- Task 8 — add Sign In and Sign Up UI
- Task 9 — initialize Supabase at app startup
- architecture alignment: created `lib/app/app.dart` as root app shell and kept `lib/main.dart` for bootstrap only
- Task 10 — Step 1: update current feature memory
- Task 10 — Step 2: update technical debt
- Task 10 — Step 3: update Supabase setup docs
- Task 10 — Step 4: run final focused validation
- Post-Sprint 1 stabilization — align Sign In UI/UX with `docs/ux/prototypes/auth-screen.png`
- Post-Sprint 1 stabilization — update auth page widget test for scroll visibility of the primary button
- Post-Sprint 1 stabilization validation — auth pages widget tests passed after UI update
- Post-Sprint 1 stabilization — extracted shared auth UI shell for Sign In and Sign Up pages
- Post-Sprint 1 stabilization — refined auth visual feedback states with reusable status banners
- Post-Sprint 1 stabilization — added forgot password route and page as a controlled UI entry point
- Post-Sprint 1 stabilization — disabled social sign-in and recovery primary action with explicit "coming soon" microcopy
- Post-Sprint 1 stabilization — implemented functional password recovery flow at repository/datasource/viewmodel boundaries
- Post-Sprint 1 stabilization — connected forgot password UI to real recovery request with success/error feedback
- Post-Sprint 1 stabilization — configured auth flow locale and copy in PT-BR
- Post-Sprint 1 stabilization — installed and applied Google Fonts for primary/secondary/mono typography tokens
- Post-Sprint 1 stabilization — translated user-safe auth runtime errors to PT-BR
- Post-Sprint 1 stabilization — centralized auth UI and auth error copy in Flutter gen-l10n ARB files and generated `AppLocalizations`
- Post-Sprint 1 stabilization — added a guard test that blocks hardcoded user-facing copy in presentation and route files
- Post-Sprint 1 stabilization validation — focused auth suites remain green after i18n refactor (17 tests)
- Post-Sprint 1 governance hardening — Localization Guard and Theme Guard workflows/templates aligned in project-management and Trello artifacts

## Pending / Deferred

- Execute Task 5 only after explicit approval: add explicit async Home UI states and localized user feedback.
- Keep the Home implementation incremental and limited to the approved remote-feed foundation slice.
- Keep profile/address persistence out of the remote feed slice; the delivery-address placeholder remains local.
- Keep search, filtering, restaurant details, destination navigation, Storage-backed media, and Realtime out of scope until separate approved slices exist.
- Keep real Trello checklist item states manually aligned through the documented MCP workflow when cards are touched by active work.
- Preserve auth UI placeholder tests when touching sign-in/sign-up shell affordances, or promote placeholders through an approved feature plan before making them interactive.
- Keep future `home`, `feed`, and `cart` presentation slices on semantic theme APIs and app tokens from their first approved implementation task.
- Keep explicit Data API grants and RLS paired in any future Supabase Home migration because public-table exposure must not be assumed.

## Notes

Use `docs/architecture/ROUTING_CONVENTIONS.md` when planning future auth redirects and protected routes.
For Trello-governed work, follow `docs/project-management/TRELLO_WORKFLOW.md`: validate real card checklist parity with `trello_get_card_checklists` and add evidence comments when cards are used to close work.
Task 10 validation completed with Dart MCP:
- `analyze_files`: No errors.
- `run_tests`: All tests passed.
Post-Sprint stabilization validation:
- `test/features/auth/presentation/auth_pages_test.dart`: passed after UI parity update.
- `test/app/routes/app_router_test.dart`: passed with forgot-password route coverage.
- Focused auth validation suite: 22 tests passed for domain/data/presentation/providers/router slices.
- PT-BR/i18n stabilization validation:
- `test/features/auth/presentation/auth_pages_test.dart`: passed.
- `test/features/auth/presentation/auth_view_model_test.dart`: passed.
- `test/features/auth/data/auth_repository_impl_test.dart`: passed.
Theme Guard/UI-UX standardization validation:
- `flutter test test/app/theme/no_hardcoded_visual_values_test.dart`: passed with strict rules (no baseline exception).
- `flutter analyze lib/features/auth/presentation/widgets/auth_page_shell.dart`: no issues.
- Follow-up audit after approval: no `home/feed/cart` feature presentation slices exist yet; current `lib/features/**/presentation/**/*.dart` remains compliant.
Post-review corrective validation:
- `flutter test test/app/routes/app_router_test.dart test/features/auth/presentation/auth_view_model_test.dart test/features/auth/presentation/auth_pages_test.dart test/features/auth/presentation/auth_providers_test.dart test/app/theme/no_hardcoded_visual_values_test.dart`: passed.
- `flutter analyze` on updated auth presentation/viewmodel/router test files: no issues.
Auth hardening post-review consolidated validation:
- `flutter test test/features/auth/presentation/auth_view_model_test.dart test/features/auth/presentation/auth_pages_test.dart test/app/routes/auth_recovery_redirect_test.dart test/app/routes/app_router_test.dart`: 31 tests passed.
Trello/docs parity validation:
- `test/app/project_management/trello_guard_checklists_test.dart`: added and committed in `a3c2291`.
ARB catalog parity validation:
- Dart MCP `add_roots` executed before Dart validation.
- `test/app/l10n/no_hardcoded_ui_strings_test.dart` and `test/app/l10n/arb_catalog_parity_test.dart`: 5 tests passed.
- Dart MCP `analyze_files` on `test/app/l10n/arb_catalog_parity_test.dart`: no errors.
Scalable i18n pipeline validation:
- Dart MCP `add_roots` executed before Dart validation.
- `test/app/l10n/no_hardcoded_ui_strings_test.dart`, `test/app/l10n/arb_catalog_parity_test.dart`, and `test/app/l10n/generated_localizations_freshness_test.dart`: 9 tests passed.
- Dart MCP `analyze_files` on updated i18n guard tests: no errors.
Home static UI validation:
- `flutter analyze` on updated Home fixture/presentation/router test files: no issues.
- `flutter test test/features/home/presentation/home_feed_providers_test.dart test/app/routes/app_router_test.dart test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/theme/no_hardcoded_visual_values_test.dart`: all tests passed.
Home widget coverage validation:
- `flutter test test/features/home/presentation/home_page_test.dart test/features/home/presentation/home_feed_providers_test.dart test/app/routes/app_router_test.dart test/app/l10n/no_hardcoded_ui_strings_test.dart test/app/theme/no_hardcoded_visual_values_test.dart`: all tests passed.
- `flutter analyze test/features/home/presentation/home_page_test.dart`: no issues.
Sprint 2 closure validation:
- `flutter test test/app/project_management/trello_guard_checklists_test.dart`: passed.
- Sprint 3 Task 1 validation:
- `dart analyze lib/features/home test/features/home`: no issues.
- `flutter test test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart`: all tests passed.
- Sprint 3 Task 2 validation:
- Transaction-scoped Supabase SQL smoke test confirmed the new Home tables, authenticated read policies, `SELECT`-only grants for `authenticated` and `service_role`, and development seed counts (`5` categories, `4` restaurants, `8` links, `1` promotion) without persisting changes to the shared project.
- Sprint 3 Task 3 validation:
- `dart analyze lib/features/home/data/dtos lib/features/home/data/datasources test/features/home/data`: no issues.
- `flutter test test/features/home/data/home_remote_datasource_test.dart`: all tests passed.
- Sprint 3 Task 4 validation:
- `dart analyze lib/features/home/domain/repositories/home_repository.dart lib/features/home/data/repositories/home_repository_impl.dart lib/features/home/presentation/providers/home_feed_providers.dart lib/app/di/app_providers.dart test/features/home/data/home_repository_impl_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart test/app/routes/app_router_test.dart`: no issues.
- `flutter test test/features/home/data/home_repository_impl_test.dart test/features/home/presentation/home_feed_async_providers_test.dart test/features/home/presentation/home_feed_providers_test.dart test/features/home/presentation/home_page_test.dart test/app/routes/app_router_test.dart`: all tests passed.
