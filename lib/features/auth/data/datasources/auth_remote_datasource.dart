import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteUser {
  const AuthRemoteUser({
    required this.id,
    required this.email,
  });

  final String id;
  final String email;
}

class AuthRemoteException implements Exception {
  const AuthRemoteException({required this.message});

  final String message;
}

abstract interface class AuthRemoteDatasource {
  Future<AuthRemoteUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthRemoteUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class SupabaseAuthRemoteDatasource implements AuthRemoteDatasource {
  const SupabaseAuthRemoteDatasource({required SupabaseClient client})
    : _client = client;

  final SupabaseClient _client;

  @override
  Future<AuthRemoteUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      () => _client.auth.signInWithPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<AuthRemoteUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _authenticate(
      () => _client.auth.signUp(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (error) {
      throw AuthRemoteException(message: error.message);
    }
  }

  Future<AuthRemoteUser> _authenticate(
    Future<AuthResponse> Function() action,
  ) async {
    try {
      final response = await action();
      final user = response.user;
      final email = user?.email;

      if (user == null || email == null || email.isEmpty) {
        throw const AuthRemoteException(
          message: 'Authentication response did not include a valid user.',
        );
      }

      return AuthRemoteUser(id: user.id, email: email);
    } on AuthException catch (error) {
      throw AuthRemoteException(message: error.message);
    }
  }
}
