import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/bootstrap/supabase_bootstrap.dart';
import 'app/config/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await initializeSupabaseIfConfigured(
    hasSupabaseConfig: AppEnvironment.hasSupabaseConfig,
    supabaseUrl: AppEnvironment.supabaseUrl,
    supabaseAnonKey: AppEnvironment.supabaseAnonKey,
    initializeSupabase: ({required String url, required String anonKey}) {
      return Supabase.initialize(url: url, anonKey: anonKey);
    },
  );

  runApp(const FlowDeliveryApp());
}
