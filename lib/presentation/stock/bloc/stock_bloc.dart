import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../data/repositories/stock_repository.dart';
import '../models/stock_response_model.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepository _repository;

  StockBloc({
    StockRepository? repository,
  })  : _repository =
      repository ?? StockRepository(),
        super(StockLoading()) {
    on<StockStarted>(_onStarted);
    on<StockRefreshRequested>(_onRefreshRequested);
  }

  // ============================================================
  // START
  // ============================================================

  Future<void> _onStarted(
      StockStarted event,
      Emitter<StockState> emit,
      ) async {
    await _loadStock(
      emit,
      showLoading: true,
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _onRefreshRequested(
      StockRefreshRequested event,
      Emitter<StockState> emit,
      ) async {
    await _loadStock(
      emit,
      showLoading: false,
    );
  }

  // ============================================================
  // LOAD STOCK
  // ============================================================

  Future<void> _loadStock(
      Emitter<StockState> emit, {
        bool showLoading = false,
      }) async {
    if (showLoading) {
      emit(StockLoading());
    }

    try {
      debugPrint(
        '========================================',
      );

      debugPrint(
        'STOCK BLOC -> LOADING STOCK',
      );

      debugPrint(
        '========================================',
      );

      final response =
      await _repository.getStock();

      final items =
      response.stockLevels
          .map(
        _mapStockItem,
      )
          .toList();

      debugPrint(
        '========================================',
      );

      debugPrint(
        'STOCK BLOC -> STOCK LOADED',
      );

      debugPrint(
        'TOTAL STOCK LEFT: '
            '${response.totalStockLeft}',
      );

      debugPrint(
        'SOLD TODAY: '
            '${response.soldToday}',
      );

      debugPrint(
        'ITEMS: ${items.length}',
      );

      debugPrint(
        '========================================',
      );

      emit(
        StockLoaded(
          date: response.date,
          totalRemaining:
          response.totalStockLeft,
          totalSoldToday:
          response.soldToday,
          items: items,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );

      debugPrint(
        'STOCK BLOC ERROR: $e',
      );

      debugPrint(
        'STACK TRACE: $stackTrace',
      );

      debugPrint(
        '========================================',
      );

      emit(
        StockError(
          _errorMessage(e),
        ),
      );
    }
  }

  // ============================================================
  // MAP STOCK
  // ============================================================

  StockItem _mapStockItem(
      StockLevelModel item,
      ) {
    return StockItem(
      categoryId: item.categoryId,
      name: item.category,
      icon: _iconForStock(item.icon),
      iconBackground:
      _backgroundForStock(item.icon),
      remaining: item.stockQty,
      total: item.targetQty,
      soldToday: item.soldToday,
      percentOfTarget:
      item.percentOfTarget,
    );
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData _iconForStock(
      String icon,
      ) {
    final value =
    icon.toLowerCase();

    if (value.contains('shirt')) {
      return Icons.checkroom_rounded;
    }

    if (value.contains('pant')) {
      return Icons.dry_cleaning_rounded;
    }

    if (value.contains('inner')) {
      return Icons.inventory_2_rounded;
    }

    if (value.contains('shoe')) {
      return Icons.shopping_bag_rounded;
    }

    return Icons.inventory_2_rounded;
  }

  // ============================================================
  // ICON BACKGROUND
  // ============================================================

  Color _backgroundForStock(
      String icon,
      ) {
    final value =
    icon.toLowerCase();

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
  // ERROR
  // ============================================================

  String _errorMessage(
      Object error,
      ) {
    if (error is StockException) {
      return error.message;
    }

    return 'Unable to load stock.';
  }
}