import 'package:flowdelivery_app/features/checkout/domain/entities/payment_summary.dart';

class PlacedOrder {
  PlacedOrder({
    required this.id,
    required this.totalInCents,
    required this.createdAt,
    PaymentSummary? payment,
  }) : payment =
           payment ??
           PaymentSummary.pendingOnDelivery(amountInCents: totalInCents);

  final String id;
  final int totalInCents;
  final DateTime createdAt;
  final PaymentSummary payment;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PlacedOrder &&
            other.id == id &&
            other.totalInCents == totalInCents &&
            other.createdAt == createdAt &&
            other.payment == payment;
  }

  @override
  int get hashCode => Object.hash(id, totalInCents, createdAt, payment);

  @override
  String toString() {
    return 'PlacedOrder('
        'id: $id, '
        'totalInCents: $totalInCents, '
        'createdAt: $createdAt, '
        'payment: $payment'
        ')';
  }
}
