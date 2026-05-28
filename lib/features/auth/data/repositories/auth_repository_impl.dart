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
  Future<void> sendPasswordRecoveryEmail({required String email}) async {
    try {
      await _datasource.sendPasswordRecoveryEmail(email: email);
    } on AuthRemoteException catch (error) {
      throw _mapRemoteFailure(error.message);
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    try {
      await _datasource.updatePassword(password: password);
    } on AuthRemoteException catch (error) {
      throw _mapRemoteFailure(error.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _datasource.signOut();
    } on AuthRemoteException catch (error) {
      throw _mapRemoteFailure(error.message);
    }
  }

  Future<AuthUser> _mapRemoteCall(
    Future<AuthRemoteUser> Function() action,
  ) async {
    try {
      final remoteUser = await action();

      return AuthUser(id: remoteUser.id, email: remoteUser.email);
    } on AuthRemoteException catch (error) {
      throw _mapRemoteFailure(error.message);
    }
  }

  AuthFailure _mapRemoteFailure(String remoteMessage) {
    final normalized = remoteMessage.trim().toLowerCase();

    if (normalized.contains('invalid login credentials') ||
        normalized.contains('invalid credentials')) {
      return const AuthFailure(code: AuthFailureCode.invalidCredentials);
    }

    if (normalized.contains('email not confirmed')) {
      return const AuthFailure(code: AuthFailureCode.emailNotConfirmed);
    }

    if (normalized.contains('user already registered') ||
        normalized.contains('already registered')) {
      return const AuthFailure(code: AuthFailureCode.userAlreadyRegistered);
    }

    if (normalized.contains('password should be at least')) {
      return const AuthFailure(code: AuthFailureCode.passwordTooShort);
    }

    if (normalized.contains('network request failed') ||
        normalized.contains('failed to fetch') ||
        normalized.contains('socket') ||
        normalized.contains('timeout') ||
        normalized.contains('timed out')) {
      return const AuthFailure(code: AuthFailureCode.networkFailure);
    }

    if (normalized.isEmpty) {
      return const AuthFailure(code: AuthFailureCode.genericFailure);
    }

    return AuthFailure(
      code: AuthFailureCode.genericFailure,
      fallbackMessage: remoteMessage,
    );
  }
}
