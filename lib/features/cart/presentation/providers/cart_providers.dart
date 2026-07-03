import 'package:flowdelivery_app/features/cart/domain/entities/cart.dart';
import 'package:flowdelivery_app/features/cart/domain/entities/cart_item.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Outcome of an [CartNotifier.addItem] attempt.
///
/// Restaurant mismatch is expected business flow, not an error, so it is
/// modeled as a return signal instead of an exception.
enum CartAddResult { added, requiresConfirmation }

class CartNotifier extends Notifier<Cart> {
  @override
  Cart build() => Cart();

  CartAddResult addItem(
    ProductDetails product, {
    required String restaurantName,
  }) {
    final currentRestaurantId = state.restaurantId;
    if (currentRestaurantId != null &&
        currentRestaurantId != product.restaurantId) {
      return CartAddResult.requiresConfirmation;
    }

    final existingItem = state.itemByProductId(product.id);
    if (existingItem != null) {
      updateQuantity(product.id, existingItem.quantity + 1);
      return CartAddResult.added;
    }

    state = Cart(
      items: [
        ...state.items,
        CartItem(
          productId: product.id,
          restaurantId: product.restaurantId,
          restaurantName: restaurantName,
          name: product.name,
          imageAssetPath: product.imageAssetPath,
          priceInCents: product.priceInCents,
          quantity: 1,
        ),
      ],
    );
    return CartAddResult.added;
  }

  void removeItem(String productId) {
    state = Cart(
      items: state.items.where((item) => item.productId != productId).toList(),
    );
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    state = Cart(
      items: [
        for (final item in state.items)
          if (item.productId == productId)
            item.copyWith(quantity: quantity)
          else
            item,
      ],
    );
  }

  void clear() {
    state = Cart();
  }
}

final cartProvider = NotifierProvider<CartNotifier, Cart>(CartNotifier.new);

final cartItemCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider).itemCount,
);
