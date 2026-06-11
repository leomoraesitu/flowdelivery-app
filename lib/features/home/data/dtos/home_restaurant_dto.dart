class HomeRestaurantDto {
  HomeRestaurantDto({
    required this.id,
    required this.name,
    required this.imageAssetPath,
    required this.rating,
    required this.deliveryTimeMinMinutes,
    required this.deliveryTimeMaxMinutes,
    required this.cuisine,
    required this.sortOrder,
    List<String> categoryIds = const [],
  }) : categoryIds = List.unmodifiable(categoryIds);

  factory HomeRestaurantDto.fromRow(Map<String, Object?> row) {
    return HomeRestaurantDto(
      id: _readString(row, key: 'id'),
      name: _readString(row, key: 'name'),
      imageAssetPath: _readString(row, key: 'image_asset_path'),
      rating: _readDouble(row, key: 'rating'),
      deliveryTimeMinMinutes: _readInt(row, key: 'delivery_time_min_minutes'),
      deliveryTimeMaxMinutes: _readInt(row, key: 'delivery_time_max_minutes'),
      cuisine: _readString(row, key: 'cuisine'),
      sortOrder: _readInt(row, key: 'sort_order'),
    );
  }

  final String id;
  final String name;
  final String imageAssetPath;
  final double rating;
  final int deliveryTimeMinMinutes;
  final int deliveryTimeMaxMinutes;
  final String cuisine;
  final int sortOrder;
  final List<String> categoryIds;

  HomeRestaurantDto copyWith({
    List<String>? categoryIds,
  }) {
    return HomeRestaurantDto(
      id: id,
      name: name,
      imageAssetPath: imageAssetPath,
      rating: rating,
      deliveryTimeMinMinutes: deliveryTimeMinMinutes,
      deliveryTimeMaxMinutes: deliveryTimeMaxMinutes,
      cuisine: cuisine,
      sortOrder: sortOrder,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeRestaurantDto &&
            other.id == id &&
            other.name == name &&
            other.imageAssetPath == imageAssetPath &&
            other.rating == rating &&
            other.deliveryTimeMinMinutes == deliveryTimeMinMinutes &&
            other.deliveryTimeMaxMinutes == deliveryTimeMaxMinutes &&
            other.cuisine == cuisine &&
            other.sortOrder == sortOrder &&
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
    sortOrder,
    Object.hashAll(categoryIds),
  );

  @override
  String toString() {
    return 'HomeRestaurantDto('
        'id: $id, '
        'name: $name, '
        'imageAssetPath: $imageAssetPath, '
        'rating: $rating, '
        'deliveryTimeMinMinutes: $deliveryTimeMinMinutes, '
        'deliveryTimeMaxMinutes: $deliveryTimeMaxMinutes, '
        'cuisine: $cuisine, '
        'sortOrder: $sortOrder, '
        'categoryIds: $categoryIds'
        ')';
  }

  static String _readString(Map<String, Object?> row, {required String key}) {
    final value = row[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }

    throw FormatException('Expected a non-empty string for "$key".');
  }

  static int _readInt(Map<String, Object?> row, {required String key}) {
    final value = row[key];
    if (value is int) {
      return value;
    }

    throw FormatException('Expected an int for "$key".');
  }

  static double _readDouble(Map<String, Object?> row, {required String key}) {
    final value = row[key];
    if (value is num) {
      return value.toDouble();
    }

    throw FormatException('Expected a numeric value for "$key".');
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
