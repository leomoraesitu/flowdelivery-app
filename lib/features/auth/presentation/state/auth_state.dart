import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';

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
    this.message,
  });

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        message = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        message = null;

  const AuthState.authenticated(AuthUser authenticatedUser)
      : status = AuthStatus.authenticated,
        user = authenticatedUser,
        message = null;

  const AuthState.failure(String errorMessage)
      : status = AuthStatus.failure,
        user = null,
        message = errorMessage;

  final AuthStatus status;
  final AuthUser? user;
  final String? message;
}
