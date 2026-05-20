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
  Future<void> signOut() async {
    try {
      await _datasource.signOut();
    } on AuthRemoteException catch (error) {
      throw AuthFailure(message: error.message);
    }
  }

  Future<AuthUser> _mapRemoteCall(
    Future<AuthRemoteUser> Function() action,
  ) async {
    try {
      final remoteUser = await action();

      return AuthUser(
        id: remoteUser.id,
        email: remoteUser.email,
      );
    } on AuthRemoteException catch (error) {
      throw AuthFailure(message: error.message);
    }
  }
}
