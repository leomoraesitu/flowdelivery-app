import 'package:flowdelivery_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flowdelivery_app/features/home/data/dtos/home_category_dto.dart';
import 'package:flowdelivery_app/features/home/data/dtos/home_promotion_dto.dart';
import 'package:flowdelivery_app/features/home/data/dtos/home_restaurant_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseHomeRemoteDatasource', () {
    test('aggregates typed DTOs from Supabase table payloads', () async {
      final datasource = SupabaseHomeRemoteDatasource(
        client: _testClient,
        categoryRowsLoader: () async => [
          {'id': 'all', 'sort_order': 0},
          {'id': 'burgers', 'sort_order': 1},
        ],
        promotionRowLoader: () async => {
          'id': 'weekend_pizza_party',
          'image_asset_path': 'assets/images/branding/logo-flowdelivery-light.png',
          'discount_percentage': 30,
          'is_free_delivery_enabled': true,
          'sort_order': 0,
        },
        featuredRestaurantRowsLoader: () async => [
          {
            'id': 'burger_artisan_collective',
            'name': 'Burger Artisan Collective',
            'image_asset_path': 'assets/images/branding/logo-flowdelivery-light.png',
            'rating': 4.8,
            'delivery_time_min_minutes': 25,
            'delivery_time_max_minutes': 35,
            'cuisine': 'american',
            'sort_order': 0,
          },
          {
            'id': 'sushi_zen',
            'name': 'Sushi Zen',
            'image_asset_path': 'assets/images/branding/logo-flowdelivery-light.png',
            'rating': 4.9,
            'delivery_time_min_minutes': 20,
            'delivery_time_max_minutes': 30,
            'cuisine': 'japanese',
            'sort_order': 1,
          },
        ],
        restaurantCategoryLinkRowsLoader: () async => [
          {
            'restaurant_id': 'burger_artisan_collective',
            'category_id': 'all',
            'sort_order': 0,
          },
          {
            'restaurant_id': 'burger_artisan_collective',
            'category_id': 'burgers',
            'sort_order': 1,
          },
          {
            'restaurant_id': 'sushi_zen',
            'category_id': 'all',
            'sort_order': 0,
          },
        ],
      );

      final payload = await datasource.getHomeFeed();

      expect(
        payload.categories,
        const [
          HomeCategoryDto(id: 'all', sortOrder: 0),
          HomeCategoryDto(id: 'burgers', sortOrder: 1),
        ],
      );
      expect(
        payload.promotion,
        const HomePromotionDto(
          id: 'weekend_pizza_party',
          imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
          discountPercentage: 30,
          hasFreeDelivery: true,
          sortOrder: 0,
        ),
      );
      expect(
        payload.featuredRestaurants,
        [
          HomeRestaurantDto(
            id: 'burger_artisan_collective',
            name: 'Burger Artisan Collective',
            imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
            rating: 4.8,
            deliveryTimeMinMinutes: 25,
            deliveryTimeMaxMinutes: 35,
            cuisine: 'american',
            sortOrder: 0,
            categoryIds: const ['all', 'burgers'],
          ),
          HomeRestaurantDto(
            id: 'sushi_zen',
            name: 'Sushi Zen',
            imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
            rating: 4.9,
            deliveryTimeMinMinutes: 20,
            deliveryTimeMaxMinutes: 30,
            cuisine: 'japanese',
            sortOrder: 1,
            categoryIds: const ['all'],
          ),
        ],
      );
    });

    test('throws a HomeRemoteException when no active promotion is returned', () {
      final datasource = SupabaseHomeRemoteDatasource(
        client: _testClient,
        categoryRowsLoader: () async => const [],
        promotionRowLoader: () async => null,
        featuredRestaurantRowsLoader: () async => const [],
        restaurantCategoryLinkRowsLoader: () async => const [],
      );

      expect(
        datasource.getHomeFeed(),
        throwsA(
          isA<HomeRemoteException>().having(
            (error) => error.message,
            'message',
            'No active Home promotion row was returned by Supabase.',
          ),
        ),
      );
    });

    test('throws a HomeRemoteException when a row payload is malformed', () {
      final datasource = SupabaseHomeRemoteDatasource(
        client: _testClient,
        categoryRowsLoader: () async => [
          {'id': 'all', 'sort_order': 'zero'},
        ],
        promotionRowLoader: () async => {
          'id': 'weekend_pizza_party',
          'image_asset_path': 'assets/images/branding/logo-flowdelivery-light.png',
          'discount_percentage': 30,
          'is_free_delivery_enabled': true,
          'sort_order': 0,
        },
        featuredRestaurantRowsLoader: () async => const [],
        restaurantCategoryLinkRowsLoader: () async => const [],
      );

      expect(
        datasource.getHomeFeed(),
        throwsA(
          isA<HomeRemoteException>().having(
            (error) => error.message,
            'message',
            'Expected an int for "sort_order".',
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
