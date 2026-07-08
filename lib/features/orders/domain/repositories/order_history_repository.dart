import 'package:flowdelivery_app/features/orders/domain/entities/order_history_entry.dart';

abstract interface class OrderHistoryRepository {
  /// Returns the authenticated user's orders, newest first.
  ///
  /// An empty list is a successful state: it means the user has not placed
  /// any orders yet.
  Future<List<OrderHistoryEntry>> loadOrderHistory();
}
