class HomeCategoryDto {
  const HomeCategoryDto({
    required this.id,
    required this.sortOrder,
  });

  factory HomeCategoryDto.fromRow(Map<String, Object?> row) {
    return HomeCategoryDto(
      id: _readString(row, key: 'id'),
      sortOrder: _readInt(row, key: 'sort_order'),
    );
  }

  final String id;
  final int sortOrder;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeCategoryDto &&
            other.id == id &&
            other.sortOrder == sortOrder;
  }

  @override
  int get hashCode => Object.hash(id, sortOrder);

  @override
  String toString() {
    return 'HomeCategoryDto(id: $id, sortOrder: $sortOrder)';
  }

  static String _readString(Map<String, Object?> row, {required String key}) {
    final value = row[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }

    throw FormatException('Expected a non-empty string for "$key".');
  }

  static int _readInt(Map<String, Object?> row, {required String key}) {
    final value = row[key];
    if (value is int) {
      return value;
    }

    throw FormatException('Expected an int for "$key".');
  }
}
