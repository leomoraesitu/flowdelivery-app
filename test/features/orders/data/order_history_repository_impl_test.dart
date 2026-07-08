import 'package:flowdelivery_app/features/orders/data/datasources/order_history_remote_datasource.dart';
import 'package:flowdelivery_app/features/orders/data/dtos/order_history_entry_dto.dart';
import 'package:flowdelivery_app/features/orders/data/repositories/order_history_repository_impl.dart';
import 'package:flowdelivery_app/features/orders/domain/entities/order_history_entry.dart';
import 'package:flowdelivery_app/features/orders/domain/failures/order_history_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderHistoryRepositoryImpl', () {
    test('maps remote DTOs into order history entries', () async {
      final datasource = _FakeOrderHistoryRemoteDatasource([
        _dto(status: 'placed'),
      ]);
      final repository = OrderHistoryRepositoryImpl(datasource: datasource);

      final entries = await repository.loadOrderHistory();

      expect(entries, [
        OrderHistoryEntry(
          id: 'order-1',
          restaurantName: 'Burger Artisan Collective',
          restaurantImagePath:
              'https://example.supabase.co/storage/v1/object/public/'
              'catalog-media/restaurants/burger_artisan_collective/cover.webp',
          createdAt: DateTime.parse('2026-07-08T14:30:00Z'),
          itemCount: 3,
          totalInCents: 4949,
          status: OrderHistoryStatus.placed,
        ),
      ]);
    });

    test('preserves an empty order history as a successful result', () async {
      final datasource = _FakeOrderHistoryRemoteDatasource(const []);
      final repository = OrderHistoryRepositoryImpl(datasource: datasource);

      final entries = await repository.loadOrderHistory();

      expect(entries, isEmpty);
    });

    test('maps remote datasource failures to a neutral domain failure', () {
      final datasource = _FakeOrderHistoryRemoteDatasource(
        const [],
        error: const OrderHistoryRemoteException(message: 'permission denied'),
      );
      final repository = OrderHistoryRepositoryImpl(datasource: datasource);

      expect(
        repository.loadOrderHistory(),
        throwsA(
          isA<OrderHistoryFailure>()
              .having(
                (failure) => failure.code,
                'code',
                OrderHistoryFailureCode.genericFailure,
              )
              .having(
                (failure) => failure.fallbackMessage,
                'fallbackMessage',
                contains('permission denied'),
              ),
        ),
      );
    });

    test('maps unknown remote status values to a neutral domain failure', () {
      final datasource = _FakeOrderHistoryRemoteDatasource([
        _dto(status: 'cancelled'),
      ]);
      final repository = OrderHistoryRepositoryImpl(datasource: datasource);

      expect(
        repository.loadOrderHistory(),
        throwsA(
          isA<OrderHistoryFailure>()
              .having(
                (failure) => failure.code,
                'code',
                OrderHistoryFailureCode.genericFailure,
              )
              .having(
                (failure) => failure.fallbackMessage,
                'fallbackMessage',
                contains('order status'),
              ),
        ),
      );
    });

    test('propagates unexpected errors unchanged', () {
      final datasource = _FakeOrderHistoryRemoteDatasource(
        const [],
        error: StateError('boom'),
      );
      final repository = OrderHistoryRepositoryImpl(datasource: datasource);

      expect(repository.loadOrderHistory(), throwsA(isA<StateError>()));
    });
  });
}

OrderHistoryEntryDto _dto({required String status}) {
  return OrderHistoryEntryDto(
    id: 'order-1',
    restaurantName: 'Burger Artisan Collective',
    restaurantImagePath:
        'https://example.supabase.co/storage/v1/object/public/'
        'catalog-media/restaurants/burger_artisan_collective/cover.webp',
    createdAt: DateTime.parse('2026-07-08T14:30:00Z'),
    itemCount: 3,
    totalInCents: 4949,
    status: status,
  );
}

class _FakeOrderHistoryRemoteDatasource
    implements OrderHistoryRemoteDatasource {
  const _FakeOrderHistoryRemoteDatasource(this.entries, {this.error});

  final List<OrderHistoryEntryDto> entries;
  final Object? error;

  @override
  Future<List<OrderHistoryEntryDto>> loadOrderHistory() {
    final error = this.error;
    if (error != null) {
      return Future<List<OrderHistoryEntryDto>>.error(error);
    }

    return Future<List<OrderHistoryEntryDto>>.value(entries);
  }
}
