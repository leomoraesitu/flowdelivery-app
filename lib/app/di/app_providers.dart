import 'package:flowdelivery_app/app/bootstrap/supabase_providers.dart';
import 'package:flowdelivery_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowdelivery_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowdelivery_app/features/auth/data/repositories/unconfigured_auth_repository.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart'
    as auth_presentation;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appAuthRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return SupabaseAuthRemoteDatasource(
    client: ref.watch(supabaseClientProvider),
  );
});

final appAuthRepositoryProvider = Provider<AuthRepository>((ref) {
  if (!ref.watch(supabaseConfiguredProvider)) {
    return const UnconfiguredAuthRepository();
  }

  return AuthRepositoryImpl(
    datasource: ref.watch(appAuthRemoteDatasourceProvider),
  );
});

final appProviderOverrides = [
  auth_presentation.authRepositoryProvider.overrideWith((ref) {
    return ref.watch(appAuthRepositoryProvider);
  }),
];
