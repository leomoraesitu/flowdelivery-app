# Authentication Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a minimal, testable authentication foundation for FlowDelivery using Supabase Auth, Riverpod, MVVM, and GoRouter.

**Architecture:** Authentication must follow the existing feature-first MVVM contract. Widgets render state and trigger ViewModel actions; ViewModels call repositories; repositories depend on datasources; datasources own Supabase calls. Routing guards depend on auth state, not on raw Supabase access from UI.

**Tech Stack:** Flutter, Dart, Supabase Flutter, Riverpod, GoRouter, flutter_test, flutter_lints.

---

## Current Repository Baseline

- Current feature: `Authentication`.
- Current status: `Planning`.
- Riverpod, Supabase, and GoRouter are accepted decisions but are not yet present in `pubspec.yaml`.
- Supabase calls must stay outside widgets.
- Implementation must remain incremental and stop after each approved task.

## File Structure

Create or modify these files during this plan:

- `pubspec.yaml` - add approved dependencies only when the first implementation task starts.
- `lib/app/config/app_environment.dart` - central environment access for Supabase configuration.
- `lib/app/app.dart` - wrap the app in provider scope and router when routing is introduced.
- `lib/app/routes/app_router.dart` - GoRouter configuration and auth redirects.
- `lib/features/auth/domain/entities/auth_user.dart` - domain user entity.
- `lib/features/auth/domain/failures/auth_failure.dart` - user-safe auth failure model.
- `lib/features/auth/data/datasources/auth_remote_datasource.dart` - low-level Supabase Auth calls.
- `lib/features/auth/data/repositories/auth_repository_impl.dart` - maps datasource responses to domain results.
- `lib/features/auth/domain/repositories/auth_repository.dart` - repository contract.
- `lib/features/auth/presentation/state/auth_state.dart` - explicit UI auth state.
- `lib/features/auth/presentation/viewmodels/auth_view_model.dart` - sign-in, sign-up, sign-out orchestration.
- `lib/features/auth/presentation/providers/auth_providers.dart` - Riverpod dependency wiring.
- `lib/features/auth/presentation/pages/sign_in_page.dart` - first auth UI page.
- `lib/features/auth/presentation/pages/sign_up_page.dart` - account creation UI page.
- `test/features/auth/...` - focused unit and widget tests for each implemented slice.
- `docs/setup/SUPABASE_SETUP.md` - update only when configuration behavior changes.
- `.ai/memory/current_feature.md` - update task status after validated slices.

## Out of Scope

- Password reset.
- Social login.
- Profile table synchronization.
- Role-based access.
- Realtime auth-dependent flows.
- Edge Functions.
- Production secrets or service role keys.

---

### Task 1: Add Auth Dependencies Intentionally

**Files:**

- Modify: `pubspec.yaml`
- Test: dependency resolution only

**Skills aplicaveis:**

- `dart-resolve-package-conflicts`
- `dart-run-static-analysis`

- [ ] **Step 1: Add the approved packages**

Add dependencies only for this auth foundation:

```bash
flutter pub add flutter_riverpod go_router supabase_flutter
```

Expected:

```text
Command exits with code 0 and reports the dependencies changed.
```

- [ ] **Step 2: Resolve packages**

Run:

```bash
flutter pub get
```

Expected:

```text
Got dependencies!
```

- [ ] **Step 3: Run static analysis**

Run:

```bash
flutter analyze
```

Expected:

```text
No issues found!
```

### Task 2: Centralize Supabase Environment Configuration

**Files:**

- Create: `lib/app/config/app_environment.dart`
- Test: `test/app/config/app_environment_test.dart`

**Skills aplicaveis:**

- `dart-add-unit-test`

- [ ] **Step 1: Write configuration tests**

Create `test/app/config/app_environment_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flowdelivery_app/app/config/app_environment.dart';

void main() {
  test('reads Supabase values from dart defines', () {
    expect(AppEnvironment.supabaseUrl, isA<String>());
    expect(AppEnvironment.supabaseAnonKey, isA<String>());
  });
}
```

- [ ] **Step 2: Create the configuration object**

Create `lib/app/config/app_environment.dart`:

```dart
abstract final class AppEnvironment {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasSupabaseConfig {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }
}
```

- [ ] **Step 3: Validate the slice**

Run:

```bash
flutter test test/app/config/app_environment_test.dart
```

Expected:

```text
All tests passed!
```

### Task 3: Model Auth Domain Boundaries

**Files:**

- Create: `lib/features/auth/domain/entities/auth_user.dart`
- Create: `lib/features/auth/domain/failures/auth_failure.dart`
- Test: `test/features/auth/domain/auth_domain_test.dart`

