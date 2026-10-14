import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/odoo/odoo_client.dart';
import '../../../core/odoo/odoo_exception.dart';
import '../../../core/storage/secure_storage.dart';
import '../domain/customer.dart';

class CustomerRepository {
  final OdooClient _odooClient;
  final SecureStorageService _secureStorage;
  final ConnectivityService _connectivityService;
  final AppDatabase _db;
  StreamSubscription<bool>? _connectivitySubscription;

  CustomerRepository({
    OdooClient? odooClient,
    SecureStorageService? secureStorage,
    ConnectivityService? connectivityService,
    required this._db,
  })  : _odooClient = odooClient ?? OdooClient(),
        _secureStorage = secureStorage ?? SecureStorageService(),
        _connectivityService = connectivityService ?? ConnectivityService() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivitySubscription = _connectivityService.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        unawaited(processOutbox().catchError((Object error, StackTrace stackTrace) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
              library: 'customer sync',
              context: ErrorDescription('while syncing queued customer changes'),
            ),
          );
        }));
      }
    });
  }

  Future<List<Customer>> getCustomers({
    String? searchQuery,
    int offset = 0,
    int limit = 40,
  }) async {
    final isOnline = await _connectivityService.isConnected();
    final creds = await _secureStorage.getCredentials();

    if (!isOnline || creds['baseUrl'] == null || creds['uid'] == null) {
      return _getCachedCustomers(searchQuery: searchQuery, offset: offset, limit: limit);
    }

    try {
      final List domain = [
        ['customer_rank', '>', 0]
      ];
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        domain.add(['name', 'ilike', searchQuery.trim()]);
      }

      final res = await _odooClient.executeKw(
        baseUrl: creds['baseUrl'],
        db: creds['db'],
        uid: creds['uid'],
        password: creds['password'],
        model: 'res.partner',
        method: 'search_read',
        args: [domain],
        kwargs: {
          'fields': ['name', 'phone', 'email', 'street', 'city', 'zip', 'country_id'],
          'offset': offset,
          'limit': limit,
          'order': 'name asc',
        },
      );

      if (res is! List) {
        throw OdooException('Odoo returned an invalid customer list.');
      }
      final customers = res
          .map((e) => Customer.fromOdooJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      final visibleCustomers = <Customer>[];
      for (final customer in customers) {
        visibleCustomers.add(await _cacheCustomer(customer));
      }
      return visibleCustomers;
    } on OdooException catch (error) {
      if (!error.isNetworkError) rethrow;
      final cached = await _getCachedCustomers(
        searchQuery: searchQuery,
        offset: offset,
        limit: limit,
      );
      if (cached.isEmpty) rethrow;
      return cached;
    }
  }

  Future<List<Customer>> _getCachedCustomers({
    String? searchQuery,
    required int offset,
    required int limit,
  }) async {
    var query = _db.select(_db.cachedCustomers);
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query = query..where((tbl) => tbl.name.like('%${searchQuery.trim()}%'));
    }
    query = query..limit(limit, offset: offset);
    final rows = await query.get();
    return rows.map(_customerFromRow).toList();
  }

  Customer _customerFromRow(CachedCustomer row) {
    return Customer(
      id: row.id,
      name: row.name ?? 'Unnamed',
      phone: row.phone,
      email: row.email,
      street: row.street,
      city: row.city,
      zip: row.zip,
      country: row.country,
      isDirty: row.isDirty,
      writeDate: row.writeDate,
    );
  }

  Future<Customer> _cacheCustomer(Customer customer) async {
    final cached = await (_db.select(_db.cachedCustomers)
          ..where((table) => table.id.equals(customer.id)))
        .getSingleOrNull();
    final hasPendingPhone = cached?.isDirty ?? false;
    await _db.into(_db.cachedCustomers).insertOnConflictUpdate(
          CachedCustomersCompanion.insert(
            id: Value(customer.id),
            name: Value(customer.name),
            phone: Value(hasPendingPhone ? cached?.phone : customer.phone),
            email: Value(customer.email),
            street: Value(customer.street),
            city: Value(customer.city),
            zip: Value(customer.zip),
            country: Value(customer.country),
            isDirty: Value(hasPendingPhone),
          ),
        );
    return customer.copyWith(
      phone: hasPendingPhone ? cached?.phone : customer.phone,
      isDirty: hasPendingPhone,
    );
  }

  Future<Customer?> getCustomerById(int id) async {
    final isOnline = await _connectivityService.isConnected();
    final creds = await _secureStorage.getCredentials();

    if (!isOnline || creds['baseUrl'] == null || creds['uid'] == null) {
      return await _getCachedCustomer(id);
    }

    try {
      final res = await _odooClient.executeKw(
        baseUrl: creds['baseUrl'],
        db: creds['db'],
        uid: creds['uid'],
        password: creds['password'],
        model: 'res.partner',
        method: 'read',
        args: [
          [id]
        ],
        kwargs: {
          'fields': ['name', 'phone', 'email', 'street', 'city', 'zip', 'country_id'],
        },
      );
      if (res is! List || res.isEmpty) return null;
      final customer = Customer.fromOdooJson(Map<String, dynamic>.from(res.first as Map));
      return await _cacheCustomer(customer);
    } on OdooException catch (error) {
      if (!error.isNetworkError) rethrow;
      final cached = await _getCachedCustomer(id);
      if (cached == null) rethrow;
      return cached;
    }
  }

  Future<Customer?> _getCachedCustomer(int id) async {
    final row = await (_db.select(_db.cachedCustomers)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _customerFromRow(row);
  }

  Future<bool> updateCustomerPhone(int id, String newPhone) async {
    final isOnline = await _connectivityService.isConnected();
    final creds = await _secureStorage.getCredentials();

    if (isOnline && creds['baseUrl'] != null && creds['uid'] != null) {
      try {
        final res = await _odooClient.executeKw(
          baseUrl: creds['baseUrl'],
          db: creds['db'],
          uid: creds['uid'],
          password: creds['password'],
          model: 'res.partner',
          method: 'write',
          args: [
            [id],
            {'phone': newPhone}
          ],
        );
        if (res != true) {
          throw OdooException('Odoo did not confirm the phone number update.');
        }
        await _db.transaction(() async {
          await (_db.update(_db.cachedCustomers)..where((table) => table.id.equals(id))).write(
            CachedCustomersCompanion(phone: Value(newPhone), isDirty: const Value(false)),
          );
          await (_db.delete(_db.pendingChanges)..where((table) => table.partnerId.equals(id))).go();
        });
        return true;
      } on OdooException catch (error) {
        if (!error.isNetworkError) rethrow;
      }
    }

    await _db.transaction(() async {
      await (_db.update(_db.cachedCustomers)..where((table) => table.id.equals(id))).write(
        CachedCustomersCompanion(phone: Value(newPhone), isDirty: const Value(true)),
      );
      await _db.into(_db.pendingChanges).insert(
            PendingChangesCompanion.insert(
              partnerId: id,
              fieldName: 'phone',
              newValue: newPhone,
            ),
          );
    });
    return false;
  }

  Future<void> processOutbox() async {
    final isOnline = await _connectivityService.isConnected();
    if (!isOnline) return;

    final creds = await _secureStorage.getCredentials();
    if (creds['baseUrl'] == null || creds['uid'] == null) return;

    final pendingList = await _db.select(_db.pendingChanges).get();
    for (final item in pendingList) {
      try {
        await _odooClient.executeKw(
          baseUrl: creds['baseUrl'],
          db: creds['db'],
          uid: creds['uid'],
          password: creds['password'],
          model: 'res.partner',
          method: 'write',
          args: [
            [item.partnerId],
            {item.fieldName: item.newValue}
          ],
        );

        // Success: remove from pendingChanges and clear isDirty in cachedCustomers
        await (_db.delete(_db.pendingChanges)..where((tbl) => tbl.id.equals(item.id))).go();

        final remaining = await (_db.select(_db.pendingChanges)
              ..where((tbl) => tbl.partnerId.equals(item.partnerId)))
            .get();

        if (remaining.isEmpty) {
          await (_db.update(_db.cachedCustomers)
                ..where((tbl) => tbl.id.equals(item.partnerId)))
              .write(const CachedCustomersCompanion(isDirty: Value(false)));
        }
      } on OdooException catch (error) {
        if (error.isNetworkError) break;
        rethrow;
      }
    }
  }

  Future<int> pendingChangeCount() async {
    final count = _db.pendingChanges.id.count();
    final query = _db.selectOnly(_db.pendingChanges)..addColumns([count]);
    return await query.map((row) => row.read(count)!).getSingle();
  }

  Future<void> clearLocalCustomers() async {
    await _db.transaction(() async {
      await _db.delete(_db.pendingChanges).go();
      await _db.delete(_db.cachedCustomers).go();
    });
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final repository = CustomerRepository(db: db, connectivityService: connectivity);
  ref.onDispose(repository.dispose);
  return repository;
});
