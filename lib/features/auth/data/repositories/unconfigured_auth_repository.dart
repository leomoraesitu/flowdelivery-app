import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';

class UnconfiguredAuthRepository implements AuthRepository {
  const UnconfiguredAuthRepository();

  static const _message =
      'Supabase is not configured. Provide SUPABASE_URL and '
      'SUPABASE_ANON_KEY to enable authentication.';

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw const AuthFailure(message: _message);
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw const AuthFailure(message: _message);
  }

  @override
  Future<void> signOut() async {}
}
