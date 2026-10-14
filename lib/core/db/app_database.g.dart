// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedCustomersTable extends CachedCustomers
    with TableInfo<$CachedCustomersTable, CachedCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
    'street',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zipMeta = const VerificationMeta('zip');
  @override
  late final GeneratedColumn<String> zip = GeneratedColumn<String>(
    'zip',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDirtyMeta = const VerificationMeta(
    'isDirty',
  );
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
    'is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _writeDateMeta = const VerificationMeta(
    'writeDate',
  );
  @override
  late final GeneratedColumn<DateTime> writeDate = GeneratedColumn<DateTime>(
    'write_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    email,
    street,
    city,
    zip,
    country,
    isDirty,
    writeDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCustomer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('street')) {
      context.handle(
        _streetMeta,
        street.isAcceptableOrUnknown(data['street']!, _streetMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('zip')) {
      context.handle(
        _zipMeta,
        zip.isAcceptableOrUnknown(data['zip']!, _zipMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('is_dirty')) {
      context.handle(
        _isDirtyMeta,
        isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta),
      );
    }
    if (data.containsKey('write_date')) {
      context.handle(
        _writeDateMeta,
        writeDate.isAcceptableOrUnknown(data['write_date']!, _writeDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCustomer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      street: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}street'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      zip: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zip'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      isDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dirty'],
      )!,
      writeDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}write_date'],
      ),
    );
  }

  @override
  $CachedCustomersTable createAlias(String alias) {
    return $CachedCustomersTable(attachedDatabase, alias);
  }
}

class CachedCustomer extends DataClass implements Insertable<CachedCustomer> {
  final int id;
  final String? name;
  final String? phone;
  final String? email;
  final String? street;
  final String? city;
  final String? zip;
  final String? country;
  final bool isDirty;
  final DateTime? writeDate;
  const CachedCustomer({
    required this.id,
    this.name,
    this.phone,
    this.email,
    this.street,
    this.city,
    this.zip,
    this.country,
    required this.isDirty,
    this.writeDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || street != null) {
      map['street'] = Variable<String>(street);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || zip != null) {
      map['zip'] = Variable<String>(zip);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || writeDate != null) {
      map['write_date'] = Variable<DateTime>(writeDate);
    }
    return map;
  }

  CachedCustomersCompanion toCompanion(bool nullToAbsent) {
    return CachedCustomersCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      street: street == null && nullToAbsent
          ? const Value.absent()
          : Value(street),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      zip: zip == null && nullToAbsent ? const Value.absent() : Value(zip),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      isDirty: Value(isDirty),
      writeDate: writeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(writeDate),
    );
  }

  factory CachedCustomer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCustomer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      street: serializer.fromJson<String?>(json['street']),
      city: serializer.fromJson<String?>(json['city']),
      zip: serializer.fromJson<String?>(json['zip']),
      country: serializer.fromJson<String?>(json['country']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      writeDate: serializer.fromJson<DateTime?>(json['writeDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'street': serializer.toJson<String?>(street),
      'city': serializer.toJson<String?>(city),
      'zip': serializer.toJson<String?>(zip),
      'country': serializer.toJson<String?>(country),
      'isDirty': serializer.toJson<bool>(isDirty),
      'writeDate': serializer.toJson<DateTime?>(writeDate),
    };
  }

  CachedCustomer copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> street = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> zip = const Value.absent(),
    Value<String?> country = const Value.absent(),
    bool? isDirty,
    Value<DateTime?> writeDate = const Value.absent(),
  }) => CachedCustomer(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    street: street.present ? street.value : this.street,
    city: city.present ? city.value : this.city,
    zip: zip.present ? zip.value : this.zip,
    country: country.present ? country.value : this.country,
    isDirty: isDirty ?? this.isDirty,
    writeDate: writeDate.present ? writeDate.value : this.writeDate,
  );
  CachedCustomer copyWithCompanion(CachedCustomersCompanion data) {
    return CachedCustomer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      street: data.street.present ? data.street.value : this.street,
      city: data.city.present ? data.city.value : this.city,
      zip: data.zip.present ? data.zip.value : this.zip,
      country: data.country.present ? data.country.value : this.country,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      writeDate: data.writeDate.present ? data.writeDate.value : this.writeDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCustomer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('street: $street, ')
          ..write('city: $city, ')
          ..write('zip: $zip, ')
          ..write('country: $country, ')
          ..write('isDirty: $isDirty, ')
          ..write('writeDate: $writeDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    email,
    street,
    city,
    zip,
    country,
    isDirty,
    writeDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCustomer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.street == this.street &&
          other.city == this.city &&
          other.zip == this.zip &&
          other.country == this.country &&
          other.isDirty == this.isDirty &&
          other.writeDate == this.writeDate);
}

