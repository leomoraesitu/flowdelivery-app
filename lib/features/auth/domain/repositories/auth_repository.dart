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

  Future<void> sendPasswordRecoveryEmail({required String email});

  Future<void> updatePassword({required String password});

  Future<void> signOut();
}
