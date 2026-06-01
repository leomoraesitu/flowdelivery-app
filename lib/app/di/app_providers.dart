import 'package:flowdelivery_app/app/bootstrap/supabase_providers.dart';
import 'package:flowdelivery_app/app/config/app_environment.dart';
import 'package:flowdelivery_app/app/routes/auth_recovery_redirect.dart';
import 'package:flowdelivery_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowdelivery_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowdelivery_app/features/auth/data/repositories/unconfigured_auth_repository.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart'
    as auth_presentation;
import 'package:flowdelivery_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flowdelivery_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flowdelivery_app/features/home/domain/repositories/home_repository.dart';
import 'package:flowdelivery_app/features/home/presentation/providers/home_feed_providers.dart'
    as home_presentation;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appAuthRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return SupabaseAuthRemoteDatasource(
    client: ref.watch(supabaseClientProvider),
    passwordRecoveryRedirectUrl: buildPasswordRecoveryRedirectUrl(
      currentUri: Uri.base,
      configuredOrigin: AppEnvironment.passwordRecoveryRedirectOrigin,
    ),
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

final appHomeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  return SupabaseHomeRemoteDatasource(
    client: ref.watch(supabaseClientProvider),
  );
});

final appHomeRepositoryProvider = Provider<HomeRepository>((ref) {
  if (!ref.watch(supabaseConfiguredProvider)) {
    return const FixtureHomeRepository();
  }

  return HomeRepositoryImpl(
    datasource: ref.watch(appHomeRemoteDatasourceProvider),
  );
});

final appProviderOverrides = [
  auth_presentation.authRepositoryProvider.overrideWith((ref) {
    return ref.watch(appAuthRepositoryProvider);
  }),
  home_presentation.homeRepositoryProvider.overrideWith((ref) {
    return ref.watch(appHomeRepositoryProvider);
  }),
];
