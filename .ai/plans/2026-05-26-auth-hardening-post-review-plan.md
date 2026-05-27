# Auth Hardening Post-Review Plan

> For agentic workers: execute incrementally, one approved task at a time. Do not implement multiple tasks without explicit approval.

## Goal

Address the review findings for authentication robustness and maintainability while preserving MVVM, Clean Architecture, and Supabase isolation.

## Scope

- Treat `AuthFailure` in sign-out flow and expose predictable state/feedback.
- Make password-recovery redirect origin explicit through environment configuration.
- Reduce unnecessary rebuilds in reset-password presentation.
- Add focused tests for sign-out failure behavior and expected state.
- Define a gradual migration plan from legacy Riverpod provider usage to non-legacy patterns.

## Architecture Constraints

- Keep `Supabase` access restricted to datasource layer.
- Keep business flow orchestration in ViewModel.
- Keep routing policy at app level.
- Keep UI focused on rendering and user interaction.
- Prefer incremental, reversible changes with focused validation.

## Out of Scope

- New auth capabilities (social login, profile sync, RBAC, realtime).
- Broad visual redesign.
- Full state-management rewrite in a single task.

## Planned Files

- `lib/features/auth/presentation/viewmodels/auth_view_model.dart`
- `lib/features/auth/presentation/state/auth_state.dart`
- `lib/features/auth/presentation/pages/reset_password_page.dart`
- `lib/app/config/app_environment.dart`
- `lib/app/routes/auth_recovery_redirect.dart`
- `lib/app/di/app_providers.dart`
- `lib/features/auth/presentation/providers/auth_providers.dart`
- `test/features/auth/presentation/auth_view_model_test.dart`
- `test/features/auth/presentation/auth_pages_test.dart`
- `test/app/routes/auth_recovery_redirect_test.dart`
- Optional docs if behavior/decisions change.

## Tasks

### Task 1: Harden sign-out failure handling in ViewModel

Concept:

- Ensure sign-out failures are captured as `AuthFailure` and surfaced predictably.

Files:

- `lib/features/auth/presentation/viewmodels/auth_view_model.dart`
- `lib/features/auth/presentation/state/auth_state.dart` (if state extension is required)

Responsibilities:

- Handle `AuthFailure` in `signOut()`.
- Preserve deterministic state transitions.
- Keep behavior testable and explicit.

Validation:

- `test/features/auth/presentation/auth_view_model_test.dart`

Skills aplicaveis:

- `flutter-apply-architecture-best-practices`
- `dart-add-unit-test`

- [x] Step 1: define expected sign-out failure state contract
- [x] Step 2: implement sign-out failure handling in ViewModel/state
- [x] Step 3: validate focused unit tests

### Task 2: Make recovery redirect origin explicit by environment

Concept:

- Remove implicit dependence on `Uri.base` as the only source of redirect origin.

Files:

- `lib/app/config/app_environment.dart`
- `lib/app/routes/auth_recovery_redirect.dart`
- `lib/app/di/app_providers.dart`
- `test/app/routes/auth_recovery_redirect_test.dart`

Responsibilities:

- Introduce environment-driven redirect origin input.
- Keep safe fallback strategy where needed.
- Preserve current route target (`/reset-password`).

Validation:

- `test/app/routes/auth_recovery_redirect_test.dart`
- focused router/auth tests if contract changes

Skills aplicaveis:

- `flutter-setup-declarative-routing`
- `dart-add-unit-test`

- [x] Step 1: define redirect precedence (configured origin vs fallback)
- [x] Step 2: implement environment-configured redirect builder wiring
- [x] Step 3: validate redirect tests and focused routing behavior

### Task 3: Reduce unnecessary rebuilds in reset-password page

Concept:

- Observe only state slices needed by the UI to reduce broad page rebuilds.

Files:

- `lib/features/auth/presentation/pages/reset_password_page.dart`
- `test/features/auth/presentation/auth_pages_test.dart` (if behavior assertions need updates)

Responsibilities:

- Replace broad provider watch with granular `select`-based observation.
- Preserve loading, success, failure, and local validation behavior.
- Keep UX semantics unchanged.

Validation:

- `test/features/auth/presentation/auth_pages_test.dart`

Skills aplicaveis:

