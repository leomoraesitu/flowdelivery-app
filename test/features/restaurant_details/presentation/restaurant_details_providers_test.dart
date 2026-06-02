import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_category.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';
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

  group('restaurantDetailsViewDataProvider', () {
    test(
      'defaults to the first category and exposes all items for it',
      () async {
        final container = ProviderContainer(
          overrides: [
            restaurantDetailsRepositoryProvider.overrideWithValue(
              _FakeRestaurantDetailsRepository(),
            ),
          ],
        );
        addTearDown(container.dispose);

        final viewData = await container.read(
          restaurantDetailsViewDataProvider('burger_artisan_collective').future,
        );

        expect(viewData.details, _details);
        expect(viewData.selectedCategoryId, 'popular');
        expect(viewData.visibleItems.map((item) => item.id).toList(), [
          'signature_truffle',
          'spicy_nashville_chicken',
          'sweet_potato_crisp',
        ]);
      },
    );

    test('filters visible items by the selected category', () async {
      final container = ProviderContainer(
        overrides: [
          restaurantDetailsRepositoryProvider.overrideWithValue(
            _FakeRestaurantDetailsRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(
        restaurantDetailsViewDataProvider('burger_artisan_collective').future,
      );

      container
          .read(
            restaurantDetailsSelectedCategoryProvider(
              'burger_artisan_collective',
            ).notifier,
          )
          .selectCategory('sides');

      final viewData = await container.read(
        restaurantDetailsViewDataProvider('burger_artisan_collective').future,
      );

      expect(viewData.selectedCategoryId, 'sides');
      expect(viewData.visibleItems.map((item) => item.id).toList(), [
        'sweet_potato_crisp',
      ]);
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
  categories: const [
    RestaurantMenuCategory(id: 'popular'),
    RestaurantMenuCategory(id: 'burgers'),
    RestaurantMenuCategory(id: 'sides'),
  ],
  items: const [
    RestaurantMenuItem(
      id: 'signature_truffle',
      categoryId: 'burgers',
      name: 'The Signature Truffle',
      description: 'Wagyu beef with truffle aioli.',
      imageAssetPath: 'assets/images/signature-truffle.png',
      priceInCents: 1850,
    ),
    RestaurantMenuItem(
      id: 'spicy_nashville_chicken',
      categoryId: 'burgers',
      name: 'Spicy Nashville Chicken',
      description: 'Crispy chicken breast with cayenne glaze.',
      imageAssetPath: 'assets/images/spicy-nashville-chicken.png',
      priceInCents: 1400,
    ),
    RestaurantMenuItem(
      id: 'sweet_potato_crisp',
      categoryId: 'sides',
      name: 'Sweet Potato Crisp',
      description: 'Hand-cut sweet potato fries.',
      imageAssetPath: 'assets/images/sweet-potato-crisp.png',
      priceInCents: 650,
    ),
  ],
);
