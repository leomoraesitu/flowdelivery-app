# Authentication Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a minimal, testable authentication foundation for FlowDelivery using Supabase Auth, Riverpod, MVVM, and GoRouter.

**Architecture:** Authentication follows the approved feature-first MVVM + Clean Architecture direction. Widgets render state and delegate actions; ViewModels orchestrate UI state; repositories expose domain contracts; datasources isolate Supabase Auth calls; app-level routing owns auth redirects.

**Tech Stack:** Flutter, Dart, `flutter_riverpod`, `go_router`, `supabase_flutter`, `flutter_test`, `flutter_lints`.

---

## Current Repository Baseline

- Current branch: `feat/authentication-flow`.
- Current feature: `Authentication`.
- Current status: `Planning`.
- Current `pubspec.yaml` does not include `flutter_riverpod`, `go_router`, or `supabase_flutter`.
- Supabase calls must stay outside widgets and ViewModels.
- Runtime navigation is deferred until an approved implementation task adds `go_router`.
- Implementation must be incremental and stop after each approved task.

## Out of Scope

- Password reset.
- Social login.
- Profile table synchronization.
- Role-based access.
- Realtime auth-dependent flows.
- Edge Functions.
- Production secrets or service role keys.
- Full authenticated app shell with multiple tabs.

## Planned File Responsibilities

