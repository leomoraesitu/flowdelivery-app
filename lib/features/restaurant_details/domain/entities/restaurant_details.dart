import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_category.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';

class RestaurantDetails {
  const RestaurantDetails({
    required this.id,
    required this.name,
    required this.imageAssetPath,
    required this.rating,
    required this.deliveryTimeMinMinutes,
    required this.deliveryTimeMaxMinutes,
    required this.cuisine,
    required this.categories,
    required this.items,
  });

  final String id;
  final String name;
  final String imageAssetPath;
  final double rating;
  final int deliveryTimeMinMinutes;
  final int deliveryTimeMaxMinutes;
  final String cuisine;
  final List<RestaurantMenuCategory> categories;
  final List<RestaurantMenuItem> items;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RestaurantDetails &&
            other.id == id &&
            other.name == name &&
            other.imageAssetPath == imageAssetPath &&
            other.rating == rating &&
            other.deliveryTimeMinMinutes == deliveryTimeMinMinutes &&
            other.deliveryTimeMaxMinutes == deliveryTimeMaxMinutes &&
            other.cuisine == cuisine &&
            _sameList(other.categories, categories) &&
            _sameList(other.items, items);
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    imageAssetPath,
    rating,
    deliveryTimeMinMinutes,
    deliveryTimeMaxMinutes,
    cuisine,
    Object.hashAll(categories),
    Object.hashAll(items),
  );

  @override
  String toString() {
    return 'RestaurantDetails('
        'id: $id, '
        'name: $name, '
        'imageAssetPath: $imageAssetPath, '
        'rating: $rating, '
        'deliveryTimeMinMinutes: $deliveryTimeMinMinutes, '
        'deliveryTimeMaxMinutes: $deliveryTimeMaxMinutes, '
        'cuisine: $cuisine, '
        'categories: $categories, '
        'items: $items'
        ')';
  }

  static bool _sameList<T>(List<T> left, List<T> right) {
    if (identical(left, right)) {
      return true;
    }

    if (left.length != right.length) {
      return false;
    }

    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) {
        return false;
      }
    }

    return true;
  }
}
