import 'app_routes.dart';

String buildPasswordRecoveryRedirectUrl({
  required Uri currentUri,
  String? configuredOrigin,
}) {
  final configuredUri = _parseConfiguredOrigin(configuredOrigin);

  // A configured origin may carry a deployment base path (for example, the
  // GitHub Pages project subpath `/flowdelivery-app`). Preserve it so the
  // recovery link resolves under the deployed base href. The current-origin
  // fallback intentionally ignores the in-app route path and resets to root.
  if (configuredUri != null) {
    final basePath = _stripTrailingSlash(configuredUri.path);

    return Uri(
      scheme: configuredUri.scheme,
      host: configuredUri.host,
      port: configuredUri.hasPort ? configuredUri.port : null,
      path: '$basePath${AppRoutes.resetPasswordPath}',
    ).toString();
  }

  return Uri(
    scheme: currentUri.scheme,
    host: currentUri.host,
    port: currentUri.hasPort ? currentUri.port : null,
    path: AppRoutes.resetPasswordPath,
  ).toString();
}

String _stripTrailingSlash(String path) {
  if (path.endsWith('/')) {
    return path.substring(0, path.length - 1);
  }

  return path;
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
