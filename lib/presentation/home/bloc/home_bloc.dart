// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/constants/app_colors.dart';
// import '../models/home_response_model.dart';
// import '../repositories/home_repository.dart';
//
// part 'home_event.dart';
// part 'home_state.dart';
//
// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final HomeRepository _homeRepository;
//
//   HomeBloc({HomeRepository? homeRepository})
//       : _homeRepository = homeRepository ?? HomeRepository(),
//         super(HomeLoading()) {
//     on<HomeStarted>(_onStarted);
//   }
//
//   // ---- Fallback sample data -------------------------------------------
//   // The API's exact field names for transactions/budgets/recentActivity
//   // aren't confirmed yet (see the debugPrints in HomeRepository). If a
//   // section comes back empty/missing, we fall back to this sample data so
//   // the page still looks correct instead of showing blank sections.
//   static const List<double> _fallbackChartPoints = [
//     20, 35, 30, 45, 40, 60, 50, 70, 65, 80,
//   ];
//
//   static final List<TransactionItem> _fallbackTransactions = [
//     const TransactionItem(
//       title: 'Shirts',
//       date: '24/08/21',
//       amount: 20,
//       isExpense: true,
//       icon: Icons.local_dining_rounded,
//     ),
//     const TransactionItem(
//       title: 'Pants',
//       date: '22/07/21',
//       amount: 22,
//       isExpense: false,
//       icon: Icons.laptop_mac_rounded,
//     ),
//     const TransactionItem(
//       title: 'Innerwears',
//       date: '22/07/21',
//       amount: 20,
//       isExpense: true,
//       icon: Icons.shopping_bag_rounded,
//     ),
//   ];
//
//   static final List<BudgetItem> _fallbackBudgets = [
//     const BudgetItem(
//       title: 'Shirts',
//       spent: 700,
//       total: 1000,
//       icon: Icons.local_dining_rounded,
//       color: AppColors.success,
//     ),
//     const BudgetItem(
//       title: 'Pants',
//       spent: 350,
//       total: 1000,
//       icon: Icons.shopping_bag_rounded,
//       color: AppColors.budgetOrange,
//     ),
//     const BudgetItem(
//       title: 'Innerwears',
//       spent: 500,
//       total: 1000,
//       icon: Icons.laptop_mac_rounded,
//       color: AppColors.primary,
//     ),
//   ];
//
//   static final List<BillActivityItem> _fallbackRecentActivity = [
//     const BillActivityItem(
//       itemName: 'Shirts',
//       billId: 'B1042',
//       date: 'Today',
//       time: '10:45 AM',
//       price: 999,
//       salePrice: 799,
//       quantity: 2,
//       paymentMode: 'UPI',
//       icon: Icons.checkroom_rounded,
//       iconBackground: AppColors.activityShirtsBg,
//     ),
//     const BillActivityItem(
//       itemName: 'Pants',
//       billId: 'B1041',
//       date: 'Yesterday',
//       time: '4:20 PM',
//       price: 1299,
//       salePrice: 999,
//       quantity: 1,
//       paymentMode: 'Cash',
//       icon: Icons.dry_cleaning_rounded,
//       iconBackground: AppColors.activityPantsBg,
//     ),
//     const BillActivityItem(
//       itemName: 'Innerwear',
//       billId: 'B1039',
//       date: 'Oct 24',
//       time: '1:05 PM',
//       price: 499,
//       salePrice: 399,
//       quantity: 3,
//       paymentMode: 'UPI',
//       icon: Icons.inventory_2_rounded,
//       iconBackground: AppColors.activityInnerwearBg,
//     ),
//   ];
//   // -----------------------------------------------------------------------
//
//   IconData _iconForName(String name) {
//     switch (name.trim().toLowerCase()) {
//       case 'shirts':
//         return Icons.checkroom_rounded;
//       case 'pants':
//         return Icons.dry_cleaning_rounded;
//       case 'innerwear':
//       case 'innerwears':
//         return Icons.inventory_2_rounded;
//       default:
//         return Icons.category_rounded;
//     }
//   }
//
//   Color _iconBackgroundForName(String name) {
//     switch (name.trim().toLowerCase()) {
//       case 'shirts':
//         return AppColors.activityShirtsBg;
//       case 'pants':
//         return AppColors.activityPantsBg;
//       case 'innerwear':
//       case 'innerwears':
//         return AppColors.activityInnerwearBg;
//       default:
//         return AppColors.navSelectedBackground;
//     }
//   }
//
//   List<TransactionItem> _mapTransactions(List<Map<String, dynamic>> raw) {
//     if (raw.isEmpty) {
//       debugPrint('HomeBloc: transactions missing/empty -> using fallback');
//       return _fallbackTransactions;
//     }
//     return raw.map((json) {
//       final title = (json['title'] ?? json['name'] ?? json['item'] ?? 'Item')
//           .toString();
//       final typeStr = (json['type'] ?? '').toString().toLowerCase();
//       final isExpense = json['is_expense'] as bool? ??
//           json['isExpense'] as bool? ??
//           (typeStr == 'expense');
//       return TransactionItem(
//         title: title,
//         date: (json['date'] ?? '').toString(),
//         amount: homeToDouble(json['amount']),
//         isExpense: isExpense,
//         icon: _iconForName(title),
//       );
//     }).toList();
//   }
//
//   List<BudgetItem> _mapBudgets(List<Map<String, dynamic>> raw) {
//     if (raw.isEmpty) {
//       debugPrint('HomeBloc: budgets missing/empty -> using fallback');
//       return _fallbackBudgets;
//     }
//     const palette = [
//       AppColors.success,
//       AppColors.budgetOrange,
//       AppColors.primary,
//     ];
//     var index = 0;
//     return raw.map((json) {
//       final title =
//       (json['title'] ?? json['name'] ?? json['category'] ?? 'Category')
//           .toString();
//       final color = palette[index % palette.length];
//       index++;
//       return BudgetItem(
//         title: title,
//         spent: homeToDouble(json['spent']),
//         total: homeToDouble(json['total'] ?? json['limit']),
//         icon: _iconForName(title),
//         color: color,
//       );
//     }).toList();
//   }
//
//   List<BillActivityItem> _mapRecentActivity(List<Map<String, dynamic>> raw) {
//     if (raw.isEmpty) {
//       debugPrint('HomeBloc: recentActivity missing/empty -> using fallback');
//       return _fallbackRecentActivity;
//     }
//     return raw.map((json) {
//       final itemName =
//       (json['item_name'] ?? json['itemName'] ?? json['name'] ?? 'Item')
//           .toString();
//       return BillActivityItem(
//         itemName: itemName,
//         billId: (json['bill_id'] ?? json['billId'] ?? '').toString(),
//         date: (json['date'] ?? '').toString(),
//         time: (json['time'] ?? '').toString(),
//         price: homeToDouble(json['price']),
//         salePrice: homeToDouble(json['sale_price'] ?? json['salePrice']),
//         quantity: (json['quantity'] as num?)?.toInt() ?? 1,
//         paymentMode:
//         (json['payment_mode'] ?? json['paymentMode'] ?? 'Cash').toString(),
//         icon: _iconForName(itemName),
//         iconBackground: _iconBackgroundForName(itemName),
//       );
//     }).toList();
//   }
//
//   String _currentMonthParam() {
//     final now = DateTime.now();
//     return '${now.year}-${now.month.toString().padLeft(2, '0')}';
//   }
//
//   Future<void> _onStarted(
//       HomeStarted event,
//       Emitter<HomeState> emit,
//       ) async {
//     emit(HomeLoading());
//     final month = _currentMonthParam();
//     debugPrint('HomeBloc: fetching home data for month=$month');
//
//     try {
//       final HomeResponseModel response =
//       await _homeRepository.getHome(month: month);
//
//       final chartPoints = response.chartPoints.isEmpty
//           ? _fallbackChartPoints
//           : response.chartPoints;
//       if (response.chartPoints.isEmpty) {
//         debugPrint('HomeBloc: chartPoints missing/empty -> using fallback');
//       }
//
//       emit(
//         HomeLoaded(
//           totalSales: response.totalSales,
//           income: response.income,
//           expense: response.expense,
//           profit: response.profit,
//           chartPoints: chartPoints,
//           transactions: _mapTransactions(response.transactions),
//           budgets: _mapBudgets(response.budgets),
//           recentActivity: _mapRecentActivity(response.recentActivity),
//         ),
//       );
//     } catch (e) {
//       debugPrint('HomeBloc: failed to load home data -> $e');
//       emit(HomeError('Could not load dashboard. Please try again.'));
//     }
//   }
// }



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