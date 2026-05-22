enum AuthFailureCode {
  invalidCredentials,
  emailNotConfirmed,
  userAlreadyRegistered,
  passwordTooShort,
  networkFailure,
  unconfiguredEnvironment,
  genericFailure,
}

class AuthFailure implements Exception {
  const AuthFailure({required this.code, this.fallbackMessage});

  final AuthFailureCode code;
  final String? fallbackMessage;

  @override
  String toString() => fallbackMessage ?? code.name;
}