- `pubspec.yaml`: records approved auth, routing, and state management dependencies.
- `lib/app/config/app_environment.dart`: centralizes compile-time environment values for Supabase.
- `lib/features/auth/domain/entities/auth_user.dart`: domain identity model with no Supabase dependency.
- `lib/features/auth/domain/failures/auth_failure.dart`: user-safe auth failure value.
- `lib/features/auth/domain/repositories/auth_repository.dart`: domain contract for auth actions.
- `lib/features/auth/presentation/state/auth_state.dart`: explicit UI state for auth flows.
- `lib/features/auth/presentation/viewmodels/auth_view_model.dart`: coordinates sign-in, sign-up, and sign-out through `AuthRepository`.
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`: owns low-level Supabase Auth calls.
- `lib/features/auth/data/repositories/auth_repository_impl.dart`: maps datasource responses/errors into domain-facing values.
- `lib/features/auth/presentation/providers/auth_providers.dart`: wires dependencies with Riverpod.
- `lib/app/routes/app_routes.dart`: centralizes route names and paths.
- `lib/app/routes/app_router.dart`: creates `GoRouter` and auth redirects.
- `lib/app/app.dart`: hosts `ProviderScope` and `MaterialApp.router` after routing is introduced.
- `lib/features/auth/presentation/pages/sign_in_page.dart`: sign-in screen.
- `lib/features/auth/presentation/pages/sign_up_page.dart`: sign-up screen.
- `test/...`: mirrors implemented slices with focused tests.

---

### Task 1: Add Auth Dependencies Intentionally

**Concept:** Dependencies are architecture decisions. Riverpod, GoRouter, and Supabase are documented choices, but imports are only allowed after the packages exist in `pubspec.yaml`.

**Files:**

- Modify: `pubspec.yaml`
- Generated: `pubspec.lock`

**Responsibilities:**

- Add only the packages required for the approved auth foundation.
- Avoid importing these packages in Dart code during this task.

**Dependencies:**

- `flutter_riverpod`
- `go_router`
- `supabase_flutter`

**Tests / Validation:**

- `flutter pub get`
- `flutter analyze`

**Risks:**

- Package resolution may expose SDK or transitive version constraints.

**Skills aplicáveis:**

- `dart-resolve-package-conflicts`
- `dart-run-static-analysis`

- [x] **Step 1: Confirm dependency baseline**

Run:

```bash
flutter pub deps
```

Expected:

```text
flutter_riverpod is absent
go_router is absent
supabase_flutter is absent
```

- [x] **Step 2: Add approved dependencies**

Run:

```bash
flutter pub add flutter_riverpod go_router supabase_flutter
```

Expected:

```text
Changed 3 dependencies!
```

- [x] **Step 3: Resolve dependencies**

Run:

```bash
flutter pub get
```

Expected:

```text
Got dependencies!
```

- [x] **Step 4: Validate static analysis**

Run:

```bash
flutter analyze
```

Expected:

```text
No issues found!
```

---

### Task 2: Centralize Supabase Environment Configuration

**Concept:** App configuration belongs at app level, not inside feature widgets. This keeps secrets and environment access predictable and testable.

**Files:**

- Create: `lib/app/config/app_environment.dart`
- Create: `test/app/config/app_environment_test.dart`

**Responsibilities:**

- Read Supabase values from Dart defines.
- Expose a simple boolean that indicates whether required values are present.

**Dependencies:**

- No new package dependencies beyond Flutter test tooling.

**Tests / Validation:**

- `flutter test test/app/config/app_environment_test.dart`

**Risks:**

- Empty Dart defines are valid at compile time; runtime initialization must handle missing values later.

**Skills aplicáveis:**

- `dart-add-unit-test`

- [ ] **Step 1: Write configuration test**

Create `test/app/config/app_environment_test.dart`:

```dart
import 'package:flowdelivery_app/app/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnvironment', () {
    test('exposes Supabase dart define values as strings', () {
      expect(AppEnvironment.supabaseUrl, isA<String>());
      expect(AppEnvironment.supabaseAnonKey, isA<String>());
    });

    test('reports whether Supabase configuration is available', () {
      final hasConfig = AppEnvironment.supabaseUrl.isNotEmpty &&
          AppEnvironment.supabaseAnonKey.isNotEmpty;

      expect(AppEnvironment.hasSupabaseConfig, hasConfig);
    });
  });
}
```

- [ ] **Step 2: Run test to verify missing implementation**

Run:

```bash
flutter test test/app/config/app_environment_test.dart
```

Expected:

```text
Error: Can't read 'lib/app/config/app_environment.dart'
```

- [ ] **Step 3: Create environment object**

Create `lib/app/config/app_environment.dart`:

```dart
abstract final class AppEnvironment {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasSupabaseConfig {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }
}
```

- [ ] **Step 4: Validate configuration slice**

Run:

```bash
flutter test test/app/config/app_environment_test.dart
```

Expected:

```text
All tests passed!
```

---

### Task 3: Model Auth Domain Boundaries

**Concept:** Domain files describe business meaning and contracts. They must not import Flutter widgets, Riverpod, GoRouter, or Supabase.

**Files:**

- Create: `lib/features/auth/domain/entities/auth_user.dart`
- Create: `lib/features/auth/domain/failures/auth_failure.dart`
- Create: `lib/features/auth/domain/repositories/auth_repository.dart`
- Create: `test/features/auth/domain/auth_domain_test.dart`

**Responsibilities:**

- Represent authenticated identity with `AuthUser`.
- Represent user-safe auth failure with `AuthFailure`.
- Define `AuthRepository` as the domain contract.

**Dependencies:**

- No new runtime dependencies.

**Tests / Validation:**

- `flutter test test/features/auth/domain/auth_domain_test.dart`

**Risks:**

- Returning `AuthUser` directly from repository methods makes failures exception-based unless a result type is introduced. For this first slice, use `AuthFailure` as the exception value and keep the API simple.

**Skills aplicáveis:**

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Write domain tests**

Create `test/features/auth/domain/auth_domain_test.dart`:

```dart
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

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
    return AuthUser(id: 'user-2', email: email);
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  group('Auth domain', () {
    test('auth user exposes identity data without backend details', () {
      const user = AuthUser(id: 'user-1', email: 'user@example.com');

      expect(user.id, 'user-1');
      expect(user.email, 'user@example.com');
    });

    test('auth failure stores a user-safe message', () {
      const failure = AuthFailure(message: 'Invalid credentials');

      expect(failure.message, 'Invalid credentials');
    });

    test('repository contract exposes email/password auth actions', () async {
      final repository = FakeAuthRepository();

      final signedInUser = await repository.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );

      final signedUpUser = await repository.signUpWithEmailAndPassword(
        email: 'new@example.com',
        password: 'password123',
      );

      await repository.signOut();

      expect(signedInUser.email, 'user@example.com');
      expect(signedUpUser.email, 'new@example.com');
    });
  });
}
```

- [ ] **Step 2: Run test to verify missing domain files**

Run:

```bash
flutter test test/features/auth/domain/auth_domain_test.dart
```

Expected:

```text
Error: Can't read one or more auth domain imports
```

- [ ] **Step 3: Create `AuthUser`**

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

- [ ] **Step 4: Create `AuthFailure`**

Create `lib/features/auth/domain/failures/auth_failure.dart`:

```dart
class AuthFailure implements Exception {
  const AuthFailure({required this.message});

