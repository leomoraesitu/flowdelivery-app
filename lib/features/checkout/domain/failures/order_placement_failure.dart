enum OrderPlacementFailureCode {
  networkFailure,
  unconfiguredEnvironment,
  genericFailure,
}

class OrderPlacementFailure implements Exception {
  const OrderPlacementFailure({required this.code, this.fallbackMessage});

  final OrderPlacementFailureCode code;
  final String? fallbackMessage;

  @override
  String toString() => fallbackMessage ?? code.name;
}
