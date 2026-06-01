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
}
