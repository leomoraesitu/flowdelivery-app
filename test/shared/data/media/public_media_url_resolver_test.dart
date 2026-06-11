import 'package:flowdelivery_app/app/bootstrap/supabase_providers.dart';
import 'package:flowdelivery_app/app/di/app_providers.dart';
import 'package:flowdelivery_app/shared/data/media/public_media_url_resolver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabasePublicMediaUrlResolver', () {
    late SupabasePublicMediaUrlResolver resolver;

    setUp(() {
      resolver = SupabasePublicMediaUrlResolver(client: _testClient);
    });

    test('preserves local asset paths', () {
      const path = 'assets/images/branding/logo-flowdelivery-light.png';

      expect(resolver.resolve(path), path);
    });

    test('resolves restaurant object paths through catalog-media', () {
      expect(
        resolver.resolve('restaurants/burger_artisan_collective/cover.webp'),
        'https://example.supabase.co/storage/v1/object/public/catalog-media/'
        'restaurants/burger_artisan_collective/cover.webp',
      );
    });

    test('resolves product object paths through catalog-media', () {
      expect(
        resolver.resolve(
          'products/burger_artisan_collective/signature_truffle.webp',
        ),
        'https://example.supabase.co/storage/v1/object/public/catalog-media/'
        'products/burger_artisan_collective/signature_truffle.webp',
      );
    });

    test('rejects blank paths with an explicit failure', () {
      expect(
        () => resolver.resolve('   '),
        throwsA(
          isA<PublicMediaResolutionFailure>().having(
            (failure) => failure.code,
            'code',
            PublicMediaResolutionFailureCode.blankPath,
          ),
        ),
      );
    });

    test('rejects unsupported paths with an explicit failure', () {
      expect(
        () => resolver.resolve('https://cdn.example.com/image.webp'),
        throwsA(
          isA<PublicMediaResolutionFailure>().having(
            (failure) => failure.code,
            'code',
            PublicMediaResolutionFailureCode.unsupportedPath,
          ),
        ),
      );
    });
  });

  test('app provider composes the resolver with the Supabase client', () {
    final container = ProviderContainer(
      overrides: [supabaseClientProvider.overrideWithValue(_testClient)],
    );
    addTearDown(container.dispose);

    final resolver = container.read(appPublicMediaUrlResolverProvider);

    expect(
      resolver.resolve('restaurants/pasta_roma/cover.webp'),
      'https://example.supabase.co/storage/v1/object/public/catalog-media/'
      'restaurants/pasta_roma/cover.webp',
    );
  });
}

final _testClient = SupabaseClient(
  'https://example.supabase.co',
  'test-anon-key',
);
