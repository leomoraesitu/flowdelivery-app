import 'package:flowdelivery_app/features/orders/data/datasources/order_history_remote_datasource.dart';
import 'package:flowdelivery_app/features/orders/data/dtos/order_history_entry_dto.dart';
import 'package:flowdelivery_app/shared/data/media/public_media_url_resolver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseOrderHistoryRemoteDatasource', () {
    test('parses embedded order rows into typed DTOs', () async {
      final datasource = _buildDatasource(
        orderRowsLoader: () async => [_validOrderRow],
      );

      final entries = await datasource.loadOrderHistory();

      expect(entries, [
        OrderHistoryEntryDto(
          id: 'order-1',
          restaurantName: 'Burger Artisan Collective',
          restaurantImagePath:
              'https://example.supabase.co/storage/v1/object/public/'
              'catalog-media/restaurants/burger_artisan_collective/cover.webp',
          createdAt: DateTime.parse('2026-07-08T14:30:00Z'),
          itemCount: 3,
          totalInCents: 4949,
          status: 'placed',
        ),
      ]);
    });

    test('returns an empty list when no orders exist', () async {
      final datasource = _buildDatasource(orderRowsLoader: () async => []);

      final entries = await datasource.loadOrderHistory();

      expect(entries, isEmpty);
    });

    test('throws a remote exception when the restaurant embed is missing', () {
      final datasource = _buildDatasource(
        orderRowsLoader: () async => [
          {..._validOrderRow, 'restaurants': null},
        ],
      );

      expect(
        datasource.loadOrderHistory(),
        throwsA(
          isA<OrderHistoryRemoteException>().having(
            (error) => error.message,
            'message',
            'Expected an object embed for "restaurants".',
          ),
        ),
      );
    });

    test(
      'throws a remote exception when order item quantities are malformed',
      () {
        final datasource = _buildDatasource(
          orderRowsLoader: () async => [
            {
              ..._validOrderRow,
              'order_items': [
                {'quantity': 'many'},
              ],
            },
          ],
        );

        expect(
          datasource.loadOrderHistory(),
          throwsA(
            isA<OrderHistoryRemoteException>().having(
              (error) => error.message,
              'message',
              'Expected an int for "order_items.quantity".',
            ),
          ),
        );
      },
    );

    test('maps PostgrestException to OrderHistoryRemoteException', () {
      final datasource = _buildDatasource(
        orderRowsLoader: () async {
          throw const PostgrestException(message: 'permission denied');
        },
      );

      expect(
        datasource.loadOrderHistory(),
        throwsA(
          isA<OrderHistoryRemoteException>().having(
            (error) => error.message,
            'message',
            contains('permission denied'),
          ),
        ),
      );
    });

    test('maps media resolution failures to OrderHistoryRemoteException', () {
      final datasource = _buildDatasource(
        orderRowsLoader: () async => [
          {
            ..._validOrderRow,
            'restaurants': {
              'name': 'Burger Artisan Collective',
              'image_asset_path': 'unsupported/cover.webp',
            },
          },
        ],
      );

      expect(
        datasource.loadOrderHistory(),
        throwsA(
          isA<OrderHistoryRemoteException>().having(
            (error) => error.message,
            'message',
            contains('Public media resolution failed'),
          ),
        ),
      );
    });
  });
}

SupabaseOrderHistoryRemoteDatasource _buildDatasource({
  required OrderHistoryRemoteRowsLoader orderRowsLoader,
}) {
  return SupabaseOrderHistoryRemoteDatasource(
    client: _testClient,
    mediaUrlResolver: _mediaUrlResolver,
    orderRowsLoader: orderRowsLoader,
  );
}

final _testClient = SupabaseClient(
  'https://example.supabase.co',
  'test-anon-key',
);

final _mediaUrlResolver = SupabasePublicMediaUrlResolver(client: _testClient);

const _validOrderRow = {
  'id': 'order-1',
  'total_in_cents': 4949,
  'status': 'placed',
  'created_at': '2026-07-08T14:30:00Z',
  'restaurants': {
    'name': 'Burger Artisan Collective',
    'image_asset_path': 'restaurants/burger_artisan_collective/cover.webp',
  },
  'order_items': [
    {'quantity': 2},
    {'quantity': 1},
  ],
};
