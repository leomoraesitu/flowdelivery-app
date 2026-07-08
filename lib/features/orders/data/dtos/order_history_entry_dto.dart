class OrderHistoryEntryDto {
  const OrderHistoryEntryDto({
    required this.id,
    required this.restaurantName,
    required this.restaurantImagePath,
    required this.createdAt,
    required this.itemCount,
    required this.totalInCents,
    required this.status,
  });

  factory OrderHistoryEntryDto.fromRow(Map<String, Object?> row) {
    return OrderHistoryEntryDto(
      id: _readString(row, key: 'id'),
      restaurantName: _readString(row, key: 'restaurant_name'),
      restaurantImagePath: _readString(row, key: 'restaurant_image_path'),
      createdAt: DateTime.parse(_readString(row, key: 'created_at')),
      itemCount: _readInt(row, key: 'item_count'),
      totalInCents: _readInt(row, key: 'total_in_cents'),
      status: _readString(row, key: 'status'),
    );
  }

  final String id;
  final String restaurantName;
  final String restaurantImagePath;
  final DateTime createdAt;
  final int itemCount;
  final int totalInCents;
  final String status;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OrderHistoryEntryDto &&
            other.id == id &&
            other.restaurantName == restaurantName &&
            other.restaurantImagePath == restaurantImagePath &&
            other.createdAt == createdAt &&
            other.itemCount == itemCount &&
            other.totalInCents == totalInCents &&
            other.status == status;
  }

  @override
  int get hashCode => Object.hash(
    id,
    restaurantName,
    restaurantImagePath,
    createdAt,
    itemCount,
    totalInCents,
    status,
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
