import 'package:flowdelivery_app/app/bootstrap/supabase_providers.dart';
import 'package:flowdelivery_app/app/di/app_providers.dart';
import 'package:flowdelivery_app/features/orders/data/repositories/order_history_repository_impl.dart';
import 'package:flowdelivery_app/features/orders/domain/entities/order_history_entry.dart';
import 'package:flowdelivery_app/features/orders/domain/repositories/order_history_repository.dart';
import 'package:flowdelivery_app/features/orders/presentation/providers/order_history_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('orderHistoryProvider', () {
    test('loads the order history through the repository', () async {
      final repository = _FakeOrderHistoryRepository([_entry]);
      final container = ProviderContainer(
        overrides: [
          orderHistoryRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(orderHistoryProvider.future),
        completion([_entry]),
      );
      expect(repository.loadCount, 1);
    });

    test('preserves empty history as a successful provider result', () async {
      final repository = _FakeOrderHistoryRepository(const []);
      final container = ProviderContainer(
        overrides: [
          orderHistoryRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(orderHistoryProvider.future),
        completion(isEmpty),
      );
    });

    test('propagates repository failures', () async {
      final repository = _FakeOrderHistoryRepository(
        const [],
        error: StateError('boom'),
      );
      final container = ProviderContainer(
        overrides: [
          orderHistoryRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(orderHistoryProvider.future),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('app provider overrides', () {
    test('wire the presentation repository to the app composition root', () {
      final container = ProviderContainer(
        overrides: [
          supabaseConfiguredProvider.overrideWithValue(true),
          supabaseInitializedProvider.overrideWithValue(true),
          supabaseClientProvider.overrideWithValue(_testClient),
          ...appProviderOverrides,
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(orderHistoryRepositoryProvider),
        isA<OrderHistoryRepositoryImpl>(),
      );
    });
  });
}

class _FakeOrderHistoryRepository implements OrderHistoryRepository {
  _FakeOrderHistoryRepository(this.entries, {this.error});

  final List<OrderHistoryEntry> entries;
  final Object? error;
  var loadCount = 0;

  @override
  Future<List<OrderHistoryEntry>> loadOrderHistory() {
    loadCount += 1;

    final error = this.error;
    if (error != null) {
      return Future<List<OrderHistoryEntry>>.error(error);
    }

    return Future<List<OrderHistoryEntry>>.value(entries);
  }
}

final _entry = OrderHistoryEntry(
  id: 'order-1',
  restaurantName: 'Burger Artisan Collective',
  restaurantImagePath: 'assets/images/restaurant.png',
  createdAt: DateTime.parse('2026-07-08T14:30:00Z'),
  itemCount: 3,
  totalInCents: 4949,
  status: OrderHistoryStatus.placed,
);

final _testClient = SupabaseClient(
  'https://example.supabase.co',
  'test-anon-key',
);
