import 'app_routes.dart';

String buildPasswordRecoveryRedirectUrl({
  required Uri currentUri,
  String? configuredOrigin,
}) {
  final configuredUri = _parseConfiguredOrigin(configuredOrigin);
  final effectiveOrigin = configuredUri ?? currentUri;

  return Uri(
    scheme: effectiveOrigin.scheme,
    host: effectiveOrigin.host,
    port: effectiveOrigin.hasPort ? effectiveOrigin.port : null,
    path: AppRoutes.resetPasswordPath,
  ).toString();
}

Uri? _parseConfiguredOrigin(String? configuredOrigin) {
  if (configuredOrigin == null) {
    return null;
  }

  final trimmed = configuredOrigin.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final parsed = Uri.tryParse(trimmed);
  if (parsed == null || !parsed.hasScheme || parsed.host.isEmpty) {
    return null;
  }

  return parsed;
}
