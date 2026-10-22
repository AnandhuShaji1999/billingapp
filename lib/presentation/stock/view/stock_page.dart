import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../routes/app_routes.dart';
import '../bloc/stock_bloc.dart';

class StockPage extends StatefulWidget {
  const StockPage({
    super.key,
  });

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  int _navIndex = 2;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      StockBloc()
        ..add(
          StockStarted(),
        ),
      child: Scaffold(
        backgroundColor: AppColors.background,

        // ============================================================
        // APP BAR
        // ============================================================

        appBar: const CustomAppBar(
          title: 'Stock',
        ),

        // ============================================================
        // BODY
        // ============================================================

        body: BlocBuilder<StockBloc, StockState>(
          builder: (
              context,
              state,
              ) {
            // ========================================================
            // LOADING
            // ========================================================

            if (state is StockLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ========================================================
            // ERROR
            // ========================================================

            if (state is StockError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.error,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<StockBloc>()
                              .add(
                            StockStarted(),
                          );
                        },
                        child: const Text(
                          'Retry',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ========================================================
            // LOADED
            // ========================================================

            if (state is! StockLoaded) {
              return const SizedBox();
            }

            final loaded = state;

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<StockBloc>()
                    .add(
                  StockRefreshRequested(),
                );
              },

              child: SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),

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
                    // SUMMARY CARDS
                    // ==================================================

                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Total Stock Left',
                            value:
                            '${loaded.totalRemaining}',
                            icon:
                            Icons.inventory_2_rounded,
                            color:
                            AppColors.primary,
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: _SummaryCard(
                            label: 'Sold Today',
                            value:
                            '${loaded.totalSoldToday}',
                            icon:
                            Icons.trending_up_rounded,
                            color:
                            AppColors.success,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    // ==================================================
                    // STOCK LEVELS TITLE
                    // ==================================================

                    const Text(
                      'Stock Levels',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    // ==================================================
                    // EMPTY STOCK
                    // ==================================================

                    if (loaded.items.isEmpty)
                      Container(
                        width: double.infinity,

                        padding:
                        const EdgeInsets
                            .symmetric(
                          vertical: 32,
                          horizontal: 20,
                        ),

                        decoration:
                        BoxDecoration(
                          color:
                          AppColors.surface,
                          borderRadius:
                          BorderRadius
                              .circular(
                            18,
                          ),
                        ),

                        child: const Center(
                          child: Text(
                            'No stock available',
                            style:
                            TextStyle(
                              fontSize: 14,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ),
                      ),

                    // ==================================================
                    // STOCK ITEMS
                    // ==================================================

                    ...loaded.items.map(
                          (item) => Padding(
                        padding:
                        const EdgeInsets
                            .only(
                          bottom: 14,
                        ),

                        child: _StockCard(
                          item: item,
                        ),
                      ),
                    ),

                    // ==================================================
                    // NO MANAGE INVENTORY BUTTON
                    // ==================================================
                    //
                    // Button intentionally removed.
                    //
                    // ==================================================
                  ],
                ),
              ),
            );
          },
        ),

        // ============================================================
        // BOTTOM NAVIGATION
        // ============================================================

        bottomNavigationBar:
        CustomBottomNavBar(
          currentIndex: _navIndex,

          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.home,
              );
            } else if (index == 1) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.history,
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

// ============================================================================
// SUMMARY CARD
// ============================================================================

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surface,

        borderRadius:
        BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.03,
            ),
            blurRadius: 8,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ==========================================================
          // ICON
          // ==========================================================

          Container(
            width: 36,
            height: 36,

            decoration: BoxDecoration(
              color:
              color.withOpacity(0.12),

              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),

            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // ==========================================================
          // VALUE
          // ==========================================================

          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.bold,
              color:
              AppColors.textPrimary,
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          // ==========================================================
          // LABEL
          // ==========================================================

          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color:
              AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STOCK CARD
// ============================================================================

class _StockCard extends StatelessWidget {
  final StockItem item;

  const _StockCard({
    required this.item,
  });

  // ============================================================
  // PROGRESS COLOR
  // ============================================================

  Color get _progressColor {
    // Backend has percentage.
    if (item.percentOfTarget != null &&
        item.percentOfTarget! <= 20) {
      return AppColors.error;
    }

    if (item.percentOfTarget != null &&
        item.percentOfTarget! <= 50) {
      return AppColors.budgetOrange;
    }

    // Fallback when percentage is null.
    if (item.percentOfTarget == null &&
        item.total > 0) {
      final ratio =
          item.remaining /
              item.total;

      if (ratio <= 0.2) {
        return AppColors.error;
      }

      if (ratio <= 0.5) {
        return AppColors.budgetOrange;
      }
    }

    return AppColors.success;
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surface,

        borderRadius:
        BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.03,
            ),
            blurRadius: 8,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ==========================================================
          // HEADER
          // ==========================================================

          Row(
            children: [
              // ======================================================
              // ICON
              // ======================================================

              Container(
                width: 36,
                height: 36,

                decoration:
                BoxDecoration(
                  color:
                  item.iconBackground,

                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                ),

                child: Icon(
                  item.icon,
                  color:
                  AppColors.primary,
                  size: 18,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              // ======================================================
              // ITEM NAME
              // ======================================================

              Expanded(
                child: Text(
                  item.name,

                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                    color: AppColors
                        .textPrimary,
                  ),
                ),
              ),

              // ======================================================
              // STOCK COUNT
              // ======================================================

              Text(
                '${item.remaining} / ${item.total}',

                style:
                TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  _progressColor,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          // ==========================================================
          // PROGRESS BAR
          // ==========================================================

          ClipRRect(
            borderRadius:
            BorderRadius.circular(6),

            child:
            LinearProgressIndicator(
              value:
              item.ratio.clamp(
                0.0,
                1.0,
              ),

              minHeight: 8,

              backgroundColor:
              AppColors.budgetTrack,

              valueColor:
              AlwaysStoppedAnimation<
                  Color>(
                _progressColor,
              ),
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          // ==========================================================
          // SOLD TODAY
          // ==========================================================

          Text(
            'Sold today: ${item.soldToday}',

            style:
            const TextStyle(
              fontSize: 11,
              color:
              AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}