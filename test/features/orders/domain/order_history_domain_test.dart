import 'package:flowdelivery_app/features/orders/domain/entities/order_history_entry.dart';
import 'package:flowdelivery_app/features/orders/domain/repositories/order_history_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOrderHistoryRepository implements OrderHistoryRepository {
  _FakeOrderHistoryRepository(this.entries);

  final List<OrderHistoryEntry> entries;

  @override
  Future<List<OrderHistoryEntry>> loadOrderHistory() async => entries;
}

void main() {
  group('Order history domain', () {
    final createdAt = DateTime.parse('2026-07-08T14:30:00Z');

    final entry = OrderHistoryEntry(
      id: 'order-1',
      restaurantName: 'Burger Artisan Collective',
      restaurantImagePath: 'catalog/restaurants/burger_artisan_cover.webp',
      createdAt: createdAt,
      itemCount: 3,
      totalInCents: 4949,
      status: OrderHistoryStatus.placed,
    );

    test('exposes read-only order history metadata', () {
      expect(entry.id, 'order-1');
      expect(entry.restaurantName, 'Burger Artisan Collective');
      expect(
        entry.restaurantImagePath,
        'catalog/restaurants/burger_artisan_cover.webp',
      );
      expect(entry.createdAt, createdAt);
      expect(entry.itemCount, 3);
      expect(entry.totalInCents, 4949);
      expect(entry.status, OrderHistoryStatus.placed);
    });

    test('uses value equality across identical field sets', () {
      final sameEntry = OrderHistoryEntry(
        id: 'order-1',
        restaurantName: 'Burger Artisan Collective',
        restaurantImagePath: 'catalog/restaurants/burger_artisan_cover.webp',
        createdAt: createdAt,
        itemCount: 3,
        totalInCents: 4949,
        status: OrderHistoryStatus.placed,
      );

      expect(entry, equals(sameEntry));
      expect(entry.hashCode, equals(sameEntry.hashCode));
    });

    test('differs when any field changes', () {
      final updatedEntry = OrderHistoryEntry(
        id: 'order-1',
        restaurantName: 'Burger Artisan Collective',
        restaurantImagePath: 'catalog/restaurants/burger_artisan_cover.webp',
        createdAt: createdAt,
        itemCount: 4,
        totalInCents: 4949,
        status: OrderHistoryStatus.placed,
      );

      expect(entry, isNot(equals(updatedEntry)));
    });

    test('treats empty history as a successful repository result', () async {
      final repository = _FakeOrderHistoryRepository(const []);

      await expectLater(repository.loadOrderHistory(), completion(isEmpty));
    });
  });
}
