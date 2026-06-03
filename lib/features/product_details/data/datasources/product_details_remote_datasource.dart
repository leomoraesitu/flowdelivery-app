import 'package:flowdelivery_app/features/product_details/data/dtos/product_details_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef ProductDetailsRemoteSingleRowLoader =
    Future<Map<String, Object?>?> Function(String productId);

class ProductDetailsRemoteException implements Exception {
  const ProductDetailsRemoteException({required this.message});

  final String message;

  @override
  String toString() => 'ProductDetailsRemoteException(message: $message)';
}

abstract interface class ProductDetailsRemoteDatasource {
  /// Returns the product row for [productId], or `null` when no product
  /// exists. A `null` result is the expected not-found case and is not an
  /// error; genuine remote/parsing failures raise
  /// [ProductDetailsRemoteException].
  Future<ProductDetailsDto?> getProductDetails(String productId);
}

class SupabaseProductDetailsRemoteDatasource
    implements ProductDetailsRemoteDatasource {
  const SupabaseProductDetailsRemoteDatasource({
    required SupabaseClient client,
    ProductDetailsRemoteSingleRowLoader? productRowLoader,
  }) : _client = client,
       _productRowLoader = productRowLoader;

  static const _menuItemsTable = 'restaurant_menu_items';

  final SupabaseClient _client;
  final ProductDetailsRemoteSingleRowLoader? _productRowLoader;

  @override
  Future<ProductDetailsDto?> getProductDetails(String productId) async {
    try {
      final row = await _loadProductRow(productId);
      if (row == null) {
        return null;
      }

      return ProductDetailsDto.fromRow(row);
    } on PostgrestException catch (error) {
      throw ProductDetailsRemoteException(message: error.message);
    } on FormatException catch (error) {
      throw ProductDetailsRemoteException(message: error.message);
    }
  }

  Future<Map<String, Object?>?> _loadProductRow(String productId) {
    final loader = _productRowLoader;
    if (loader != null) {
      return loader(productId);
    }

    return _selectMaybeSingleRow(
      table: _menuItemsTable,
      columns:
          'id, restaurant_id, category_id, name, description, image_asset_path, price_in_cents',
      filters: {'id': productId},
    );
  }

  Future<Map<String, Object?>?> _selectMaybeSingleRow({
    required String table,
    required String columns,
    Map<String, Object?> filters = const {},
  }) async {
    dynamic query = _client.from(table).select(columns);

    for (final entry in filters.entries) {
      query = query.eq(entry.key, entry.value);
    }

    return _castMaybeSingleRow(await query.maybeSingle(), table: table);
  }

  Map<String, Object?>? _castMaybeSingleRow(
    Object? response, {
    required String table,
  }) {
    if (response == null) {
      return null;
    }

    if (response is! Map) {
      throw ProductDetailsRemoteException(
        message: 'Supabase returned an invalid row for "$table".',
      );
    }

    return Map<String, Object?>.from(response);
  }
}
