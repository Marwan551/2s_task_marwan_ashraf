import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/odoo/odoo_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../domain/sales_order.dart';

class SalesOrderRepository {
  final OdooClient _odooClient;
  final SecureStorageService _secureStorage;
  final ConnectivityService _connectivityService;

  SalesOrderRepository({
    OdooClient? odooClient,
    SecureStorageService? secureStorage,
    ConnectivityService? connectivityService,
  })  : _odooClient = odooClient ?? OdooClient(),
        _secureStorage = secureStorage ?? SecureStorageService(),
        _connectivityService = connectivityService ?? ConnectivityService();

  Future<List<SalesOrder>> getSalesOrders({int offset = 0, int limit = 40}) async {
    final isOnline = await _connectivityService.isConnected();
    if (!isOnline) {
      throw Exception('Network connection required to view Sales Orders');
    }

    final creds = await _secureStorage.getCredentials();
    if (creds['baseUrl'] == null || creds['uid'] == null) {
      throw Exception('Session expired');
    }

    final res = await _odooClient.executeKw(
      baseUrl: creds['baseUrl'],
      db: creds['db'],
      uid: creds['uid'],
      password: creds['password'],
      model: 'sale.order',
      method: 'search_read',
      args: [[]],
      kwargs: {
        'fields': [
          'name',
          'partner_id',
          'date_order',
          'state',
          'amount_untaxed',
          'amount_tax',
          'amount_total',
          'currency_id',
        ],
        'offset': offset,
        'limit': limit,
        'order': 'date_order desc',
      },
    );

    if (res is List) {
      return res
          .map((e) => SalesOrder.fromOdooJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }

  Future<SalesOrder> getSalesOrderDetail(int orderId) async {
    final isOnline = await _connectivityService.isConnected();
    if (!isOnline) {
      throw Exception('Network connection required to view Sales Order details');
    }

    final creds = await _secureStorage.getCredentials();
    final res = await _odooClient.executeKw(
      baseUrl: creds['baseUrl'],
      db: creds['db'],
      uid: creds['uid'],
      password: creds['password'],
      model: 'sale.order',
      method: 'read',
      args: [
        [orderId]
      ],
      kwargs: {
        'fields': [
          'name',
          'partner_id',
          'date_order',
          'state',
          'amount_untaxed',
          'amount_tax',
          'amount_total',
          'currency_id',
          'order_line',
        ],
      },
    );

    if (res is List && res.isNotEmpty) {
      final order = SalesOrder.fromOdooJson(Map<String, dynamic>.from(res.first as Map));

      if (order.lineIds.isNotEmpty) {
        final linesRes = await _odooClient.executeKw(
          baseUrl: creds['baseUrl'],
          db: creds['db'],
          uid: creds['uid'],
          password: creds['password'],
          model: 'sale.order.line',
          method: 'read',
          args: [order.lineIds],
          kwargs: {
            'fields': ['product_id', 'name', 'product_uom_qty', 'price_unit', 'price_subtotal'],
          },
        );

        if (linesRes is List) {
          final lines = linesRes
              .map((l) => SalesOrderLine.fromOdooJson(Map<String, dynamic>.from(l as Map)))
              .toList();
          return order.copyWith(lines: lines);
        }
      }
      return order;
    }
    throw Exception('Order not found');
  }

  Future<void> confirmSalesOrder(int orderId) async {
    final isOnline = await _connectivityService.isConnected();
    if (!isOnline) {
      throw Exception('Network connection required to confirm order.');
    }

    final creds = await _secureStorage.getCredentials();
    await _odooClient.executeKw(
      baseUrl: creds['baseUrl'],
      db: creds['db'],
      uid: creds['uid'],
      password: creds['password'],
      model: 'sale.order',
      method: 'action_confirm',
      args: [
        [orderId]
      ],
    );
  }
}

final salesOrderRepositoryProvider = Provider<SalesOrderRepository>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return SalesOrderRepository(connectivityService: connectivity);
});
