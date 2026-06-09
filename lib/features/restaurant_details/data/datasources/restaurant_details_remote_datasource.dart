import 'package:flowdelivery_app/features/restaurant_details/data/dtos/restaurant_details_dtos.dart';
import 'package:flowdelivery_app/shared/data/media/public_media_url_resolver.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef RestaurantDetailsRemoteRowsLoader =
    Future<List<Map<String, Object?>>> Function(String restaurantId);
typedef RestaurantDetailsRemoteSingleRowLoader =
    Future<Map<String, Object?>?> Function(String restaurantId);

class RestaurantDetailsRemoteException implements Exception {
  const RestaurantDetailsRemoteException({required this.message});

  final String message;

  @override
  String toString() => 'RestaurantDetailsRemoteException(message: $message)';
}

abstract interface class RestaurantDetailsRemoteDatasource {
  Future<RestaurantDetailsRemotePayload> getRestaurantDetails(
    String restaurantId,
  );
}

class SupabaseRestaurantDetailsRemoteDatasource
    implements RestaurantDetailsRemoteDatasource {
  const SupabaseRestaurantDetailsRemoteDatasource({
    required SupabaseClient client,
    required PublicMediaUrlResolver mediaUrlResolver,
    RestaurantDetailsRemoteSingleRowLoader? restaurantRowLoader,
    RestaurantDetailsRemoteRowsLoader? categoryRowsLoader,
    RestaurantDetailsRemoteRowsLoader? itemRowsLoader,
  }) : _client = client,
       _mediaUrlResolver = mediaUrlResolver,
       _restaurantRowLoader = restaurantRowLoader,
       _categoryRowsLoader = categoryRowsLoader,
       _itemRowsLoader = itemRowsLoader;

  static const _restaurantsTable = 'restaurants';
  static const _menuCategoriesTable = 'restaurant_menu_categories';
  static const _menuItemsTable = 'restaurant_menu_items';

  final SupabaseClient _client;
  final PublicMediaUrlResolver _mediaUrlResolver;
  final RestaurantDetailsRemoteSingleRowLoader? _restaurantRowLoader;
  final RestaurantDetailsRemoteRowsLoader? _categoryRowsLoader;
  final RestaurantDetailsRemoteRowsLoader? _itemRowsLoader;

  @override
  Future<RestaurantDetailsRemotePayload> getRestaurantDetails(
    String restaurantId,
  ) async {
    try {
      final restaurantRow = await _loadRestaurantRow(restaurantId);
      if (restaurantRow == null) {
        throw RestaurantDetailsRemoteException(
          message:
              'No restaurant row was returned by Supabase for "$restaurantId".',
        );
      }

      return RestaurantDetailsRemotePayload(
        restaurant: RestaurantDetailsDto.fromRow(
          _resolveMediaPath(restaurantRow),
        ),
        categories: (await _loadCategoryRows(
          restaurantId,
        )).map(RestaurantMenuCategoryDto.fromRow).toList(growable: false),
        items: (await _loadItemRows(restaurantId))
            .map(_resolveMediaPath)
            .map(RestaurantMenuItemDto.fromRow)
            .toList(growable: false),
      );
    } on PostgrestException catch (error) {
      throw RestaurantDetailsRemoteException(message: error.message);
    } on FormatException catch (error) {
      throw RestaurantDetailsRemoteException(message: error.message);
    } on PublicMediaResolutionFailure catch (error) {
      throw RestaurantDetailsRemoteException(
        message: 'Public media resolution failed: ${error.code.name}.',
      );
    }
  }

  Future<Map<String, Object?>?> _loadRestaurantRow(String restaurantId) {
    final loader = _restaurantRowLoader;
    if (loader != null) {
      return loader(restaurantId);
    }

    return _selectMaybeSingleRow(
      table: _restaurantsTable,
      columns:
          'id, name, image_asset_path, rating, delivery_time_min_minutes, delivery_time_max_minutes, cuisine',
      filters: {'id': restaurantId},
    );
  }

  Future<List<Map<String, Object?>>> _loadCategoryRows(String restaurantId) {
    final loader = _categoryRowsLoader;
    if (loader != null) {
      return loader(restaurantId);
    }

    return _selectRows(
      table: _menuCategoriesTable,
      columns: 'restaurant_id, id, sort_order',
      filters: {'restaurant_id': restaurantId},
      orderBy: const ['sort_order', 'id'],
    );
  }

  Future<List<Map<String, Object?>>> _loadItemRows(String restaurantId) {
    final loader = _itemRowsLoader;
    if (loader != null) {
      return loader(restaurantId);
    }

    return _selectRows(
      table: _menuItemsTable,
      columns:
          'id, restaurant_id, category_id, name, description, image_asset_path, price_in_cents, sort_order',
      filters: {'restaurant_id': restaurantId},
      orderBy: const ['category_id', 'sort_order', 'id'],
    );
  }

  Future<List<Map<String, Object?>>> _selectRows({
    required String table,
    required String columns,
    Map<String, Object?> filters = const {},
    List<String> orderBy = const [],
  }) async {
    dynamic query = _client.from(table).select(columns);

    for (final entry in filters.entries) {
      query = query.eq(entry.key, entry.value);
    }

    for (final column in orderBy) {
      query = query.order(column);
    }

    return _castRows(await query, table: table);
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

  List<Map<String, Object?>> _castRows(
    Object? response, {
    required String table,
  }) {
    if (response is! List) {
      throw RestaurantDetailsRemoteException(
        message: 'Supabase returned an invalid row collection for "$table".',
      );
    }

    return response
        .map((row) => _castRow(row, table: table))
        .toList(growable: false);
  }

  Map<String, Object?>? _castMaybeSingleRow(
    Object? response, {
    required String table,
  }) {
    if (response == null) {
      return null;
    }

    return _castRow(response, table: table);
  }

  Map<String, Object?> _castRow(Object? row, {required String table}) {
    if (row is! Map) {
      throw RestaurantDetailsRemoteException(
        message: 'Supabase returned an invalid row for "$table".',
      );
    }

    return Map<String, Object?>.from(row);
  }

  Map<String, Object?> _resolveMediaPath(Map<String, Object?> row) {
    final storedPath = row['image_asset_path'];
    if (storedPath is! String) {
      return row;
    }

    return {...row, 'image_asset_path': _mediaUrlResolver.resolve(storedPath)};
  }
}
