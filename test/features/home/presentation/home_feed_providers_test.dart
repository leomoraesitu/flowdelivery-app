import 'package:flowdelivery_app/features/home/presentation/providers/home_feed_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('homeFeedProvider', () {
    test('exposes deterministic typed home feed content', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final content = container.read(homeFeedProvider);

      expect(
        content.categories.map((category) => category.id).toList(),
        equals(['all', 'burgers', 'pizza', 'sushi', 'healthy']),
      );
      expect(content.promotion.id, 'weekend_pizza_party');
      expect(content.promotion.discountPercentage, 30);
      expect(content.promotion.hasFreeDelivery, isTrue);
      expect(
        content.featuredRestaurants.map((restaurant) => restaurant.name).toList(),
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

    test('exposes read-only collections to presentation', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final content = container.read(homeFeedProvider);

      expect(
        () => content.categories.add(content.categories.first),
        throwsUnsupportedError,
      );
      expect(
        () => content.featuredRestaurants.add(content.featuredRestaurants.first),
        throwsUnsupportedError,
      );
      expect(
        () => content.featuredRestaurants.first.categoryIds.add('pizza'),
        throwsUnsupportedError,
      );
    });
  });
}
