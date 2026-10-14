import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class CachedCustomers extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get street => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get zip => text().nullable()();
  TextColumn get country => text().nullable()();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
  DateTimeColumn get writeDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PendingChanges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partnerId => integer()();
  TextColumn get fieldName => text()();
  TextColumn get newValue => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

@DriftDatabase(tables: [CachedCustomers, PendingChanges])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'odoo_sales_db');
  }
}
