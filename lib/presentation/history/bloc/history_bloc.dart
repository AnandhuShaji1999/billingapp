import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_file_saver/public_file_saver.dart';

import '../../../core/constants/app_colors.dart';
import '../data/repositories/history_repository.dart';
import '../models/history_response_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _repository;

  String _currentPeriod = 'today';

  DateTime? _currentDate;

  DateTime? _currentMonth;

  HistoryBloc({
    HistoryRepository? repository,
  })  : _repository = repository ?? HistoryRepository(),
        super(HistoryLoading()) {
    on<HistoryStarted>(_onStarted);
    on<HistoryTodayRequested>(_onTodayRequested);
    on<HistoryDateSelected>(_onDateSelected);
    on<HistoryMonthSelected>(_onMonthSelected);
  }

  // ============================================================
  // START
  // ============================================================

  Future<void> _onStarted(
      HistoryStarted event,
      Emitter<HistoryState> emit,
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
      HistoryTodayRequested event,
      Emitter<HistoryState> emit,
      ) async {
    await _loadToday(
      emit,
      showLoading: true,
    );
  }

  Future<void> _loadToday(
      Emitter<HistoryState> emit, {
        bool showLoading = false,
      }) async {
    if (showLoading) {
      emit(HistoryLoading());
    }

    try {
      _currentPeriod = 'today';
      _currentDate = null;
      _currentMonth = null;

      debugPrint(
        '========================================',
      );

      debugPrint(
        'HISTORY BLOC -> LOADING TODAY',
      );

      debugPrint(
        '========================================',
      );

      final response = await _repository.getHistory(
        period: 'today',
      );

      final items = _mapTransactions(
        response.transactions,
      );

      final dailyTotals = _mapInsights(
        response.collectionInsights,
      );

      debugPrint(
        'HISTORY BLOC -> COLLECTION: '
            '${response.collection}',
      );

      debugPrint(
        'HISTORY BLOC -> BILLS: '
            '${response.billCount}',
      );

      emit(
        HistoryLoaded(
          allItems: items,
          filteredItems: items,
          filterLabel: 'Today',
          totalCollection: response.collection,
          dailyTotals: dailyTotals,
          period: 'today',
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        'HISTORY BLOC TODAY ERROR: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      emit(
        HistoryError(
          _errorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // DATE
  // ============================================================

  Future<void> _onDateSelected(
      HistoryDateSelected event,
      Emitter<HistoryState> emit,
      ) async {
    emit(HistoryLoading());

    try {
      _currentPeriod = 'date';
      _currentDate = event.date;
      _currentMonth = null;

      debugPrint(
        '========================================',
      );

      debugPrint(
        'HISTORY BLOC -> LOADING DATE',
      );

      debugPrint(
        'DATE: ${_formatDateForApi(event.date)}',
      );

      debugPrint(
        '========================================',
      );

      final response = await _repository.getHistory(
        period: 'date',
        date: event.date,
      );

      final items = _mapTransactions(
        response.transactions,
      );

      final dailyTotals = _mapInsights(
        response.collectionInsights,
      );

      emit(
        HistoryLoaded(
          allItems: items,
          filteredItems: items,
          filterLabel: _formatDate(event.date),
          totalCollection: response.collection,
          dailyTotals: dailyTotals,
          period: 'date',
          selectedDate: event.date,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        'HISTORY BLOC DATE ERROR: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      emit(
        HistoryError(
          _errorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // MONTH
  // ============================================================

  Future<void> _onMonthSelected(
      HistoryMonthSelected event,
      Emitter<HistoryState> emit,
      ) async {
    emit(HistoryLoading());

    try {
      _currentPeriod = 'month';
      _currentDate = null;
      _currentMonth = event.month;

      debugPrint(
        '========================================',
      );

      debugPrint(
        'HISTORY BLOC -> LOADING MONTH',
      );

      debugPrint(
        'MONTH: ${_formatMonthForApi(event.month)}',
      );

      debugPrint(
        '========================================',
      );

      final response = await _repository.getHistory(
        period: 'month',
        month: event.month,
      );

      final items = _mapTransactions(
        response.transactions,
      );

      final dailyTotals = _mapInsights(
        response.collectionInsights,
      );

      emit(
        HistoryLoaded(
          allItems: items,
          filteredItems: items,
          filterLabel: _formatMonth(event.month),
          totalCollection: response.collection,
          dailyTotals: dailyTotals,
          period: 'month',
          selectedMonth: event.month,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        'HISTORY BLOC MONTH ERROR: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      emit(
        HistoryError(
          _errorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // MAP TRANSACTIONS
  // ============================================================

  List<HistoryBillItem> _mapTransactions(
      List<HistoryTransactionModel> transactions,
      ) {
    return transactions.map((item) {
      final quantity =
      item.itemCount <= 0 ? 1 : item.itemCount;

      final salePrice =
          item.total / quantity;

      return HistoryBillItem(
        itemName: item.category.isEmpty
            ? 'Unknown'
            : item.category,

        billId: item.billNo.isEmpty
            ? '-'
            : item.billNo,

        dateTime:
        item.paidAt ?? DateTime.now(),

        // API currently doesn't return MRP.
        price: salePrice,

        salePrice: salePrice,

        quantity: quantity,

        paymentMode:
        _formatPaymentMode(
          item.paymentMethod,
        ),

        icon:
        _iconForItem(
          item.category,
        ),

        iconBackground:
        _backgroundForItem(
          item.category,
        ),
      );
    }).toList();
  }

  // ============================================================
  // MAP INSIGHTS
  // ============================================================

  List<DailyTotal> _mapInsights(
      List<HistoryInsightModel> insights,
      ) {
    return insights
        .map(
          (item) => DailyTotal(
        date: item.date,
        total: item.total,
      ),
    )
        .toList();
  }

  // ============================================================
  // DOWNLOAD PDF
  // ============================================================

  Future<String> downloadReport() async {
    debugPrint(
      '========================================',
    );

    debugPrint(
      'HISTORY BLOC -> DOWNLOAD REPORT',
    );

    debugPrint(
      'CURRENT PERIOD: $_currentPeriod',
    );

    debugPrint(
      'CURRENT DATE: $_currentDate',
    );

    debugPrint(
      'CURRENT MONTH: $_currentMonth',
    );

    debugPrint(
      '========================================',
    );

    try {
      // --------------------------------------------------------
      // GET PDF FROM API
      // --------------------------------------------------------

      debugPrint(
        'HISTORY BLOC -> calling repository...',
      );

      final response =
      await _repository.downloadHistoryReport(
        period: _currentPeriod,
        date: _currentDate,
        month: _currentMonth,
      );

      debugPrint(
        '========================================',
      );

      debugPrint(
        'PDF RESPONSE RECEIVED',
      );

      debugPrint(
        'STATUS: ${response.statusCode}',
      );

      debugPrint(
        'CONTENT TYPE: '
            '${response.headers['content-type']}',
      );

      debugPrint(
        'CONTENT LENGTH: '
            '${response.headers['content-length']}',
      );

      debugPrint(
        'PDF BYTES: '
            '${response.bodyBytes.length}',
      );

      debugPrint(
        '========================================',
      );

      // --------------------------------------------------------
      // CHECK API RESPONSE
      // --------------------------------------------------------

      if (response.statusCode != 200) {
        throw HistoryException(
          'Failed to download PDF '
              '(${response.statusCode})',
        );
      }

      if (response.bodyBytes.isEmpty) {
        throw HistoryException(
          'Downloaded PDF is empty.',
        );
      }

      // --------------------------------------------------------
      // FILE NAME
      // --------------------------------------------------------

      final fileName =
      _buildReportFileName();

      debugPrint(
        'PDF FILE NAME: $fileName',
      );

      // --------------------------------------------------------
      // SAVE TO ANDROID DOWNLOADS
      // --------------------------------------------------------

      debugPrint(
        '========================================',
      );

      debugPrint(
        'SAVING PDF TO DEVICE DOWNLOADS',
      );

      debugPrint(
        'BYTES: ${response.bodyBytes.length}',
      );

      debugPrint(
        'FILE NAME: $fileName',
      );

      debugPrint(
        '========================================',
      );

      final savedFile =
      await PublicFileSaver().saveBytes(
        bytes: response.bodyBytes,
        fileName: fileName,
        mimeType: 'application/pdf',
      );

      // --------------------------------------------------------
      // IMPORTANT:
      // saveBytes() CAN RETURN NULL
      // --------------------------------------------------------

      if (savedFile == null) {
        debugPrint(
          '========================================',
        );

        debugPrint(
          'PDF SAVE RESULT IS NULL',
        );

        debugPrint(
          '========================================',
        );

        throw HistoryException(
          'PDF could not be saved.',
        );
      }

      // --------------------------------------------------------
      // SAVE RESULT
      // --------------------------------------------------------

      debugPrint(
        '========================================',
      );

      debugPrint(
        'PDF SAVE RESULT',
      );

      debugPrint(
        'SUCCESS: ${savedFile.isSuccess}',
      );

      debugPrint(
        'FILE NAME: ${savedFile.fileName}',
      );

      debugPrint(
        'PATH: ${savedFile.path}',
      );

      debugPrint(
        'URI: ${savedFile.uri}',
      );

      debugPrint(
        '========================================',
      );

      // --------------------------------------------------------
      // CHECK SAVE STATUS
      // --------------------------------------------------------

      if (!savedFile.isSuccess) {
        throw HistoryException(
          'PDF could not be saved.',
        );
      }

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      debugPrint(
        '========================================',
      );

      debugPrint(
        'PDF DOWNLOAD SUCCESS',
      );

      debugPrint(
        'FILE: ${savedFile.fileName}',
      );

      debugPrint(
        'PATH: ${savedFile.path}',
      );

      debugPrint(
        'URI: ${savedFile.uri}',
      );

      debugPrint(
        '========================================',
      );

      return savedFile.path ??
          savedFile.uri ??
          fileName;
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );

      debugPrint(
        'HISTORY BLOC -> DOWNLOAD FAILED',
      );

      debugPrint(
        'ERROR: $e',
      );

      debugPrint(
        'STACK TRACE:',
      );

      debugPrint(
        '$stackTrace',
      );

      debugPrint(
        '========================================',
      );

      if (e is HistoryException) {
        rethrow;
      }

      throw HistoryException(
        'Unable to download history report.',
      );
    }
  }

  // ============================================================
  // FILE NAME
  // ============================================================

  String _buildReportFileName() {
    if (_currentPeriod == 'today') {
      final date =
      _formatDateForApi(
        DateTime.now(),
      );

      return 'shopbill-today-$date.pdf';
    }

    if (_currentPeriod == 'date' &&
        _currentDate != null) {
      final date =
      _formatDateForApi(
        _currentDate!,
      );

      return 'shopbill-date-$date.pdf';
    }

    if (_currentPeriod == 'month' &&
        _currentMonth != null) {
      final month =
      _formatMonthForApi(
        _currentMonth!,
      );

      return 'shopbill-month-$month.pdf';
    }

    return 'shopbill-history.pdf';
  }

  // ============================================================
  // PAYMENT MODE
  // ============================================================

  String _formatPaymentMode(
      String value,
      ) {
    if (value.isEmpty) {
      return '';
    }

    final upper = value.toUpperCase();

    if (upper == 'UPI') {
      return 'UPI';
    }

    if (upper == 'CASH') {
      return 'Cash';
    }

    return value;
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData _iconForItem(
      String itemName,
      ) {
    final value =
    itemName.toLowerCase();

    if (value.contains('shirt')) {
      return Icons.checkroom_rounded;
    }

    if (value.contains('inner')) {
      return Icons.inventory_2_rounded;
    }

    if (value.contains('pant')) {
      return Icons.dry_cleaning_rounded;
    }

    return Icons.shopping_bag_rounded;
  }

  // ============================================================
  // BACKGROUND
  // ============================================================

  Color _backgroundForItem(
      String itemName,
      ) {
    final value =
    itemName.toLowerCase();

    if (value.contains('shirt')) {
      return AppColors.activityShirtsBg;
    }

    if (value.contains('inner')) {
      return AppColors.activityInnerwearBg;
    }

    if (value.contains('pant')) {
      return AppColors.activityPantsBg;
    }

    return AppColors.navSelectedBackground;
  }

  // ============================================================
  // DISPLAY DATE
  // ============================================================

  String _formatDate(
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

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  // ============================================================
  // API DATE
  // ============================================================

  String _formatDateForApi(
      DateTime date,
      ) {
    final month =
    date.month
        .toString()
        .padLeft(2, '0');

    final day =
    date.day
        .toString()
        .padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  // ============================================================
  // DISPLAY MONTH
  // ============================================================

  String _formatMonth(
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
        '${date.year}';
  }

  // ============================================================
  // API MONTH
  // ============================================================

  String _formatMonthForApi(
      DateTime date,
      ) {
    final month =
    date.month
        .toString()
        .padLeft(2, '0');

    return '${date.year}-$month';
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _errorMessage(
      Object error,
      ) {
    if (error is HistoryException) {
      return error.message;
    }

    return 'Unable to load history.';
  }
}