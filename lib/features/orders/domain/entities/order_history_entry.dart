enum OrderHistoryStatus { placed }

class OrderHistoryEntry {
  const OrderHistoryEntry({
    required this.id,
    required this.restaurantName,
    required this.restaurantImagePath,
    required this.createdAt,
    required this.itemCount,
    required this.totalInCents,
    required this.status,
  }) : assert(itemCount >= 0, 'Item count must not be negative.'),
       assert(totalInCents >= 0, 'Order total must not be negative.');

  final String id;
  final String restaurantName;
  final String restaurantImagePath;
  final DateTime createdAt;
  final int itemCount;
  final int totalInCents;
  final OrderHistoryStatus status;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OrderHistoryEntry &&
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

  @override
  String toString() {
    return 'OrderHistoryEntry('
        'id: $id, '
        'restaurantName: $restaurantName, '
        'restaurantImagePath: $restaurantImagePath, '
        'createdAt: $createdAt, '
        'itemCount: $itemCount, '
        'totalInCents: $totalInCents, '
        'status: $status'
        ')';
  }
}
