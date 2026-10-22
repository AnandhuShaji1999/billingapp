import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../bloc/employee_salary_bloc.dart';
import '../../models/employee.dart';
import '../../models/salary_history.dart';

class EmployeeSalaryPage extends StatelessWidget {
  final Employee employee;

  const EmployeeSalaryPage({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeSalaryBloc()
        ..add(
          EmployeeSalaryStarted(
            employeeId: employee.id,
          ),
        ),
      child: _EmployeeSalaryView(
        employee: employee,
      ),
    );
  }
}

class _EmployeeSalaryView extends StatelessWidget {
  final Employee employee;

  const _EmployeeSalaryView({
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Salary & History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      body: BlocConsumer<EmployeeSalaryBloc, EmployeeSalaryState>(
        listener: (context, state) {
          if (state.status == EmployeeSalaryStatus.updated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Salary updated successfully',
                ),
                backgroundColor: AppColors.success,
              ),
            );
          }

          if (state.status == EmployeeSalaryStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Something went wrong',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },

        builder: (context, state) {
          if (state.status == EmployeeSalaryStatus.loading &&
              state.history.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<EmployeeSalaryBloc>()
                  .add(
                EmployeeSalaryHistoryRequested(
                  employeeId: employee.id,
                ),
              );
            },

            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ============================================================
                // EMPLOYEE HEADER
                // ============================================================

                _EmployeeHeader(
                  employee: employee,
                ),

                const SizedBox(height: 16),

                // ============================================================
                // CURRENT SALARY
                // ============================================================

                _CurrentSalaryCard(
                  salary: state.updateResponse
                      ?.employee
                      .monthlySalary ??
                      employee.monthlySalary,
                  onUpdate: () {
                    _showUpdateSalarySheet(
                      context,
                      employee,
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ============================================================
                // HISTORY HEADER
                // ============================================================

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Salary History',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    Text(
                      '${state.history.length} records',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ============================================================
                // HISTORY
                // ============================================================

                if (state.history.isEmpty)
                  const _EmptyHistory()
                else
                  ...state.history.map(
                        (item) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: _SalaryHistoryCard(
                        history: item,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================================================================
  // OPEN UPDATE SALARY SHEET
  // ==========================================================================

  void _showUpdateSalarySheet(
      BuildContext context,
      Employee employee,
      ) {
    // Get the existing bloc BEFORE opening the modal.
    final salaryBloc =
    context.read<EmployeeSalaryBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (_) {
        // Pass the SAME bloc into the bottom sheet.
        return BlocProvider.value(
          value: salaryBloc,
          child: _UpdateSalarySheet(
            employee: employee,
          ),
        );
      },
    );
  }
}

// ============================================================================
// UPDATE SALARY SHEET
// ============================================================================

class _UpdateSalarySheet extends StatefulWidget {
  final Employee employee;

  const _UpdateSalarySheet({
    required this.employee,
  });

  @override
  State<_UpdateSalarySheet> createState() =>
      _UpdateSalarySheetState();
}

class _UpdateSalarySheetState
    extends State<_UpdateSalarySheet> {
  late final TextEditingController salaryController;
  late final TextEditingController reasonController;

  DateTime selectedDate = DateTime.now();

  bool saving = false;

  @override
  void initState() {
    super.initState();

    salaryController =
        TextEditingController();

    reasonController =
        TextEditingController();
  }

  @override
  void dispose() {
    salaryController.dispose();
    reasonController.dispose();

    super.dispose();
  }

  // ==========================================================================
  // UPDATE SALARY
  // ==========================================================================

  Future<void> _updateSalary() async {
    if (saving) {
      return;
    }

    // ------------------------------------------------------------------------
    // VALIDATE SALARY
    // ------------------------------------------------------------------------

    final salary =
    salaryController.text.trim();

    if (salary.isEmpty) {
      _showMessage(
        'Please enter new salary',
      );
      return;
    }

    final value =
    double.tryParse(salary);

    if (value == null) {
      _showMessage(
        'Please enter a valid salary',
      );
      return;
    }

    if (value ==
        widget.employee.monthlySalary) {
      _showMessage(
        'New salary must differ from current salary.',
      );
      return;
    }

    // ------------------------------------------------------------------------
    // DATE
    // ------------------------------------------------------------------------

    final date =
        '${selectedDate.year.toString().padLeft(4, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';

    final reason =
    reasonController.text.trim();

    // ------------------------------------------------------------------------
    // DEBUG
    // ------------------------------------------------------------------------

    debugPrint(
      '========================================',
    );

    debugPrint(
      'SALARY UPDATE',
    );

    debugPrint(
      'Employee ID: ${widget.employee.id}',
    );

    debugPrint(
      'Old Salary: ${widget.employee.monthlySalary}',
    );

    debugPrint(
      'New Salary: $value',
    );

    debugPrint(
      'Effective On: $date',
    );

    debugPrint(
      'Reason: $reason',
    );

    debugPrint(
      'Dispatching EmployeeSalaryUpdateRequested',
    );

    debugPrint(
      '========================================',
    );

    // ------------------------------------------------------------------------
    // SET LOADING
    // ------------------------------------------------------------------------

    setState(() {
      saving = true;
    });

    // ------------------------------------------------------------------------
    // GET BLOC
    // ------------------------------------------------------------------------

    final bloc =
    context.read<EmployeeSalaryBloc>();

    // ------------------------------------------------------------------------
    // WAIT FOR ACTUAL API RESULT
    //
    // We create the Future BEFORE dispatching the event.
    // This prevents missing the updated state.
    // ------------------------------------------------------------------------

    final resultFuture =
    bloc.stream.firstWhere(
          (state) =>
      state.status ==
          EmployeeSalaryStatus.updated ||
          state.status ==
              EmployeeSalaryStatus.error,
    );

    // ------------------------------------------------------------------------
    // SEND UPDATE REQUEST
    // ------------------------------------------------------------------------

    bloc.add(
      EmployeeSalaryUpdateRequested(
        employeeId:
        widget.employee.id,
        monthlySalary:
        value.toStringAsFixed(2),
        effectiveOn:
        date,
        reason:
        reason,
      ),
    );

    // ------------------------------------------------------------------------
    // WAIT FOR BLOC RESULT
    // ------------------------------------------------------------------------

    final result =
    await resultFuture;

    if (!mounted) {
      return;
    }

    // ------------------------------------------------------------------------
    // SUCCESS
    // ------------------------------------------------------------------------

    if (result.status ==
        EmployeeSalaryStatus.updated) {
      Navigator.of(context).pop();
      return;
    }

    // ------------------------------------------------------------------------
    // ERROR
    // ------------------------------------------------------------------------

    setState(() {
      saving = false;
    });

    _showMessage(
      result.errorMessage ??
          'Failed to update salary',
    );
  }

  // ==========================================================================
  // DATE PICKER
  // ==========================================================================

  Future<void> _selectDate() async {
    if (saving) {
      return;
    }

    final picked =
    await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
    );

    if (picked == null ||
        !mounted) {
      return;
    }

    setState(() {
      selectedDate = picked;
    });
  }

  // ==========================================================================
  // MESSAGE
  // ==========================================================================

  void _showMessage(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        AppColors.error,
      ),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight:
          MediaQuery.of(context)
              .size
              .height *
              0.85,
        ),

        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
          BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
            MediaQuery.of(context)
                .viewInsets
                .bottom +
                20,
          ),

          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // ==============================================================
              // HEADER
              // ==============================================================

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Update Salary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: saving
                        ? null
                        : () {
                      Navigator.of(
                        context,
                      ).pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ==============================================================
              // CURRENT SALARY
              // ==============================================================

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(14),

                decoration:
                BoxDecoration(
                  color:
                  AppColors.background,
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .payments_outlined,
                      color:
                      AppColors.primary,
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    const Text(
                      'Current Salary',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '₹${widget.employee.monthlySalary.toStringAsFixed(2)}',
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ==============================================================
              // NEW SALARY
              // ==============================================================

              TextField(
                controller:
                salaryController,
                enabled: !saving,

                keyboardType:
                const TextInputType
                    .numberWithOptions(
                  decimal: true,
                ),

                decoration:
                InputDecoration(
                  labelText:
                  'New Monthly Salary',

                  prefixIcon:
                  const Icon(
                    Icons.currency_rupee,
                  ),

                  filled: true,

                  fillColor:
                  AppColors.background,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ==============================================================
              // EFFECTIVE DATE
              // ==============================================================

              InkWell(
                onTap: saving
                    ? null
                    : _selectDate,

                child: Container(
                  width: double.infinity,

                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),

                  decoration:
                  BoxDecoration(
                    color:
                    AppColors.background,
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .calendar_today_outlined,
                        size: 20,
                        color: AppColors
                            .textSecondary,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      const Text(
                        'Effective Date',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        _formatDate(
                          selectedDate,
                        ),
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.w600,
                          color: AppColors
                              .textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ==============================================================
              // REASON
              // ==============================================================

              TextField(
                controller:
                reasonController,
                enabled: !saving,
                maxLines: 2,

                decoration:
                InputDecoration(
                  labelText: 'Reason',
                  hintText:
                  'Annual salary revision',

                  filled: true,

                  fillColor:
                  AppColors.background,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==============================================================
              // UPDATE BUTTON
              // ==============================================================

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: saving
                      ? null
                      : _updateSalary,

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.primary,
                    foregroundColor:
                    Colors.white,
                    disabledBackgroundColor:
                    Colors.grey.shade300,
                    elevation: 0,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),

                  child: saving
                      ? const SizedBox(
                    width: 20,
                    height: 20,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,

                      valueColor:
                      AlwaysStoppedAnimation<
                          Color>(
                        Colors.white,
                      ),
                    ),
                  )
                      : const Text(
                    'Update Salary',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EMPLOYEE HEADER
// ============================================================================

class _EmployeeHeader
    extends StatelessWidget {
  final Employee employee;

  const _EmployeeHeader({
    required this.employee,
  });

  String get initials {
    final parts = employee.name
        .trim()
        .split(' ')
        .where(
          (e) => e.isNotEmpty,
    )
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    return parts
        .map(
          (e) => e[0],
    )
        .take(2)
        .join()
        .toUpperCase();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient:
        const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
            Colors.white
                .withOpacity(0.2),

            child: Text(
              initials,
              style:
              const TextStyle(
                color: Colors.white,
                fontWeight:
                FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  employee.name,
                  style:
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  employee.jobTitle.isEmpty
                      ? employee.role
                      : employee.jobTitle,

                  style:
                  const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
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

// ============================================================================
// CURRENT SALARY CARD
// ============================================================================

class _CurrentSalaryCard
    extends StatelessWidget {
  final double salary;
  final VoidCallback onUpdate;

  const _CurrentSalaryCard({
    required this.salary,
    required this.onUpdate,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black
                .withOpacity(0.03),
            blurRadius: 8,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration:
                BoxDecoration(
                  color: AppColors.success
                      .withOpacity(0.12),

                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),

                child: const Icon(
                  Icons.payments_rounded,
                  color:
                  AppColors.success,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Current Monthly Salary',
                  style: TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),

              Text(
                '₹${salary.toStringAsFixed(2)}',

                style:
                const TextStyle(
                  color:
                  AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 46,

            child:
            ElevatedButton.icon(
              onPressed: onUpdate,

              icon: const Icon(
                Icons.edit_rounded,
                size: 18,
              ),

              label: const Text(
                'Update Salary',
              ),

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppColors.primary,
                foregroundColor:
                Colors.white,
                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SALARY HISTORY CARD
// ============================================================================

class _SalaryHistoryCard
    extends StatelessWidget {
  final SalaryHistory history;

  const _SalaryHistoryCard({
    required this.history,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final increase =
        history.newSalary >
            history.previousSalary;

    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: Colors.black
              .withOpacity(0.04),
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration:
                BoxDecoration(
                  color: increase
                      ? AppColors.success
                      .withOpacity(0.12)
                      : AppColors.primary
                      .withOpacity(0.12),

                  shape:
                  BoxShape.circle,
                ),

                child: Icon(
                  increase
                      ? Icons
                      .trending_up_rounded
                      : Icons
                      .payments_outlined,

                  color: increase
                      ? AppColors.success
                      : AppColors.primary,

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
                      history.reason.isEmpty
                          ? 'Salary Change'
                          : history.reason,

                      style:
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppColors
                            .textPrimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Effective ${history.effectiveOn}',

                      style:
                      const TextStyle(
                        fontSize: 11,
                        color:
                        AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _SalaryValue(
                  label: 'Previous',
                  value:
                  '₹${history.previousSalary.toStringAsFixed(2)}',
                ),
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color:
                AppColors.textSecondary,
              ),

              Expanded(
                child: _SalaryValue(
                  label: 'New Salary',
                  value:
                  '₹${history.newSalary.toStringAsFixed(2)}',
                  highlight: true,
                ),
              ),
            ],
          ),

          if (history.createdAt !=
              null) ...[
            const SizedBox(height: 12),

            Align(
              alignment:
              Alignment.centerLeft,

              child: Text(
                'Recorded ${_formatDateTime(history.createdAt!)}',

                style:
                const TextStyle(
                  fontSize: 10,
                  color:
                  AppColors
                      .textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// SALARY VALUE
// ============================================================================

class _SalaryValue
    extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SalaryValue({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style:
          const TextStyle(
            fontSize: 10,
            color:
            AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,

          style: TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w700,

            color: highlight
                ? AppColors.success
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// EMPTY HISTORY
// ============================================================================

class _EmptyHistory
    extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(16),
      ),

      child: const Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 42,
            color:
            AppColors.textSecondary,
          ),

          SizedBox(height: 10),

          Text(
            'No salary history',
            style: TextStyle(
              fontWeight:
              FontWeight.w600,
              color:
              AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DATE HELPERS
// ============================================================================

String _formatDate(
    DateTime date,
    ) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

String _formatDateTime(
    DateTime date,
    ) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
