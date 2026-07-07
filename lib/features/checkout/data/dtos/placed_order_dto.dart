class PlacedOrderDto {
  const PlacedOrderDto({
    required this.id,
    required this.totalInCents,
    required this.createdAt,
  });

  factory PlacedOrderDto.fromRow(Map<String, Object?> row) {
    return PlacedOrderDto(
      id: _readString(row, key: 'order_id'),
      totalInCents: _readInt(row, key: 'order_total_in_cents'),
      createdAt: DateTime.parse(_readString(row, key: 'order_created_at')),
    );
  }

  final String id;
  final int totalInCents;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PlacedOrderDto &&
            other.id == id &&
            other.totalInCents == totalInCents &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, totalInCents, createdAt);
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
