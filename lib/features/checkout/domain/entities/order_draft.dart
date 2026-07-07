import 'dart:collection';

import 'package:flowdelivery_app/features/checkout/domain/entities/payment_summary.dart';

class OrderDraftItem {
  const OrderDraftItem({
    required this.productId,
    required this.productName,
    required this.unitPriceInCents,
    required this.quantity,
  }) : assert(quantity >= 1, 'Order draft item quantity must be at least 1.');

  final String productId;
  final String productName;
  final int unitPriceInCents;
  final int quantity;

  int get subtotalInCents => unitPriceInCents * quantity;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OrderDraftItem &&
            other.productId == productId &&
            other.productName == productName &&
            other.unitPriceInCents == unitPriceInCents &&
            other.quantity == quantity;
  }

  @override
  int get hashCode =>
      Object.hash(productId, productName, unitPriceInCents, quantity);

  @override
  String toString() {
    return 'OrderDraftItem('
        'productId: $productId, '
        'productName: $productName, '
        'unitPriceInCents: $unitPriceInCents, '
        'quantity: $quantity'
        ')';
  }
}

class OrderDraft {
  OrderDraft({
    required this.restaurantId,
    required List<OrderDraftItem> items,
    required this.deliveryFeeInCents,
    required this.deliveryAddress,
    this.paymentMethod = PaymentMethod.cashOnDelivery,
  }) : assert(items.isNotEmpty, 'Order draft requires at least one item.'),
       assert(
         deliveryFeeInCents >= 0,
         'Order draft delivery fee must not be negative.',
       ),
       items = UnmodifiableListView<OrderDraftItem>(
         List<OrderDraftItem>.of(items),
       );

  /// Fixed delivery fee for the current checkout slice; dynamic fees are a
  /// separately approved future slice.
  static const int standardDeliveryFeeInCents = 599;

  final String restaurantId;
  final UnmodifiableListView<OrderDraftItem> items;
  final int deliveryFeeInCents;
  final String deliveryAddress;
  final PaymentMethod paymentMethod;

  int get subtotalInCents =>
      items.fold<int>(0, (total, item) => total + item.subtotalInCents);

  int get totalInCents => subtotalInCents + deliveryFeeInCents;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! OrderDraft ||
        other.restaurantId != restaurantId ||
        other.deliveryFeeInCents != deliveryFeeInCents ||
        other.deliveryAddress != deliveryAddress ||
        other.paymentMethod != paymentMethod ||
        other.items.length != items.length) {
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
  int get hashCode => Object.hash(
    restaurantId,
    deliveryFeeInCents,
    deliveryAddress,
    paymentMethod,
    Object.hashAll(items),
  );

  @override
  String toString() {
    return 'OrderDraft('
        'restaurantId: $restaurantId, '
        'items: $items, '
        'deliveryFeeInCents: $deliveryFeeInCents, '
        'deliveryAddress: $deliveryAddress, '
        'paymentMethod: $paymentMethod'
        ')';
  }
}
