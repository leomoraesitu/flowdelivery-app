import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/repositories/restaurant_details_repository.dart';
import 'package:flowdelivery_app/features/restaurant_details/presentation/providers/restaurant_details_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('restaurantDetailsProvider', () {
    test('loads restaurant details by stable restaurant id', () async {
      final repository = _FakeRestaurantDetailsRepository();
      final container = ProviderContainer(
        overrides: [
          restaurantDetailsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(
          restaurantDetailsProvider('burger_artisan_collective').future,
        ),
        completion(_details),
      );
      expect(repository.requestedRestaurantIds, ['burger_artisan_collective']);
    });
  });

  group('restaurantDetailsSelectedCategoryProvider', () {
    test('owns selected category independently for each restaurant', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(
          restaurantDetailsSelectedCategoryProvider('restaurant-1'),
        ),
        isNull,
      );
      expect(
        container.read(
          restaurantDetailsSelectedCategoryProvider('restaurant-2'),
        ),
        isNull,
      );

      container
          .read(
            restaurantDetailsSelectedCategoryProvider('restaurant-1').notifier,
          )
          .selectCategory('burgers');

      expect(
        container.read(
          restaurantDetailsSelectedCategoryProvider('restaurant-1'),
        ),
        'burgers',
      );
      expect(
        container.read(
          restaurantDetailsSelectedCategoryProvider('restaurant-2'),
        ),
        isNull,
      );
    });

    test('resets the selected category for the restaurant', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(
        restaurantDetailsSelectedCategoryProvider('restaurant-1').notifier,
      );

      controller.selectCategory('burgers');
      controller.reset();

      expect(
        container.read(
          restaurantDetailsSelectedCategoryProvider('restaurant-1'),
        ),
        isNull,
      );
    });
  });
}

class _FakeRestaurantDetailsRepository implements RestaurantDetailsRepository {
  final requestedRestaurantIds = <String>[];

  @override
  Future<RestaurantDetails> getRestaurantDetails(String restaurantId) async {
    requestedRestaurantIds.add(restaurantId);
    return _details;
  }
}

final _details = RestaurantDetails(
  id: 'burger_artisan_collective',
  name: 'Burger Artisan Collective',
  imageAssetPath: 'assets/images/restaurant.png',
  rating: 4.8,
  deliveryTimeMinMinutes: 25,
  deliveryTimeMaxMinutes: 35,
  cuisine: 'american',
  categories: const [],
  items: const [],
);
