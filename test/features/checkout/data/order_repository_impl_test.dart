import 'package:flowdelivery_app/features/checkout/data/datasources/order_remote_datasource.dart';
import 'package:flowdelivery_app/features/checkout/data/dtos/placed_order_dto.dart';
import 'package:flowdelivery_app/features/checkout/data/repositories/order_repository_impl.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/order_draft.dart';
import 'package:flowdelivery_app/features/checkout/domain/failures/order_placement_failure.dart';
import 'package:flutter_test/flutter_test.dart';

final _draft = OrderDraft(
  restaurantId: 'burger_artisan_collective',
  items: const [
    OrderDraftItem(
      productId: 'signature_truffle',
      productName: 'The Signature Truffle',
      unitPriceInCents: 1850,
      quantity: 2,
    ),
    OrderDraftItem(
      productId: 'sweet_potato_crisps',
      productName: 'Sweet Potato Crisps',
      unitPriceInCents: 650,
      quantity: 1,
    ),
  ],
  deliveryFeeInCents: 599,
  deliveryAddress: 'Rua Demo, 123',
);

class _FakeOrderRemoteDatasource implements OrderRemoteDatasource {
  _FakeOrderRemoteDatasource({this.error});

  final Object? error;
  Map<String, Object?>? receivedPayload;

  @override
  Future<PlacedOrderDto> createOrder({
    required String restaurantId,
    required String deliveryAddress,
    required int deliveryFeeInCents,
    required List<Map<String, Object?>> items,
  }) {
    receivedPayload = {
      'restaurant_id': restaurantId,
      'delivery_address': deliveryAddress,
      'delivery_fee_in_cents': deliveryFeeInCents,
      'items': items,
    };

    final error = this.error;
    if (error != null) {
      return Future<PlacedOrderDto>.error(error);
    }

    return Future<PlacedOrderDto>.value(
      PlacedOrderDto(
        id: 'order-1',
        totalInCents: 4949,
        createdAt: DateTime.parse('2026-07-07T12:00:00Z'),
      ),
    );
  }
}

void main() {
  group('OrderRepositoryImpl', () {
    test('maps the draft to the RPC payload and the DTO to PlacedOrder', () async {
      final datasource = _FakeOrderRemoteDatasource();
      final repository = OrderRepositoryImpl(datasource: datasource);

      final order = await repository.placeOrder(_draft);

      expect(order.id, 'order-1');
      expect(order.totalInCents, 4949);
      expect(order.createdAt, DateTime.parse('2026-07-07T12:00:00Z'));

      final payload = datasource.receivedPayload!;
      expect(payload['restaurant_id'], _draft.restaurantId);
      expect(payload['delivery_address'], _draft.deliveryAddress);
      expect(payload['delivery_fee_in_cents'], _draft.deliveryFeeInCents);
      expect(payload['items'], const [
        {
          'product_id': 'signature_truffle',
          'product_name': 'The Signature Truffle',
          'unit_price_in_cents': 1850,
          'quantity': 2,
        },
        {
          'product_id': 'sweet_potato_crisps',
          'product_name': 'Sweet Potato Crisps',
          'unit_price_in_cents': 650,
          'quantity': 1,
        },
      ]);
    });

    test(
      'maps OrderRemoteException to OrderPlacementFailure with a neutral code',
      () async {
        final repository = OrderRepositoryImpl(
          datasource: _FakeOrderRemoteDatasource(
            error: const OrderRemoteException(message: 'permission denied'),
          ),
        );

        await expectLater(
          () => repository.placeOrder(_draft),
          throwsA(
            isA<OrderPlacementFailure>()
                .having(
                  (failure) => failure.code,
                  'code',
                  OrderPlacementFailureCode.genericFailure,
                )
                .having(
                  (failure) => failure.fallbackMessage,
                  'fallbackMessage',
                  contains('permission denied'),
                ),
          ),
        );
      },
    );

    test('propagates unexpected errors unchanged', () async {
      final repository = OrderRepositoryImpl(
        datasource: _FakeOrderRemoteDatasource(error: StateError('boom')),
      );

      await expectLater(
        () => repository.placeOrder(_draft),
        throwsA(isA<StateError>()),
      );
    });
  });
}
