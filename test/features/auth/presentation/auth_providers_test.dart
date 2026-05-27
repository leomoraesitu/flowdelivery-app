import 'package:flowdelivery_app/app/bootstrap/supabase_providers.dart';
import 'package:flowdelivery_app/app/di/app_providers.dart';
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
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

  @override
  Future<void> sendPasswordRecoveryEmail({required String email}) async {}

  @override
  Future<void> updatePassword({required String password}) async {}
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

  test(
    'auth view model reports failure when Supabase is not configured',
    () async {
      final container = ProviderContainer(
        overrides: [
          ...appProviderOverrides,
          supabaseConfiguredProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      final viewModel = container.read(authViewModelProvider);

      await viewModel.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );

      expect(viewModel.state.status, AuthStatus.failure);
      expect(
        viewModel.state.failure?.code,
        AuthFailureCode.unconfiguredEnvironment,
      );
    },
  );

  test(
    'auth repository reports explicit error when Supabase is not initialized',
    () {
      final container = ProviderContainer(
        overrides: [
          supabaseConfiguredProvider.overrideWithValue(true),
          supabaseInitializedProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      expect(
        () => container.read(appAuthRepositoryProvider),
        throwsA(
          isA<Object>().having(
            (error) => error.toString(),
            'message',
            contains('nao foi inicializado'),
          ),
        ),
      );
    },
  );
}
