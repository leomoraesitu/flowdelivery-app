import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthState _state = const AuthState.unauthenticated();

  AuthState get state => _state;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setState(const AuthState.loading());

    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setState(AuthState.authenticated(user));
    } on AuthFailure catch (error) {
      _setState(AuthState.failure(error));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setState(const AuthState.loading());

    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setState(AuthState.authenticated(user));
    } on AuthFailure catch (error) {
      _setState(AuthState.failure(error));
    }
  }

  Future<void> signOut() async {
    _setState(
      _state.copyWith(
        signOutStatus: SignOutStatus.loading,
        signOutFailure: null,
      ),
    );

    try {
      await _authRepository.signOut();
      _setState(
        _state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          failure: null,
          signOutStatus: SignOutStatus.success,
          signOutFailure: null,
        ),
      );
    } on AuthFailure catch (error) {
      _setState(
        _state.copyWith(
          signOutStatus: SignOutStatus.failure,
          signOutFailure: error,
        ),
      );
    }
  }

  Future<void> sendPasswordRecoveryEmail({required String email}) async {
    _setState(
      _state.copyWith(
        passwordRecoveryStatus: PasswordRecoveryStatus.loading,
        passwordRecoveryFailure: null,
      ),
    );

    try {
      await _authRepository.sendPasswordRecoveryEmail(email: email);
      _setState(
        _state.copyWith(
          passwordRecoveryStatus: PasswordRecoveryStatus.success,
          passwordRecoveryFailure: null,
        ),
      );
    } on AuthFailure catch (error) {
      _setState(
        _state.copyWith(
          passwordRecoveryStatus: PasswordRecoveryStatus.failure,
          passwordRecoveryFailure: error,
        ),
      );
    }
  }

  Future<void> updatePassword({required String password}) async {
    _setState(
      _state.copyWith(
        passwordResetStatus: PasswordResetStatus.loading,
        passwordResetFailure: null,
      ),
    );

    try {
      await _authRepository.updatePassword(password: password);
      _setState(
        _state.copyWith(
          passwordResetStatus: PasswordResetStatus.success,
          passwordResetFailure: null,
        ),
      );
    } on AuthFailure catch (error) {
      _setState(
        _state.copyWith(
          passwordResetStatus: PasswordResetStatus.failure,
          passwordResetFailure: error,
        ),
      );
    }
  }

  void resetPasswordRecoveryState() {
    _setState(
      _state.copyWith(
        passwordRecoveryStatus: PasswordRecoveryStatus.idle,
        passwordRecoveryFailure: null,
      ),
    );
  }

  void resetPasswordResetState() {
    _setState(
      _state.copyWith(
        passwordResetStatus: PasswordResetStatus.idle,
        passwordResetFailure: null,
      ),
    );
  }

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
