class HomeCategory {
  const HomeCategory({
    required this.id,
  });

  final String id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'HomeCategory(id: $id)';
}
