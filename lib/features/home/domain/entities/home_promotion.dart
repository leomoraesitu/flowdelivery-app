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
}