**Skills aplicaveis:**

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Write domain tests**

Create `test/features/auth/domain/auth_domain_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';

void main() {
  test('auth user exposes identity data without backend details', () {
    const user = AuthUser(id: 'user-1', email: 'user@example.com');

    expect(user.id, 'user-1');
    expect(user.email, 'user@example.com');
  });

  test('auth failure stores a user-safe message', () {
    const failure = AuthFailure(message: 'Invalid credentials');

    expect(failure.message, 'Invalid credentials');
  });
}
```

- [ ] **Step 2: Create domain entity**

Create `lib/features/auth/domain/entities/auth_user.dart`:

```dart
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
  });

  final String id;
  final String email;
}
```

- [ ] **Step 3: Create auth failure**

Create `lib/features/auth/domain/failures/auth_failure.dart`:

```dart
class AuthFailure {
  const AuthFailure({required this.message});

  final String message;
}
```

- [ ] **Step 4: Validate the slice**

Run:

```bash
flutter test test/features/auth/domain/auth_domain_test.dart
```

Expected:

```text
All tests passed!
```

### Task 4: Define Repository Contract

**Files:**

- Create: `lib/features/auth/domain/repositories/auth_repository.dart`
- Modify: `test/features/auth/domain/auth_domain_test.dart`

**Skills aplicaveis:**

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Extend domain tests for repository shape**

Add to `test/features/auth/domain/auth_domain_test.dart`:

```dart
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: 'user-1', email: email);
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: 'user-1', email: email);
  }

  @override
  Future<void> signOut() async {}
}
```

- [ ] **Step 2: Create the repository contract**

Create `lib/features/auth/domain/repositories/auth_repository.dart`:

```dart
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
```

- [ ] **Step 3: Validate the slice**

Run:

```bash
flutter test test/features/auth/domain/auth_domain_test.dart
```

Expected:

```text
All tests passed!
```

### Task 5: Add Auth State and ViewModel

**Files:**

- Create: `lib/features/auth/presentation/state/auth_state.dart`
- Create: `lib/features/auth/presentation/viewmodels/auth_view_model.dart`
- Test: `test/features/auth/presentation/auth_view_model_test.dart`

**Skills aplicaveis:**

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Write ViewModel tests**

Create `test/features/auth/presentation/auth_view_model_test.dart` with a fake repository that returns a domain user.

Expected behaviors:

- initial state is unauthenticated and idle;
- successful sign in stores `AuthUser`;
- failed sign in exposes a user-safe error message.

- [ ] **Step 2: Create explicit auth state**

Create `lib/features/auth/presentation/state/auth_state.dart` with:

```dart
enum AuthStatus { unauthenticated, loading, authenticated, failure }
```

Include fields for `AuthUser? user` and `String? message`.

- [ ] **Step 3: Create ViewModel**

Create `lib/features/auth/presentation/viewmodels/auth_view_model.dart`.

The ViewModel must:

- own `AuthState`;
- call `AuthRepository`;
- avoid Supabase imports;
- expose sign in, sign up, and sign out actions.

- [ ] **Step 4: Validate the slice**

Run:

```bash
flutter test test/features/auth/presentation/auth_view_model_test.dart
```

Expected:

```text
All tests passed!
```

### Task 6: Add Supabase Datasource and Repository Implementation

**Files:**

