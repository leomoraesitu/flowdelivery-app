enum PaymentMethod { cashOnDelivery }

enum PaymentStatus { pendingOnDelivery }

class PaymentSummary {
  const PaymentSummary({
    required this.id,
    required this.method,
    required this.status,
    required this.amountInCents,
  }) : assert(amountInCents >= 0, 'Payment amount must not be negative.');

  const PaymentSummary.pendingOnDelivery({
    required int amountInCents,
    String id = '',
  }) : this(
         id: id,
         method: PaymentMethod.cashOnDelivery,
         status: PaymentStatus.pendingOnDelivery,
         amountInCents: amountInCents,
       );

  final String id;
  final PaymentMethod method;
  final PaymentStatus status;
  final int amountInCents;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaymentSummary &&
            other.id == id &&
            other.method == method &&
            other.status == status &&
            other.amountInCents == amountInCents;
  }

  @override
  int get hashCode => Object.hash(id, method, status, amountInCents);

  @override
  String toString() {
    return 'PaymentSummary('
        'id: $id, '
        'method: $method, '
        'status: $status, '
        'amountInCents: $amountInCents'
        ')';
  }
}
