import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_feed_content.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';
import 'package:flowdelivery_app/features/home/domain/repositories/home_repository.dart';
import 'package:flowdelivery_app/features/home/presentation/providers/home_feed_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('homeFeedProvider', () {
    test('exposes deterministic typed home feed content by default', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);
      final content = container.read(homeFeedProvider);

      expect(content.deliveryAddress, 'Rua das Flores, 42');
      expect(
        content.categories.map((category) => category.id).toList(),
        equals(['all', 'burgers', 'pizza', 'sushi', 'healthy']),
      );
      expect(content.promotion.id, 'weekend_pizza_party');
      expect(content.promotion.discountPercentage, 30);
      expect(content.promotion.hasFreeDelivery, isTrue);
      expect(
        content.featuredRestaurants
            .map((restaurant) => restaurant.name)
            .toList(),
        equals([
          'Burger Artisan Collective',
          'Pasta Roma',
          'Sushi Zen',
          'Taco Harbor',
        ]),
      );
      expect(content.featuredRestaurants.first.rating, 4.8);
      expect(content.featuredRestaurants.first.categoryIds, ['all', 'burgers']);
    });

    test('reads the feed content through the repository contract', () async {
      final expectedContent = HomeFeedContent(
        deliveryAddress: 'Avenida Brasil, 1000',
        categories: const [HomeCategory(id: 'all')],
        promotion: const HomePromotion(
          id: 'custom_promotion',
          imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
          discountPercentage: 15,
          hasFreeDelivery: false,
        ),
        featuredRestaurants: [
          HomeRestaurant(
            id: 'custom_restaurant',
            name: 'Custom Restaurant',
            imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
            rating: 4.4,
            deliveryTimeMinMinutes: 18,
            deliveryTimeMaxMinutes: 28,
            cuisine: 'fusion',
            categoryIds: const ['all'],
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _TestHomeRepository(expectedContent),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);
      final content = container.read(homeFeedProvider);

      expect(content, expectedContent);
    });

    test('exposes read-only collections to presentation', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);
      final content = container.read(homeFeedProvider);

      expect(
        () => content.categories.add(content.categories.first),
        throwsUnsupportedError,
      );
      expect(
        () =>
            content.featuredRestaurants.add(content.featuredRestaurants.first),
        throwsUnsupportedError,
      );
      expect(
        () => content.featuredRestaurants.first.categoryIds.add('pizza'),
        throwsUnsupportedError,
      );
    });
  });

  group('homeFeed discovery providers', () {
    HomeFeedContent buildDiscoveryContent() {
      return HomeFeedContent(
        deliveryAddress: 'Avenida Brasil, 1000',
        categories: const [
          HomeCategory(id: 'all'),
          HomeCategory(id: 'burgers'),
          HomeCategory(id: 'pizza'),
          HomeCategory(id: 'sushi'),
        ],
        promotion: const HomePromotion(
          id: 'custom_promotion',
          imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
          discountPercentage: 15,
          hasFreeDelivery: false,
        ),
        featuredRestaurants: [
          HomeRestaurant(
            id: 'burger_house',
            name: 'Burger House',
            imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
            rating: 4.4,
            deliveryTimeMinMinutes: 18,
            deliveryTimeMaxMinutes: 28,
            cuisine: 'american',
            categoryIds: const ['all', 'burgers'],
          ),
          HomeRestaurant(
            id: 'roma_pizza',
            name: 'Roma Pizza',
            imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
            rating: 4.7,
            deliveryTimeMinMinutes: 20,
            deliveryTimeMaxMinutes: 32,
            cuisine: 'italian',
            categoryIds: const ['all', 'pizza'],
          ),
          HomeRestaurant(
            id: 'sushi_zen',
            name: 'Sushi Zen',
            imageAssetPath: 'assets/images/branding/logo-flowdelivery-light.png',
            rating: 4.8,
            deliveryTimeMinMinutes: 22,
            deliveryTimeMaxMinutes: 34,
            cuisine: 'japanese',
            categoryIds: const ['all', 'sushi'],
          ),
        ],
      );
    }

    test('owns default selected category and search query state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final discoveryState = container.read(homeFeedDiscoveryControllerProvider);

      expect(discoveryState.selectedCategoryId, homeAllCategoryId);
      expect(discoveryState.searchQuery, isEmpty);
    });

    test('exposes a derived feed contract for presentation', () async {
      final expectedContent = buildDiscoveryContent();
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _TestHomeRepository(expectedContent),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);
      final viewData = container.read(homeFeedViewProvider);

      expect(viewData.content, expectedContent);
      expect(viewData.deliveryAddress, expectedContent.deliveryAddress);
      expect(viewData.categories, expectedContent.categories);
      expect(viewData.promotion, expectedContent.promotion);
      expect(viewData.visibleRestaurants, expectedContent.featuredRestaurants);
      expect(viewData.discoveryState.selectedCategoryId, homeAllCategoryId);
      expect(viewData.discoveryState.searchQuery, isEmpty);
    });

    test('keeps the default discovery state equivalent to the full feed', () async {
      final expectedContent = buildDiscoveryContent();
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _TestHomeRepository(expectedContent),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);
      final viewData = container.read(homeFeedViewProvider);

      expect(
        viewData.visibleRestaurants.map((restaurant) => restaurant.id).toList(),
        expectedContent.featuredRestaurants
            .map((restaurant) => restaurant.id)
            .toList(),
      );
    });

    test('filters restaurants by selected category id', () async {
      final expectedContent = buildDiscoveryContent();
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _TestHomeRepository(expectedContent),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);

      container
          .read(homeFeedDiscoveryControllerProvider.notifier)
          .selectCategory('pizza');

      final viewData = container.read(homeFeedViewProvider);

      expect(
        viewData.visibleRestaurants.map((restaurant) => restaurant.id).toList(),
        equals(['roma_pizza']),
      );
    });

    test('filters restaurants by normalized search query', () async {
      final expectedContent = buildDiscoveryContent();
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _TestHomeRepository(expectedContent),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);

      container
          .read(homeFeedDiscoveryControllerProvider.notifier)
          .setSearchQuery('  JAPANESE  ');

      final viewData = container.read(homeFeedViewProvider);

      expect(
        viewData.visibleRestaurants.map((restaurant) => restaurant.id).toList(),
        equals(['sushi_zen']),
      );
    });

    test('combines selected category and normalized search query deterministically',
        () async {
      final expectedContent = buildDiscoveryContent();
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _TestHomeRepository(expectedContent),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);

      container
          .read(homeFeedDiscoveryControllerProvider.notifier)
          .selectCategory('pizza');
      container
          .read(homeFeedDiscoveryControllerProvider.notifier)
          .setSearchQuery('  ROMA ');

      final viewData = container.read(homeFeedViewProvider);

      expect(viewData.discoveryState.selectedCategoryId, 'pizza');
      expect(viewData.discoveryState.searchQuery, '  ROMA ');
      expect(
        viewData.visibleRestaurants.map((restaurant) => restaurant.id).toList(),
        equals(['roma_pizza']),
      );
    });

    test('resets combined discovery filters to the full feed baseline', () async {
      final expectedContent = buildDiscoveryContent();
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            _TestHomeRepository(expectedContent),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeFeedAsyncProvider.future);

      final controller = container.read(
        homeFeedDiscoveryControllerProvider.notifier,
      );
      controller.selectCategory('pizza');
      controller.setSearchQuery('sushi');

      expect(container.read(homeFeedViewProvider).visibleRestaurants, isEmpty);

      controller.reset();

      final viewData = container.read(homeFeedViewProvider);

      expect(viewData.discoveryState.selectedCategoryId, homeAllCategoryId);
      expect(viewData.discoveryState.searchQuery, isEmpty);
      expect(
        viewData.visibleRestaurants.map((restaurant) => restaurant.id).toList(),
        expectedContent.featuredRestaurants
            .map((restaurant) => restaurant.id)
            .toList(),
      );
    });
  });
}

class _TestHomeRepository implements HomeRepository {
  const _TestHomeRepository(this.content);

  final HomeFeedContent content;

  @override
  Future<HomeFeedContent> getHomeFeedContent() async {
    return content;
  }
}
