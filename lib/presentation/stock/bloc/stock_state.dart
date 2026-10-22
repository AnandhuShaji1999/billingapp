part of 'stock_bloc.dart';

abstract class StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final DateTime date;
  final int totalRemaining;
  final int totalSoldToday;
  final List<StockItem> items;

  StockLoaded({
    required this.date,
    required this.totalRemaining,
    required this.totalSoldToday,
    required this.items,
  });
}

class StockError extends StockState {
  final String message;

  StockError(this.message);
}

// ============================================================
// STOCK ITEM FOR UI
// ============================================================

class StockItem {
  final int categoryId;
  final String name;
  final IconData icon;
  final Color iconBackground;
  final int remaining;
  final int total;
  final int soldToday;
  final double? percentOfTarget;

  StockItem({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.iconBackground,
    required this.remaining,
    required this.total,
    required this.soldToday,
    required this.percentOfTarget,
  });

  // ============================================================
  // PROGRESS RATIO
  // ============================================================

  double get ratio {
    if (percentOfTarget != null) {
      return (percentOfTarget! / 100)
          .clamp(0.0, 1.0);
    }

    if (total <= 0) {
      return 0.0;
    }

    return (remaining / total)
        .clamp(0.0, 1.0);
  }
}