import 'package:flowdelivery_app/features/orders/domain/entities/order_history_entry.dart';
import 'package:flowdelivery_app/features/orders/domain/repositories/order_history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderHistoryRepositoryProvider = Provider<OrderHistoryRepository>((ref) {
  throw StateError('Order history repository was not configured.');
});

final orderHistoryProvider = FutureProvider<List<OrderHistoryEntry>>((ref) {
  return ref.watch(orderHistoryRepositoryProvider).loadOrderHistory();
});
