import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';

class HomeFeedContent {
  HomeFeedContent({
    required this.deliveryAddress,
    required List<HomeCategory> categories,
    required this.promotion,
    required List<HomeRestaurant> featuredRestaurants,
  }) : categories = List.unmodifiable(categories),
       featuredRestaurants = List.unmodifiable(featuredRestaurants);

  final String deliveryAddress;
  final List<HomeCategory> categories;
  final HomePromotion promotion;
  final List<HomeRestaurant> featuredRestaurants;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeFeedContent &&
            other.deliveryAddress == deliveryAddress &&
            _sameList(other.categories, categories) &&
            other.promotion == promotion &&
            _sameList(other.featuredRestaurants, featuredRestaurants);
  }

  @override
  int get hashCode => Object.hash(
    deliveryAddress,
    Object.hashAll(categories),
    promotion,
    Object.hashAll(featuredRestaurants),
  );

  @override
  String toString() {
    return 'HomeFeedContent('
        'deliveryAddress: $deliveryAddress, '
        'categories: $categories, '
        'promotion: $promotion, '
        'featuredRestaurants: $featuredRestaurants'
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
