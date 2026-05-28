import 'package:flowdelivery_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowdelivery_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRemoteDatasource implements AuthRemoteDatasource {
  FakeAuthRemoteDatasource({this.shouldFail = false, this.errorMessage});

  final bool shouldFail;
  final String? errorMessage;
  String? lastUpdatedPassword;

  @override
  Future<AuthRemoteUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldFail) {
      throw AuthRemoteException(message: errorMessage ?? 'Invalid credentials');
    }

    return AuthRemoteUser(id: 'user-1', email: email);
  }

  @override
  Future<AuthRemoteUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldFail) {
      throw AuthRemoteException(
        message: errorMessage ?? 'Unable to create account',
      );
    }

    return AuthRemoteUser(id: 'user-2', email: email);
  }

  @override
  Future<void> signOut() async {
    if (shouldFail) {
      throw AuthRemoteException(message: errorMessage ?? 'Unable to sign out');
    }
  }

  @override
  Future<void> sendPasswordRecoveryEmail({required String email}) async {
    if (shouldFail) {
      throw AuthRemoteException(
        message: errorMessage ?? 'Unable to send recovery email',
      );
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    if (shouldFail) {
      throw AuthRemoteException(
        message: errorMessage ?? 'Unable to update password',
      );
    }

    lastUpdatedPassword = password;
  }
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

    test('maps remote user to domain user on sign up', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(),
      );

      final user = await repository.signUpWithEmailAndPassword(
        email: 'new@example.com',
        password: 'password123',
      );

      expect(user.id, 'user-2');
      expect(user.email, 'new@example.com');
    });

    test('maps remote exception to auth failure', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(
          shouldFail: true,
          errorMessage: 'Invalid login credentials',
        ),
      );

      expect(
        () => repository.signInWithEmailAndPassword(
          email: 'user@example.com',
          password: 'bad-password',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (error) => error.code,
            'code',
            AuthFailureCode.invalidCredentials,
          ),
        ),
      );
    });

    test('maps already registered error to user-safe PT-BR message', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(
          shouldFail: true,
          errorMessage: 'User already registered',
        ),
      );

      expect(
        () => repository.signUpWithEmailAndPassword(
          email: 'existing@example.com',
          password: 'password123',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (error) => error.code,
            'code',
            AuthFailureCode.userAlreadyRegistered,
          ),
        ),
      );
    });

    test('maps network error to user-safe PT-BR message', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(
          shouldFail: true,
          errorMessage: 'Network request failed',
        ),
      );

      expect(
        () => repository.sendPasswordRecoveryEmail(email: 'user@example.com'),
        throwsA(
          isA<AuthFailure>().having(
            (error) => error.code,
            'code',
            AuthFailureCode.networkFailure,
          ),
        ),
      );
    });

    test('maps sign out remote exception to auth failure', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(shouldFail: true),
      );

      expect(repository.signOut, throwsA(isA<AuthFailure>()));
    });

    test('maps password recovery remote exception to auth failure', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(shouldFail: true),
      );

      expect(
        () => repository.sendPasswordRecoveryEmail(email: 'user@example.com'),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('delegates password update to remote datasource', () async {
      final datasource = FakeAuthRemoteDatasource();
      final repository = AuthRepositoryImpl(datasource: datasource);

      await repository.updatePassword(password: 'new-password123');

      expect(datasource.lastUpdatedPassword, 'new-password123');
    });

    test('maps password update remote exception to auth failure', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(
          shouldFail: true,
          errorMessage: 'Password should be at least 6 characters',
        ),
      );

      expect(
        () => repository.updatePassword(password: 'short'),
        throwsA(
          isA<AuthFailure>().having(
            (error) => error.code,
            'code',
            AuthFailureCode.passwordTooShort,
          ),
        ),
      );
    });
  });
}
