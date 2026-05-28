# Password Recovery Completion Plan

## Goal

Complete the password recovery flow beyond the existing recovery email request by adding reset-link handling, a new-password screen, repository/datasource support for updating the password, and focused validation.

## Current State

Already implemented and validated:

- `/forgot-password` route and page.
- `AuthRepository.sendPasswordRecoveryEmail`.
- Supabase `resetPasswordForEmail` integration in the auth datasource.
- ViewModel state for recovery request loading, success, failure, and stale-feedback reset.
- Focused repository, ViewModel, routing, and widget tests for the recovery request flow.

Not implemented yet:

- Reset-password route.
- Deep-link/session handoff handling.
- New-password page.
- Password update operation after the Supabase recovery session is established.
- Manual QA instructions for Supabase email redirect configuration.

## Architecture

Keep the existing MVVM + Clean Architecture boundaries:

- UI pages render form state and delegate actions.
- `AuthViewModel` coordinates recovery request and password update UI state.
- `AuthRepository` exposes domain-facing auth actions.
- `AuthRemoteDatasource` owns Supabase Auth calls.
- `app_router.dart` owns route registration and auth redirect policy.
- User-facing copy goes through ARB + `AppLocalizations`.

## Proposed Route

Add a reset-password route only when implementing this feature:

```text
/reset-password
```

The route should be treated as an auth/recovery route, not as a protected app destination. It must be reachable from the Supabase recovery redirect flow without being redirected away before the reset UI can process the recovery state.

## Implementation Tasks

### Task 1: Extend Domain and Data Contracts

Files:

- `lib/features/auth/domain/repositories/auth_repository.dart`
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/auth/data/repositories/unconfigured_auth_repository.dart`
- `test/features/auth/data/auth_repository_impl_test.dart`

Work:

- Add a password update contract, for example `updatePassword`.
- Implement it with Supabase Auth using the active recovery session.
- Map Supabase/Auth errors into existing `AuthFailure` values.
- Keep Supabase types out of domain and presentation.

Validation:

- Repository tests for success and mapped failure.

### Task 2: Add ViewModel Reset State

Files:

- `lib/features/auth/presentation/state/auth_state.dart`
- `lib/features/auth/presentation/viewmodels/auth_view_model.dart`
- `test/features/auth/presentation/auth_view_model_test.dart`

Work:

- Add reset-password status/failure state distinct from recovery email request state.
- Add a ViewModel method for password update.
- Reset stale reset-password feedback when entering/leaving the reset page.

Validation:

- ViewModel tests for loading, success, failure, and reset lifecycle.

### Task 3: Add Routing for Reset Password

Files:

- `lib/app/routes/app_routes.dart`
- `lib/app/routes/app_router.dart`
- `test/app/routes/app_router_test.dart`

Work:

- Add reset-password route name and path.
- Treat reset-password as an auth/recovery route in redirect logic.
- Add route tests proving unauthenticated users can reach the reset route during recovery.

Validation:

- Router tests for reset route access and no redirect loop.

### Task 4: Add Reset Password UI

Files:

- `lib/features/auth/presentation/pages/reset_password_page.dart`
- `test/features/auth/presentation/auth_pages_test.dart`

Work:

- Add new password and confirmation fields.
- Validate empty input and password mismatch locally before calling ViewModel.
- Show success and failure feedback.
- Provide navigation back to sign-in after success.
- Use the existing auth shell where it fits without forcing unrelated layout changes.

Validation:

- Widget tests for validation, success, failure, and navigation affordance.

### Task 5: Add Localization

Files:

- `lib/l10n/app_pt.arb`
- `lib/l10n/app_pt_BR.arb`
- `lib/l10n/app_en.arb`
- generated localization files after `flutter gen-l10n`
- `test/app/l10n/*`

Work:

- Add all reset-password UI copy through ARB files.
- Include descriptions in the template catalog.
- Regenerate localizations.

Validation:

- Hardcoded-copy guard.
- ARB catalog parity guard.
- Generated localization freshness guard.

### Task 6: Documentation and Memory Reconciliation

Files:

- `docs/PROJECT_BOOTSTRAP.md`
- `docs/project-management/SPRINT_1.md`
- `docs/architecture/ROUTING_CONVENTIONS.md`
- `.ai/memory/current_feature.md`
- `.ai/memory/current_sprint.md`
- `.ai/memory/technical_debt.md`

Work:

- Move reset-password completion from planned work to implemented work only after tests pass.
- Record Supabase redirect/manual QA requirements.
- Keep social login, profile sync, role-based access, realtime, and Edge Functions out of scope.

Validation:

- Documentation review against implemented code.

## Acceptance Criteria

- User can request a password recovery email.
- Recovery redirect can land on the reset-password route.
- User can submit a new password after the recovery session is established.
- Empty password and mismatch validation happen before repository calls.
- Supabase password update remains isolated in the datasource.
- Widgets and ViewModels do not import Supabase.
- Auth redirects do not block the recovery route.
- All new user-facing copy is in ARB files and accessed through `AppLocalizations`.
- Focused repository, ViewModel, routing, widget, i18n, and theme guard validations pass.

## Out of Scope

- Social login.
- Profile synchronization.
- Role-based access.
- Realtime auth-dependent flows.
- Edge Functions.
- Full authenticated app shell.
- Production email template customization beyond documenting required redirect configuration.

## Risks

- Supabase recovery redirects require project configuration outside the repository.
- Web/mobile deep-link behavior can differ by platform.
- Reset routes can be accidentally redirected away if auth route classification is incomplete.
- Manual QA may require real Supabase credentials and email delivery.

## Validation Commands

Use Dart MCP after `add_roots` when available.

Focused suites:

```text
test/features/auth/data/auth_repository_impl_test.dart
test/features/auth/presentation/auth_view_model_test.dart
test/features/auth/presentation/auth_pages_test.dart
test/app/routes/app_router_test.dart
test/app/l10n/no_hardcoded_ui_strings_test.dart
test/app/l10n/arb_catalog_parity_test.dart
test/app/l10n/generated_localizations_freshness_test.dart
test/app/theme/no_hardcoded_visual_values_test.dart
```

Also run `flutter gen-l10n` before generated localization freshness validation after ARB changes.
