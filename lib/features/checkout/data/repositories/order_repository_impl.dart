import 'package:flowdelivery_app/features/checkout/data/datasources/order_remote_datasource.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/order_draft.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/payment_summary.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/placed_order.dart';
import 'package:flowdelivery_app/features/checkout/domain/failures/order_placement_failure.dart';
import 'package:flowdelivery_app/features/checkout/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl({required OrderRemoteDatasource datasource})
    : _datasource = datasource;

  final OrderRemoteDatasource _datasource;

  @override
  Future<PlacedOrder> placeOrder(OrderDraft draft) async {
    try {
      final dto = await _datasource.createOrder(
        restaurantId: draft.restaurantId,
        deliveryAddress: draft.deliveryAddress,
        deliveryFeeInCents: draft.deliveryFeeInCents,
        paymentMethod: _toRemotePaymentMethod(draft.paymentMethod),
        items: [
          for (final item in draft.items)
            {
              'product_id': item.productId,
              'product_name': item.productName,
              'unit_price_in_cents': item.unitPriceInCents,
              'quantity': item.quantity,
            },
        ],
      );

      return PlacedOrder(
        id: dto.id,
        totalInCents: dto.totalInCents,
        createdAt: dto.createdAt,
        payment: PaymentSummary(
          id: dto.paymentId,
          method: _toDomainPaymentMethod(dto.paymentMethod),
          status: _toDomainPaymentStatus(dto.paymentStatus),
          amountInCents: dto.paymentAmountInCents,
        ),
      );
    } on OrderRemoteException catch (error) {
      throw OrderPlacementFailure(
        code: OrderPlacementFailureCode.genericFailure,
        fallbackMessage: error.message,
      );
    }
  }

  String _toRemotePaymentMethod(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cashOnDelivery => 'cash_on_delivery',
    };
  }

  PaymentMethod _toDomainPaymentMethod(String value) {
    return switch (value) {
      'cash_on_delivery' => PaymentMethod.cashOnDelivery,
      _ => throw OrderPlacementFailure(
        code: OrderPlacementFailureCode.genericFailure,
        fallbackMessage: 'Unsupported payment_method "$value".',
      ),
    };
  }

  PaymentStatus _toDomainPaymentStatus(String value) {
    return switch (value) {
      'pending_on_delivery' => PaymentStatus.pendingOnDelivery,
      _ => throw OrderPlacementFailure(
        code: OrderPlacementFailureCode.genericFailure,
        fallbackMessage: 'Unsupported payment_status "$value".',
      ),
    };
  }
}
