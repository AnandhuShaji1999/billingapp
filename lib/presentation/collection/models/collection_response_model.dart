class CollectionResponseModel {
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final double totalCollection;
  final int billCount;
  final double grossProfit;

  final List<PaymentBreakdownModel> paymentBreakdown;
  final List<CategoryCollectionModel> categoryCollection;
  final List<CollectionBillModel> bills;

  CollectionResponseModel({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.totalCollection,
    required this.billCount,
    required this.grossProfit,
    required this.paymentBreakdown,
    required this.categoryCollection,
    required this.bills,
  });

  factory CollectionResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final paymentList =
        json['payment_breakdown'] as List<dynamic>? ?? [];

    final categoryList =
        json['category_collection'] as List<dynamic>? ?? [];

    final billsList =
        json['bills'] as List<dynamic>? ?? [];

    return CollectionResponseModel(
      period:
      json['period']?.toString() ?? 'today',

      startDate:
      DateTime.tryParse(
        json['start_date']?.toString() ?? '',
      ) ??
          DateTime.now(),

      endDate:
      DateTime.tryParse(
        json['end_date']?.toString() ?? '',
      ) ??
          DateTime.now(),

      totalCollection:
      _toDouble(
        json['total_collection'],
      ),

      billCount:
      _toInt(
        json['bill_count'],
      ),

      grossProfit:
      _toDouble(
        json['gross_profit'],
      ),

      paymentBreakdown:
      paymentList
          .map(
            (item) =>
            PaymentBreakdownModel.fromJson(
              Map<String, dynamic>.from(
                item as Map,
              ),
            ),
      )
          .toList(),

      categoryCollection:
      categoryList
          .map(
            (item) =>
            CategoryCollectionModel.fromJson(
              Map<String, dynamic>.from(
                item as Map,
              ),
            ),
      )
          .toList(),

      bills:
      billsList
          .map(
            (item) =>
            CollectionBillModel.fromJson(
              Map<String, dynamic>.from(
                item as Map,
              ),
            ),
      )
          .toList(),
    );
  }

  // ============================================================
  // PAYMENT TOTAL
  // ============================================================

  double get paymentTotal {
    return paymentBreakdown.fold(
      0.0,
          (sum, item) => sum + item.amount,
    );
  }

  // ============================================================
  // UPI
  // ============================================================

  double get upiTotal {
    return _paymentAmount('upi');
  }

  // ============================================================
  // CASH
  // ============================================================

  double get cashTotal {
    return _paymentAmount('cash');
  }

  // ============================================================
  // CARD
  // ============================================================

  double get cardTotal {
    return _paymentAmount('card');
  }

  // ============================================================
  // MIXED
  // ============================================================

  double get mixedTotal {
    return _paymentAmount('mixed');
  }

  double _paymentAmount(
      String method,
      ) {
    return paymentBreakdown
        .where(
          (item) =>
      item.method.toLowerCase() ==
          method.toLowerCase(),
    )
        .fold(
      0.0,
          (sum, item) => sum + item.amount,
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  static double _toDouble(
      dynamic value,
      ) {
    if (value == null) {
      return 0.0;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0.0;
  }

  static int _toInt(
      dynamic value,
      ) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }
}

// ============================================================================
// PAYMENT BREAKDOWN
// ============================================================================

class PaymentBreakdownModel {
  final String method;
  final double amount;
  final double percent;

  PaymentBreakdownModel({
    required this.method,
    required this.amount,
    required this.percent,
  });

  factory PaymentBreakdownModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaymentBreakdownModel(
      method:
      json['method']?.toString() ?? '',

      amount:
      _toDouble(
        json['amount'],
      ),

      percent:
      _toDouble(
        json['percent'],
      ),
    );
  }

  static double _toDouble(
      dynamic value,
      ) {
    if (value == null) {
      return 0.0;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0.0;
  }
}

// ============================================================================
// CATEGORY COLLECTION
// ============================================================================

class CategoryCollectionModel {
  final int categoryId;
  final String category;
  final int qty;
  final double amount;
  final double grossProfit;
  final double percentOfCollection;

  CategoryCollectionModel({
    required this.categoryId,
    required this.category,
    required this.qty,
    required this.amount,
    required this.grossProfit,
    required this.percentOfCollection,
  });

  factory CategoryCollectionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CategoryCollectionModel(
      categoryId:
      _toInt(
        json['category_id'],
      ),

      category:
      json['category']?.toString() ?? '',

      qty:
      _toInt(
        json['qty'],
      ),

      amount:
      _toDouble(
        json['amount'],
      ),

      grossProfit:
      _toDouble(
        json['gross_profit'],
      ),

      percentOfCollection:
      _toDouble(
        json['percent_of_collection'],
      ),
    );
  }

  static int _toInt(
      dynamic value,
      ) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  static double _toDouble(
      dynamic value,
      ) {
    if (value == null) {
      return 0.0;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0.0;
  }
}

// ============================================================================
// BILL
// ============================================================================

class CollectionBillModel {
  final int id;
  final String billNo;
  final DateTime? paidAt;
  final String category;
  final int itemCount;
  final String paymentMethod;
  final double total;
  final double cost;
  final double grossProfit;

  CollectionBillModel({
    required this.id,
    required this.billNo,
    required this.paidAt,
    required this.category,
    required this.itemCount,
    required this.paymentMethod,
    required this.total,
    required this.cost,
    required this.grossProfit,
  });

  factory CollectionBillModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CollectionBillModel(
      id:
      _toInt(
        json['id'],
      ),

      billNo:
      json['bill_no']?.toString() ?? '',

      paidAt:
      DateTime.tryParse(
        json['paid_at']?.toString() ?? '',
      ),

      category:
      json['category']?.toString() ?? '',

      itemCount:
      _toInt(
        json['item_count'],
      ),

      paymentMethod:
      json['payment_method']?.toString() ?? '',

      total:
      _toDouble(
        json['total'],
      ),

      cost:
      _toDouble(
        json['cost'],
      ),

      grossProfit:
      _toDouble(
        json['gross_profit'],
      ),
    );
  }

  static int _toInt(
      dynamic value,
      ) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  static double _toDouble(
      dynamic value,
      ) {
    if (value == null) {
      return 0.0;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0.0;
  }
}