import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/order_draft.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/placed_order.dart';
import 'package:flowdelivery_app/features/checkout/domain/failures/order_placement_failure.dart';
import 'package:flowdelivery_app/features/checkout/domain/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  throw StateError('Order repository was not configured.');
});

sealed class CheckoutState {
  const CheckoutState();
}

class CheckoutIdle extends CheckoutState {
  const CheckoutIdle();

  @override
  bool operator ==(Object other) => other is CheckoutIdle;

  @override
  int get hashCode => (CheckoutIdle).hashCode;
}

class CheckoutSubmitting extends CheckoutState {
  const CheckoutSubmitting();

  @override
  bool operator ==(Object other) => other is CheckoutSubmitting;

  @override
  int get hashCode => (CheckoutSubmitting).hashCode;
}

class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess({required this.order});

  final PlacedOrder order;

  @override
  bool operator ==(Object other) =>
      other is CheckoutSuccess && other.order == order;

  @override
  int get hashCode => Object.hash(CheckoutSuccess, order);
}

class CheckoutFailure extends CheckoutState {
  const CheckoutFailure({required this.code});

  final OrderPlacementFailureCode code;

  @override
  bool operator ==(Object other) =>
      other is CheckoutFailure && other.code == code;

  @override
  int get hashCode => Object.hash(CheckoutFailure, code);
}

class CheckoutViewModel extends Notifier<CheckoutState> {
  @override
  CheckoutState build() => const CheckoutIdle();

  /// Builds an [OrderDraft] from the current cart and places it through the
  /// [orderRepositoryProvider] repository.
  ///
  /// Re-entrant calls while submitting are no-ops (double-order guard), and
  /// an empty cart is a no-op. On success the cart is cleared exactly once.
  /// [deliveryAddress] is provided by the page because the demo address is
  /// localized presentation copy.
  Future<void> placeOrder({required String deliveryAddress}) async {
    if (state is CheckoutSubmitting) {
      return;
    }

    final cart = ref.read(cartProvider);
    final restaurantId = cart.restaurantId;
    if (restaurantId == null) {
      return;
    }

    state = const CheckoutSubmitting();

    final draft = OrderDraft(
      restaurantId: restaurantId,
      items: [
        for (final item in cart.items)
          OrderDraftItem(
            productId: item.productId,
            productName: item.name,
            unitPriceInCents: item.priceInCents,
            quantity: item.quantity,
          ),
      ],
      deliveryFeeInCents: OrderDraft.standardDeliveryFeeInCents,
      deliveryAddress: deliveryAddress,
    );

    try {
      final order = await ref.read(orderRepositoryProvider).placeOrder(draft);
      ref.read(cartProvider.notifier).clear();
      state = CheckoutSuccess(order: order);
    } on OrderPlacementFailure catch (failure) {
      state = CheckoutFailure(code: failure.code);
    } catch (_) {
      state = const CheckoutFailure(
        code: OrderPlacementFailureCode.genericFailure,
      );
    }
  }

  /// Returns to the idle state, e.g. when the checkout page is reopened.
  void reset() {
    state = const CheckoutIdle();
  }
}
