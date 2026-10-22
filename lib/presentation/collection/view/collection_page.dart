// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/widgets/custom_app_bar.dart';
// import '../../../core/widgets/custom_bottom_nav_bar.dart';
// import '../../../routes/app_routes.dart';
// import '../bloc/collection_bloc.dart';
//
// class CollectionPage extends StatefulWidget {
//   const CollectionPage({super.key});
//
//   @override
//   State<CollectionPage> createState() => _CollectionPageState();
// }
//
// class _CollectionPageState extends State<CollectionPage> {
//   int _navIndex = 3;
//
//   Future<void> _pickDate(BuildContext context) async {
//     final bloc = context.read<CollectionBloc>();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       bloc.add(CollectionDateSelected(picked));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => CollectionBloc()..add(CollectionStarted()),
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: const CustomAppBar(title: 'Collection'),
//         body: BlocBuilder<CollectionBloc, CollectionState>(
//           builder: (context, state) {
//             if (state is CollectionLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             final loaded = state as CollectionLoaded;
//             return SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _CollectionSummaryCard(
//                     label: loaded.filterLabel,
//                     total: loaded.totalCollection,
//                     upi: loaded.upiTotal,
//                     cash: loaded.cashTotal,
//                     profit: loaded.totalProfit,
//                     onPickDate: () => _pickDate(context),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _ActionButton(
//                           icon: Icons.calendar_month_rounded,
//                           label: 'Choose Date',
//                           onTap: () => _pickDate(context),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _ActionButton(
//                           icon: Icons.ios_share_rounded,
//                           label: 'Export Report',
//                           onTap: () {},
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 28),
//                   const Text(
//                     'Category Collection',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   if (loaded.categories.isEmpty)
//                     const _EmptyState(text: 'No sales for this date')
//                   else
//                     ...loaded.categories.map(
//                           (c) => Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: _CategoryCard(
//                           category: c,
//                           totalCollection: loaded.totalCollection,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Payment Breakdown',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _PaymentBreakdownCard(
//                     upi: loaded.upiTotal,
//                     cash: loaded.cashTotal,
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '${loaded.filterLabel} Bills',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       Text(
//                         '${loaded.bills.length} bills',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   if (loaded.bills.isEmpty)
//                     const _EmptyState(text: 'No bills for this date')
//                   else
//                     ...loaded.bills.map(
//                           (bill) => Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: _BillTile(bill: bill),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//         bottomNavigationBar: CustomBottomNavBar(
//           currentIndex: _navIndex,
//           onTap: (index) {
//             if (index == 0) {
//               Navigator.pushReplacementNamed(context, AppRoutes.home);
//             } else if (index == 1) {
//               Navigator.pushReplacementNamed(context, AppRoutes.history);
//             } else if (index == 2) {
//               Navigator.pushReplacementNamed(context, AppRoutes.stock);
//             } else if (index == 4) {
//               Navigator.pushReplacementNamed(context, AppRoutes.profile);
//             } else {
//               setState(() => _navIndex = index);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class _CollectionSummaryCard extends StatelessWidget {
//   final String label;
//   final double total;
//   final double upi;
//   final double cash;
//   final double profit;
//   final VoidCallback onPickDate;
//
//   const _CollectionSummaryCard({
//     required this.label,
//     required this.total,
//     required this.upi,
//     required this.cash,
//     required this.profit,
//     required this.onPickDate,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [AppColors.primary, AppColors.secondary],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.cardShadow,
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Total Collection',
//                 style: TextStyle(color: Colors.white70, fontSize: 13),
//               ),
//               GestureDetector(
//                 onTap: onPickDate,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         label,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       const Icon(
//                         Icons.calendar_today_rounded,
//                         color: Colors.white,
//                         size: 13,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             '\$${total.toStringAsFixed(2)}',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _StatChip(
//                   label: 'UPI',
//                   value: '\$${upi.toStringAsFixed(0)}',
//                   icon: Icons.qr_code_rounded,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _StatChip(
//                   label: 'Cash',
//                   value: '\$${cash.toStringAsFixed(0)}',
//                   icon: Icons.payments_rounded,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _StatChip(
//                   label: 'Profit',
//                   value: '\$${profit.toStringAsFixed(0)}',
//                   icon: Icons.trending_up_rounded,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _StatChip extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//
//   const _StatChip({
//     required this.label,
//     required this.value,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 13, color: Colors.white),
//               const SizedBox(width: 4),
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.white70, fontSize: 11),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//
//   const _ActionButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 48,
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//           elevation: 0,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 16),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CategoryCard extends StatelessWidget {
//   final CategoryCollection category;
//   final double totalCollection;
//
//   const _CategoryCard({required this.category, required this.totalCollection});
//
//   @override
//   Widget build(BuildContext context) {
//     final ratio = totalCollection == 0
//         ? 0.0
//         : (category.saleAmount / totalCollection).clamp(0.0, 1.0);
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: category.iconBackground,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(category.icon, color: AppColors.primary, size: 18),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   '${category.name} • ${category.unitsSold} pcs',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ),
//               Text(
//                 '\$${category.saleAmount.toStringAsFixed(0)}',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(6),
//             child: LinearProgressIndicator(
//               value: ratio,
//               minHeight: 8,
//               backgroundColor: AppColors.budgetTrack,
//               valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'Profit: \$${category.profit.toStringAsFixed(0)}',
//             style: const TextStyle(fontSize: 11, color: AppColors.success),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _PaymentBreakdownCard extends StatelessWidget {
//   final double upi;
//   final double cash;
//
//   const _PaymentBreakdownCard({required this.upi, required this.cash});
//
//   @override
//   Widget build(BuildContext context) {
//     final total = upi + cash;
//     final upiPercent = total == 0 ? 0 : (upi / total * 100).round();
//     final cashPercent = total == 0 ? 0 : (cash / total * 100).round();
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _PaymentRow(
//             icon: Icons.qr_code_rounded,
//             label: 'UPI Collection',
//             amount: upi,
//             percent: upiPercent,
//             color: AppColors.upiColor,
//           ),
//           const Divider(height: 24, color: AppColors.divider),
//           _PaymentRow(
//             icon: Icons.payments_rounded,
//             label: 'Cash Collection',
//             amount: cash,
//             percent: cashPercent,
//             color: AppColors.cashColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _PaymentRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final double amount;
//   final int percent;
//   final Color color;
//
//   const _PaymentRow({
//     required this.icon,
//     required this.label,
//     required this.amount,
//     required this.percent,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: color, size: 18),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//         ),
//         Text(
//           '\$${amount.toStringAsFixed(0)}',
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             '$percent%',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _BillTile extends StatelessWidget {
//   final CollectionBillItem bill;
//   const _BillTile({required this.bill});
//
//   String _formatTime(DateTime date) {
//     final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
//     final period = date.hour >= 12 ? 'PM' : 'AM';
//     final minute = date.minute.toString().padLeft(2, '0');
//     return '$hour:$minute $period';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isUpi = bill.paymentMode.toUpperCase() == 'UPI';
//     final paymentColor = isUpi ? AppColors.upiColor : AppColors.cashColor;
//
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: bill.iconBackground,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(bill.icon, color: AppColors.primary, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   bill.itemName,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'Bill #${bill.billId} • ${_formatTime(bill.dateTime)} • Qty ${bill.quantity}',
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '\$${bill.total.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.primary,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: paymentColor.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   bill.paymentMode,
//                   style: TextStyle(
//                     fontSize: 9.5,
//                     fontWeight: FontWeight.w700,
//                     color: paymentColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _EmptyState extends StatelessWidget {
//   final String text;
//   const _EmptyState({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 40),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           const Icon(
//             Icons.receipt_long_outlined,
//             size: 36,
//             color: AppColors.textSecondary,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             text,
//             style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../routes/app_routes.dart';
import '../bloc/collection_bloc.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({
    super.key,
  });

  @override
  State<CollectionPage> createState() =>
      _CollectionPageState();
}

