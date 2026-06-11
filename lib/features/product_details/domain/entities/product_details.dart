class ProductDetails {
  const ProductDetails({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageAssetPath,
    required this.priceInCents,
  });

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
        other is ProductDetails &&
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

  @override
  String toString() {
    return 'ProductDetails('
        'id: $id, '
        'restaurantId: $restaurantId, '
        'categoryId: $categoryId, '
        'name: $name, '
        'description: $description, '
        'imageAssetPath: $imageAssetPath, '
        'priceInCents: $priceInCents'
        ')';
  }
}
