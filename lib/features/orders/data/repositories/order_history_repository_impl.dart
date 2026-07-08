import 'package:flowdelivery_app/features/orders/data/datasources/order_history_remote_datasource.dart';
import 'package:flowdelivery_app/features/orders/data/dtos/order_history_entry_dto.dart';
import 'package:flowdelivery_app/features/orders/domain/entities/order_history_entry.dart';
import 'package:flowdelivery_app/features/orders/domain/failures/order_history_failure.dart';
import 'package:flowdelivery_app/features/orders/domain/repositories/order_history_repository.dart';

class OrderHistoryRepositoryImpl implements OrderHistoryRepository {
  const OrderHistoryRepositoryImpl({
    required OrderHistoryRemoteDatasource datasource,
  }) : _datasource = datasource;

  final OrderHistoryRemoteDatasource _datasource;

  @override
  Future<List<OrderHistoryEntry>> loadOrderHistory() async {
    try {
      final dtos = await _datasource.loadOrderHistory();

      return dtos.map(_toDomain).toList(growable: false);
    } on OrderHistoryRemoteException catch (error) {
      throw OrderHistoryFailure(
        code: OrderHistoryFailureCode.genericFailure,
        fallbackMessage: error.message,
      );
    }
  }

  OrderHistoryEntry _toDomain(OrderHistoryEntryDto dto) {
    return OrderHistoryEntry(
      id: dto.id,
      restaurantName: dto.restaurantName,
      restaurantImagePath: dto.restaurantImagePath,
      createdAt: dto.createdAt,
      itemCount: dto.itemCount,
      totalInCents: dto.totalInCents,
      status: _toDomainStatus(dto.status),
    );
  }

  OrderHistoryStatus _toDomainStatus(String value) {
    return switch (value) {
      'placed' => OrderHistoryStatus.placed,
      _ => throw OrderHistoryFailure(
        code: OrderHistoryFailureCode.genericFailure,
        fallbackMessage: 'Unsupported order status "$value".',
      ),
    };
  }
}
