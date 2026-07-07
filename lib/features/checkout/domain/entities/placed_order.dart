class PlacedOrder {
  const PlacedOrder({
    required this.id,
    required this.totalInCents,
    required this.createdAt,
  });

  final String id;
  final int totalInCents;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PlacedOrder &&
            other.id == id &&
            other.totalInCents == totalInCents &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, totalInCents, createdAt);

  @override
  String toString() {
    return 'PlacedOrder('
        'id: $id, '
        'totalInCents: $totalInCents, '
        'createdAt: $createdAt'
        ')';
  }
}
