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
      throw const AuthFailure(code: AuthFailureCode.invalidCredentials);
    }

    return AuthUser(id: 'user-1', email: email);
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldFail) {
      throw const AuthFailure(code: AuthFailureCode.genericFailure);
    }

    return AuthUser(id: 'user-2', email: email);
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordRecoveryEmail({required String email}) async {
    if (shouldFail) {
      throw const AuthFailure(
        code: AuthFailureCode.genericFailure,
        fallbackMessage: 'Nao foi possivel enviar o e-mail de recuperacao',
      );
    }
  }
}

void main() {
  group('AuthViewModel', () {
    test('starts unauthenticated and idle', () {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(),
      );

      expect(viewModel.state.status, AuthStatus.unauthenticated);
      expect(viewModel.state.user, isNull);
      expect(viewModel.state.failure, isNull);
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
      expect(viewModel.state.failure, isNull);
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
      expect(viewModel.state.failure?.code, AuthFailureCode.invalidCredentials);
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

    test('password recovery request stores success state', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(),
      );

      await viewModel.sendPasswordRecoveryEmail(
        email: 'user@example.com',
      );

      expect(
        viewModel.state.passwordRecoveryStatus,
        PasswordRecoveryStatus.success,
      );
      expect(viewModel.state.passwordRecoveryFailure, isNull);
    });

    test('password recovery request stores user-safe error on failure', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(shouldFail: true),
      );

      await viewModel.sendPasswordRecoveryEmail(
        email: 'user@example.com',
      );

      expect(
        viewModel.state.passwordRecoveryStatus,
        PasswordRecoveryStatus.failure,
      );
      expect(
        viewModel.state.passwordRecoveryFailure?.code,
        AuthFailureCode.genericFailure,
      );
      expect(
        viewModel.state.passwordRecoveryFailure?.fallbackMessage,
        'Nao foi possivel enviar o e-mail de recuperacao',
      );
    });

    test('resetPasswordRecoveryState clears stale recovery feedback', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(shouldFail: true),
      );

      await viewModel.sendPasswordRecoveryEmail(
        email: 'user@example.com',
      );

      viewModel.resetPasswordRecoveryState();

      expect(
        viewModel.state.passwordRecoveryStatus,
        PasswordRecoveryStatus.idle,
      );
      expect(viewModel.state.passwordRecoveryFailure, isNull);
    });
  });
}
