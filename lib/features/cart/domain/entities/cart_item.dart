class CartItem {
  const CartItem({
    required this.productId,
    required this.restaurantId,
    required this.name,
    required this.imageAssetPath,
    required this.priceInCents,
    required this.quantity,
  }) : assert(quantity >= 1, 'Cart item quantity must be at least 1.');

  final String productId;
  final String restaurantId;
  final String name;
  final String imageAssetPath;
  final int priceInCents;
  final int quantity;

  int get subtotalInCents => priceInCents * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      restaurantId: restaurantId,
      name: name,
      imageAssetPath: imageAssetPath,
      priceInCents: priceInCents,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CartItem &&
            other.productId == productId &&
            other.restaurantId == restaurantId &&
            other.name == name &&
            other.imageAssetPath == imageAssetPath &&
            other.priceInCents == priceInCents &&
            other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(
    productId,
    restaurantId,
    name,
    imageAssetPath,
    priceInCents,
    quantity,
  );

  @override
  String toString() {
    return 'CartItem('
        'productId: $productId, '
        'restaurantId: $restaurantId, '
        'name: $name, '
        'imageAssetPath: $imageAssetPath, '
        'priceInCents: $priceInCents, '
        'quantity: $quantity'
        ')';
  }
}