  final String message;

  @override
  String toString() => message;
}
```

- [ ] **Step 5: Create `AuthRepository`**

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

- [ ] **Step 6: Validate domain slice**

Run:

```bash
flutter test test/features/auth/domain/auth_domain_test.dart
```

Expected:

```text
All tests passed!
```

---

### Task 4: Add Auth State and ViewModel

**Concept:** The ViewModel owns UI workflow state. Widgets should not decide business outcomes; they should display `AuthState` and call ViewModel methods.

**Files:**

- Create: `lib/features/auth/presentation/state/auth_state.dart`
- Create: `lib/features/auth/presentation/viewmodels/auth_view_model.dart`
- Create: `test/features/auth/presentation/auth_view_model_test.dart`

**Responsibilities:**

- Represent loading, authenticated, unauthenticated, and failure states.
- Call `AuthRepository` for auth actions.
- Keep Supabase imports out of presentation logic.

**Dependencies:**

- Domain auth files from Task 3.

**Tests / Validation:**

- `flutter test test/features/auth/presentation/auth_view_model_test.dart`

**Risks:**

- Using `ChangeNotifier` keeps the ViewModel simple and works with Riverpod wiring, but state mutation must remain disciplined.

**Skills aplicáveis:**

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Write ViewModel tests**

Create `test/features/auth/presentation/auth_view_model_test.dart`:

```dart
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flowdelivery_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldFail) {
      throw const AuthFailure(message: 'Invalid credentials');
    }

    return AuthUser(id: 'user-1', email: email);
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldFail) {
      throw const AuthFailure(message: 'Unable to create account');
    }

    return AuthUser(id: 'user-2', email: email);
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  group('AuthViewModel', () {
    test('starts unauthenticated and idle', () {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(),
      );

      expect(viewModel.state.status, AuthStatus.unauthenticated);
      expect(viewModel.state.user, isNull);
      expect(viewModel.state.message, isNull);
    });

    test('successful sign in stores authenticated user', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(),
      );

      await viewModel.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );

      expect(viewModel.state.status, AuthStatus.authenticated);
      expect(viewModel.state.user?.email, 'user@example.com');
      expect(viewModel.state.message, isNull);
    });

    test('failed sign in exposes user-safe error message', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(shouldFail: true),
      );

      await viewModel.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'bad-password',
      );

      expect(viewModel.state.status, AuthStatus.failure);
      expect(viewModel.state.user, isNull);
      expect(viewModel.state.message, 'Invalid credentials');
    });

    test('sign out clears authenticated user', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(),
      );

      await viewModel.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );
      await viewModel.signOut();

      expect(viewModel.state.status, AuthStatus.unauthenticated);
      expect(viewModel.state.user, isNull);
    });
  });
}
```

- [ ] **Step 2: Run test to verify missing presentation files**

Run:

```bash
flutter test test/features/auth/presentation/auth_view_model_test.dart
```

Expected:

```text
Error: Can't read one or more auth presentation imports
```

- [ ] **Step 3: Create explicit auth state**

Create `lib/features/auth/presentation/state/auth_state.dart`:

```dart
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';

enum AuthStatus {
  unauthenticated,
  loading,
  authenticated,
  failure,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        message = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        message = null;

  const AuthState.authenticated(AuthUser authenticatedUser)
      : status = AuthStatus.authenticated,
        user = authenticatedUser,
        message = null;

  const AuthState.failure(String errorMessage)
      : status = AuthStatus.failure,
        user = null,
        message = errorMessage;

