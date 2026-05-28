typedef SupabaseInitializer =
    Future<void> Function({required String url, required String anonKey});

bool _isSupabaseInitialized = false;

bool get isSupabaseInitialized => _isSupabaseInitialized;

Future<bool> initializeSupabaseIfConfigured({
  required bool hasSupabaseConfig,
  required String supabaseUrl,
  required String supabaseAnonKey,
  required SupabaseInitializer initializeSupabase,
}) async {
  if (!hasSupabaseConfig) {
    return false;
  }

  await initializeSupabase(url: supabaseUrl, anonKey: supabaseAnonKey);
  _isSupabaseInitialized = true;
  return true;
}
