import 'package:flowdelivery_app/features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'package:flowdelivery_app/features/product_details/data/dtos/product_details_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseProductDetailsRemoteDatasource', () {
    test('parses a typed DTO from a Supabase row payload', () async {
      final datasource = SupabaseProductDetailsRemoteDatasource(
        client: _testClient,
        productRowLoader: (_) async => {
          'id': 'signature_truffle',
          'restaurant_id': 'burger_artisan_collective',
          'category_id': 'burgers',
          'name': 'The Signature Truffle',
          'description':
              'Wagyu beef, black truffle aioli, aged cheddar, and caramelized onions.',
          'image_asset_path':
              'assets/images/branding/logo-flowdelivery-light.png',
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
          imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
          priceInCents: 1850,
        ),
      );
    });

    test('returns null when the product does not exist', () async {
      final datasource = SupabaseProductDetailsRemoteDatasource(
        client: _testClient,
        productRowLoader: (_) async => null,
      );

      final product = await datasource.getProductDetails('missing_product');

      expect(product, isNull);
    });

    test('throws a remote exception when the row payload is malformed', () {
      final datasource = SupabaseProductDetailsRemoteDatasource(
        client: _testClient,
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
  });
}

final _testClient = SupabaseClient(
  'https://example.supabase.co',
  'test-anon-key',
);
