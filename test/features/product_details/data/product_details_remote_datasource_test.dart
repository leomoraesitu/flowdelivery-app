import 'package:flowdelivery_app/features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'package:flowdelivery_app/features/product_details/data/dtos/product_details_dto.dart';
import 'package:flowdelivery_app/shared/data/media/public_media_url_resolver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseProductDetailsRemoteDatasource', () {
    test('parses a typed DTO from a Supabase row payload', () async {
      final datasource = SupabaseProductDetailsRemoteDatasource(
        client: _testClient,
        mediaUrlResolver: _mediaUrlResolver,
        productRowLoader: (_) async => {
          'id': 'signature_truffle',
          'restaurant_id': 'burger_artisan_collective',
          'category_id': 'burgers',
          'name': 'The Signature Truffle',
          'description':
              'Wagyu beef, black truffle aioli, aged cheddar, and caramelized onions.',
          'image_asset_path':
              'products/burger_artisan_collective/signature_truffle.webp',
          'price_in_cents': 1850,
        },
      );

      final product = await datasource.getProductDetails('signature_truffle');

      expect(
        product,
        const ProductDetailsDto(
          id: 'signature_truffle',
          restaurantId: 'burger_artisan_collective',
          categoryId: 'burgers',
          name: 'The Signature Truffle',
          description:
              'Wagyu beef, black truffle aioli, aged cheddar, and caramelized onions.',
          imageAssetPath:
              'https://example.supabase.co/storage/v1/object/public/'
              'catalog-media/products/burger_artisan_collective/'
              'signature_truffle.webp',
          priceInCents: 1850,
        ),
      );
    });

    test(
      'parses a seeded non-burger product from a Supabase row payload',
      () async {
        final datasource = SupabaseProductDetailsRemoteDatasource(
          client: _testClient,
          mediaUrlResolver: _mediaUrlResolver,
          productRowLoader: (_) async => {
            'id': 'sushi_zen_omakase_sampler',
            'restaurant_id': 'sushi_zen',
            'category_id': 'popular',
            'name': 'Omakase Sampler',
            'description':
                'Chef-selected nigiri and rolls with seasonal garnish and soy.',
            'image_asset_path':
                'assets/images/branding/logo-flowdelivery-light.png',
            'price_in_cents': 2490,
          },
        );

        final product = await datasource.getProductDetails(
          'sushi_zen_omakase_sampler',
        );

        expect(
          product,
          const ProductDetailsDto(
            id: 'sushi_zen_omakase_sampler',
            restaurantId: 'sushi_zen',
            categoryId: 'popular',
            name: 'Omakase Sampler',
            description:
                'Chef-selected nigiri and rolls with seasonal garnish and soy.',
            imageAssetPath:
                'assets/images/branding/logo-flowdelivery-light.png',
            priceInCents: 2490,
          ),
        );
      },
    );

    test('returns null when the product does not exist', () async {
      final datasource = SupabaseProductDetailsRemoteDatasource(
        client: _testClient,
        mediaUrlResolver: _mediaUrlResolver,
        productRowLoader: (_) async => null,
      );

      final product = await datasource.getProductDetails('missing_product');

      expect(product, isNull);
    });

    test('throws a remote exception when the row payload is malformed', () {
      final datasource = SupabaseProductDetailsRemoteDatasource(
        client: _testClient,
        mediaUrlResolver: _mediaUrlResolver,
        productRowLoader: (_) async => {
          'id': 'signature_truffle',
          'restaurant_id': 'burger_artisan_collective',
          'category_id': 'burgers',
          'name': 'The Signature Truffle',
          'description':
              'Wagyu beef, black truffle aioli, aged cheddar, and caramelized onions.',
          'image_asset_path':
              'assets/images/branding/logo-flowdelivery-light.png',
          'price_in_cents': 'expensive',
        },
      );

      expect(
        datasource.getProductDetails('signature_truffle'),
        throwsA(
          isA<ProductDetailsRemoteException>().having(
            (error) => error.message,
            'message',
            'Expected an int for "price_in_cents".',
          ),
        ),
      );
    });

    test('maps media resolution failures to the remote exception', () {
      final datasource = SupabaseProductDetailsRemoteDatasource(
        client: _testClient,
        mediaUrlResolver: _mediaUrlResolver,
        productRowLoader: (_) async => {
          'id': 'signature_truffle',
          'restaurant_id': 'burger_artisan_collective',
          'category_id': 'burgers',
          'name': 'The Signature Truffle',
          'description':
              'Wagyu beef, black truffle aioli, aged cheddar, and caramelized onions.',
          'image_asset_path': 'unsupported/product.webp',
          'price_in_cents': 1850,
        },
      );

      expect(
        datasource.getProductDetails('signature_truffle'),
        throwsA(isA<ProductDetailsRemoteException>()),
      );
    });
  });
}

final _testClient = SupabaseClient(
  'https://example.supabase.co',
  'test-anon-key',
);

final _mediaUrlResolver = SupabasePublicMediaUrlResolver(client: _testClient);
