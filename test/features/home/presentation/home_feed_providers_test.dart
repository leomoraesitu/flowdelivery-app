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
    test('owns default selected category and search query state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final discoveryState = container.read(homeFeedDiscoveryControllerProvider);

      expect(discoveryState.selectedCategoryId, homeAllCategoryId);
      expect(discoveryState.searchQuery, isEmpty);
    });

    test('exposes a derived feed contract for presentation', () async {
      final expectedContent = HomeFeedContent(
        deliveryAddress: 'Avenida Brasil, 1000',
        categories: const [
          HomeCategory(id: 'all'),
          HomeCategory(id: 'pizza'),
        ],
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
      final viewData = container.read(homeFeedViewProvider);

      expect(viewData.content, expectedContent);
      expect(viewData.deliveryAddress, expectedContent.deliveryAddress);
      expect(viewData.categories, expectedContent.categories);
      expect(viewData.promotion, expectedContent.promotion);
      expect(viewData.visibleRestaurants, expectedContent.featuredRestaurants);
      expect(viewData.discoveryState.selectedCategoryId, homeAllCategoryId);
      expect(viewData.discoveryState.searchQuery, isEmpty);
    });

    test('updates the derived discovery contract when state changes', () async {
      final expectedContent = HomeFeedContent(
        deliveryAddress: 'Avenida Brasil, 1000',
        categories: const [
          HomeCategory(id: 'all'),
          HomeCategory(id: 'pizza'),
        ],
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

      container
          .read(homeFeedDiscoveryControllerProvider.notifier)
          .selectCategory('pizza');
      container
          .read(homeFeedDiscoveryControllerProvider.notifier)
          .setSearchQuery('roma');

      final viewData = container.read(homeFeedViewProvider);

      expect(viewData.discoveryState.selectedCategoryId, 'pizza');
      expect(viewData.discoveryState.searchQuery, 'roma');
      expect(viewData.visibleRestaurants, expectedContent.featuredRestaurants);
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
