import 'package:flowdelivery_app/app/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnvironment', () {
    test('exposes Supabase dart define values as strings', () {
      expect(AppEnvironment.supabaseUrl, isA<String>());
      expect(AppEnvironment.supabaseAnonKey, isA<String>());
    });

    test('reports whether Supabase configuration is available', () {
      final hasConfig = AppEnvironment.supabaseUrl.isNotEmpty &&
          AppEnvironment.supabaseAnonKey.isNotEmpty;

      expect(AppEnvironment.hasSupabaseConfig, hasConfig);
    });
  });
}
