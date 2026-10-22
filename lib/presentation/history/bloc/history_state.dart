part of 'history_bloc.dart';

abstract class HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryBillItem> allItems;
  final List<HistoryBillItem> filteredItems;

  final String filterLabel;

  final double totalCollection;

  final List<DailyTotal> dailyTotals;

  final String period;

  final DateTime? selectedDate;

  final DateTime? selectedMonth;

  HistoryLoaded({
    required this.allItems,
    required this.filteredItems,
    required this.filterLabel,
    required this.totalCollection,
    required this.dailyTotals,
    required this.period,
    this.selectedDate,
    this.selectedMonth,
  });
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}

// ======================================================
// HISTORY ITEM
// ======================================================

class HistoryBillItem {
  final String itemName;
  final String billId;
  final DateTime dateTime;

  final double price;
  final double salePrice;

  final int quantity;

  final String paymentMode;

  final IconData icon;
  final Color iconBackground;

  const HistoryBillItem({
    required this.itemName,
    required this.billId,
    required this.dateTime,
    required this.price,
    required this.salePrice,
    required this.quantity,
    required this.paymentMode,
    required this.icon,
    required this.iconBackground,
  });

  double get total =>
      salePrice * quantity;
}

// ======================================================
// DAILY TOTAL
// ======================================================

class DailyTotal {
  final DateTime date;
  final double total;

  const DailyTotal({
    required this.date,
    required this.total,
  });
}