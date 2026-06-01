class HomePromotion {
  const HomePromotion({
    required this.id,
    required this.imageAssetPath,
    required this.discountPercentage,
    required this.hasFreeDelivery,
  });

  final String id;
  final String imageAssetPath;
  final int discountPercentage;
  final bool hasFreeDelivery;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomePromotion &&
            other.id == id &&
            other.imageAssetPath == imageAssetPath &&
            other.discountPercentage == discountPercentage &&
            other.hasFreeDelivery == hasFreeDelivery;
  }

  @override
  int get hashCode => Object.hash(
        id,
        imageAssetPath,
        discountPercentage,
        hasFreeDelivery,
      );

  @override
  String toString() {
    return 'HomePromotion('
        'id: $id, '
        'imageAssetPath: $imageAssetPath, '
        'discountPercentage: $discountPercentage, '
        'hasFreeDelivery: $hasFreeDelivery'
        ')';
  }
}
