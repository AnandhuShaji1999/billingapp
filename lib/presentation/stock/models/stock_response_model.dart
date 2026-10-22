class StockResponseModel {
  final DateTime date;
  final int totalStockLeft;
  final int soldToday;
  final List<StockLevelModel> stockLevels;

  StockResponseModel({
    required this.date,
    required this.totalStockLeft,
    required this.soldToday,
    required this.stockLevels,
  });

  factory StockResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final stockLevelsJson =
        json['stock_levels'] as List<dynamic>? ?? [];

    return StockResponseModel(
      date: DateTime.tryParse(
        json['date']?.toString() ?? '',
      ) ??
          DateTime.now(),

      totalStockLeft:
      _toInt(json['total_stock_left']),

      soldToday:
      _toInt(json['sold_today']),

      stockLevels:
      stockLevelsJson
          .map(
            (item) =>
            StockLevelModel.fromJson(
              Map<String, dynamic>.from(
                item as Map,
              ),
            ),
      )
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
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

class StockLevelModel {
  final int categoryId;
  final String category;
  final String icon;
  final int stockQty;
  final int targetQty;
  final int soldToday;
  final double? percentOfTarget;

  StockLevelModel({
    required this.categoryId,
    required this.category,
    required this.icon,
    required this.stockQty,
    required this.targetQty,
    required this.soldToday,
    required this.percentOfTarget,
  });

  factory StockLevelModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return StockLevelModel(
      categoryId:
      _toInt(json['category_id']),

      category:
      json['category']?.toString() ?? '',

      icon:
      json['icon']?.toString() ?? '',

      stockQty:
      _toInt(json['stock_qty']),

      targetQty:
      _toInt(json['target_qty']),

      soldToday:
      _toInt(json['sold_today']),

      percentOfTarget:
      _toDoubleNullable(
        json['percent_of_target'],
      ),
    );
  }

  static int _toInt(dynamic value) {
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

  static double? _toDoubleNullable(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }
}