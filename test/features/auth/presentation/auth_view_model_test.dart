import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flowdelivery_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.shouldFail = false, this.shouldFailSignOut = false});

  final bool shouldFail;
  final bool shouldFailSignOut;
  String? lastUpdatedPassword;

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
  Future<void> signOut() async {
    if (shouldFailSignOut) {
      throw const AuthFailure(code: AuthFailureCode.networkFailure);
    }
  }

  @override
  Future<void> sendPasswordRecoveryEmail({required String email}) async {
    if (shouldFail) {
      throw const AuthFailure(
        code: AuthFailureCode.genericFailure,
        fallbackMessage: 'Nao foi possivel enviar o e-mail de recuperacao',
      );
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    if (shouldFail) {
      throw const AuthFailure(code: AuthFailureCode.genericFailure);
    }

    lastUpdatedPassword = password;
  }
}

void main() {
  group('AuthViewModel', () {
    test('starts unauthenticated and idle', () {
      final viewModel = AuthViewModel(authRepository: FakeAuthRepository());

      expect(viewModel.state.status, AuthStatus.unauthenticated);
      expect(viewModel.state.user, isNull);
      expect(viewModel.state.failure, isNull);
      expect(viewModel.state.signOutStatus, SignOutStatus.idle);
      expect(viewModel.state.signOutFailure, isNull);
    });

    test('successful sign in stores authenticated user', () async {
      final viewModel = AuthViewModel(authRepository: FakeAuthRepository());

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
      final viewModel = AuthViewModel(authRepository: FakeAuthRepository());

      await viewModel.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );
      await viewModel.signOut();

      expect(viewModel.state.status, AuthStatus.unauthenticated);
      expect(viewModel.state.user, isNull);
      expect(viewModel.state.signOutStatus, SignOutStatus.success);
      expect(viewModel.state.signOutFailure, isNull);
    });

    test('sign out failure keeps authenticated state and exposes error', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(shouldFailSignOut: true),
      );

      await viewModel.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );

      await viewModel.signOut();

      expect(viewModel.state.status, AuthStatus.authenticated);
      expect(viewModel.state.user?.email, 'user@example.com');
      expect(viewModel.state.failure, isNull);
      expect(viewModel.state.signOutStatus, SignOutStatus.failure);
      expect(viewModel.state.signOutFailure?.code, AuthFailureCode.networkFailure);
    });

    test('password recovery request stores success state', () async {
      final viewModel = AuthViewModel(authRepository: FakeAuthRepository());

      await viewModel.sendPasswordRecoveryEmail(email: 'user@example.com');

      expect(
        viewModel.state.passwordRecoveryStatus,
        PasswordRecoveryStatus.success,
      );
      expect(viewModel.state.passwordRecoveryFailure, isNull);
    });

    test(
      'password recovery request stores user-safe error on failure',
      () async {
        final viewModel = AuthViewModel(
          authRepository: FakeAuthRepository(shouldFail: true),
        );

        await viewModel.sendPasswordRecoveryEmail(email: 'user@example.com');

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
      },
    );

    test('resetPasswordRecoveryState clears stale recovery feedback', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(shouldFail: true),
      );

      await viewModel.sendPasswordRecoveryEmail(email: 'user@example.com');

      viewModel.resetPasswordRecoveryState();

      expect(
        viewModel.state.passwordRecoveryStatus,
        PasswordRecoveryStatus.idle,
      );
      expect(viewModel.state.passwordRecoveryFailure, isNull);
    });

    test('successful password update stores success state', () async {
      final repository = FakeAuthRepository();
      final viewModel = AuthViewModel(authRepository: repository);

      await viewModel.updatePassword(password: 'new-password123');

      expect(repository.lastUpdatedPassword, 'new-password123');
      expect(viewModel.state.passwordResetStatus, PasswordResetStatus.success);
      expect(viewModel.state.passwordResetFailure, isNull);
    });

    test('failed password update stores user-safe error', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(shouldFail: true),
      );

      await viewModel.updatePassword(password: 'short');

      expect(viewModel.state.passwordResetStatus, PasswordResetStatus.failure);
      expect(
        viewModel.state.passwordResetFailure?.code,
        AuthFailureCode.genericFailure,
      );
    });

    test('resetPasswordResetState clears stale reset feedback', () async {
      final viewModel = AuthViewModel(
        authRepository: FakeAuthRepository(shouldFail: true),
      );

      await viewModel.updatePassword(password: 'short');

      viewModel.resetPasswordResetState();

      expect(viewModel.state.passwordResetStatus, PasswordResetStatus.idle);
      expect(viewModel.state.passwordResetFailure, isNull);
    });
  });
}
