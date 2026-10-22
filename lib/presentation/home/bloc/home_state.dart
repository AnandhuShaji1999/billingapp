// part of 'home_bloc.dart';
//
// abstract class HomeState {}
//
// class HomeLoading extends HomeState {}
//
// class HomeError extends HomeState {
//   final String message;
//   HomeError(this.message);
// }
//
// class HomeLoaded extends HomeState {
//   final double totalSales;
//   final double income;
//   final double expense;
//   final double profit;
//   final List<double> chartPoints;
//   final List<TransactionItem> transactions;
//   final List<BudgetItem> budgets;
//   final List<BillActivityItem> recentActivity;
//
//   HomeLoaded({
//     required this.totalSales,
//     required this.income,
//     required this.expense,
//     required this.profit,
//     required this.chartPoints,
//     required this.transactions,
//     required this.budgets,
//     required this.recentActivity,
//   });
// }
//
// class TransactionItem {
//   final String title;
//   final String date;
//   final double amount;
//   final bool isExpense;
//   final IconData icon;
//
//   const TransactionItem({
//     required this.title,
//     required this.date,
//     required this.amount,
//     required this.isExpense,
//     required this.icon,
//   });
// }
//
// class BudgetItem {
//   final String title;
//   final double spent;
//   final double total;
//   final IconData icon;
//   final Color color;
//
//   const BudgetItem({
//     required this.title,
//     required this.spent,
//     required this.total,
//     required this.icon,
//     required this.color,
//   });
// }
//
// class BillActivityItem {
//   final String itemName;
//   final String billId;
//   final String date;
//   final String time;
//   final double price;
//   final double salePrice;
//   final int quantity;
//   final String paymentMode;
//   final IconData icon;
//   final Color iconBackground;
//
//   const BillActivityItem({
//     required this.itemName,
//     required this.billId,
//     required this.date,
//     required this.time,
//     required this.price,
//     required this.salePrice,
//     required this.quantity,
//     required this.paymentMode,
//     required this.icon,
//     required this.iconBackground,
//   });
//
//   double get total => salePrice * quantity;
// }


part of 'home_bloc.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class HomeLoaded extends HomeState {
  final String month;

  final double totalSales;
  final double income;
  final double expense;
  final double costOfGoods;
  final double profit;

  final List<double> chartPoints;

  final List<TransactionItem> transactions;

  final List<BudgetItem> budgets;

  final List<BillActivityItem> recentActivity;

  HomeLoaded({
    required this.month,
    required this.totalSales,
    required this.income,
    required this.expense,
    required this.costOfGoods,
    required this.profit,
    required this.chartPoints,
    required this.transactions,
    required this.budgets,
    required this.recentActivity,
  });
}

/// ------------------------------------------------------------
/// Transaction UI Model
/// ------------------------------------------------------------

class TransactionItem {
  final String title;
  final String date;
  final double amount;
  final bool isExpense;
  final IconData icon;

  const TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.icon,
  });
}

/// ------------------------------------------------------------
/// Budget UI Model
/// ------------------------------------------------------------

class BudgetItem {
  final int categoryId;
  final String title;
  final double spent;
  final double total;
  final double percentUsed;
  final IconData icon;
  final Color color;

  const BudgetItem({
    required this.categoryId,
    required this.title,
    required this.spent,
    required this.total,
    required this.percentUsed,
    required this.icon,
    required this.color,
  });
}

/// ------------------------------------------------------------
/// Recent Activity UI Model
/// ------------------------------------------------------------

class BillActivityItem {
  final int id;

  final String itemName;
  final String billId;

  final String date;
  final String time;

  final double price;
  final double salePrice;

  final double cost;
  final double grossProfit;

  final int quantity;

  final String paymentMode;

  final IconData icon;
  final Color iconBackground;

  const BillActivityItem({
    required this.id,
    required this.itemName,
    required this.billId,
    required this.date,
    required this.time,
    required this.price,
    required this.salePrice,
    required this.cost,
    required this.grossProfit,
    required this.quantity,
    required this.paymentMode,
    required this.icon,
    required this.iconBackground,
  });

  double get total => salePrice * quantity;
}