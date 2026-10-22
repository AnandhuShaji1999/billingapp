import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../data/repositories/collection_repository.dart';
import '../models/collection_response_model.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc
    extends Bloc<
        CollectionEvent,
        CollectionState> {
  final CollectionRepository
  _repository;

  // ============================================================
  // CURRENT FILTER
  // ============================================================

  String _currentPeriod = 'today';

  DateTime? _currentDate;

  DateTime? _currentMonth;

  CollectionBloc({
    CollectionRepository?
    repository,
  })  : _repository =
      repository ??
          CollectionRepository(),
        super(
        CollectionLoading(),
      ) {
    on<CollectionStarted>(
      _onStarted,
    );

    on<CollectionTodayRequested>(
      _onTodayRequested,
    );

    on<CollectionDateSelected>(
      _onDateSelected,
    );

    on<CollectionMonthSelected>(
      _onMonthSelected,
    );
  }

  // ============================================================
  // START
  // ============================================================

  Future<void> _onStarted(
      CollectionStarted event,
      Emitter<CollectionState>
      emit,
      ) async {
    await _loadToday(
      emit,
      showLoading: true,
    );
  }

  // ============================================================
  // TODAY
  // ============================================================

  Future<void> _onTodayRequested(
      CollectionTodayRequested
      event,
      Emitter<CollectionState>
      emit,
      ) async {
    await _loadToday(
      emit,
      showLoading: true,
    );
  }

  Future<void> _loadToday(
      Emitter<CollectionState>
      emit, {
        bool showLoading = false,
      }) async {
    if (showLoading) {
      emit(
        CollectionLoading(),
      );
    }

    try {
      _currentPeriod = 'today';
      _currentDate = null;
      _currentMonth = null;

      debugPrint(
        '========================================',
      );
      debugPrint(
        'COLLECTION BLOC -> LOADING TODAY',
      );
      debugPrint(
        '========================================',
      );

      final response =
      await _repository.getCollection(
        period: 'today',
      );

      emit(
        _createLoadedState(
          response: response,
          filterLabel: 'Today',
          period: 'today',
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );
      debugPrint(
        'COLLECTION BLOC TODAY ERROR',
      );
      debugPrint(
        'ERROR: $e',
      );
      debugPrint(
        'STACK TRACE: $stackTrace',
      );
      debugPrint(
        '========================================',
      );

      emit(
        CollectionError(
          _errorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // DATE
  // ============================================================

  Future<void> _onDateSelected(
      CollectionDateSelected event,
      Emitter<CollectionState>
      emit,
      ) async {
    emit(
      CollectionLoading(),
    );

    try {
      _currentPeriod = 'date';
      _currentDate = event.date;
      _currentMonth = null;

      debugPrint(
        '========================================',
      );
      debugPrint(
        'COLLECTION BLOC -> LOADING DATE',
      );
      debugPrint(
        'DATE: ${_formatDate(event.date)}',
      );
      debugPrint(
        '========================================',
      );

      final response =
      await _repository.getCollection(
        period: 'date',
        date: event.date,
      );

      emit(
        _createLoadedState(
          response: response,
          filterLabel:
          _formatDisplayDate(
            event.date,
          ),
          period: 'date',
          selectedDate: event.date,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );
      debugPrint(
        'COLLECTION BLOC DATE ERROR',
      );
      debugPrint(
        'ERROR: $e',
      );
      debugPrint(
        'STACK TRACE: $stackTrace',
      );
      debugPrint(
        '========================================',
      );

      emit(
        CollectionError(
          _errorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // MONTH
  // ============================================================

  Future<void> _onMonthSelected(
      CollectionMonthSelected
      event,
      Emitter<CollectionState>
      emit,
      ) async {
    emit(
      CollectionLoading(),
    );

    try {
      _currentPeriod = 'month';
      _currentDate = null;
      _currentMonth = event.month;

      debugPrint(
        '========================================',
      );
      debugPrint(
        'COLLECTION BLOC -> LOADING MONTH',
      );
      debugPrint(
        'MONTH: ${_formatMonth(event.month)}',
      );
      debugPrint(
        '========================================',
      );

      final response =
      await _repository.getCollection(
        period: 'month',
        month: event.month,
      );

      emit(
        _createLoadedState(
          response: response,
          filterLabel:
          _formatDisplayMonth(
            event.month,
          ),
          period: 'month',
          selectedMonth: event.month,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );
      debugPrint(
        'COLLECTION BLOC MONTH ERROR',
      );
      debugPrint(
        'ERROR: $e',
      );
      debugPrint(
        'STACK TRACE: $stackTrace',
      );
      debugPrint(
        '========================================',
      );

      emit(
        CollectionError(
          _errorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // CREATE LOADED STATE
  // ============================================================

  CollectionLoaded
  _createLoadedState({
    required CollectionResponseModel
    response,
    required String filterLabel,
    required String period,
    DateTime? selectedDate,
    DateTime? selectedMonth,
  }) {
    final categories =
    _mapCategories(
      response.categoryCollection,
    );

    final payments =
    _mapPayments(
      response.paymentBreakdown,
    );

    final bills =
    _mapBills(
      response.bills,
    );

    debugPrint(
      '========================================',
    );
    debugPrint(
      'COLLECTION BLOC -> LOADED',
    );
    debugPrint(
      'FILTER: $filterLabel',
    );
    debugPrint(
      'PERIOD: $period',
    );
    debugPrint(
      'TOTAL: ${response.totalCollection}',
    );
    debugPrint(
      'BILLS: ${response.billCount}',
    );
    debugPrint(
      'PROFIT: ${response.grossProfit}',
    );
    debugPrint(
      'UPI: ${response.upiTotal}',
    );
    debugPrint(
      'CASH: ${response.cashTotal}',
    );
    debugPrint(
      'CARD: ${response.cardTotal}',
    );
    debugPrint(
      'MIXED: ${response.mixedTotal}',
    );
    debugPrint(
      'CATEGORIES: ${categories.length}',
    );
    debugPrint(
      'BILLS LIST: ${bills.length}',
    );
    debugPrint(
      '========================================',
    );

    return CollectionLoaded(
      filterLabel:
      filterLabel,

      totalCollection:
      response.totalCollection,

      upiTotal:
      response.upiTotal,

      cashTotal:
      response.cashTotal,

      cardTotal:
      response.cardTotal,

      mixedTotal:
      response.mixedTotal,

      totalProfit:
      response.grossProfit,

      billCount:
      response.billCount,

      categories:
      categories,

      paymentBreakdown:
      payments,

      bills:
      bills,

      period:
      period,

      selectedDate:
      selectedDate,

      selectedMonth:
      selectedMonth,
    );
  }

  // ============================================================
  // MAP CATEGORIES
  // ============================================================

  List<CategoryCollection>
  _mapCategories(
      List<CategoryCollectionModel>
      categories,
      ) {
    return categories.map(
          (item) {
        return CategoryCollection(
          categoryId:
          item.categoryId,

          name:
          item.category.isEmpty
              ? 'Unknown'
              : item.category,

          unitsSold:
          item.qty,

          saleAmount:
          item.amount,

          profit:
          item.grossProfit,

          percentOfCollection:
          item.percentOfCollection,

          icon:
          _iconForCategory(
            item.category,
          ),

          iconBackground:
          _backgroundForCategory(
            item.category,
          ),
        );
      },
    ).toList();
  }

  // ============================================================
  // MAP PAYMENTS
  // ============================================================

  List<PaymentBreakdown>
  _mapPayments(
      List<PaymentBreakdownModel>
      payments,
      ) {
    return payments.map(
          (item) {
        return PaymentBreakdown(
          method:
          item.method,

          amount:
          item.amount,

          percent:
          item.percent,
        );
      },
    ).toList();
  }

  // ============================================================
  // MAP BILLS
  // ============================================================

  List<CollectionBillItem>
  _mapBills(
      List<CollectionBillModel>
      bills,
      ) {
    return bills.map(
          (item) {
        return CollectionBillItem(
          id:
          item.id,

          itemName:
          item.category.isEmpty
              ? 'Unknown'
              : item.category,

          billId:
          item.billNo.isEmpty
              ? '-'
              : item.billNo,

          dateTime:
          item.paidAt ??
              DateTime.now(),

          quantity:
          item.itemCount <= 0
              ? 1
              : item.itemCount,

          paymentMode:
          _formatPaymentMethod(
            item.paymentMethod,
          ),

          total:
          item.total,

          cost:
          item.cost,

          profit:
          item.grossProfit,

          icon:
          _iconForCategory(
            item.category,
          ),

          iconBackground:
          _backgroundForCategory(
            item.category,
          ),
        );
      },
    ).toList();
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData _iconForCategory(
      String category,
      ) {
    final value =
    category.toLowerCase();

    if (value.contains('shirt')) {
      return Icons.checkroom_rounded;
    }

    if (value.contains('pant')) {
      return Icons.dry_cleaning_rounded;
    }

    if (value.contains('shoe')) {
      return Icons.shopping_bag_rounded;
    }

    if (value.contains('inner')) {
      return Icons.inventory_2_rounded;
    }

    if (value.contains('dress')) {
      return Icons.checkroom_rounded;
    }

    return Icons.inventory_2_rounded;
  }

  // ============================================================
  // ICON BACKGROUND
  // ============================================================

  Color _backgroundForCategory(
      String category,
      ) {
    final value =
    category.toLowerCase();

    if (value.contains('shirt')) {
      return AppColors
          .activityShirtsBg;
    }

    if (value.contains('inner')) {
      return AppColors
          .activityInnerwearBg;
    }

    if (value.contains('pant')) {
      return AppColors
          .activityPantsBg;
    }

    return AppColors
        .navSelectedBackground;
  }

  // ============================================================
  // PAYMENT NAME
  // ============================================================

  String _formatPaymentMethod(
      String method,
      ) {
    final value =
    method.toLowerCase();

    switch (value) {
      case 'upi':
        return 'UPI';

      case 'cash':
        return 'Cash';

      case 'card':
        return 'Card';

      case 'mixed':
        return 'Mixed';

      default:
        if (method.isEmpty) {
          return 'Unknown';
        }

        return method[0].toUpperCase() +
            method.substring(1);
    }
  }

  // ============================================================
  // API DATE
  // ============================================================

  String _formatDate(
      DateTime date,
      ) {
    final month =
    date.month.toString().padLeft(
      2,
      '0',
    );

    final day =
    date.day.toString().padLeft(
      2,
      '0',
    );

    return '${date.year}-$month-$day';
  }

  // ============================================================
  // API MONTH
  // ============================================================

  String _formatMonth(
      DateTime date,
      ) {
    final month =
    date.month.toString().padLeft(
      2,
      '0',
    );

    return '${date.year}-$month';
  }

  // ============================================================
  // DISPLAY DATE
  // ============================================================

  String _formatDisplayDate(
      DateTime date,
      ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} '
        '${date.day}, '
        '${date.year}';
  }

  // ============================================================
  // DISPLAY MONTH
  // ============================================================

  String _formatDisplayMonth(
      DateTime date,
      ) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} '
        '${date.year}';
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _errorMessage(
      Object error,
      ) {
    if (error
    is CollectionException) {
      return error.message;
    }

    return 'Unable to load collection.';
  }
}