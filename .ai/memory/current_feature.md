# Current Feature

## Feature

Authentication

## Status

Task 10 completed for Sprint 1

## Current Step

Awaiting next approved task

## Completed

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

## Pending

- Awaiting next approved feature/task

## Notes

Do not implement more than the next approved task from `.ai/plans/2026-05-19-authentication-plan.md`.
Use `docs/architecture/ROUTING_CONVENTIONS.md` when planning future auth redirects and protected routes.
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
