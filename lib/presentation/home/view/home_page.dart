import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../routes/app_routes.dart';

import '../bloc/home_bloc.dart';

// ============================================================
// CURRENT MONTH NAME (e.g. "October")
// ============================================================

String _currentMonthName() {
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

  return months[DateTime.now().month - 1];
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(HomeStarted()),
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: const CustomAppBar(
          title: 'Shop Billing',
        ),

        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 40,
                        color: AppColors.error,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<HomeBloc>()
                              .add(HomeStarted());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is! HomeLoaded) {
              return const SizedBox.shrink();
            }

            final loaded = state;

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
                  const _ProfileHeader(),

                  const SizedBox(height: 20),

                  _SalesCard(
                    totalSales: loaded.totalSales,
                    income: loaded.income,
                    expense: loaded.expense,
                    profit: loaded.profit,
                    chartPoints: loaded.chartPoints,
                  ),

                  const SizedBox(height: 28),

                  const _SectionHeader(
                    title: 'Transactions',
                  ),

                  const SizedBox(height: 12),

                  ...loaded.transactions.map(
                        (transaction) => Padding(
                      padding:
                      const EdgeInsets.only(bottom: 12),
                      child: _TransactionTile(
                        transaction: transaction,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const _SectionHeader(
                    title: 'Monthly Budgets',
                  ),

                  const SizedBox(height: 12),

                  ...loaded.budgets.map(
                        (budget) => Padding(
                      padding:
                      const EdgeInsets.only(bottom: 12),
                      child: _BudgetCard(
                        budget: budget,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const _RecentActivityHeader(),

                  const SizedBox(height: 12),

                  ...loaded.recentActivity.map(
                        (activity) => Padding(
                      padding:
                      const EdgeInsets.only(bottom: 12),
                      child: _ActivityTile(
                        activity: activity,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _navIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.history,
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

// ============================================================
// PROFILE HEADER
// ============================================================

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.avatarBackground,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'Admin',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SECTION HEADER
// ============================================================

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        const Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

// ============================================================
// RECENT ACTIVITY HEADER
// ============================================================

class _RecentActivityHeader extends StatelessWidget {
  const _RecentActivityHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.filter_list_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ACTIVITY TILE
// ============================================================

class _ActivityTile extends StatelessWidget {
  final BillActivityItem activity;

  const _ActivityTile({
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        activity.price > activity.salePrice;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
            decoration: BoxDecoration(
              color: activity.iconBackground,
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Icon(
              activity.icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activity.itemName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w700,
                          color:
                          AppColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      '₹${activity.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  '${activity.date}, ${activity.time}',
                  style: const TextStyle(
                    fontSize: 12,
                    color:
                    AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment:
                  WrapCrossAlignment.center,
                  children: [
                    _InfoPill(
                      text:
                      'Bill #${activity.billId}',
                    ),

                    _InfoPill(
                      text:
                      'Qty ${activity.quantity}',
                    ),

                    _PaymentBadge(
                      mode:
                      activity.paymentMode,
                    ),
                  ],
                ),

                if (hasDiscount) ...[
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Text(
                        'MRP ₹${activity.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color:
                          AppColors.textSecondary,
                          decoration:
                          TextDecoration
                              .lineThrough,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'Sale ₹${activity.salePrice.toStringAsFixed(0)}',
                        style: const TextStyle(
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

// ============================================================
// INFO PILL
// ============================================================

class _InfoPill extends StatelessWidget {
  final String text;

  const _InfoPill({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
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
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ============================================================
// PAYMENT BADGE
// ============================================================

class _PaymentBadge extends StatelessWidget {
  final String mode;

  const _PaymentBadge({
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final isUpi =
        mode.toUpperCase() == 'UPI';

    final color = isUpi
        ? AppColors.upiColor
        : AppColors.cashColor;

    final icon = isUpi
        ? Icons.qr_code_rounded
        : Icons.payments_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius:
        BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: color,
          ),

          const SizedBox(width: 4),

          Text(
            mode.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SALES CARD
// ============================================================

class _SalesCard extends StatelessWidget {
  final double totalSales;
  final double income;
  final double expense;
  final double profit;
  final List<double> chartPoints;

  const _SalesCard({
    required this.totalSales,
    required this.income,
    required this.expense,
    required this.profit,
    required this.chartPoints,
  });

  @override
  Widget build(BuildContext context) {
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
                'Total Sales',
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
                child: Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Text(
                      _currentMonthName(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            '₹${totalSales.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 90,
            child: _SalesChart(
              points: chartPoints,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _StatChip(
                  label: 'Income',
                  value:
                  '₹${income.toStringAsFixed(0)}',
                  icon:
                  Icons.arrow_upward_rounded,
                  color:
                  AppColors.incomeColor,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _StatChip(
                  label: 'Expense',
                  value:
                  '₹${expense.toStringAsFixed(0)}',
                  icon:
                  Icons.arrow_downward_rounded,
                  color:
                  AppColors.expenseColor,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _StatChip(
                  label: 'Profit',
                  value:
                  '₹${profit.toStringAsFixed(0)}',
                  icon:
                  Icons.trending_up_rounded,
                  color:
                  AppColors.profitColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STAT CHIP
// ============================================================

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 13,
                color: color,
              ),

              const SizedBox(width: 4),

              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SALES CHART
// ============================================================

class _SalesChart extends StatelessWidget {
  final List<double> points;

  const _SalesChart({
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(
            constraints.maxWidth,
            constraints.maxHeight,
          ),
          painter: _ChartPainter(
            points: points,
          ),
        );
      },
    );
  }
}

// ============================================================
// CHART PAINTER
// ============================================================

class _ChartPainter extends CustomPainter {
  final List<double> points;

  _ChartPainter({
    required this.points,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    if (points.isEmpty) {
      return;
    }

    if (points.length == 1) {
      final point = Offset(
        size.width / 2,
        size.height / 2,
      );

      final paint = Paint()
        ..color = AppColors.chartLine
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        point,
        4,
        paint,
      );

      return;
    }

    final maxVal =
    points.reduce(math.max);

    final minVal =
    points.reduce(math.min);

    final range =
    (maxVal - minVal) == 0
        ? 1.0
        : maxVal - minVal;

    final stepX =
        size.width / (points.length - 1);

    Offset pointAt(int index) {
      final normalized =
          (points[index] - minVal) /
              range;

      final x =
          stepX * index;

      final y =
          size.height -
              (normalized *
                  size.height);

      return Offset(x, y);
    }

    final path = Path();

    for (
    int i = 0;
    i < points.length;
    i++
    ) {
      final offset = pointAt(i);

      if (i == 0) {
        path.moveTo(
          offset.dx,
          offset.dy,
        );
      } else {
        path.lineTo(
          offset.dx,
          offset.dy,
        );
      }
    }

    final linePaint = Paint()
      ..color = AppColors.chartLine
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      path,
      linePaint,
    );

    final peakIndex =
    points.indexOf(maxVal);

    final peakOffset =
    pointAt(peakIndex);

    canvas.drawCircle(
      peakOffset,
      4,
      Paint()
        ..color = AppColors.chartLine,
    );

    canvas.drawCircle(
      peakOffset,
      7,
      Paint()
        ..color = AppColors.chartLine
            .withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final tooltipText =
        '₹${maxVal.toStringAsFixed(2)}';

    final textPainter =
    TextPainter(
      text: TextSpan(
        text: tooltipText,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight:
          FontWeight.w700,
        ),
      ),
      textDirection:
      TextDirection.ltr,
    )..layout();

    final bubbleWidth =
        textPainter.width + 16;

    final bubbleHeight =
        textPainter.height + 10;

    final bubbleLeft =
    (peakOffset.dx -
        bubbleWidth / 2)
        .clamp(
      0.0,
      size.width -
          bubbleWidth,
    );

    final bubbleTop =
    (peakOffset.dy -
        bubbleHeight -
        12)
        .clamp(
      0.0,
      size.height -
          bubbleHeight,
    );

    final bubbleRect =
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        bubbleLeft,
        bubbleTop,
        bubbleWidth,
        bubbleHeight,
      ),
      const Radius.circular(8),
    );

    canvas.drawRRect(
      bubbleRect,
      Paint()
        ..color = AppColors.surface,
    );

    textPainter.paint(
      canvas,
      Offset(
        bubbleLeft + 8,
        bubbleTop + 5,
      ),
    );
  }

  @override
  bool shouldRepaint(
      covariant _ChartPainter oldDelegate,
      ) {
    return oldDelegate.points != points;
  }
}

// ============================================================
// TRANSACTION TILE
// ============================================================

class _TransactionTile extends StatelessWidget {
  final TransactionItem transaction;

  const _TransactionTile({
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor =
    transaction.isExpense
        ? AppColors.expenseColor
        : AppColors.incomeColor;

    final sign =
    transaction.isExpense
        ? '-'
        : '+';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:
              AppColors.iconBackground,
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color:
              AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  transaction.date,
                  style:
                  const TextStyle(
                    fontSize: 12,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '$sign₹${transaction.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w700,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BUDGET CARD
// ============================================================

class _BudgetCard extends StatelessWidget {
  final BudgetItem budget;

  const _BudgetCard({
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final progress = budget.total <= 0
        ? 0.0
        : (budget.spent /
        budget.total)
        .clamp(0.0, 1.0);

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
            Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:
              budget.color.withOpacity(0.12),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Icon(
              budget.icon,
              color: budget.color,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

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
                    Text(
                      budget.title,
                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),

                    Text(
                      '${budget.percentUsed.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        budget.color,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(6),
                  child:
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor:
                    AppColors.budgetTrack,
                    valueColor:
                    AlwaysStoppedAnimation<
                        Color>(
                      budget.color,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '₹${budget.spent.toStringAsFixed(0)} '
                      'of '
                      '₹${budget.total.toStringAsFixed(0)}',
                  style:
                  const TextStyle(
                    fontSize: 11,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}