import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';

enum AuthStatus {
  unauthenticated,
  loading,
  authenticated,
  failure,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.failure,
  });

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        failure = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        failure = null;

  const AuthState.authenticated(AuthUser authenticatedUser)
      : status = AuthStatus.authenticated,
        user = authenticatedUser,
      failure = null;

    const AuthState.failure(AuthFailure authFailure)
      : status = AuthStatus.failure,
        user = null,
      failure = authFailure;

  final AuthStatus status;
  final AuthUser? user;
    final AuthFailure? failure;
}
