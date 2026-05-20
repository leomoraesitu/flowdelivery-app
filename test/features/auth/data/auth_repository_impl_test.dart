import 'package:flowdelivery_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowdelivery_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRemoteDatasource implements AuthRemoteDatasource {
  const FakeAuthRemoteDatasource({this.shouldFail = false});

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
  Future<void> signOut() async {
    if (shouldFail) {
      throw const AuthRemoteException(message: 'Unable to sign out');
    }
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

    test('maps sign out remote exception to auth failure', () async {
      final repository = AuthRepositoryImpl(
        datasource: FakeAuthRemoteDatasource(shouldFail: true),
      );

      expect(
        repository.signOut,
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
