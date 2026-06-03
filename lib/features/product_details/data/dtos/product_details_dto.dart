class ProductDetailsDto {
  const ProductDetailsDto({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageAssetPath,
    required this.priceInCents,
  });

  factory ProductDetailsDto.fromRow(Map<String, Object?> row) {
    return ProductDetailsDto(
      id: _readString(row, key: 'id'),
      restaurantId: _readString(row, key: 'restaurant_id'),
      categoryId: _readString(row, key: 'category_id'),
      name: _readString(row, key: 'name'),
      description: _readString(row, key: 'description'),
      imageAssetPath: _readString(row, key: 'image_asset_path'),
      priceInCents: _readInt(row, key: 'price_in_cents'),
    );
  }

  final String id;
  final String restaurantId;
  final String categoryId;
  final String name;
  final String description;
  final String imageAssetPath;
  final int priceInCents;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProductDetailsDto &&
            other.id == id &&
            other.restaurantId == restaurantId &&
            other.categoryId == categoryId &&
            other.name == name &&
            other.description == description &&
            other.imageAssetPath == imageAssetPath &&
            other.priceInCents == priceInCents;
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
