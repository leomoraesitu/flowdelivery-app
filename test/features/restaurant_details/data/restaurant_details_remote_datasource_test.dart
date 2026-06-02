import 'package:flowdelivery_app/features/restaurant_details/data/datasources/restaurant_details_remote_datasource.dart';
import 'package:flowdelivery_app/features/restaurant_details/data/dtos/restaurant_details_dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseRestaurantDetailsRemoteDatasource', () {
    test('aggregates typed DTOs from Supabase table payloads', () async {
      final datasource = SupabaseRestaurantDetailsRemoteDatasource(
        client: _testClient,
        restaurantRowLoader: (_) async => {
          'id': 'burger_artisan_collective',
          'name': 'Burger Artisan Collective',
          'image_asset_path':
              'assets/images/branding/logo-flowdelivery-light.png',
          'rating': 4.8,
          'delivery_time_min_minutes': 25,
          'delivery_time_max_minutes': 35,
          'cuisine': 'american',
        },
        categoryRowsLoader: (_) async => [
          {
            'restaurant_id': 'burger_artisan_collective',
            'id': 'popular',
            'sort_order': 0,
          },
          {
            'restaurant_id': 'burger_artisan_collective',
            'id': 'burgers',
            'sort_order': 1,
          },
        ],
        itemRowsLoader: (_) async => [
          {
            'id': 'signature_truffle',
            'restaurant_id': 'burger_artisan_collective',
            'category_id': 'burgers',
            'name': 'The Signature Truffle',
            'description':
                'Wagyu beef, black truffle aioli, aged cheddar, and caramelized onions.',
            'image_asset_path':
                'assets/images/branding/logo-flowdelivery-light.png',
            'price_in_cents': 1850,
            'sort_order': 0,
          },
        ],
      );

      final payload = await datasource.getRestaurantDetails(
        'burger_artisan_collective',
      );

      expect(
        payload.restaurant,
        const RestaurantDetailsDto(
          id: 'burger_artisan_collective',
          name: 'Burger Artisan Collective',
          imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
          rating: 4.8,
          deliveryTimeMinMinutes: 25,
          deliveryTimeMaxMinutes: 35,
          cuisine: 'american',
        ),
      );
      expect(payload.categories, const [
        RestaurantMenuCategoryDto(
          restaurantId: 'burger_artisan_collective',
          id: 'popular',
          sortOrder: 0,
        ),
        RestaurantMenuCategoryDto(
          restaurantId: 'burger_artisan_collective',
          id: 'burgers',
          sortOrder: 1,
        ),
      ]);
      expect(payload.items, const [
        RestaurantMenuItemDto(
          id: 'signature_truffle',
          restaurantId: 'burger_artisan_collective',
          categoryId: 'burgers',
          name: 'The Signature Truffle',
          description:
              'Wagyu beef, black truffle aioli, aged cheddar, and caramelized onions.',
          imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
          priceInCents: 1850,
          sortOrder: 0,
        ),
      ]);
    });

    test('throws a remote exception when the restaurant does not exist', () {
      final datasource = SupabaseRestaurantDetailsRemoteDatasource(
        client: _testClient,
        restaurantRowLoader: (_) async => null,
        categoryRowsLoader: (_) async => const [],
        itemRowsLoader: (_) async => const [],
      );

      expect(
        datasource.getRestaurantDetails('missing_restaurant'),
        throwsA(
          isA<RestaurantDetailsRemoteException>().having(
            (error) => error.message,
            'message',
            'No restaurant row was returned by Supabase for "missing_restaurant".',
          ),
        ),
      );
    });

    test('throws a remote exception when a row payload is malformed', () {
      final datasource = SupabaseRestaurantDetailsRemoteDatasource(
        client: _testClient,
        restaurantRowLoader: (_) async => {
          'id': 'burger_artisan_collective',
          'name': 'Burger Artisan Collective',
          'image_asset_path':
              'assets/images/branding/logo-flowdelivery-light.png',
          'rating': 'excellent',
          'delivery_time_min_minutes': 25,
          'delivery_time_max_minutes': 35,
          'cuisine': 'american',
        },
        categoryRowsLoader: (_) async => const [],
        itemRowsLoader: (_) async => const [],
      );

      expect(
        datasource.getRestaurantDetails('burger_artisan_collective'),
        throwsA(
          isA<RestaurantDetailsRemoteException>().having(
            (error) => error.message,
            'message',
            'Expected a numeric value for "rating".',
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
