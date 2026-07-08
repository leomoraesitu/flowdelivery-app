import 'package:flowdelivery_app/features/orders/data/dtos/order_history_entry_dto.dart';
import 'package:flowdelivery_app/shared/data/media/public_media_url_resolver.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef OrderHistoryRemoteRowsLoader =
    Future<List<Map<String, Object?>>> Function();

class OrderHistoryRemoteException implements Exception {
  const OrderHistoryRemoteException({required this.message});

  final String message;

  @override
  String toString() => 'OrderHistoryRemoteException(message: $message)';
}

abstract interface class OrderHistoryRemoteDatasource {
  /// Returns the authenticated user's order history. RLS owns user scoping;
  /// callers must not add client-side user filters.
  Future<List<OrderHistoryEntryDto>> loadOrderHistory();
}

class SupabaseOrderHistoryRemoteDatasource
    implements OrderHistoryRemoteDatasource {
  const SupabaseOrderHistoryRemoteDatasource({
    required SupabaseClient client,
    required PublicMediaUrlResolver mediaUrlResolver,
    OrderHistoryRemoteRowsLoader? orderRowsLoader,
  }) : _client = client,
       _mediaUrlResolver = mediaUrlResolver,
       _orderRowsLoader = orderRowsLoader;

  static const _ordersTable = 'orders';
  static const _selectColumns =
      'id, total_in_cents, status, created_at, '
      'restaurants(name, image_asset_path), '
      'order_items(quantity)';

  final SupabaseClient _client;
  final PublicMediaUrlResolver _mediaUrlResolver;
  final OrderHistoryRemoteRowsLoader? _orderRowsLoader;

  @override
  Future<List<OrderHistoryEntryDto>> loadOrderHistory() async {
    try {
      final rows = await _loadOrderRows();

      return rows
          .map(_toDtoRow)
          .map(OrderHistoryEntryDto.fromRow)
          .toList(growable: false);
    } on PostgrestException catch (error) {
      throw OrderHistoryRemoteException(message: error.message);
    } on FormatException catch (error) {
      throw OrderHistoryRemoteException(message: error.message);
    } on PublicMediaResolutionFailure catch (error) {
      throw OrderHistoryRemoteException(
        message: 'Public media resolution failed: ${error.code.name}.',
      );
    }
  }

  Future<List<Map<String, Object?>>> _loadOrderRows() {
    final loader = _orderRowsLoader;
    if (loader != null) {
      return loader();
    }

    return _selectRows();
  }

  Future<List<Map<String, Object?>>> _selectRows() async {
    final query = _client
        .from(_ordersTable)
        .select(_selectColumns)
        .order('created_at', ascending: false);

    return _castRows(await query, table: _ordersTable);
  }

  List<Map<String, Object?>> _castRows(
    Object? response, {
    required String table,
  }) {
    if (response is! List) {
      throw OrderHistoryRemoteException(
        message: 'Supabase returned an invalid row collection for "$table".',
      );
    }

    return response
        .map((row) => _castRow(row, table: table))
        .toList(growable: false);
  }

  Map<String, Object?> _castRow(Object? row, {required String table}) {
    if (row is! Map) {
      throw OrderHistoryRemoteException(
        message: 'Supabase returned an invalid row for "$table".',
      );
    }

    return Map<String, Object?>.from(row);
  }

  Map<String, Object?> _toDtoRow(Map<String, Object?> row) {
    final restaurant = _readEmbed(row, key: 'restaurants');
    final storedImagePath = _readString(restaurant, key: 'image_asset_path');

    return {
      'id': row['id'],
      'restaurant_name': _readString(restaurant, key: 'name'),
      'restaurant_image_path': _mediaUrlResolver.resolve(storedImagePath),
      'created_at': row['created_at'],
      'item_count': _sumItemCount(row['order_items']),
      'total_in_cents': row['total_in_cents'],
      'status': row['status'],
    };
  }
}

Map<String, Object?> _readEmbed(
  Map<String, Object?> row, {
  required String key,
}) {
  final value = row[key];
  if (value is Map) {
    return Map<String, Object?>.from(value);
  }

  throw FormatException('Expected an object embed for "$key".');
}

String _readString(Map<String, Object?> row, {required String key}) {
  final value = row[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }

  throw FormatException('Expected a non-empty string for "$key".');
}

int _sumItemCount(Object? value) {
  if (value is! List) {
    throw const FormatException('Expected a list embed for "order_items".');
  }

  var total = 0;
  for (final item in value) {
    if (item is! Map) {
      throw const FormatException('Expected an object in "order_items".');
    }

    final quantity = item['quantity'];
    if (quantity is! int) {
      throw const FormatException(
        'Expected an int for "order_items.quantity".',
      );
    }

    total += quantity;
  }

  return total;
}
