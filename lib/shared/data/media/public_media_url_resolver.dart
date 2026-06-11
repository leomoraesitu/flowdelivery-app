import 'package:supabase_flutter/supabase_flutter.dart';

enum PublicMediaResolutionFailureCode { blankPath, unsupportedPath }

class PublicMediaResolutionFailure implements Exception {
  const PublicMediaResolutionFailure({required this.code});

  final PublicMediaResolutionFailureCode code;
}

abstract interface class PublicMediaUrlResolver {
  String resolve(String storedPath);
}

class SupabasePublicMediaUrlResolver implements PublicMediaUrlResolver {
  const SupabasePublicMediaUrlResolver({required SupabaseClient client})
    : _client = client;

  static const _bucket = 'catalog-media';
  static const _localAssetPrefix = 'assets/';
  static const _restaurantPrefix = 'restaurants/';
  static const _productPrefix = 'products/';

  final SupabaseClient _client;

  @override
  String resolve(String storedPath) {
    if (storedPath.trim().isEmpty) {
      throw const PublicMediaResolutionFailure(
        code: PublicMediaResolutionFailureCode.blankPath,
      );
    }

    if (storedPath.startsWith(_localAssetPrefix)) {
      return storedPath;
    }

    if (storedPath.startsWith(_restaurantPrefix) ||
        storedPath.startsWith(_productPrefix)) {
      return _client.storage.from(_bucket).getPublicUrl(storedPath);
    }

    throw const PublicMediaResolutionFailure(
      code: PublicMediaResolutionFailureCode.unsupportedPath,
    );
  }
}
