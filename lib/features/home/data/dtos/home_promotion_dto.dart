class HomePromotionDto {
  const HomePromotionDto({
    required this.id,
    required this.imageAssetPath,
    required this.discountPercentage,
    required this.hasFreeDelivery,
    required this.sortOrder,
  });

  factory HomePromotionDto.fromRow(Map<String, Object?> row) {
    return HomePromotionDto(
      id: _readString(row, key: 'id'),
      imageAssetPath: _readString(row, key: 'image_asset_path'),
      discountPercentage: _readInt(row, key: 'discount_percentage'),
      hasFreeDelivery: _readBool(row, key: 'is_free_delivery_enabled'),
      sortOrder: _readInt(row, key: 'sort_order'),
    );
  }

  final String id;
  final String imageAssetPath;
  final int discountPercentage;
  final bool hasFreeDelivery;
  final int sortOrder;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomePromotionDto &&
            other.id == id &&
            other.imageAssetPath == imageAssetPath &&
            other.discountPercentage == discountPercentage &&
            other.hasFreeDelivery == hasFreeDelivery &&
            other.sortOrder == sortOrder;
  }

  @override
  int get hashCode => Object.hash(
    id,
    imageAssetPath,
    discountPercentage,
    hasFreeDelivery,
    sortOrder,
  );

  @override
  String toString() {
    return 'HomePromotionDto('
        'id: $id, '
        'imageAssetPath: $imageAssetPath, '
        'discountPercentage: $discountPercentage, '
        'hasFreeDelivery: $hasFreeDelivery, '
        'sortOrder: $sortOrder'
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

  static bool _readBool(Map<String, Object?> row, {required String key}) {
    final value = row[key];
    if (value is bool) {
      return value;
    }

    throw FormatException('Expected a bool for "$key".');
  }
}
