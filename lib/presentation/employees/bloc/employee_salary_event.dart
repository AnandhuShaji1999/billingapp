part of 'employee_salary_bloc.dart';

abstract class EmployeeSalaryEvent {}

// ============================================================
// LOAD SALARY PAGE
// ============================================================

class EmployeeSalaryStarted
    extends EmployeeSalaryEvent {
  final int employeeId;

  EmployeeSalaryStarted({
    required this.employeeId,
  });
}

// ============================================================
// UPDATE SALARY
// ============================================================

class EmployeeSalaryUpdateRequested
    extends EmployeeSalaryEvent {
  final int employeeId;
  final String monthlySalary;
  final String? effectiveOn;
  final String? reason;

  EmployeeSalaryUpdateRequested({
    required this.employeeId,
    required this.monthlySalary,
    this.effectiveOn,
    this.reason,
  });
}

// ============================================================
// LOAD SALARY HISTORY
// ============================================================

class EmployeeSalaryHistoryRequested
    extends EmployeeSalaryEvent {
  final int employeeId;

  EmployeeSalaryHistoryRequested({
    required this.employeeId,
  });
}