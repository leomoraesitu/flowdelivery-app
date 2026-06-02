class RestaurantDetailsRemotePayload {
  RestaurantDetailsRemotePayload({
    required this.restaurant,
    required List<RestaurantMenuCategoryDto> categories,
    required List<RestaurantMenuItemDto> items,
  }) : categories = List.unmodifiable(categories),
       items = List.unmodifiable(items);

  final RestaurantDetailsDto restaurant;
  final List<RestaurantMenuCategoryDto> categories;
  final List<RestaurantMenuItemDto> items;
}

class RestaurantDetailsDto {
  const RestaurantDetailsDto({
    required this.id,
    required this.name,
    required this.imageAssetPath,
    required this.rating,
    required this.deliveryTimeMinMinutes,
    required this.deliveryTimeMaxMinutes,
    required this.cuisine,
  });

  factory RestaurantDetailsDto.fromRow(Map<String, Object?> row) {
    return RestaurantDetailsDto(
      id: _readString(row, key: 'id'),
      name: _readString(row, key: 'name'),
      imageAssetPath: _readString(row, key: 'image_asset_path'),
      rating: _readDouble(row, key: 'rating'),
      deliveryTimeMinMinutes: _readInt(row, key: 'delivery_time_min_minutes'),
      deliveryTimeMaxMinutes: _readInt(row, key: 'delivery_time_max_minutes'),
      cuisine: _readString(row, key: 'cuisine'),
    );
  }

  final String id;
  final String name;
  final String imageAssetPath;
  final double rating;
  final int deliveryTimeMinMinutes;
  final int deliveryTimeMaxMinutes;
  final String cuisine;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RestaurantDetailsDto &&
            other.id == id &&
            other.name == name &&
            other.imageAssetPath == imageAssetPath &&
            other.rating == rating &&
            other.deliveryTimeMinMinutes == deliveryTimeMinMinutes &&
            other.deliveryTimeMaxMinutes == deliveryTimeMaxMinutes &&
            other.cuisine == cuisine;
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
  );
}

class RestaurantMenuCategoryDto {
  const RestaurantMenuCategoryDto({
    required this.restaurantId,
    required this.id,
    required this.sortOrder,
  });

  factory RestaurantMenuCategoryDto.fromRow(Map<String, Object?> row) {
    return RestaurantMenuCategoryDto(
      restaurantId: _readString(row, key: 'restaurant_id'),
      id: _readString(row, key: 'id'),
      sortOrder: _readInt(row, key: 'sort_order'),
    );
  }

  final String restaurantId;
  final String id;
  final int sortOrder;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RestaurantMenuCategoryDto &&
            other.restaurantId == restaurantId &&
            other.id == id &&
            other.sortOrder == sortOrder;
  }

  @override
  int get hashCode => Object.hash(restaurantId, id, sortOrder);
}

class RestaurantMenuItemDto {
  const RestaurantMenuItemDto({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageAssetPath,
    required this.priceInCents,
    required this.sortOrder,
  });

  factory RestaurantMenuItemDto.fromRow(Map<String, Object?> row) {
    return RestaurantMenuItemDto(
      id: _readString(row, key: 'id'),
      restaurantId: _readString(row, key: 'restaurant_id'),
      categoryId: _readString(row, key: 'category_id'),
      name: _readString(row, key: 'name'),
      description: _readString(row, key: 'description'),
      imageAssetPath: _readString(row, key: 'image_asset_path'),
      priceInCents: _readInt(row, key: 'price_in_cents'),
      sortOrder: _readInt(row, key: 'sort_order'),
    );
  }

  final String id;
  final String restaurantId;
  final String categoryId;
  final String name;
  final String description;
  final String imageAssetPath;
  final int priceInCents;
  final int sortOrder;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RestaurantMenuItemDto &&
            other.id == id &&
            other.restaurantId == restaurantId &&
            other.categoryId == categoryId &&
            other.name == name &&
            other.description == description &&
            other.imageAssetPath == imageAssetPath &&
            other.priceInCents == priceInCents &&
            other.sortOrder == sortOrder;
  }

  @override
  int get hashCode => Object.hash(
    id,
    restaurantId,
    categoryId,
    name,
    description,
    imageAssetPath,
    priceInCents,
    sortOrder,
  );
}

String _readString(Map<String, Object?> row, {required String key}) {
  final value = row[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }

  throw FormatException('Expected a non-empty string for "$key".');
}

int _readInt(Map<String, Object?> row, {required String key}) {
  final value = row[key];
  if (value is int) {
    return value;
  }

  throw FormatException('Expected an int for "$key".');
}

double _readDouble(Map<String, Object?> row, {required String key}) {
  final value = row[key];
  if (value is num) {
    return value.toDouble();
  }

  throw FormatException('Expected a numeric value for "$key".');
}
