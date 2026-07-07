import 'package:flowdelivery_app/features/checkout/data/datasources/order_remote_datasource.dart';
import 'package:flowdelivery_app/features/checkout/data/dtos/placed_order_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _validRow = {
  'order_id': 'order-1',
  'order_total_in_cents': 4299,
  'order_created_at': '2026-07-07T12:00:00Z',
};

SupabaseOrderRemoteDatasource _buildDatasource(
  OrderRemoteRpcCaller rpcCaller,
) {
  return SupabaseOrderRemoteDatasource(
    client: SupabaseClient('https://unit-test.supabase.co', 'anon-key'),
    rpcCaller: rpcCaller,
  );
}

Future<PlacedOrderDto> _createOrder(
  SupabaseOrderRemoteDatasource datasource,
) {
  return datasource.createOrder(
    restaurantId: 'burger_artisan_collective',
    deliveryAddress: 'Rua Demo, 123',
    deliveryFeeInCents: 599,
    items: const [
      {
        'product_id': 'signature_truffle',
        'product_name': 'The Signature Truffle',
        'unit_price_in_cents': 1850,
        'quantity': 2,
      },
    ],
  );
}

void main() {
  group('SupabaseOrderRemoteDatasource', () {
    test('calls create_order with the expected function name and payload', () async {
      String? calledFunction;
      Map<String, Object?>? calledParams;
      final datasource = _buildDatasource((functionName, params) async {
        calledFunction = functionName;
        calledParams = params;
        return [_validRow];
      });

      await _createOrder(datasource);

      expect(calledFunction, 'create_order');
      expect(calledParams?['restaurant_id'], 'burger_artisan_collective');
      expect(calledParams?['delivery_address'], 'Rua Demo, 123');
      expect(calledParams?['delivery_fee_in_cents'], 599);
      expect(calledParams?['items'], isA<List<Map<String, Object?>>>());
    });

    test('parses a list payload into the placed-order DTO', () async {
      final datasource = _buildDatasource((_, _) async => [_validRow]);

      final dto = await _createOrder(datasource);

      expect(dto.id, 'order-1');
      expect(dto.totalInCents, 4299);
      expect(dto.createdAt, DateTime.parse('2026-07-07T12:00:00Z'));
    });

    test('parses a single-map payload into the placed-order DTO', () async {
      final datasource = _buildDatasource((_, _) async => _validRow);

      final dto = await _createOrder(datasource);

      expect(dto.id, 'order-1');
    });

    test('maps PostgrestException to OrderRemoteException', () async {
      final datasource = _buildDatasource((_, _) async {
        throw const PostgrestException(message: 'permission denied');
      });

      await expectLater(
        () => _createOrder(datasource),
        throwsA(
          isA<OrderRemoteException>().having(
            (error) => error.message,
            'message',
            contains('permission denied'),
          ),
        ),
      );
    });

    test('maps a malformed row to OrderRemoteException', () async {
      final datasource = _buildDatasource(
        (_, _) async => [
          {'order_id': 'order-1'},
        ],
      );

      await expectLater(
        () => _createOrder(datasource),
        throwsA(isA<OrderRemoteException>()),
      );
    });

    test('maps an empty payload to OrderRemoteException', () async {
      final datasource = _buildDatasource((_, _) async => <Object?>[]);

      await expectLater(
        () => _createOrder(datasource),
        throwsA(isA<OrderRemoteException>()),
      );
    });
  });
}