class CachedCustomersCompanion extends UpdateCompanion<CachedCustomer> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> street;
  final Value<String?> city;
  final Value<String?> zip;
  final Value<String?> country;
  final Value<bool> isDirty;
  final Value<DateTime?> writeDate;
  const CachedCustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.street = const Value.absent(),
    this.city = const Value.absent(),
    this.zip = const Value.absent(),
    this.country = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.writeDate = const Value.absent(),
  });
  CachedCustomersCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.street = const Value.absent(),
    this.city = const Value.absent(),
    this.zip = const Value.absent(),
    this.country = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.writeDate = const Value.absent(),
  });
  static Insertable<CachedCustomer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? street,
    Expression<String>? city,
    Expression<String>? zip,
    Expression<String>? country,
    Expression<bool>? isDirty,
    Expression<DateTime>? writeDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (zip != null) 'zip': zip,
      if (country != null) 'country': country,
      if (isDirty != null) 'is_dirty': isDirty,
      if (writeDate != null) 'write_date': writeDate,
    });
  }

  CachedCustomersCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? street,
    Value<String?>? city,
    Value<String?>? zip,
    Value<String?>? country,
    Value<bool>? isDirty,
    Value<DateTime?>? writeDate,
  }) {
    return CachedCustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      street: street ?? this.street,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      isDirty: isDirty ?? this.isDirty,
      writeDate: writeDate ?? this.writeDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (zip.present) {
      map['zip'] = Variable<String>(zip.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (writeDate.present) {
      map['write_date'] = Variable<DateTime>(writeDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('street: $street, ')
          ..write('city: $city, ')
          ..write('zip: $zip, ')
          ..write('country: $country, ')
          ..write('isDirty: $isDirty, ')
          ..write('writeDate: $writeDate')
          ..write(')'))
        .toString();
  }
}

class $PendingChangesTable extends PendingChanges
    with TableInfo<$PendingChangesTable, PendingChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _partnerIdMeta = const VerificationMeta(
    'partnerId',
  );
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
    'partner_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldNameMeta = const VerificationMeta(
    'fieldName',
  );
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
    'field_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newValueMeta = const VerificationMeta(
    'newValue',
  );
  @override
  late final GeneratedColumn<String> newValue = GeneratedColumn<String>(
    'new_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    partnerId,
    fieldName,
    newValue,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingChange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('partner_id')) {
      context.handle(
        _partnerIdMeta,
        partnerId.isAcceptableOrUnknown(data['partner_id']!, _partnerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partnerIdMeta);
    }
    if (data.containsKey('field_name')) {
      context.handle(
        _fieldNameMeta,
        fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('new_value')) {
      context.handle(
        _newValueMeta,
        newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta),
      );
    } else if (isInserting) {
      context.missing(_newValueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingChange(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}partner_id'],
      )!,
      fieldName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name'],
      )!,
      newValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_value'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingChangesTable createAlias(String alias) {
    return $PendingChangesTable(attachedDatabase, alias);
  }
}

