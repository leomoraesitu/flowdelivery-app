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
    test('exposes deterministic typed home feed content', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

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

    test('reads the feed content through the repository contract', () {
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

      final content = container.read(homeFeedProvider);

      expect(content, expectedContent);
    });

    test('exposes read-only collections to presentation', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

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
}

class _TestHomeRepository implements HomeRepository {
  const _TestHomeRepository(this.content);

  final HomeFeedContent content;

  @override
  HomeFeedContent getHomeFeedContent() {
    return content;
  }
}
