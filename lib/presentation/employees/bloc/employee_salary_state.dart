part of 'employee_salary_bloc.dart';

enum EmployeeSalaryStatus {
  initial,
  loading,
  loaded,
  updating,
  updated,
  error,
}

class EmployeeSalaryState {
  final EmployeeSalaryStatus status;

  final List<SalaryHistory> history;

  final SalaryUpdateResponse? updateResponse;

  final String? errorMessage;

  const EmployeeSalaryState({
    this.status = EmployeeSalaryStatus.initial,
    this.history = const [],
    this.updateResponse,
    this.errorMessage,
  });

  EmployeeSalaryState copyWith({
    EmployeeSalaryStatus? status,
    List<SalaryHistory>? history,
    SalaryUpdateResponse? updateResponse,
    String? errorMessage,
    bool clearError = false,
    bool clearUpdateResponse = false,
  }) {
    return EmployeeSalaryState(
      status: status ?? this.status,
      history: history ?? this.history,
      updateResponse: clearUpdateResponse
          ? null
          : updateResponse ?? this.updateResponse,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}