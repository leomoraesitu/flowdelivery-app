enum OrderHistoryFailureCode { genericFailure }

class OrderHistoryFailure implements Exception {
  const OrderHistoryFailure({required this.code, this.fallbackMessage});

  final OrderHistoryFailureCode code;
  final String? fallbackMessage;

  @override
  String toString() => fallbackMessage ?? code.name;
}
