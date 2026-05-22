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
    await _authRepository.signOut();
    _setState(const AuthState.unauthenticated());
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

  void resetPasswordRecoveryState() {
    _setState(
      _state.copyWith(
        passwordRecoveryStatus: PasswordRecoveryStatus.idle,
        passwordRecoveryFailure: null,
      ),
    );
  }

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
