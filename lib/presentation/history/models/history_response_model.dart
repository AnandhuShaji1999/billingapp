class HistoryResponseModel {
  final String period;
  final String startDate;
  final String endDate;
  final double collection;
  final int billCount;
  final List<HistoryInsightModel> collectionInsights;
  final List<HistoryTransactionModel> transactions;

  const HistoryResponseModel({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.collection,
    required this.billCount,
    required this.collectionInsights,
    required this.transactions,
  });

  factory HistoryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final insights =
    json['collection_insights'];

    final transactions =
    json['transactions'];

    return HistoryResponseModel(
      period:
      (json['period'] ?? '').toString(),

      startDate:
      (json['start_date'] ?? '').toString(),

      endDate:
      (json['end_date'] ?? '').toString(),

      collection:
      _toDouble(json['collection']),

      billCount:
      _toInt(json['bill_count']),

      collectionInsights:
      insights is List
          ? insights
          .whereType<Map>()
          .map(
            (item) =>
            HistoryInsightModel
                .fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
      )
          .toList()
          : const [],

      transactions:
      transactions is List
          ? transactions
          .whereType<Map>()
          .map(
            (item) =>
            HistoryTransactionModel
                .fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
      )
          .toList()
          : const [],
    );
  }
}

// ======================================================
// COLLECTION INSIGHT
// ======================================================

class HistoryInsightModel {
  final DateTime date;
  final double total;

  const HistoryInsightModel({
    required this.date,
    required this.total,
  });

  factory HistoryInsightModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return HistoryInsightModel(
      date:
      DateTime.tryParse(
        (json['date'] ?? '').toString(),
      ) ??
          DateTime.now(),
      total:
      _toDouble(json['total']),
    );
  }
}

// ======================================================
// TRANSACTION
// ======================================================

class HistoryTransactionModel {
  final int id;
  final String billNo;
  final DateTime? paidAt;
  final String category;
  final int itemCount;
  final String paymentMethod;
  final double total;
  final double cost;
  final double grossProfit;

  const HistoryTransactionModel({
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

  factory HistoryTransactionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return HistoryTransactionModel(
      id: _toInt(json['id']),

      billNo:
      (json['bill_no'] ?? '').toString(),

      paidAt:
      DateTime.tryParse(
        (json['paid_at'] ?? '').toString(),
      ),

      category:
      (json['category'] ?? '').toString(),

      itemCount:
      _toInt(
        json['item_count'],
        fallback: 1,
      ),

      paymentMethod:
      (json['payment_method'] ?? '')
          .toString(),

      total:
      _toDouble(json['total']),

      cost:
      _toDouble(json['cost']),

      grossProfit:
      _toDouble(json['gross_profit']),
    );
  }
}

// ======================================================
// HELPERS
// ======================================================

double _toDouble(dynamic value) {
  if (value == null) {
    return 0.0;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
    value.toString(),
  ) ??
      0.0;
}

int _toInt(
    dynamic value, {
      int fallback = 0,
    }) {
  if (value == null) {
    return fallback;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
    value.toString(),
  ) ??
      fallback;
}