  final AuthStatus status;
  final AuthUser? user;
  final String? message;
}
```

- [ ] **Step 4: Create `AuthViewModel`**

Create `lib/features/auth/presentation/viewmodels/auth_view_model.dart`:

```dart
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthState _state = const AuthState.unauthenticated();

  AuthState get state => _state;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setState(const AuthState.loading());

    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setState(AuthState.authenticated(user));
    } on AuthFailure catch (error) {
      _setState(AuthState.failure(error.message));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setState(const AuthState.loading());

    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setState(AuthState.authenticated(user));
    } on AuthFailure catch (error) {
      _setState(AuthState.failure(error.message));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _setState(const AuthState.unauthenticated());
  }

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
```

- [ ] **Step 5: Validate ViewModel slice**

Run:

```bash
flutter test test/features/auth/presentation/auth_view_model_test.dart
```

Expected:

```text
All tests passed!
```

---

### Task 5: Add Supabase Datasource and Repository Implementation

**Concept:** Datasources know external APIs. Repositories translate those external details into domain behavior.

**Files:**

- Create: `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- Create: `lib/features/auth/data/repositories/auth_repository_impl.dart`
- Create: `test/features/auth/data/auth_repository_impl_test.dart`

**Responsibilities:**

- Keep Supabase imports in the datasource file only.
- Map Supabase user data to `AuthUser`.
- Map backend exceptions to `AuthFailure`.

**Dependencies:**

- `supabase_flutter` from Task 1.
- Domain files from Task 3.

**Tests / Validation:**

- `flutter test test/features/auth/data/auth_repository_impl_test.dart`

**Risks:**

- Mocking Supabase directly can be brittle. Test repository behavior with a fake datasource instead.

**Skills aplicáveis:**

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Write repository implementation tests**

Create `test/features/auth/data/auth_repository_impl_test.dart`:

```dart
import 'package:flowdelivery_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowdelivery_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRemoteDatasource implements AuthRemoteDatasource {
  FakeAuthRemoteDatasource({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<AuthRemoteUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldFail) {
      throw const AuthRemoteException(message: 'Invalid credentials');
    }

    return AuthRemoteUser(id: 'user-1', email: email);
  }

  @override
  Future<AuthRemoteUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldFail) {
      throw const AuthRemoteException(message: 'Unable to create account');
    }

    return AuthRemoteUser(id: 'user-2', email: email);
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  group('AuthRepositoryImpl', () {
    test('maps remote user to domain user on sign in', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(),
      );

      final user = await repository.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );

      expect(user.id, 'user-1');
      expect(user.email, 'user@example.com');
    });

    test('maps remote exception to auth failure', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(shouldFail: true),
      );

      expect(
        () => repository.signInWithEmailAndPassword(
          email: 'user@example.com',
          password: 'bad-password',
        ),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify missing data files**

Run:

```bash
flutter test test/features/auth/data/auth_repository_impl_test.dart
```

Expected:

```text
Error: Can't read one or more auth data imports
```

- [ ] **Step 3: Create datasource contract and Supabase implementation**

Create `lib/features/auth/data/datasources/auth_remote_datasource.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteUser {
  const AuthRemoteUser({
    required this.id,
    required this.email,
  });

  final String id;
  final String email;
}

class AuthRemoteException implements Exception {
  const AuthRemoteException({required this.message});

  final String message;
}

