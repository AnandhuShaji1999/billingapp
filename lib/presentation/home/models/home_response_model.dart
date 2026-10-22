// double homeToDouble(dynamic value) {
//   if (value == null) return 0;
//   if (value is num) return value.toDouble();
//   return double.tryParse(value.toString()) ?? 0;
// }
//
// List<double> _asDoubleList(dynamic value) {
//   if (value is! List) return const [];
//   return value.map(homeToDouble).toList();
// }
//
// List<Map<String, dynamic>> _asMapList(dynamic value) {
//   if (value is! List) return const [];
//   return value
//       .whereType<Map>()
//       .map((e) => e.cast<String, dynamic>())
//       .toList();
// }
//
// /// First-pass model for GET /api/mobile/home/?month=YYYY-MM.
// /// Field names are guessed with several fallback keys since the real
// /// response shape hasn't been confirmed yet — HomeRepository debug-prints
// /// the raw JSON so the exact keys can be read from the console and this
// /// mapping tightened once confirmed. Anything missing/null defaults safely
// /// (0 or empty list) instead of throwing.
// class HomeResponseModel {
//   final double totalSales;
//   final double income;
//   final double expense;
//   final double profit;
//   final List<double> chartPoints;
//   final List<Map<String, dynamic>> transactions;
//   final List<Map<String, dynamic>> budgets;
//   final List<Map<String, dynamic>> recentActivity;
//
//   const HomeResponseModel({
//     required this.totalSales,
//     required this.income,
//     required this.expense,
//     required this.profit,
//     required this.chartPoints,
//     required this.transactions,
//     required this.budgets,
//     required this.recentActivity,
//   });
//
//   factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
//     return HomeResponseModel(
//       totalSales: homeToDouble(
//         json['total_sales'] ?? json['totalSales'] ?? json['sales'],
//       ),
//       income: homeToDouble(json['income']),
//       expense: homeToDouble(json['expense'] ?? json['expenses']),
//       profit: homeToDouble(json['profit']),
//       chartPoints: _asDoubleList(
//         json['chart_points'] ?? json['chartPoints'] ?? json['chart'],
//       ),
//       transactions: _asMapList(json['transactions']),
//       budgets: _asMapList(json['budgets'] ?? json['monthly_budgets']),
//       recentActivity: _asMapList(
//         json['recent_activity'] ??
//             json['recentActivity'] ??
//             json['activities'],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

double homeToDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0.0;
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) {
    return const [];
  }

  return value
      .whereType<Map>()
      .map(
        (item) => Map<String, dynamic>.from(item),
  )
      .toList();
}

class HomeResponseModel {
  final String month;
  final double totalSales;
  final double income;
  final double expense;
  final double costOfGoods;
  final double profit;

  final List<SalesTrendItem> salesTrend;
  final List<HomeTransaction> transactions;
  final List<MonthlyBudget> monthlyBudgets;
  final List<RecentActivity> recentActivity;

  const HomeResponseModel({
    required this.month,
    required this.totalSales,
    required this.income,
    required this.expense,
    required this.costOfGoods,
    required this.profit,
    required this.salesTrend,
    required this.transactions,
    required this.monthlyBudgets,
    required this.recentActivity,
  });

  factory HomeResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final salesTrendJson =
    _asMapList(json['sales_trend']);

    final transactionsJson =
    _asMapList(json['transactions']);

    final budgetsJson =
    _asMapList(json['monthly_budgets']);

    final activityJson =
    _asMapList(json['recent_activity']);

    return HomeResponseModel(
      month: (json['month'] ?? '').toString(),

      totalSales: homeToDouble(
        json['total_sales'],
      ),

      income: homeToDouble(
        json['income'],
      ),

      expense: homeToDouble(
        json['expense'],
      ),

      costOfGoods: homeToDouble(
        json['cost_of_goods'],
      ),

      profit: homeToDouble(
        json['profit'],
      ),

      salesTrend: salesTrendJson
          .map(
            (item) => SalesTrendItem.fromJson(item),
      )
          .toList(),

      transactions: transactionsJson
          .map(
            (item) => HomeTransaction.fromJson(item),
      )
          .toList(),

      monthlyBudgets: budgetsJson
          .map(
            (item) => MonthlyBudget.fromJson(item),
      )
          .toList(),

      recentActivity: activityJson
          .map(
            (item) => RecentActivity.fromJson(item),
      )
          .toList(),
    );
  }
}

// ============================================================
// SALES TREND
// ============================================================

class SalesTrendItem {
  final String date;
  final double total;

  const SalesTrendItem({
    required this.date,
    required this.total,
  });

  factory SalesTrendItem.fromJson(
      Map<String, dynamic> json,
      ) {
    return SalesTrendItem(
      date: (json['date'] ?? '').toString(),
      total: homeToDouble(
        json['total'],
      ),
    );
  }
}

// ============================================================
// TRANSACTION
// ============================================================

class HomeTransaction {
  final String type;
  final String category;
  final double amount;
  final String at;

  const HomeTransaction({
    required this.type,
    required this.category,
    required this.amount,
    required this.at,
  });

  factory HomeTransaction.fromJson(
      Map<String, dynamic> json,
      ) {
    return HomeTransaction(
      type: (json['type'] ?? '').toString(),

      category:
      (json['category'] ?? '').toString(),

      amount: homeToDouble(
        json['amount'],
      ),

      at: (json['at'] ?? '').toString(),
    );
  }
}

// ============================================================
// MONTHLY BUDGET
// ============================================================

class MonthlyBudget {
  final int categoryId;
  final String category;
  final double budget;
  final double spent;
  final double percentUsed;

  const MonthlyBudget({
    required this.categoryId,
    required this.category,
    required this.budget,
    required this.spent,
    required this.percentUsed,
  });

  factory MonthlyBudget.fromJson(
      Map<String, dynamic> json,
      ) {
    return MonthlyBudget(
      categoryId:
      (json['category_id'] as num?)?.toInt() ?? 0,

      category:
      (json['category'] ?? '').toString(),

      budget: homeToDouble(
        json['budget'],
      ),

      spent: homeToDouble(
        json['spent'],
      ),

      percentUsed: homeToDouble(
        json['percent_used'],
      ),
    );
  }
}

// ============================================================
// RECENT ACTIVITY
// ============================================================

class RecentActivity {
  final int id;
  final String billNo;
  final String paidAt;
  final String category;
  final int itemCount;
  final String paymentMethod;
  final double total;
  final double cost;
  final double grossProfit;

  const RecentActivity({
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

  factory RecentActivity.fromJson(
      Map<String, dynamic> json,
      ) {
    return RecentActivity(
      id: (json['id'] as num?)?.toInt() ?? 0,

      billNo:
      (json['bill_no'] ?? '').toString(),

      paidAt:
      (json['paid_at'] ?? '').toString(),

      category:
      (json['category'] ?? '').toString(),

      itemCount:
      (json['item_count'] as num?)?.toInt() ?? 1,

      paymentMethod:
      (json['payment_method'] ?? '').toString(),

      total: homeToDouble(
        json['total'],
      ),

      cost: homeToDouble(
        json['cost'],
      ),

      grossProfit: homeToDouble(
        json['gross_profit'],
      ),
    );
  }
}