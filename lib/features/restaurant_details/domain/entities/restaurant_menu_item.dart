class RestaurantMenuItem {
  const RestaurantMenuItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageAssetPath,
    required this.priceInCents,
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String imageAssetPath;
  final int priceInCents;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RestaurantMenuItem &&
            other.id == id &&
            other.categoryId == categoryId &&
            other.name == name &&
            other.description == description &&
            other.imageAssetPath == imageAssetPath &&
            other.priceInCents == priceInCents;
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    name,
    description,
    imageAssetPath,
    priceInCents,
  );

  @override
  String toString() {
    return 'RestaurantMenuItem('
        'id: $id, '
        'categoryId: $categoryId, '
        'name: $name, '
        'description: $description, '
        'imageAssetPath: $imageAssetPath, '
        'priceInCents: $priceInCents'
        ')';
  }
}
