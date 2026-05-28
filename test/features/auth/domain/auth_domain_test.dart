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

  @override
  Future<void> sendPasswordRecoveryEmail({required String email}) async {}

  @override
  Future<void> updatePassword({required String password}) async {}
}

void main() {
  group('Auth domain', () {
    test('auth user exposes identity data without backend details', () {
      const user = AuthUser(id: 'user-1', email: 'user@example.com');

      expect(user.id, 'user-1');
      expect(user.email, 'user@example.com');
    });

    test(
      'auth failure stores a failure code and optional fallback message',
      () {
        const failure = AuthFailure(
          code: AuthFailureCode.genericFailure,
          fallbackMessage: 'Invalid credentials',
        );

        expect(failure.code, AuthFailureCode.genericFailure);
        expect(failure.fallbackMessage, 'Invalid credentials');
      },
    );

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

      await repository.sendPasswordRecoveryEmail(email: 'recover@example.com');

      await repository.signOut();

      expect(signedInUser.email, 'user@example.com');
      expect(signedUpUser.email, 'new@example.com');
    });
  });
}
