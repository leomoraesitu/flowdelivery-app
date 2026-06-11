import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_category.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Restaurant details domain', () {
    test('menu category exposes a stable identifier', () {
      const category = RestaurantMenuCategory(id: 'burgers');

      expect(category.id, 'burgers');
    });

    test('menu item exposes read-only catalog metadata', () {
      const item = RestaurantMenuItem(
        id: 'signature-truffle',
        categoryId: 'burgers',
        name: 'The Signature Truffle',
        description: 'Wagyu beef and black truffle aioli.',
        imageAssetPath: 'assets/images/menu/signature-truffle.jpg',
        priceInCents: 1850,
      );

      expect(item.id, 'signature-truffle');
      expect(item.categoryId, 'burgers');
      expect(item.name, 'The Signature Truffle');
      expect(item.description, 'Wagyu beef and black truffle aioli.');
      expect(item.imageAssetPath, 'assets/images/menu/signature-truffle.jpg');
      expect(item.priceInCents, 1850);
    });

    test('details exposes immutable restaurant and catalog metadata', () {
      const categories = [RestaurantMenuCategory(id: 'burgers')];
      const items = [
        RestaurantMenuItem(
          id: 'signature-truffle',
          categoryId: 'burgers',
          name: 'The Signature Truffle',
          description: 'Wagyu beef and black truffle aioli.',
          imageAssetPath: 'assets/images/menu/signature-truffle.jpg',
          priceInCents: 1850,
        ),
      ];
      final details = RestaurantDetails(
        id: 'burger-artisan-collective',
        name: 'Burger Artisan Collective',
        imageAssetPath: 'assets/images/home/burger-artisan-collective.jpg',
        rating: 4.8,
        deliveryTimeMinMinutes: 25,
        deliveryTimeMaxMinutes: 35,
        cuisine: 'American',
        categories: categories,
        items: items,
      );

      expect(details.id, 'burger-artisan-collective');
      expect(details.name, 'Burger Artisan Collective');
      expect(
        details.imageAssetPath,
        'assets/images/home/burger-artisan-collective.jpg',
      );
      expect(details.rating, 4.8);
      expect(details.deliveryTimeMinMinutes, 25);
      expect(details.deliveryTimeMaxMinutes, 35);
      expect(details.cuisine, 'American');
      expect(details.categories, categories);
      expect(details.items, items);
      expect(
        () => details.categories.add(const RestaurantMenuCategory(id: 'sides')),
        throwsUnsupportedError,
      );
      expect(
        () => details.items.add(
          const RestaurantMenuItem(
            id: 'sweet-potato-crisp',
            categoryId: 'sides',
            name: 'Sweet Potato Crisp',
            description: 'Hand-cut sweet potato fries.',
            imageAssetPath: 'assets/images/menu/sweet-potato-crisp.jpg',
            priceInCents: 650,
          ),
        ),
        throwsUnsupportedError,
      );
    });
  });
}
