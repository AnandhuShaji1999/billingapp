



import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';

import '../models/home_response_model.dart';
import '../repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({
    HomeRepository? homeRepository,
  })  : _homeRepository = homeRepository ?? HomeRepository(),
        super(HomeLoading()) {
    on<HomeStarted>(_onStarted);
  }

  // ------------------------------------------------------------
  // Current month
  // Example: 2026-09
  // ------------------------------------------------------------

  String _currentMonthParam() {
    final now = DateTime.now();

    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}';
  }

  // ------------------------------------------------------------
  // Category icon
  // ------------------------------------------------------------

  IconData _iconForName(String name) {
    switch (name.trim().toLowerCase()) {
      case 'shirts':
        return Icons.checkroom_rounded;

      case 'pants':
        return Icons.dry_cleaning_rounded;

      case 'innerwear':
      case 'innerwears':
        return Icons.inventory_2_rounded;

      case 'shoes':
        return Icons.directions_walk_rounded;

      case 't-shirt':
      case 'tshirts':
      case 't-shirts':
        return Icons.checkroom_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  // ------------------------------------------------------------
  // Activity background
  // ------------------------------------------------------------

  Color _iconBackgroundForName(String name) {
    switch (name.trim().toLowerCase()) {
      case 'shirts':
        return AppColors.activityShirtsBg;

      case 'pants':
        return AppColors.activityPantsBg;

      case 'innerwear':
      case 'innerwears':
        return AppColors.activityInnerwearBg;

      default:
        return AppColors.navSelectedBackground;
    }
  }

  // ------------------------------------------------------------
  // Date formatting
  // ------------------------------------------------------------

  String _formatTransactionDate(String value) {
    if (value.isEmpty) {
      return '';
    }

    try {
      final date = DateTime.parse(value).toLocal();

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value;
    }
  }

  // ------------------------------------------------------------
  // Date + time formatting
  // ------------------------------------------------------------

  Map<String, String> _formatDateTime(String value) {
    if (value.isEmpty) {
      return {
        'date': '',
        'time': '',
      };
    }

    try {
      final dateTime = DateTime.parse(value).toLocal();

      final date =
          '${dateTime.day.toString().padLeft(2, '0')}/'
          '${dateTime.month.toString().padLeft(2, '0')}/'
          '${dateTime.year}';

      final hour = dateTime.hour == 0
          ? 12
          : dateTime.hour > 12
          ? dateTime.hour - 12
          : dateTime.hour;

      final minute = dateTime.minute.toString().padLeft(2, '0');

      final period = dateTime.hour >= 12 ? 'PM' : 'AM';

      final time = '$hour:$minute $period';

      return {
        'date': date,
        'time': time,
      };
    } catch (_) {
      return {
        'date': value,
        'time': '',
      };
    }
  }

  // ------------------------------------------------------------
  // Transactions
  // ------------------------------------------------------------

  List<TransactionItem> _mapTransactions(
      List<HomeTransaction> raw,
      ) {
    return raw.map((transaction) {
      final type = transaction.type.trim().toLowerCase();

      final isExpense = type == 'expense';

      return TransactionItem(
        title: transaction.category.isEmpty
            ? 'Transaction'
            : transaction.category,

        date: _formatTransactionDate(
          transaction.at,
        ),

        amount: transaction.amount.abs(),

        isExpense: isExpense,

        icon: _iconForName(
          transaction.category,
        ),
      );
    }).toList();
  }

  // ------------------------------------------------------------
  // Monthly budgets
  // ------------------------------------------------------------

  List<BudgetItem> _mapBudgets(
      List<MonthlyBudget> raw,
      ) {
    const palette = [
      AppColors.success,
      AppColors.budgetOrange,
      AppColors.primary,
    ];

    return raw.asMap().entries.map((entry) {
      final index = entry.key;
      final budget = entry.value;

      return BudgetItem(
        categoryId: budget.categoryId,

        title: budget.category.isEmpty
            ? 'Category'
            : budget.category,

        spent: budget.spent,

        total: budget.budget,

        percentUsed: budget.percentUsed,

        icon: _iconForName(
          budget.category,
        ),

        color: palette[index % palette.length],
      );
    }).toList();
  }

  // ------------------------------------------------------------
  // Recent activity
  // ------------------------------------------------------------

  List<BillActivityItem> _mapRecentActivity(
      List<RecentActivity> raw,
      ) {
    return raw.map((activity) {
      final dateTime = _formatDateTime(
        activity.paidAt,
      );

      final quantity =
      activity.itemCount <= 0 ? 1 : activity.itemCount;

      // API gives total bill amount.
      //
      // The old UI calculates:
      //
      // salePrice * quantity
      //
      // So divide total by quantity to make the displayed
      // total exactly equal to the API total.
      final perItemSalePrice =
      quantity > 0 ? activity.total / quantity : activity.total;

      return BillActivityItem(
        id: activity.id,

        itemName: activity.category.isEmpty
            ? 'Item'
            : activity.category,

        billId: activity.billNo,

        date: dateTime['date'] ?? '',

        time: dateTime['time'] ?? '',

        // The API does not provide MRP.
        // Keep price equal to sale price so the existing UI
        // does not show a fake discount.
        price: perItemSalePrice,

        salePrice: perItemSalePrice,

        cost: activity.cost,

        grossProfit: activity.grossProfit,

        quantity: quantity,

        paymentMode: activity.paymentMethod.isEmpty
            ? 'Cash'
            : activity.paymentMethod,

        icon: _iconForName(
          activity.category,
        ),

        iconBackground: _iconBackgroundForName(
          activity.category,
        ),
      );
    }).toList();
  }

  // ------------------------------------------------------------
  // Sales trend
  // ------------------------------------------------------------

  List<double> _mapSalesTrend(
      List<SalesTrendItem> raw,
      ) {
    return raw.map((item) {
      return item.total;
    }).toList();
  }

  // ------------------------------------------------------------
  // Load Home
  // ------------------------------------------------------------

  Future<void> _onStarted(
      HomeStarted event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());

    final month = _currentMonthParam();

    debugPrint(
      'HomeBloc -> loading home for $month',
    );

    try {
      final response = await _homeRepository.getHome(
        month: month,
      );

      final chartPoints = _mapSalesTrend(
        response.salesTrend,
      );

      final transactions = _mapTransactions(
        response.transactions,
      );

      final budgets = _mapBudgets(
        response.monthlyBudgets,
      );

      final recentActivity = _mapRecentActivity(
        response.recentActivity,
      );

      debugPrint(
        'HomeBloc -> '
            'sales=${response.totalSales}, '
            'income=${response.income}, '
            'expense=${response.expense}, '
            'cost=${response.costOfGoods}, '
            'profit=${response.profit}',
      );

      debugPrint(
        'HomeBloc -> '
            'chart=${chartPoints.length}, '
            'transactions=${transactions.length}, '
            'budgets=${budgets.length}, '
            'activity=${recentActivity.length}',
      );

      emit(
        HomeLoaded(
          month: response.month,

          totalSales: response.totalSales,

          income: response.income,

          expense: response.expense,

          costOfGoods: response.costOfGoods,

          profit: response.profit,

          chartPoints: chartPoints,

          transactions: transactions,

          budgets: budgets,

          recentActivity: recentActivity,
        ),
      );
    } catch (e) {
      debugPrint(
        'HomeBloc -> ERROR: $e',
      );

      emit(
        HomeError(
          'Could not load dashboard. Please try again.',
        ),
      );
    }
  }
}