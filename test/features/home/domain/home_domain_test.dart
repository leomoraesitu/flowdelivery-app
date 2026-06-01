import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Home domain', () {
    test('category exposes a stable identifier', () {
      const category = HomeCategory(id: 'burgers');

      expect(category.id, 'burgers');
    });

    test('promotion exposes static feed metadata', () {
      const promotion = HomePromotion(
        id: 'weekend-pizza-party',
        imageAssetPath: 'assets/images/home/weekend-pizza-party.jpg',
        discountPercentage: 30,
        hasFreeDelivery: true,
      );

      expect(promotion.id, 'weekend-pizza-party');
      expect(
        promotion.imageAssetPath,
        'assets/images/home/weekend-pizza-party.jpg',
      );
      expect(promotion.discountPercentage, 30);
      expect(promotion.hasFreeDelivery, isTrue);
    });

    test('restaurant exposes immutable feed metadata', () {
      final restaurant = HomeRestaurant(
        id: 'burger-artisan-collective',
        name: 'Burger Artisan Collective',
        imageAssetPath: 'assets/images/home/burger-artisan-collective.jpg',
        rating: 4.8,
        deliveryTimeMinMinutes: 25,
        deliveryTimeMaxMinutes: 35,
        cuisine: 'American',
        categoryIds: const ['burgers'],
      );

      expect(restaurant.id, 'burger-artisan-collective');
      expect(restaurant.name, 'Burger Artisan Collective');
      expect(restaurant.rating, 4.8);
      expect(restaurant.deliveryTimeMinMinutes, 25);
      expect(restaurant.deliveryTimeMaxMinutes, 35);
      expect(restaurant.cuisine, 'American');
      expect(restaurant.categoryIds, ['burgers']);
      expect(
        () => restaurant.categoryIds.add('pizza'),
        throwsUnsupportedError,
      );
    });
  });
}