- `flutter-build-responsive-layout`
- `flutter-add-widget-test`

- [x] Step 1: identify minimal state fields consumed by reset page
- [x] Step 2: refactor page watch strategy to granular selectors
- [x] Step 3: validate focused widget tests

### Task 4: Add explicit sign-out failure tests

Concept:

- Lock expected state behavior with focused tests before future refactors.

Files:

- `test/features/auth/presentation/auth_view_model_test.dart`

Responsibilities:

- Add unit test for sign-out failure path.
- Assert expected status/failure values after failure.

Validation:

- `test/features/auth/presentation/auth_view_model_test.dart`

Skills aplicaveis:

- `dart-add-unit-test`

- [x] Step 1: add failing-first sign-out error test
- [x] Step 2: confirm state expectations are explicit and stable
- [x] Step 3: keep existing auth ViewModel tests green

### Task 5: Plan gradual migration from legacy provider usage

Concept:

- Avoid risky one-shot migration; define phased adoption path.

Files:

- `lib/features/auth/presentation/providers/auth_providers.dart` (only if small non-breaking prep is approved)
- docs/memory artifacts (if migration decision is finalized)

Responsibilities:

- Define phase-by-phase migration path to non-legacy Riverpod pattern.
- Record rollout gates and rollback criteria.
- Keep current runtime stable until migration slice is approved.

Validation:

- documentation/memory review
- focused auth provider tests if any prep change is applied

Skills aplicaveis:

- `flutter-apply-architecture-best-practices`

- [x] Step 1: define migration phases (parallel provider, feature cutover, legacy removal)
- [x] Step 2: define validation gates per phase
- [x] Step 3: register decision in docs/memory when approved

Approved phased strategy:

Phase A - Parallel introduction (non-breaking)

- Keep current `ChangeNotifierProvider` path active.
- Introduce a parallel non-legacy provider path behind opt-in wiring only.
- Do not remove existing provider symbols in this phase.

Validation gates:

- Focused auth provider and ViewModel tests remain green.
- Router and auth page focused tests remain green.
- No runtime behavior drift in sign-in, sign-up, forgot-password, and reset-password slices.

Rollback criteria:

- Any auth routing or state regression detected in focused suites.
- Any provider override incompatibility in tests.

Phase B - Feature cutover (slice by slice)

- Migrate auth presentation consumers to the non-legacy provider path incrementally.
- Keep old and new providers temporarily side-by-side while each slice is validated.

Validation gates:

- Per-slice focused widget/unit tests before and after migration.
- No increase in broad rebuild behavior for touched screens.

Rollback criteria:

- Rebuild regression or state propagation mismatch in touched slices.
- Increased coupling or reduced testability compared with pre-cutover state.

Phase C - Legacy removal

- Remove `flutter_riverpod/legacy.dart` dependency usage from auth provider wiring.
- Delete transitional aliases only after all auth slices are migrated and green.

Validation gates:

- Full focused auth suite green (providers/viewmodel/pages/router).
- Static analysis clean on provider and presentation layers.

Rollback criteria:

- Any unresolved compatibility issue with provider overrides in tests.
- Any regression in authentication flow behavior after legacy removal.

## Acceptance Criteria

- Sign-out failure path is deterministic and test-covered.
- Recovery redirect origin is configurable and tested.
- Reset-password page observes minimal necessary state and preserves behavior.
- Focused unit/widget/routing validations remain green.
- Migration strategy from legacy provider usage is documented as phased rollout.

## Risks

- Behavior ambiguity if sign-out failure UX is not agreed before implementation.
- Redirect misconfiguration across environments if precedence is unclear.
- Rebuild optimization may accidentally skip UI refresh if selectors are incomplete.
- Provider migration can create temporary dual-pattern complexity.

## Validation Strategy

Run smallest reliable scope per task; run broader focused suite after each approved slice.

Suggested focused commands:

- `flutter test test/features/auth/presentation/auth_view_model_test.dart`
- `flutter test test/features/auth/presentation/auth_pages_test.dart`
- `flutter test test/app/routes/auth_recovery_redirect_test.dart`
- `flutter test test/app/routes/app_router_test.dart`

## Execution Rule

Proceed one task at a time and wait for explicit confirmation before moving to the next task.
