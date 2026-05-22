import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';

enum AuthStatus {
  unauthenticated,
  loading,
  authenticated,
  failure,
}

enum PasswordRecoveryStatus {
  idle,
  loading,
  success,
  failure,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.failure,
    this.passwordRecoveryStatus = PasswordRecoveryStatus.idle,
    this.passwordRecoveryFailure,
  });

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        failure = null,
        passwordRecoveryStatus = PasswordRecoveryStatus.idle,
        passwordRecoveryFailure = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        failure = null,
        passwordRecoveryStatus = PasswordRecoveryStatus.idle,
        passwordRecoveryFailure = null;

  const AuthState.authenticated(AuthUser authenticatedUser)
      : status = AuthStatus.authenticated,
        user = authenticatedUser,
        failure = null,
        passwordRecoveryStatus = PasswordRecoveryStatus.idle,
        passwordRecoveryFailure = null;

  const AuthState.failure(AuthFailure authFailure)
      : status = AuthStatus.failure,
        user = null,
        failure = authFailure,
        passwordRecoveryStatus = PasswordRecoveryStatus.idle,
        passwordRecoveryFailure = null;

  static const Object _sentinel = Object();

  final AuthStatus status;
  final AuthUser? user;
  final AuthFailure? failure;
  final PasswordRecoveryStatus passwordRecoveryStatus;
  final AuthFailure? passwordRecoveryFailure;

  AuthState copyWith({
    AuthStatus? status,
    Object? user = _sentinel,
    Object? failure = _sentinel,
    PasswordRecoveryStatus? passwordRecoveryStatus,
    Object? passwordRecoveryFailure = _sentinel,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: identical(user, _sentinel) ? this.user : user as AuthUser?,
      failure: identical(failure, _sentinel)
          ? this.failure
          : failure as AuthFailure?,
      passwordRecoveryStatus:
          passwordRecoveryStatus ?? this.passwordRecoveryStatus,
      passwordRecoveryFailure: identical(passwordRecoveryFailure, _sentinel)
          ? this.passwordRecoveryFailure
          : passwordRecoveryFailure as AuthFailure?,
    );
  }
}
