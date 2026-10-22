part of 'employee_bloc.dart';

enum EmployeeStatus {
  initial,
  loading,
  loaded,
  creating,
  created,
  updating,
  updated,
  deleting,
  deleted,
  error,
}

class EmployeeState {
  final EmployeeStatus status;
  final List<Employee> employees;
  final String? errorMessage;
  final Employee? createdEmployee;
  final Employee? updatedEmployee;
  final int? deletedEmployeeId;

  const EmployeeState({
    required this.status,
    this.employees = const [],
    this.errorMessage,
    this.createdEmployee,
    this.updatedEmployee,
    this.deletedEmployeeId,
  });

  const EmployeeState.initial()
      : status = EmployeeStatus.initial,
        employees = const [],
        errorMessage = null,
        createdEmployee = null,
        updatedEmployee = null,
        deletedEmployeeId = null;

  EmployeeState copyWith({
    EmployeeStatus? status,
    List<Employee>? employees,
    String? errorMessage,
    Employee? createdEmployee,
    Employee? updatedEmployee,
    int? deletedEmployeeId,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      errorMessage: errorMessage,
      createdEmployee: createdEmployee ?? this.createdEmployee,
      updatedEmployee: updatedEmployee ?? this.updatedEmployee,
      deletedEmployeeId: deletedEmployeeId ?? this.deletedEmployeeId,
    );
  }
}

class EmployeeInitial extends EmployeeState {
  const EmployeeInitial()
      : super(
    status: EmployeeStatus.initial,
  );
}