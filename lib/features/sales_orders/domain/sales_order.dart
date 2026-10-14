class SalesOrderLine {
  final int id;
  final String productName;
  final double quantity;
  final double priceUnit;
  final double priceSubtotal;

  SalesOrderLine({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.priceUnit,
    required this.priceSubtotal,
  });

  factory SalesOrderLine.fromOdooJson(Map<String, dynamic> json) {
    String parseProduct(dynamic val) {
      if (val is List && val.length > 1 && val[1] is String) {
        return val[1] as String;
      }
      if (val is String) return val;
      return 'Product';
    }

    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return SalesOrderLine(
      id: json['id'] as int,
      productName: json['name'] is String && (json['name'] as String).isNotEmpty
          ? json['name'] as String
          : parseProduct(json['product_id']),
      quantity: parseDouble(json['product_uom_qty']),
      priceUnit: parseDouble(json['price_unit']),
      priceSubtotal: parseDouble(json['price_subtotal']),
    );
  }
}

class SalesOrder {
  final int id;
  final String name;
  final String partnerName;
  final String dateOrder;
  final String state;
  final double amountUntaxed;
  final double amountTax;
  final double amountTotal;
  final String currencyCode;
  final List<int> lineIds;
  final List<SalesOrderLine> lines;

  SalesOrder({
    required this.id,
    required this.name,
    required this.partnerName,
    required this.dateOrder,
    required this.state,
    required this.amountUntaxed,
    required this.amountTax,
    required this.amountTotal,
    this.currencyCode = 'USD',
    this.lineIds = const [],
    this.lines = const [],
  });

  factory SalesOrder.fromOdooJson(Map<String, dynamic> json, {List<SalesOrderLine> lines = const []}) {
    String parsePartner(dynamic val) {
      if (val is List && val.length > 1 && val[1] is String) {
        return val[1] as String;
      }
      return 'Unknown Customer';
    }

    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    String parseCurrency(dynamic val) {
      if (val is List && val.length > 1 && val[1] is String) {
        final label = (val[1] as String).trim();
        final code = label.split(' ').first;
        if (RegExp(r'^[A-Z]{3}$').hasMatch(code)) return code;
      }
      return 'USD';
    }

    List<int> parseLineIds(dynamic val) {
      if (val is List) {
        return val.whereType<int>().toList();
      }
      return [];
    }

    return SalesOrder(
      id: json['id'] as int,
      name: json['name'] is String ? json['name'] as String : 'SO',
      partnerName: parsePartner(json['partner_id']),
      dateOrder: json['date_order'] is String ? json['date_order'] as String : '',
      state: json['state'] is String ? json['state'] as String : 'draft',
      amountUntaxed: parseDouble(json['amount_untaxed']),
      amountTax: parseDouble(json['amount_tax']),
      amountTotal: parseDouble(json['amount_total']),
      currencyCode: parseCurrency(json['currency_id']),
      lineIds: parseLineIds(json['order_line']),
      lines: lines,
    );
  }

  SalesOrder copyWith({
    int? id,
    String? name,
    String? partnerName,
    String? dateOrder,
    String? state,
    double? amountUntaxed,
    double? amountTax,
    double? amountTotal,
    String? currencyCode,
    List<int>? lineIds,
    List<SalesOrderLine>? lines,
  }) {
    return SalesOrder(
      id: id ?? this.id,
      name: name ?? this.name,
      partnerName: partnerName ?? this.partnerName,
      dateOrder: dateOrder ?? this.dateOrder,
      state: state ?? this.state,
      amountUntaxed: amountUntaxed ?? this.amountUntaxed,
      amountTax: amountTax ?? this.amountTax,
      amountTotal: amountTotal ?? this.amountTotal,
      currencyCode: currencyCode ?? this.currencyCode,
      lineIds: lineIds ?? this.lineIds,
      lines: lines ?? this.lines,
    );
  }
}
