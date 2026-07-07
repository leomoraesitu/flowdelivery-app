import 'package:flowdelivery_app/features/checkout/data/dtos/placed_order_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef OrderRemoteRpcCaller =
    Future<Object?> Function(String functionName, Map<String, Object?> params);

class OrderRemoteException implements Exception {
  const OrderRemoteException({required this.message});

  final String message;

  @override
  String toString() => 'OrderRemoteException(message: $message)';
}

abstract interface class OrderRemoteDatasource {
  /// Creates the order atomically through the `create_order` RPC and returns
  /// the created order row. Failures raise [OrderRemoteException]; callers
  /// must not retry the call automatically (double-order risk).
  Future<PlacedOrderDto> createOrder({
    required String restaurantId,
    required String deliveryAddress,
    required int deliveryFeeInCents,
    required String paymentMethod,
    required List<Map<String, Object?>> items,
  });
}

class SupabaseOrderRemoteDatasource implements OrderRemoteDatasource {
  const SupabaseOrderRemoteDatasource({
    required SupabaseClient client,
    OrderRemoteRpcCaller? rpcCaller,
  }) : _client = client,
       _rpcCaller = rpcCaller;

  static const _createOrderFunction = 'create_order';

  final SupabaseClient _client;
  final OrderRemoteRpcCaller? _rpcCaller;

  @override
  Future<PlacedOrderDto> createOrder({
    required String restaurantId,
    required String deliveryAddress,
    required int deliveryFeeInCents,
    required String paymentMethod,
    required List<Map<String, Object?>> items,
  }) async {
    try {
      final response = await _callRpc(_createOrderFunction, {
        'restaurant_id': restaurantId,
        'delivery_address': deliveryAddress,
        'delivery_fee_in_cents': deliveryFeeInCents,
        'order_payment_method': paymentMethod,
        'items': items,
      });

      return PlacedOrderDto.fromRow(_castSingleRow(response));
    } on PostgrestException catch (error) {
      throw OrderRemoteException(message: error.message);
    } on FormatException catch (error) {
      throw OrderRemoteException(message: error.message);
    }
  }

  Future<Object?> _callRpc(String functionName, Map<String, Object?> params) {
    final caller = _rpcCaller;
    if (caller != null) {
      return caller(functionName, params);
    }

    return _client.rpc<Object?>(functionName, params: params);
  }

  Map<String, Object?> _castSingleRow(Object? response) {
    final row = switch (response) {
      List(isNotEmpty: true) => response.first,
      Map() => response,
      _ => null,
    };

    if (row is! Map) {
      throw const OrderRemoteException(
        message: 'Supabase returned an invalid "create_order" payload.',
      );
    }

    return Map<String, Object?>.from(row);
  }
}
