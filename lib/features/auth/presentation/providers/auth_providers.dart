import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw StateError('AuthRepository dependency was not configured.');
});

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel(authRepository: ref.watch(authRepositoryProvider));
});