class PendingChange extends DataClass implements Insertable<PendingChange> {
  final int id;
  final int partnerId;
  final String fieldName;
  final String newValue;
  final DateTime createdAt;
  const PendingChange({
    required this.id,
    required this.partnerId,
    required this.fieldName,
    required this.newValue,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['partner_id'] = Variable<int>(partnerId);
    map['field_name'] = Variable<String>(fieldName);
    map['new_value'] = Variable<String>(newValue);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingChangesCompanion toCompanion(bool nullToAbsent) {
    return PendingChangesCompanion(
      id: Value(id),
      partnerId: Value(partnerId),
      fieldName: Value(fieldName),
      newValue: Value(newValue),
      createdAt: Value(createdAt),
    );
  }

  factory PendingChange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingChange(
      id: serializer.fromJson<int>(json['id']),
      partnerId: serializer.fromJson<int>(json['partnerId']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      newValue: serializer.fromJson<String>(json['newValue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partnerId': serializer.toJson<int>(partnerId),
      'fieldName': serializer.toJson<String>(fieldName),
      'newValue': serializer.toJson<String>(newValue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingChange copyWith({
    int? id,
    int? partnerId,
    String? fieldName,
    String? newValue,
    DateTime? createdAt,
  }) => PendingChange(
    id: id ?? this.id,
    partnerId: partnerId ?? this.partnerId,
    fieldName: fieldName ?? this.fieldName,
    newValue: newValue ?? this.newValue,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingChange copyWithCompanion(PendingChangesCompanion data) {
    return PendingChange(
      id: data.id.present ? data.id.value : this.id,
      partnerId: data.partnerId.present ? data.partnerId.value : this.partnerId,
      fieldName: data.fieldName.present ? data.fieldName.value : this.fieldName,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingChange(')
          ..write('id: $id, ')
          ..write('partnerId: $partnerId, ')
          ..write('fieldName: $fieldName, ')
          ..write('newValue: $newValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, partnerId, fieldName, newValue, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingChange &&
          other.id == this.id &&
          other.partnerId == this.partnerId &&
          other.fieldName == this.fieldName &&
          other.newValue == this.newValue &&
          other.createdAt == this.createdAt);
}

class PendingChangesCompanion extends UpdateCompanion<PendingChange> {
  final Value<int> id;
  final Value<int> partnerId;
  final Value<String> fieldName;
  final Value<String> newValue;
  final Value<DateTime> createdAt;
  const PendingChangesCompanion({
    this.id = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.newValue = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingChangesCompanion.insert({
    this.id = const Value.absent(),
    required int partnerId,
    required String fieldName,
    required String newValue,
    this.createdAt = const Value.absent(),
  }) : partnerId = Value(partnerId),
       fieldName = Value(fieldName),
       newValue = Value(newValue);
  static Insertable<PendingChange> custom({
    Expression<int>? id,
    Expression<int>? partnerId,
    Expression<String>? fieldName,
    Expression<String>? newValue,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partnerId != null) 'partner_id': partnerId,
      if (fieldName != null) 'field_name': fieldName,
      if (newValue != null) 'new_value': newValue,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingChangesCompanion copyWith({
    Value<int>? id,
    Value<int>? partnerId,
    Value<String>? fieldName,
    Value<String>? newValue,
    Value<DateTime>? createdAt,
  }) {
    return PendingChangesCompanion(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      fieldName: fieldName ?? this.fieldName,
      newValue: newValue ?? this.newValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<String>(newValue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingChangesCompanion(')
          ..write('id: $id, ')
          ..write('partnerId: $partnerId, ')
          ..write('fieldName: $fieldName, ')
          ..write('newValue: $newValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedCustomersTable cachedCustomers = $CachedCustomersTable(
    this,
  );
  late final $PendingChangesTable pendingChanges = $PendingChangesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedCustomers,
    pendingChanges,
  ];
}

typedef $$CachedCustomersTableCreateCompanionBuilder =
    CachedCustomersCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> street,
      Value<String?> city,
      Value<String?> zip,
      Value<String?> country,
      Value<bool> isDirty,
      Value<DateTime?> writeDate,
    });
typedef $$CachedCustomersTableUpdateCompanionBuilder =
    CachedCustomersCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> street,
      Value<String?> city,
      Value<String?> zip,
      Value<String?> country,
      Value<bool> isDirty,
      Value<DateTime?> writeDate,
    });

class $$CachedCustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zip => $composableBuilder(
    column: $table.zip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get writeDate => $composableBuilder(
    column: $table.writeDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get street => $composableBuilder(
    column: $table.street,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zip => $composableBuilder(
    column: $table.zip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get writeDate => $composableBuilder(
    column: $table.writeDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCustomersTable> {
  $$CachedCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get street =>
      $composableBuilder(column: $table.street, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get zip =>
      $composableBuilder(column: $table.zip, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get writeDate =>
      $composableBuilder(column: $table.writeDate, builder: (column) => column);
}

class $$CachedCustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCustomersTable,
          CachedCustomer,
          $$CachedCustomersTableFilterComposer,
          $$CachedCustomersTableOrderingComposer,
          $$CachedCustomersTableAnnotationComposer,
          $$CachedCustomersTableCreateCompanionBuilder,
          $$CachedCustomersTableUpdateCompanionBuilder,
          (
            CachedCustomer,
            BaseReferences<
              _$AppDatabase,
              $CachedCustomersTable,
              CachedCustomer
            >,
          ),
          CachedCustomer,
          PrefetchHooks Function()
        > {
  $$CachedCustomersTableTableManager(
    _$AppDatabase db,
    $CachedCustomersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> zip = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<DateTime?> writeDate = const Value.absent(),
              }) => CachedCustomersCompanion(
                id: id,
                name: name,
                phone: phone,
                email: email,
                street: street,
                city: city,
                zip: zip,
                country: country,
                isDirty: isDirty,
                writeDate: writeDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> street = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> zip = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<DateTime?> writeDate = const Value.absent(),
              }) => CachedCustomersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                email: email,
                street: street,
                city: city,
                zip: zip,
                country: country,
                isDirty: isDirty,
                writeDate: writeDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCustomersTable,
      CachedCustomer,
      $$CachedCustomersTableFilterComposer,
      $$CachedCustomersTableOrderingComposer,
      $$CachedCustomersTableAnnotationComposer,
      $$CachedCustomersTableCreateCompanionBuilder,
      $$CachedCustomersTableUpdateCompanionBuilder,
      (
        CachedCustomer,
        BaseReferences<_$AppDatabase, $CachedCustomersTable, CachedCustomer>,
      ),
      CachedCustomer,
      PrefetchHooks Function()
    >;
typedef $$PendingChangesTableCreateCompanionBuilder =
    PendingChangesCompanion Function({
      Value<int> id,
      required int partnerId,
      required String fieldName,
      required String newValue,
      Value<DateTime> createdAt,
    });
typedef $$PendingChangesTableUpdateCompanionBuilder =
    PendingChangesCompanion Function({
      Value<int> id,
      Value<int> partnerId,
      Value<String> fieldName,
      Value<String> newValue,
      Value<DateTime> createdAt,
    });

class $$PendingChangesTableFilterComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get partnerId => $composableBuilder(
    column: $table.partnerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get partnerId => $composableBuilder(
    column: $table.partnerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get partnerId =>
      $composableBuilder(column: $table.partnerId, builder: (column) => column);

  GeneratedColumn<String> get fieldName =>
      $composableBuilder(column: $table.fieldName, builder: (column) => column);

  GeneratedColumn<String> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingChangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingChangesTable,
          PendingChange,
          $$PendingChangesTableFilterComposer,
          $$PendingChangesTableOrderingComposer,
          $$PendingChangesTableAnnotationComposer,
          $$PendingChangesTableCreateCompanionBuilder,
          $$PendingChangesTableUpdateCompanionBuilder,
          (
            PendingChange,
            BaseReferences<_$AppDatabase, $PendingChangesTable, PendingChange>,
          ),
          PendingChange,
          PrefetchHooks Function()
        > {
  $$PendingChangesTableTableManager(
    _$AppDatabase db,
    $PendingChangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partnerId = const Value.absent(),
                Value<String> fieldName = const Value.absent(),
                Value<String> newValue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingChangesCompanion(
                id: id,
                partnerId: partnerId,
                fieldName: fieldName,
                newValue: newValue,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partnerId,
                required String fieldName,
                required String newValue,
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingChangesCompanion.insert(
                id: id,
                partnerId: partnerId,
                fieldName: fieldName,
                newValue: newValue,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingChangesTable,
      PendingChange,
      $$PendingChangesTableFilterComposer,
      $$PendingChangesTableOrderingComposer,
      $$PendingChangesTableAnnotationComposer,
      $$PendingChangesTableCreateCompanionBuilder,
      $$PendingChangesTableUpdateCompanionBuilder,
      (
        PendingChange,
        BaseReferences<_$AppDatabase, $PendingChangesTable, PendingChange>,
      ),
      PendingChange,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedCustomersTableTableManager get cachedCustomers =>
      $$CachedCustomersTableTableManager(_db, _db.cachedCustomers);
  $$PendingChangesTableTableManager get pendingChanges =>
      $$PendingChangesTableTableManager(_db, _db.pendingChanges);
}