abstract interface class AuthRemoteDatasource {
  Future<AuthRemoteUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthRemoteUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class SupabaseAuthRemoteDatasource implements AuthRemoteDatasource {
  const SupabaseAuthRemoteDatasource({required SupabaseClient client})
      : _client = client;

  final SupabaseClient _client;

  @override
  Future<AuthRemoteUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      () => _client.auth.signInWithPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<AuthRemoteUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      () => _client.auth.signUp(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<AuthRemoteUser> _authenticate(
    Future<AuthResponse> Function() action,
  ) async {
    try {
      final response = await action();
      final user = response.user;
      final email = user?.email;

      if (user == null || email == null || email.isEmpty) {
        throw const AuthRemoteException(
          message: 'Authentication response did not include a valid user.',
        );
      }

      return AuthRemoteUser(id: user.id, email: email);
    } on AuthException catch (error) {
      throw AuthRemoteException(message: error.message);
    }
  }
}
```

- [ ] **Step 4: Create repository implementation**

Create `lib/features/auth/data/repositories/auth_repository_impl.dart`:

```dart
import 'package:flowdelivery_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthRemoteDatasource datasource})
      : _datasource = datasource;

  final AuthRemoteDatasource _datasource;

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _mapRemoteCall(
      () => _datasource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _mapRemoteCall(
      () => _datasource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<void> signOut() async {
    try {
      await _datasource.signOut();
    } on AuthRemoteException catch (error) {
      throw AuthFailure(message: error.message);
    }
  }

  Future<AuthUser> _mapRemoteCall(
    Future<AuthRemoteUser> Function() action,
  ) async {
    try {
      final remoteUser = await action();

      return AuthUser(
        id: remoteUser.id,
        email: remoteUser.email,
      );
    } on AuthRemoteException catch (error) {
      throw AuthFailure(message: error.message);
    }
  }
}
```

- [ ] **Step 5: Validate data slice**

Run:

```bash
flutter test test/features/auth/data/auth_repository_impl_test.dart
```

Expected:

```text
All tests passed!
```

---

### Task 6: Wire Riverpod Providers

**Concept:** Providers are dependency wiring and lifecycle tools. They should create and expose objects, not hide business rules.

**Files:**

- Create: `lib/features/auth/presentation/providers/auth_providers.dart`
- Create: `test/features/auth/presentation/auth_providers_test.dart`
- Modify: `lib/app/app.dart`

**Responsibilities:**

- Provide Supabase client, datasource, repository, and ViewModel.
- Allow tests to override repository/provider dependencies.
- Wrap app root in `ProviderScope`.

**Dependencies:**

- `flutter_riverpod` from Task 1.
- Supabase datasource/repository from Task 5.

**Tests / Validation:**

- `flutter test test/features/auth/presentation/auth_providers_test.dart`

**Risks:**

- Initializing Supabase before config exists can fail. Provider wiring should read `Supabase.instance.client` only after app initialization is handled in the approved app bootstrap task.

**Skills aplicáveis:**

- `dart-add-unit-test`
- `flutter-apply-architecture-best-practices`

- [ ] **Step 1: Write provider wiring test**

Create `test/features/auth/presentation/auth_providers_test.dart`:

```dart
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
    return AuthUser(id: 'user-2', email: email);
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  test('auth view model provider can use an overridden repository', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      ],
    );
    addTearDown(container.dispose);

    final viewModel = container.read(authViewModelProvider);

    await viewModel.signInWithEmailAndPassword(
      email: 'user@example.com',
      password: 'password123',
    );

    expect(viewModel.state.user?.email, 'user@example.com');
  });
}
```

- [ ] **Step 2: Run test to verify missing providers**

Run:

```bash
flutter test test/features/auth/presentation/auth_providers_test.dart
```

Expected:

```text
Error: Can't read auth_providers.dart
```

- [ ] **Step 3: Create auth providers**

Create `lib/features/auth/presentation/providers/auth_providers.dart`:

```dart
import 'package:flowdelivery_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowdelivery_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return SupabaseAuthRemoteDatasource(
    client: ref.watch(supabaseClientProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    datasource: ref.watch(authRemoteDatasourceProvider),
  );
});

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
```

- [ ] **Step 4: Wrap app root with `ProviderScope`**

Modify `lib/app/app.dart` so the root app is wrapped once:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowDeliveryApp extends StatelessWidget {
  const FlowDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: FlowDeliveryAppView(),
    );
  }
}
```

Keep existing theme configuration inside `FlowDeliveryAppView` or the existing app widget shape used by the repository.

- [ ] **Step 5: Validate provider slice**

Run:

```bash
flutter test test/features/auth/presentation/auth_providers_test.dart
```

Expected:

```text
All tests passed!
```

---

### Task 7: Add Declarative Routing and Auth Guard

**Concept:** Global navigation policy belongs to app routing. Feature pages can be destinations, but they should not define global redirects.

