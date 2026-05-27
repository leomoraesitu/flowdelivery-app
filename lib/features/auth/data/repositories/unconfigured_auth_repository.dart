import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';

class UnconfiguredAuthRepository implements AuthRepository {
  const UnconfiguredAuthRepository();

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw const AuthFailure(code: AuthFailureCode.unconfiguredEnvironment);
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw const AuthFailure(code: AuthFailureCode.unconfiguredEnvironment);
  }

  @override
  Future<void> sendPasswordRecoveryEmail({required String email}) async {
    throw const AuthFailure(code: AuthFailureCode.unconfiguredEnvironment);
  }

  @override
  Future<void> updatePassword({required String password}) async {
    throw const AuthFailure(code: AuthFailureCode.unconfiguredEnvironment);
  }

  @override
  Future<void> signOut() async {}
}
