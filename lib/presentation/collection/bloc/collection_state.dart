part of 'collection_bloc.dart';

abstract class CollectionState {}

// ============================================================================
// LOADING
// ============================================================================

class CollectionLoading
    extends CollectionState {}

// ============================================================================
// LOADED
// ============================================================================

class CollectionLoaded
    extends CollectionState {
  final String filterLabel;

  final double totalCollection;

  final double upiTotal;

  final double cashTotal;

  final double cardTotal;

  final double mixedTotal;

  final double totalProfit;

  final int billCount;

  final List<CategoryCollection> categories;

  final List<PaymentBreakdown> paymentBreakdown;

  final List<CollectionBillItem> bills;

  final String period;

  final DateTime? selectedDate;

  final DateTime? selectedMonth;

  CollectionLoaded({
    required this.filterLabel,
    required this.totalCollection,
    required this.upiTotal,
    required this.cashTotal,
    required this.cardTotal,
    required this.mixedTotal,
    required this.totalProfit,
    required this.billCount,
    required this.categories,
    required this.paymentBreakdown,
    required this.bills,
    required this.period,
    this.selectedDate,
    this.selectedMonth,
  });
}

// ============================================================================
// ERROR
// ============================================================================

class CollectionError
    extends CollectionState {
  final String message;

  CollectionError(
      this.message,
      );
}

// ============================================================================
// CATEGORY UI MODEL
// ============================================================================

class CategoryCollection {
  final int categoryId;

  final String name;

  final int unitsSold;

  final double saleAmount;

  final double profit;

  final double percentOfCollection;

  final IconData icon;

  final Color iconBackground;

  CategoryCollection({
    required this.categoryId,
    required this.name,
    required this.unitsSold,
    required this.saleAmount,
    required this.profit,
    required this.percentOfCollection,
    required this.icon,
    required this.iconBackground,
  });
}

// ============================================================================
// PAYMENT UI MODEL
// ============================================================================

class PaymentBreakdown {
  final String method;

  final double amount;

  final double percent;

  PaymentBreakdown({
    required this.method,
    required this.amount,
    required this.percent,
  });
}

// ============================================================================
// BILL UI MODEL
// ============================================================================

class CollectionBillItem {
  final int id;

  final String itemName;

  final String billId;

  final DateTime dateTime;

  final int quantity;

  final String paymentMode;

  final double total;

  final double cost;

  final double profit;

  final IconData icon;

  final Color iconBackground;

  CollectionBillItem({
    required this.id,
    required this.itemName,
    required this.billId,
    required this.dateTime,
    required this.quantity,
    required this.paymentMode,
    required this.total,
    required this.cost,
    required this.profit,
    required this.icon,
    required this.iconBackground,
  });
}