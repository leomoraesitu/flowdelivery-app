class RestaurantMenuCategory {
  const RestaurantMenuCategory({required this.id});

  final String id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RestaurantMenuCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'RestaurantMenuCategory(id: $id)';
}
