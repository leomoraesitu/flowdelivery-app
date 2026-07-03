import 'dart:collection';

import 'package:flowdelivery_app/features/cart/domain/entities/cart_item.dart';

class Cart {
  Cart({List<CartItem> items = const <CartItem>[]})
    : items = UnmodifiableListView<CartItem>(List<CartItem>.of(items));

  final UnmodifiableListView<CartItem> items;

  bool get isEmpty => items.isEmpty;

  int get itemCount =>
      items.fold<int>(0, (total, item) => total + item.quantity);

  int get totalInCents =>
      items.fold<int>(0, (total, item) => total + item.subtotalInCents);

  String? get restaurantId => items.isEmpty ? null : items.first.restaurantId;

  CartItem? itemByProductId(String productId) {
    for (final item in items) {
      if (item.productId == productId) {
        return item;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Cart || other.items.length != items.length) {
      return false;
    }
    for (var index = 0; index < items.length; index++) {
      if (other.items[index] != items[index]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(items);

  @override
  String toString() => 'Cart(items: $items)';
}
