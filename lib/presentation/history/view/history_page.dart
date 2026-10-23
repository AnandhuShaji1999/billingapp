import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../routes/app_routes.dart';
import '../bloc/history_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _navIndex = 1;

  bool _isDownloading = false;

  // ======================================================
  // DATE PICKER
  // ======================================================

  Future<void> _pickDate(
      BuildContext context,
      ) async {
    final bloc = context.read<HistoryBloc>();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      debugPrint(
        'HISTORY PAGE -> DATE SELECTED: $picked',
      );

      bloc.add(
        HistoryDateSelected(picked),
      );
    }
  }

  // ======================================================
  // MONTH PICKER
  // ======================================================

  Future<void> _pickMonth(
      BuildContext context,
      ) async {
    final bloc = context.read<HistoryBloc>();

    final now = DateTime.now();

    final months = List.generate(
      12,
          (i) => DateTime(
        now.year,
        now.month - i,
      ),
    );

    debugPrint(
      'HISTORY PAGE -> opening month picker',
    );

    final selected =
    await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height:
            MediaQuery.of(sheetContext)
                .size
                .height *
                0.65,
            child: Column(
              children: [
                // ------------------------------------------
                // HEADER
                // ------------------------------------------

                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    12,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      const Text(
                        'Select Month',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.w700,
                          color:
                          AppColors.textPrimary,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  height: 1,
                ),

                // ------------------------------------------
                // SCROLLABLE MONTH LIST
                // ------------------------------------------

                Expanded(
                  child: ListView.separated(
                    padding:
                    const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      20,
                    ),
                    itemCount:
                    months.length,
                    separatorBuilder:
                        (_, __) =>
                    const SizedBox(
                      height: 4,
                    ),
                    itemBuilder:
                        (_, index) {
                      final month =
                      months[index];

                      return ListTile(
                        contentPadding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 8,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            12,
                          ),
                        ),
                        leading:
                        Container(
                          width: 40,
                          height: 40,
                          decoration:
                          BoxDecoration(
                            color: AppColors
                                .navSelectedBackground,
                            borderRadius:
                            BorderRadius
                                .circular(
                              10,
                            ),
                          ),
                          child:
                          const Icon(
                            Icons
                                .calendar_view_month_rounded,
                            color: AppColors
                                .primary,
                          ),
                        ),
                        title: Text(
                          _monthLabel(
                            month,
                          ),
                          style:
                          const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w600,
                            color: AppColors
                                .textPrimary,
                          ),
                        ),
                        trailing:
                        const Icon(
                          Icons
                              .chevron_right_rounded,
                          color: AppColors
                              .textSecondary,
                        ),
                        onTap: () {
                          debugPrint(
                            'HISTORY PAGE -> MONTH SELECTED: '
                                '$month',
                          );

                          Navigator.pop(
                            sheetContext,
                            month,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      debugPrint(
        'HISTORY PAGE -> selected month: '
            '$selected',
      );

      bloc.add(
        HistoryMonthSelected(
          selected,
        ),
      );
    }
  }

  String _monthLabel(
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

    return '${months[date.month - 1]} ${date.year}';
  }

  // ======================================================
  // DOWNLOAD REPORT
  // ======================================================

  Future<void> _downloadReport(
      HistoryBloc bloc,
      ) async {
    if (_isDownloading) {
      debugPrint(
        'DOWNLOAD REPORT -> already downloading',
      );
      return;
    }

    debugPrint(
      '========================================',
    );
    debugPrint(
      'HISTORY PAGE -> DOWNLOAD REPORT CLICKED',
    );
    debugPrint(
      '========================================',
    );

    setState(() {
      _isDownloading = true;
    });

    try {
      debugPrint(
        'HISTORY PAGE -> calling bloc.downloadReport()',
      );

      final filePath =
      await bloc.downloadReport();

      debugPrint(
        '========================================',
      );
      debugPrint(
        'HISTORY PAGE -> DOWNLOAD SUCCESS',
      );
      debugPrint(
        'FILE PATH: $filePath',
      );
      debugPrint(
        '========================================',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Report downloaded successfully',
          ),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );
      debugPrint(
        'HISTORY PAGE -> DOWNLOAD ERROR',
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

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return BlocProvider(
      create: (_) => HistoryBloc()
        ..add(
          HistoryStarted(),
        ),
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: const CustomAppBar(
          title: 'History',
        ),

        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (
              context,
              state,
              ) {
            // ==================================================
            // LOADING
            // ==================================================

            if (state is HistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ==================================================
            // ERROR
            // ==================================================

            if (state is HistoryError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }

            if (state is! HistoryLoaded) {
              return const SizedBox.shrink();
            }

            final loaded = state;

            // IMPORTANT:
            // This context belongs to BlocBuilder,
            // therefore HistoryBloc is available here.
            final historyBloc =
            context.read<HistoryBloc>();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                24,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // COLLECTION CARD
                  // ==================================================

                  _CollectionCard(
                    label: loaded.filterLabel,
                    total: loaded.totalCollection,
                    billCount:
                    loaded.filteredItems.length,

                    // IMPORTANT FIX
                    onDownload: () {
                      debugPrint(
                        'DOWNLOAD BUTTON -> HistoryBloc found',
                      );

                      _downloadReport(
                        historyBloc,
                      );
                    },

                    isDownloading:
                    _isDownloading,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // COLLECTION INSIGHTS
                  // ==================================================

                  const Text(
                    'Collection Insights',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _InsightsChart(
                    dailyTotals:
                    loaded.dailyTotals,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // FILTER BUTTONS
                  // ==================================================

                  Row(
                    children: [
                      Expanded(
                        child: _FilterChip(
                          icon: Icons.today_rounded,
                          label: 'Today',
                          isActive:
                          loaded.period ==
                              'today',
                          onTap: () {
                            historyBloc.add(
                              HistoryTodayRequested(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: _FilterChip(
                          icon:
                          Icons.calendar_today_rounded,
                          label: 'Date',
                          isActive:
                          loaded.period ==
                              'date',
                          onTap: () {
                            _pickDate(context);
                          },
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: _FilterChip(
                          icon:
                          Icons.calendar_view_month_rounded,
                          label: 'Month',
                          isActive:
                          loaded.period ==
                              'month',
                          onTap: () {
                            _pickMonth(context);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // TRANSACTION HEADER
                  // ==================================================

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${loaded.filterLabel} Transactions',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                          AppColors.textPrimary,
                        ),
                      ),

                      Text(
                        '${loaded.filteredItems.length} bills',
                        style: const TextStyle(
                          fontSize: 12,
                          color:
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // ==================================================
                  // TRANSACTIONS
                  // ==================================================

                  if (loaded.filteredItems.isEmpty)
                    const _EmptyState()
                  else
                    ...loaded.filteredItems.map(
                          (item) => Padding(
                        padding:
                        const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: _HistoryTile(
                          item: item,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),

        // ==================================================
        // BOTTOM NAVIGATION
        // ==================================================

        bottomNavigationBar:
        CustomBottomNavBar(
          currentIndex: _navIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.home,
              );
            } else if (index == 2) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.stock,
              );
            } else if (index == 3) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.collection,
              );
            } else if (index == 4) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.profile,
              );
            } else {
              setState(() {
                _navIndex = index;
              });
            }
          },
        ),
      ),
    );
  }
}

// ======================================================
// COLLECTION CARD
// ======================================================

class _CollectionCard extends StatelessWidget {
  final String label;
  final double total;
  final int billCount;

  final VoidCallback onDownload;
  final bool isDownloading;

  const _CollectionCard({
    required this.label,
    required this.total,
    required this.billCount,
    required this.onDownload,
    required this.isDownloading,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Collection',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.15),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            '₹${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '$billCount bills',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 16),

          // ==================================================
          // DOWNLOAD BUTTON
          // ==================================================

          GestureDetector(
            onTap: isDownloading
                ? null
                : onDownload,
            child: Container(
              padding:
              const EdgeInsets.symmetric(
                vertical: 12,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.15),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  if (isDownloading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(
                      Icons
                          .file_download_outlined,
                      color: Colors.white,
                      size: 18,
                    ),

                  const SizedBox(width: 8),

                  Text(
                    isDownloading
                        ? 'Downloading...'
                        : 'Download Report',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// INSIGHTS CHART
// ======================================================

class _InsightsChart extends StatelessWidget {
  final List<DailyTotal> dailyTotals;

  const _InsightsChart({
    required this.dailyTotals,
  });

  String _weekdayLabel(
      DateTime date,
      ) {
    const labels = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return labels[
    date.weekday - 1
    ];
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final maxTotal =
    dailyTotals.fold<double>(
      0,
          (max, item) =>
      item.total > max
          ? item.total
          : max,
    );

    final safeMax =
    maxTotal == 0
        ? 1.0
        : maxTotal;

    final today =
    DateTime.now();

    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.03),
            blurRadius: 8,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 110,
        child: dailyTotals.isEmpty
            ? const SizedBox.shrink()
            : Row(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children:
          dailyTotals.map(
                (item) {
              final isToday =
                  item.date.year ==
                      today.year &&
                      item.date.month ==
                          today.month &&
                      item.date.day ==
                          today.day;

              final barHeight =
                  70 *
                      (item.total /
                          safeMax);

              return Column(
                mainAxisAlignment:
                MainAxisAlignment
                    .end,
                children: [
                  Text(
                    item.total == 0
                        ? ''
                        : '₹${item.total.toStringAsFixed(0)}',
                    style:
                    const TextStyle(
                      fontSize: 9,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Container(
                    width: 20,
                    height:
                    barHeight < 4
                        ? 4
                        : barHeight,
                    decoration:
                    BoxDecoration(
                      color: isToday
                          ? AppColors
                          .primary
                          : AppColors
                          .insightBarInactive,
                      borderRadius:
                      BorderRadius
                          .circular(
                        6,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    _weekdayLabel(
                      item.date,
                    ),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                      isToday
                          ? FontWeight
                          .w700
                          : FontWeight
                          .w400,
                      color: isToday
                          ? AppColors
                          .primary
                          : AppColors
                          .textSecondary,
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

// ======================================================
// FILTER CHIP
// ======================================================

class _FilterChip
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final color = isActive
        ? AppColors.primary
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors
              .navSelectedBackground
              : AppColors.surface,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : AppColors.divider,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// HISTORY TILE
// ======================================================

class _HistoryTile
    extends StatelessWidget {
  final HistoryBillItem item;

  const _HistoryTile({
    required this.item,
  });

  String _formatDateTime(
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

    final hour =
    date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final period =
    date.hour >= 12
        ? 'PM'
        : 'AM';

    final minute =
    date.minute
        .toString()
        .padLeft(2, '0');

    return '${date.day} '
        '${months[date.month - 1]} • '
        '$hour:$minute $period';
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final hasDiscount =
        item.price > item.salePrice;

    final isUpi =
        item.paymentMode
            .toUpperCase() ==
            'UPI';

    final paymentColor = isUpi
        ? AppColors.upiColor
        : AppColors.cashColor;

    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.03),
            blurRadius: 8,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
            BoxDecoration(
              color:
              item.iconBackground,
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              item.icon,
              color:
              AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style:
                        const TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w700,
                          color: AppColors
                              .textPrimary,
                        ),
                      ),
                    ),

                    Text(
                      '₹${item.total.toStringAsFixed(2)}',
                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  _formatDateTime(
                    item.dateTime,
                  ),
                  style:
                  const TextStyle(
                    fontSize: 12,
                    color:
                    AppColors
                        .textSecondary,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _Pill(
                      text:
                      'Bill #${item.billId}',
                    ),

                    _Pill(
                      text:
                      'Qty ${item.quantity}',
                    ),

                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        paymentColor
                            .withOpacity(
                          0.12,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          8,
                        ),
                      ),
                      child: Text(
                        item.paymentMode,
                        style:
                        TextStyle(
                          fontSize: 10.5,
                          fontWeight:
                          FontWeight.w700,
                          color:
                          paymentColor,
                        ),
                      ),
                    ),
                  ],
                ),

                if (hasDiscount) ...[
                  const SizedBox(
                    height: 6,
                  ),

                  Row(
                    children: [
                      Text(
                        'MRP ₹${item.price.toStringAsFixed(0)}',
                        style:
                        const TextStyle(
                          fontSize: 11,
                          color:
                          AppColors
                              .textSecondary,
                          decoration:
                          TextDecoration
                              .lineThrough,
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        'Sale ₹${item.salePrice.toStringAsFixed(0)}',
                        style:
                        const TextStyle(
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w700,
                          color:
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// PILL
// ======================================================

class _Pill
    extends StatelessWidget {
  final String text;

  const _Pill({
    required this.text,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
        BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight:
          FontWeight.w600,
          color:
          AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ======================================================
// EMPTY STATE
// ======================================================

class _EmptyState
    extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 36,
            color:
            AppColors.textSecondary,
          ),

          SizedBox(height: 8),

          Text(
            'No collections found',
            style: TextStyle(
              color:
              AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}