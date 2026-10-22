import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/employee_salary_repository.dart';
import '../models/salary_history.dart';
import '../models/salary_update_response.dart';

part 'employee_salary_event.dart';
part 'employee_salary_state.dart';

class EmployeeSalaryBloc
    extends Bloc<EmployeeSalaryEvent, EmployeeSalaryState> {
  final EmployeeSalaryRepository _repository;

  EmployeeSalaryBloc({
    EmployeeSalaryRepository? repository,
  }) : _repository =
      repository ?? EmployeeSalaryRepository(),
        super(
        const EmployeeSalaryState(),
      ) {
    on<EmployeeSalaryStarted>(
      _onStarted,
    );

    on<EmployeeSalaryHistoryRequested>(
      _onHistoryRequested,
    );

    on<EmployeeSalaryUpdateRequested>(
      _onUpdateRequested,
    );
  }

  // ============================================================
  // LOAD SALARY HISTORY
  // ============================================================

  Future<void> _onStarted(
      EmployeeSalaryStarted event,
      Emitter<EmployeeSalaryState> emit,
      ) async {
    emit(
      state.copyWith(
        status: EmployeeSalaryStatus.loading,
        clearError: true,
      ),
    );

    try {
      debugPrint(
        'EmployeeSalaryBloc: loading salary history '
            'for employee ${event.employeeId}',
      );

      final history =
      await _repository.getSalaryHistory(
        employeeId: event.employeeId,
      );

      debugPrint(
        'EmployeeSalaryBloc: salary history loaded '
            '${history.length} records',
      );

      emit(
        state.copyWith(
          status: EmployeeSalaryStatus.loaded,
          history: history,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint(
        'EmployeeSalaryBloc: salary history failed -> $e',
      );

      emit(
        state.copyWith(
          status: EmployeeSalaryStatus.error,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }

  // ============================================================
  // LOAD HISTORY
  // ============================================================

  Future<void> _onHistoryRequested(
      EmployeeSalaryHistoryRequested event,
      Emitter<EmployeeSalaryState> emit,
      ) async {
    try {
      debugPrint(
        'EmployeeSalaryBloc: refreshing salary history '
            'for employee ${event.employeeId}',
      );

      final history =
      await _repository.getSalaryHistory(
        employeeId: event.employeeId,
      );

      emit(
        state.copyWith(
          status: EmployeeSalaryStatus.loaded,
          history: history,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint(
        'EmployeeSalaryBloc: history refresh failed -> $e',
      );

      emit(
        state.copyWith(
          status: EmployeeSalaryStatus.error,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }

  // ============================================================
  // UPDATE SALARY
  // ============================================================

  Future<void> _onUpdateRequested(
      EmployeeSalaryUpdateRequested event,
      Emitter<EmployeeSalaryState> emit,
      ) async {
    emit(
      state.copyWith(
        status: EmployeeSalaryStatus.updating,
        clearError: true,
      ),
    );

    try {
      debugPrint(
        'EmployeeSalaryBloc: updating salary '
            'for employee ${event.employeeId}',
      );

      final response =
      await _repository.updateSalary(
        employeeId: event.employeeId,
        monthlySalary: event.monthlySalary,
        effectiveOn: event.effectiveOn,
        reason: event.reason,
      );

      debugPrint(
        'EmployeeSalaryBloc: salary updated -> '
            '${response.employee.monthlySalary}',
      );

      // --------------------------------------------------------
      // LOAD UPDATED HISTORY
      // --------------------------------------------------------

      final history =
      await _repository.getSalaryHistory(
        employeeId: event.employeeId,
      );

      // --------------------------------------------------------
      // EMIT UPDATED
      // --------------------------------------------------------

      emit(
        state.copyWith(
          status: EmployeeSalaryStatus.updated,
          history: history,
          updateResponse: response,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint(
        'EmployeeSalaryBloc: salary update failed -> $e',
      );

      emit(
        state.copyWith(
          status: EmployeeSalaryStatus.error,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }

  // ============================================================
  // ERROR CLEANUP
  // ============================================================

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring(
        'Exception: '.length,
      );
    }

    return message;
  }
}