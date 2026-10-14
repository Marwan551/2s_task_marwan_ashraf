class Customer {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? street;
  final String? city;
  final String? zip;
  final String? country;
  final bool isDirty;
  final DateTime? writeDate;

  Customer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.street,
    this.city,
    this.zip,
    this.country,
    this.isDirty = false,
    this.writeDate,
  });

  factory Customer.fromOdooJson(Map<String, dynamic> json) {
    String? parseString(dynamic val) {
      if (val is String) return val;
      return null;
    }

    String? parseMany2one(dynamic val) {
      if (val is List && val.length > 1 && val[1] is String) {
        return val[1] as String;
      }
      return null;
    }

    return Customer(
      id: json['id'] as int,
      name: parseString(json['name']) ?? 'Unnamed Customer',
      phone: parseString(json['phone']),
      email: parseString(json['email']),
      street: parseString(json['street']),
      city: parseString(json['city']),
      zip: parseString(json['zip']),
      country: parseMany2one(json['country_id']),
    );
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? street,
    String? city,
    String? zip,
    String? country,
    bool? isDirty,
    DateTime? writeDate,
  }) {
    return Customer(
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
}