- Create: `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- Create: `lib/features/auth/data/repositories/auth_repository_impl.dart`
- Test: `test/features/auth/data/auth_repository_impl_test.dart`

**Skills aplicaveis:**

- `dart-add-unit-test`
- `dart-generate-test-mocks`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Write repository implementation tests**

Test mapping from datasource user data to `AuthUser`.

Test that datasource errors become user-safe `AuthFailure` or equivalent repository failure behavior chosen during implementation.

- [ ] **Step 2: Create datasource**

Create `auth_remote_datasource.dart`.

Rules:

- this is the only auth feature file allowed to import Supabase directly;
- expose email/password sign in, sign up, and sign out;
- do not expose raw Supabase responses above the data layer.

- [ ] **Step 3: Create repository implementation**

Create `auth_repository_impl.dart`.

Rules:

- depend on datasource abstraction or concrete datasource;
- map backend user data into `AuthUser`;
- map backend errors into user-safe failures.

- [ ] **Step 4: Validate the slice**

Run:

```bash
flutter test test/features/auth/data/auth_repository_impl_test.dart
```

Expected:

```text
All tests passed!
```

### Task 7: Wire Riverpod Providers

**Files:**

- Create: `lib/features/auth/presentation/providers/auth_providers.dart`
- Modify: `lib/app/app.dart`
- Test: `test/features/auth/presentation/auth_providers_test.dart`

**Skills aplicaveis:**

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Write provider wiring test**

Test that providers can be overridden with a fake repository and expose an `AuthViewModel`.

- [ ] **Step 2: Create auth providers**

Create providers for:

- Supabase client access at the app/data boundary;
- datasource;
- repository;
- auth ViewModel.

- [ ] **Step 3: Wrap the app with ProviderScope**

Modify `lib/app/app.dart` only if the app root does not already provide `ProviderScope`.

- [ ] **Step 4: Validate the slice**

Run:

```bash
flutter test test/features/auth/presentation/auth_providers_test.dart
```

Expected:

```text
All tests passed!
```

### Task 8: Add Declarative Routing and Auth Guard

**Files:**

- Create: `lib/app/routes/app_router.dart`
- Modify: `lib/app/app.dart`
- Test: `test/app/routes/app_router_test.dart`

**Skills aplicaveis:**

- `flutter-setup-declarative-routing`
- `dart-add-unit-test`

- [ ] **Step 1: Write routing tests**

Test initial unauthenticated routing to sign in.

Test authenticated routing to the first protected shell route.

- [ ] **Step 2: Create router**

Create `app_router.dart` using GoRouter.

Rules:

- keep route paths centralized;
- auth redirect reads auth state/provider;
- feature pages do not own global navigation policy.

- [ ] **Step 3: Use MaterialApp.router**

Modify `lib/app/app.dart` to use the router.

- [ ] **Step 4: Validate the slice**

Run:

```bash
flutter test test/app/routes/app_router_test.dart
```

Expected:

```text
All tests passed!
```

### Task 9: Add Sign In and Sign Up UI

**Files:**

- Create: `lib/features/auth/presentation/pages/sign_in_page.dart`
- Create: `lib/features/auth/presentation/pages/sign_up_page.dart`
- Test: `test/features/auth/presentation/auth_pages_test.dart`

**Skills aplicaveis:**

- `flutter-add-widget-test`
- `flutter-build-responsive-layout`
- `flutter-add-widget-preview`

- [ ] **Step 1: Write widget tests**

Test that sign in and sign up pages render:

- email field;
- password field;
- primary action button;
- navigation link between sign in and sign up.

- [ ] **Step 2: Create sign in page**

Create a page that:

- renders inputs;
- calls ViewModel/provider action;
- shows loading and error states;
- avoids direct repository or Supabase calls.

- [ ] **Step 3: Create sign up page**

Create a page with the same boundaries as sign in.

- [ ] **Step 4: Validate the slice**

Run:

```bash
flutter test test/features/auth/presentation/auth_pages_test.dart
```

Expected:

```text
All tests passed!
```

### Task 10: Reconcile Documentation and Memory

**Files:**

- Modify: `.ai/memory/current_feature.md`
- Modify: `docs/setup/SUPABASE_SETUP.md`
- Modify: `docs/architecture/ARCHITECTURE_OVERVIEW.md` only if routing or auth boundaries changed

**Skills aplicaveis:**

- `dart-run-static-analysis`

- [ ] **Step 1: Update current feature memory**

Record completed authentication slices and next pending task.

- [ ] **Step 2: Update Supabase setup docs**

Document any new required `--dart-define` values:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

- [ ] **Step 3: Run final focused validation**

Run:

```bash
flutter analyze
flutter test
```

Expected:

```text
No issues found!
All tests passed!
```

---

## Acceptance Criteria

- Auth feature has explicit domain, data, presentation, and provider boundaries.
- Widgets do not import Supabase.
- ViewModels do not import Supabase.
- Supabase calls are isolated in the datasource layer.
- Riverpod is used for dependency wiring and UI state observation.
- GoRouter owns global route policy and auth redirects.
- Each slice has focused validation.
- Documentation and `.ai/memory/current_feature.md` reflect the latest state.

## Risks

- Package versions may need adjustment during `flutter pub get`.
- Supabase Auth behavior requires real project credentials for manual end-to-end validation.
- Router guards can become coupled to UI state if the auth provider boundary is not kept explicit.
- Tests that mock Supabase directly may be brittle; prefer datasource or repository fakes where possible.

## Self-Review

- Spec coverage: current pending items in `.ai/memory/current_feature.md` are represented by tasks for planning, repository layer, Riverpod providers, UI, tests, and documentation updates.
- Placeholder scan: no TBD/TODO placeholders are present.
- Scope check: password reset, profile sync, roles, and social login are intentionally out of scope.
