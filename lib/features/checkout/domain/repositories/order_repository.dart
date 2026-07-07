import 'package:flowdelivery_app/features/checkout/domain/entities/order_draft.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/placed_order.dart';

abstract interface class OrderRepository {
  /// Persists [draft] atomically and returns the created [PlacedOrder].
  ///
  /// Throws an
  /// [OrderPlacementFailure](../failures/order_placement_failure.dart) with a
  /// neutral code when placement fails; presentation maps codes to localized
  /// copy. Callers must not retry automatically (double-order risk).
  Future<PlacedOrder> placeOrder(OrderDraft draft);
}