class _CollectionPageState
    extends State<CollectionPage> {
  int _navIndex = 3;

  // ============================================================
  // PICK DATE
  // ============================================================

  Future<void> _pickDate(
      BuildContext context,
      ) async {
    final bloc =
    context.read<CollectionBloc>();

    final picked =
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:
      DateTime.now().subtract(
        const Duration(
          days: 365,
        ),
      ),
      lastDate:
      DateTime.now(),
    );

    if (picked != null) {
      bloc.add(
        CollectionDateSelected(
          picked,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return BlocProvider(
      create: (_) =>
      CollectionBloc()
        ..add(
          CollectionStarted(),
        ),

      child: Scaffold(
        backgroundColor:
        AppColors.background,

        appBar:
        const CustomAppBar(
          title: 'Collection',
        ),

        body:
        BlocBuilder<
            CollectionBloc,
            CollectionState>(
          builder: (
              context,
              state,
              ) {
            // ==================================================
            // LOADING
            // ==================================================

            if (state
            is CollectionLoading) {
              return const Center(
                child:
                CircularProgressIndicator(),
              );
            }

            // ==================================================
            // ERROR
            // ==================================================

            if (state
            is CollectionError) {
              return Center(
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                    24,
                  ),
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons
                            .error_outline_rounded,
                        size: 40,
                        color:
                        AppColors.error,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        state.message,
                        textAlign:
                        TextAlign.center,
                        style:
                        const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<
                              CollectionBloc>()
                              .add(
                            CollectionStarted(),
                          );
                        },

                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          AppColors
                              .primary,
                          foregroundColor:
                          Colors.white,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),
                        ),

                        child:
                        const Text(
                          'Retry',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ==================================================
            // LOADED
            // ==================================================

            if (state
            is! CollectionLoaded) {
              return const SizedBox();
            }

            final loaded = state;

            return SingleChildScrollView(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                24,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [
                  // ==================================================
                  // SUMMARY CARD
                  // ==================================================

                  _CollectionSummaryCard(
                    label:
                    loaded.filterLabel,

                    total:
                    loaded.totalCollection,

                    upi:
                    loaded.upiTotal,

                    cash:
                    loaded.cashTotal,

                    profit:
                    loaded.totalProfit,

                    onPickDate: () =>
                        _pickDate(
                          context,
                        ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================================================
                  // ACTION BUTTONS
                  // ==================================================

                  Row(
                    children: [
                      Expanded(
                        child:
                        _ActionButton(
                          icon: Icons
                              .calendar_month_rounded,
                          label:
                          'Choose Date',
                          onTap: () =>
                              _pickDate(
                                context,
                              ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child:
                        _ActionButton(
                          icon: Icons
                              .ios_share_rounded,
                          label:
                          'Export Report',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ==================================================
                  // CATEGORY COLLECTION
                  // ==================================================

                  const Text(
                    'Category Collection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w700,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  if (loaded
                      .categories
                      .isEmpty)
                    const _EmptyState(
                      text:
                      'No sales for this date',
                    )
                  else
                    ...loaded.categories
                        .map(
                          (c) => Padding(
                        padding:
                        const EdgeInsets
                            .only(
                          bottom: 12,
                        ),
                        child:
                        _CategoryCard(
                          category: c,
                          totalCollection:
                          loaded
                              .totalCollection,
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // PAYMENT BREAKDOWN
                  // ==================================================

                  const Text(
                    'Payment Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w700,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _PaymentBreakdownCard(
                    upi:
                    loaded.upiTotal,
                    cash:
                    loaded.cashTotal,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // BILLS HEADER
                  // ==================================================

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                    children: [
                      Text(
                        '${loaded.filterLabel} Bills',

                        style:
                        const TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w700,
                          color: AppColors
                              .textPrimary,
                        ),
                      ),

                      Text(
                        '${loaded.bills.length} bills',

                        style:
                        const TextStyle(
                          fontSize: 12,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // ==================================================
                  // BILLS
                  // ==================================================

                  if (loaded
                      .bills
                      .isEmpty)
                    const _EmptyState(
                      text:
                      'No bills for this date',
                    )
                  else
                    ...loaded.bills.map(
                          (bill) => Padding(
                        padding:
                        const EdgeInsets
                            .only(
                          bottom: 12,
                        ),
                        child:
                        _BillTile(
                          bill: bill,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),

        // ============================================================
        // BOTTOM NAVIGATION
        // ============================================================

        bottomNavigationBar:
        CustomBottomNavBar(
          currentIndex:
          _navIndex,

          onTap: (index) {
            if (index == 0) {
              Navigator
                  .pushReplacementNamed(
                context,
                AppRoutes.home,
              );
            } else if (index == 1) {
              Navigator
                  .pushReplacementNamed(
                context,
                AppRoutes.history,
              );
            } else if (index == 2) {
              Navigator
                  .pushReplacementNamed(
                context,
                AppRoutes.stock,
              );
            } else if (index == 4) {
              Navigator
                  .pushReplacementNamed(
                context,
                AppRoutes.profile,
              );
            } else {
              setState(
                    () => _navIndex = index,
              );
            }
          },
        ),
      ),
    );
  }
}

// ============================================================================
// COLLECTION SUMMARY CARD
// ============================================================================

class _CollectionSummaryCard
    extends StatelessWidget {
  final String label;
  final double total;
  final double upi;
  final double cash;
  final double profit;
  final VoidCallback onPickDate;

  const _CollectionSummaryCard({
    required this.label,
    required this.total,
    required this.upi,
    required this.cash,
    required this.profit,
    required this.onPickDate,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient:
        const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin:
          Alignment.topLeft,
          end:
          Alignment.bottomRight,
        ),

        borderRadius:
        BorderRadius.circular(
          24,
        ),

        boxShadow: [
          BoxShadow(
            color:
            AppColors.cardShadow,
            blurRadius: 20,
            offset:
            const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

            children: [
              const Text(
                'Total Collection',
                style: TextStyle(
                  color:
                  Colors.white70,
                  fontSize: 13,
                ),
              ),

              GestureDetector(
                onTap:
                onPickDate,

                child: Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.white
                        .withOpacity(
                      0.15,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                      20,
                    ),
                  ),

                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [
                      Text(
                        label,

                        style:
                        const TextStyle(
                          color:
                          Colors.white,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      const Icon(
                        Icons
                            .calendar_today_rounded,
                        color:
                        Colors.white,
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            '\$${total.toStringAsFixed(2)}',

            style:
            const TextStyle(
              color:
              Colors.white,
              fontSize: 30,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Row(
            children: [
              Expanded(
                child:
                _StatChip(
                  label:
                  'UPI',
                  value:
                  '\$${upi.toStringAsFixed(0)}',
                  icon:
                  Icons.qr_code_rounded,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child:
                _StatChip(
                  label:
                  'Cash',
                  value:
                  '\$${cash.toStringAsFixed(0)}',
                  icon:
                  Icons.payments_rounded,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child:
                _StatChip(
                  label:
                  'Profit',
                  value:
                  '\$${profit.toStringAsFixed(0)}',
                  icon:
                  Icons
                      .trending_up_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STAT CHIP
// ============================================================================

class _StatChip
    extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),

      decoration:
      BoxDecoration(
        color:
        Colors.white.withOpacity(
          0.12,
        ),
        borderRadius:
        BorderRadius.circular(
          14,
        ),
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
                color:
                Colors.white,
              ),

              const SizedBox(
                width: 4,
              ),

              Text(
                label,
                style:
                const TextStyle(
                  color:
                  Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            value,
            style:
            const TextStyle(
              color:
              Colors.white,
              fontSize: 14,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ACTION BUTTON
// ============================================================================

class _ActionButton
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return SizedBox(
      height: 48,

      child:
      ElevatedButton(
        onPressed: onTap,

        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          AppColors.primary,
          foregroundColor:
          Colors.white,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),

          elevation: 0,
        ),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              size: 16,
            ),

            const SizedBox(
              width: 8,
            ),

            Text(
              label,
              style:
              const TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CATEGORY CARD
// ============================================================================

class _CategoryCard
    extends StatelessWidget {
  final CategoryCollection
  category;

  final double totalCollection;

  const _CategoryCard({
    required this.category,
    required this.totalCollection,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final ratio =
    totalCollection == 0
        ? 0.0
        : (category.saleAmount /
        totalCollection)
        .clamp(
      0.0,
      1.0,
    );

    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration:
      BoxDecoration(
        color:
        AppColors.surface,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,

                decoration:
                BoxDecoration(
                  color:
                  category
                      .iconBackground,
                  borderRadius:
                  BorderRadius
                      .circular(
                    10,
                  ),
                ),

                child: Icon(
                  category.icon,
                  color:
                  AppColors.primary,
                  size: 18,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  '${category.name} • ${category.unitsSold} pcs',

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

              Text(
                '\$${category.saleAmount.toStringAsFixed(0)}',

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
            height: 10,
          ),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(
              6,
            ),

            child:
            LinearProgressIndicator(
              value: ratio,

              minHeight: 8,

              backgroundColor:
              AppColors
                  .budgetTrack,

              valueColor:
              const AlwaysStoppedAnimation<
                  Color>(
                AppColors.primary,
              ),
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            'Profit: \$${category.profit.toStringAsFixed(0)}',

            style:
            const TextStyle(
              fontSize: 11,
              color:
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAYMENT BREAKDOWN
// ============================================================================

class _PaymentBreakdownCard
    extends StatelessWidget {
  final double upi;
  final double cash;

  const _PaymentBreakdownCard({
    required this.upi,
    required this.cash,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final total =
        upi + cash;

    final upiPercent =
    total == 0
        ? 0
        : (upi /
        total *
        100)
        .round();

    final cashPercent =
    total == 0
        ? 0
        : (cash /
        total *
        100)
        .round();

    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration:
      BoxDecoration(
        color:
        AppColors.surface,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

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
        children: [
          _PaymentRow(
            icon:
            Icons.qr_code_rounded,

            label:
            'UPI Collection',

            amount:
            upi,

            percent:
            upiPercent,

            color:
            AppColors.upiColor,
          ),

          const Divider(
            height: 24,
            color:
            AppColors.divider,
          ),

          _PaymentRow(
            icon:
            Icons.payments_rounded,

            label:
            'Cash Collection',

            amount:
            cash,

            percent:
            cashPercent,

            color:
            AppColors.cashColor,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAYMENT ROW
// ============================================================================

class _PaymentRow
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final int percent;
  final Color color;

  const _PaymentRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,

          decoration:
          BoxDecoration(
            color:
            color.withOpacity(
              0.12,
            ),

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
          width: 12,
        ),

        Expanded(
          child: Text(
            label,

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

        Text(
          '\$${amount.toStringAsFixed(0)}',

          style:
          const TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w700,
            color: AppColors
                .textPrimary,
          ),
        ),

        const SizedBox(
          width: 8,
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
            color.withOpacity(
              0.12,
            ),

            borderRadius:
            BorderRadius.circular(
              8,
            ),
          ),

          child: Text(
            '$percent%',

            style:
            TextStyle(
              fontSize: 11,
              fontWeight:
              FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BILL TILE
// ============================================================================

class _BillTile
    extends StatelessWidget {
  final CollectionBillItem bill;

  const _BillTile({
    required this.bill,
  });

  String _formatTime(
      DateTime date,
      ) {
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
        .padLeft(
      2,
      '0',
    );

    return '$hour:$minute $period';
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final isUpi =
        bill.paymentMode
            .toUpperCase() ==
            'UPI';

    final paymentColor =
    isUpi
        ? AppColors.upiColor
        : AppColors.cashColor;

    return Container(
      padding:
      const EdgeInsets.all(14),

      decoration:
      BoxDecoration(
        color:
        AppColors.surface,

        borderRadius:
        BorderRadius.circular(
          16,
        ),

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

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,

            decoration:
            BoxDecoration(
              color:
              bill.iconBackground,

              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(
              bill.icon,
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
              CrossAxisAlignment
                  .start,

              children: [
                Text(
                  bill.itemName,

                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                    color: AppColors
                        .textPrimary,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  'Bill #${bill.billId} • ${_formatTime(bill.dateTime)} • Qty ${bill.quantity}',

                  style:
                  const TextStyle(
                    fontSize: 11,
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .end,

            children: [
              Text(
                '\$${bill.total.toStringAsFixed(2)}',

                style:
                const TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  AppColors.primary,
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Container(
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 6,
                  vertical: 2,
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
                    6,
                  ),
                ),

                child: Text(
                  bill.paymentMode,

                  style:
                  TextStyle(
                    fontSize: 9.5,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    paymentColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _EmptyState
    extends StatelessWidget {
  final String text;

  const _EmptyState({
    required this.text,
  });

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

      decoration:
      BoxDecoration(
        color:
        AppColors.surface,

        borderRadius:
        BorderRadius.circular(
          16,
        ),
      ),

      child: Column(
        children: [
          const Icon(
            Icons
                .receipt_long_outlined,
            size: 36,
            color:
            AppColors
                .textSecondary,
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            text,

            style:
            const TextStyle(
              color: AppColors
                  .textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}