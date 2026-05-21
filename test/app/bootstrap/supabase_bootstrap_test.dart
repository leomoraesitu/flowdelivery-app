import 'package:flowdelivery_app/app/bootstrap/supabase_bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('initializeSupabaseIfConfigured', () {
    test('does not initialize when config is missing', () async {
      var initialized = false;

      final result = await initializeSupabaseIfConfigured(
        hasSupabaseConfig: false,
        supabaseUrl: '',
        supabaseAnonKey: '',
        initializeSupabase:
            ({required String url, required String anonKey}) async {
              initialized = true;
            },
      );

      expect(result, isFalse);
      expect(initialized, isFalse);
    });

    test('initializes with provided values when config exists', () async {
      var callCount = 0;
      String? capturedUrl;
      String? capturedAnonKey;

      final result = await initializeSupabaseIfConfigured(
        hasSupabaseConfig: true,
        supabaseUrl: 'https://project.supabase.co',
        supabaseAnonKey: 'anon-key',
        initializeSupabase:
            ({required String url, required String anonKey}) async {
              callCount++;
              capturedUrl = url;
              capturedAnonKey = anonKey;
            },
      );

      expect(result, isTrue);
      expect(isSupabaseInitialized, isTrue);
      expect(callCount, 1);
      expect(capturedUrl, 'https://project.supabase.co');
      expect(capturedAnonKey, 'anon-key');
    });
  });
}