**Files:**

- Create: `lib/app/routes/app_routes.dart`
- Create: `lib/app/routes/app_router.dart`
- Create: `test/app/routes/app_router_test.dart`
- Modify: `lib/app/app.dart`

**Responsibilities:**

- Centralize route names and paths.
- Use `GoRouter` for route configuration.
- Redirect based on auth state exposed through providers/ViewModels.

**Dependencies:**

- `go_router` from Task 1.
- Riverpod providers from Task 6.
- Auth pages from Task 8 may be introduced as placeholders only if this task is executed before UI.

**Tests / Validation:**

- `flutter test test/app/routes/app_router_test.dart`

**Risks:**

- Redirect loops can happen if authenticated, unauthenticated, and loading states are not separated.
- If auth pages do not exist yet, this task must either create minimal pages with approval or be executed after Task 8.

**Skills aplicáveis:**

- `flutter-setup-declarative-routing`
- `dart-add-unit-test`

- [ ] **Step 1: Confirm ordering**

If `sign_in_page.dart` and `sign_up_page.dart` do not exist, execute Task 8 before this task or request approval to create minimal route destination pages in this task.

- [ ] **Step 2: Write route constants**

Create `lib/app/routes/app_routes.dart`:

```dart
abstract final class AppRoutes {
  static const String homeName = 'home';
  static const String signInName = 'sign-in';
  static const String signUpName = 'sign-up';

  static const String homePath = '/';
  static const String signInPath = '/sign-in';
  static const String signUpPath = '/sign-up';
}
```

- [ ] **Step 3: Create router test**

Create `test/app/routes/app_router_test.dart` with a widget test that pumps `MaterialApp.router` and verifies unauthenticated users see the sign-in route.

- [ ] **Step 4: Create app router**

Create `lib/app/routes/app_router.dart` with `GoRouter`, public auth routes, and an auth redirect function that reads auth state from the approved provider boundary.

- [ ] **Step 5: Migrate app root to `MaterialApp.router`**

Modify `lib/app/app.dart` to use the router config while preserving existing theme setup.

- [ ] **Step 6: Validate routing slice**

Run:

```bash
flutter test test/app/routes/app_router_test.dart
```

Expected:

```text
All tests passed!
```

---

### Task 8: Add Sign In and Sign Up UI

**Concept:** Auth pages are views. They render inputs, loading, and errors, then delegate actions to the ViewModel/provider.

**Files:**

- Create: `lib/features/auth/presentation/pages/sign_in_page.dart`
- Create: `lib/features/auth/presentation/pages/sign_up_page.dart`
- Create: `test/features/auth/presentation/auth_pages_test.dart`

**Responsibilities:**

- Render email and password fields.
- Render primary auth action.
- Render navigation link between sign in and sign up.
- Avoid direct repository or Supabase calls.

**Dependencies:**

- Riverpod providers from Task 6.
- Theme tokens from existing app theme files.

**Tests / Validation:**

- `flutter test test/features/auth/presentation/auth_pages_test.dart`

**Risks:**

- UI can easily absorb validation/business logic. Keep validation minimal and delegate auth actions.

**Skills aplicáveis:**

- `flutter-add-widget-test`
- `flutter-build-responsive-layout`

- [ ] **Step 1: Write widget tests**

Create `test/features/auth/presentation/auth_pages_test.dart` to verify each page renders:

```text
Email field
Password field
Primary action button
Navigation link to the paired auth page
```

- [ ] **Step 2: Run test to verify missing pages**

Run:

```bash
flutter test test/features/auth/presentation/auth_pages_test.dart
```

Expected:

```text
Error: Can't read one or more auth page imports
```

- [ ] **Step 3: Create sign-in page**

Create `lib/features/auth/presentation/pages/sign_in_page.dart` with a `ConsumerStatefulWidget` that:

- owns text controllers;
- watches `authViewModelProvider`;
- calls `signInWithEmailAndPassword`;
- shows loading and failure state.

- [ ] **Step 4: Create sign-up page**

Create `lib/features/auth/presentation/pages/sign_up_page.dart` with the same boundaries as sign-in, calling `signUpWithEmailAndPassword`.

