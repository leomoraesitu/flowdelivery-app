class PlacedOrderDto {
  const PlacedOrderDto({
    required this.id,
    required this.totalInCents,
    required this.createdAt,
    required this.paymentId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentAmountInCents,
  });

  factory PlacedOrderDto.fromRow(Map<String, Object?> row) {
    return PlacedOrderDto(
      id: _readString(row, key: 'order_id'),
      totalInCents: _readInt(row, key: 'order_total_in_cents'),
      createdAt: DateTime.parse(_readString(row, key: 'order_created_at')),
      paymentId: _readString(row, key: 'payment_id'),
      paymentMethod: _readString(row, key: 'payment_method'),
      paymentStatus: _readString(row, key: 'payment_status'),
      paymentAmountInCents: _readInt(row, key: 'payment_amount_in_cents'),
    );
  }

  final String id;
  final int totalInCents;
  final DateTime createdAt;
  final String paymentId;
  final String paymentMethod;
  final String paymentStatus;
  final int paymentAmountInCents;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PlacedOrderDto &&
            other.id == id &&
            other.totalInCents == totalInCents &&
            other.createdAt == createdAt &&
            other.paymentId == paymentId &&
            other.paymentMethod == paymentMethod &&
            other.paymentStatus == paymentStatus &&
            other.paymentAmountInCents == paymentAmountInCents;
  }

  @override
  int get hashCode => Object.hash(
    id,
    totalInCents,
    createdAt,
    paymentId,
    paymentMethod,
    paymentStatus,
    paymentAmountInCents,
  );
}

String _readString(Map<String, Object?> row, {required String key}) {
  final value = row[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }

  throw FormatException('Expected a non-empty string for "$key".');
}

int _readInt(Map<String, Object?> row, {required String key}) {
  final value = row[key];
  if (value is int) {
    return value;
  }

  throw FormatException('Expected an int for "$key".');
}
