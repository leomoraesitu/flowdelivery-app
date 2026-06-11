class HomeRestaurant {
  HomeRestaurant({
    required this.id,
    required this.name,
    required this.imageAssetPath,
    required this.rating,
    required this.deliveryTimeMinMinutes,
    required this.deliveryTimeMaxMinutes,
    required this.cuisine,
    required List<String> categoryIds,
  }) : categoryIds = List.unmodifiable(categoryIds);

  final String id;
  final String name;
  final String imageAssetPath;
  final double rating;
  final int deliveryTimeMinMinutes;
  final int deliveryTimeMaxMinutes;
  final String cuisine;
  final List<String> categoryIds;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeRestaurant &&
            other.id == id &&
            other.name == name &&
            other.imageAssetPath == imageAssetPath &&
            other.rating == rating &&
            other.deliveryTimeMinMinutes == deliveryTimeMinMinutes &&
            other.deliveryTimeMaxMinutes == deliveryTimeMaxMinutes &&
            other.cuisine == cuisine &&
            _sameCategoryIds(other.categoryIds, categoryIds);
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
        Object.hashAll(categoryIds),
      );

  @override
  String toString() {
    return 'HomeRestaurant('
        'id: $id, '
        'name: $name, '
        'imageAssetPath: $imageAssetPath, '
        'rating: $rating, '
        'deliveryTimeMinMinutes: $deliveryTimeMinMinutes, '
        'deliveryTimeMaxMinutes: $deliveryTimeMaxMinutes, '
        'cuisine: $cuisine, '
        'categoryIds: $categoryIds'
        ')';
  }

  static bool _sameCategoryIds(List<String> left, List<String> right) {
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
