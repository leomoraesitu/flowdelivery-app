import 'package:flowdelivery_app/app/config/app_environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_bootstrap.dart';

final supabaseConfiguredProvider = Provider<bool>((ref) {
  return AppEnvironment.hasSupabaseConfig;
});

final supabaseInitializedProvider = Provider<bool>((ref) {
  return isSupabaseInitialized;
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  if (!ref.watch(supabaseConfiguredProvider)) {
    throw StateError('Supabase is not configured.');
  }

  if (!ref.watch(supabaseInitializedProvider)) {
    throw StateError('Supabase is configured but was not initialized.');
  }

  return Supabase.instance.client;
});