- [ ] **Step 5: Validate UI slice**

Run:

```bash
flutter test test/features/auth/presentation/auth_pages_test.dart
```

Expected:

```text
All tests passed!
```

---

### Task 9: Initialize Supabase at App Startup

**Concept:** External SDK initialization belongs at the app boundary. Feature code should receive initialized dependencies through providers, not initialize SDKs itself.

**Files:**

- Modify: `lib/main.dart`
- Modify: `lib/app/config/app_environment.dart`
- Create: `test/app/config/app_environment_test.dart` only if Task 2 did not already create it

**Responsibilities:**

- Initialize Supabase with `SUPABASE_URL` and `SUPABASE_ANON_KEY`.
- Fail clearly or defer initialization when config is absent, according to the implementation decision.

**Dependencies:**

- `supabase_flutter` from Task 1.
- `AppEnvironment` from Task 2.

**Tests / Validation:**

- `flutter analyze`
- `flutter test`

**Risks:**

- Calling `Supabase.initialize` with empty values can break local tests. Keep tests isolated from real SDK initialization where possible.

**Skills aplicáveis:**

- `dart-add-unit-test`
- `dart-run-static-analysis`

- [ ] **Step 1: Inspect current app startup**

Read:

```text
lib/main.dart
lib/app/app.dart
```

Confirm the existing app class names before editing.

- [ ] **Step 2: Add startup initialization**

Modify `lib/main.dart` to ensure Flutter bindings are initialized, read `AppEnvironment`, and initialize Supabase only with valid config.

- [ ] **Step 3: Validate app startup slice**

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

### Task 10: Reconcile Documentation and Memory

**Concept:** Documentation must reflect implemented behavior, not planned behavior. Update memory only after slices are actually validated.

**Files:**

- Modify: `.ai/memory/current_feature.md`
- Modify: `.ai/memory/technical_debt.md`
- Modify: `docs/setup/SUPABASE_SETUP.md`
- Modify: `docs/architecture/ROUTING_CONVENTIONS.md` only if route behavior changed from the current convention

**Responsibilities:**

- Record completed auth slices.
- Document required Dart defines.
- Keep known dependency debt accurate.

**Dependencies:**

- Completion of the implementation slices being documented.

**Tests / Validation:**

- `flutter analyze`
- `flutter test`

**Risks:**

- Updating docs before implementation would create drift. Only update facts that are true in the repository.

**Skills aplicáveis:**

- `dart-run-static-analysis`

- [ ] **Step 1: Update current feature memory**

Record completed slices and next pending step in `.ai/memory/current_feature.md`.

- [ ] **Step 2: Update technical debt**

If dependencies are installed, remove or revise the debt item that says Riverpod, GoRouter, and Supabase are absent.

- [ ] **Step 3: Update Supabase setup docs**

Document required Dart defines:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

- [ ] **Step 4: Run final focused validation**

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

- Auth feature has explicit domain, data, presentation, provider, and routing boundaries.
- Widgets do not import Supabase.
- ViewModels do not import Supabase.
- Supabase calls are isolated in the datasource layer.
- Riverpod is used for dependency wiring and UI state observation.
- GoRouter owns global route policy and auth redirects.
- Route paths and names are centralized.
- Each implemented slice has focused validation.
- Documentation and memory reflect only validated implementation.

## Riscos Gerais

- Package versions may need adjustment during dependency resolution.
- Supabase Auth manual validation requires real project credentials.
- Router guards can become coupled to UI state if the provider boundary is not kept explicit.
- Widget tests may need provider overrides to avoid real Supabase initialization.
- The current project rule asks for Flutter/Dart commands through Dart MCP after `add_roots`; if unavailable in the session, record the fallback before running CLI commands.

## Self-Review

- Spec coverage: the plan covers pending feature planning, technical planning, dependencies, repository layer, Riverpod providers, UI, tests, routing, documentation, and memory.
- Placeholder scan: no forbidden placeholder markers are used.
- Scope check: password reset, social login, profile synchronization, roles, realtime flows, Edge Functions, and production secrets are intentionally outside this feature slice.
