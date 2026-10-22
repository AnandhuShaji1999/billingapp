import 'package:flutter_bloc/flutter_bloc.dart';


import '../data/repository/employee_repository.dart';
import '../models/employee.dart';


part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc({
    EmployeeRepository? repository,
  })  : _repository = repository ?? EmployeeRepository(),
        super(const EmployeeInitial()) {
    on<EmployeesLoadRequested>(_onLoadEmployees);
    on<EmployeeCreateRequested>(_onCreateEmployee);
    on<EmployeeUpdateRequested>(_onUpdateEmployee);
    on<EmployeeDeleteRequested>(_onDeleteEmployee);
  }

  final EmployeeRepository _repository;

  Future<void> _onLoadEmployees(
      EmployeesLoadRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    emit(
      state.copyWith(
        status: EmployeeStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final employees = await _repository.getEmployees();

      emit(
        state.copyWith(
          status: EmployeeStatus.loaded,
          employees: employees,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateEmployee(
      EmployeeCreateRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    emit(
      state.copyWith(
        status: EmployeeStatus.creating,
        errorMessage: null,
      ),
    );

    try {
      final employee = await _repository.createEmployee(
        email: event.email,
        username: event.username,
        name: event.name,
        phone: event.phone,
        role: event.role,
        jobTitle: event.jobTitle,
        monthlySalary: event.monthlySalary,
        password: event.password,
      );

      final updatedEmployees = [
        ...state.employees,
        employee,
      ];

      emit(
        state.copyWith(
          status: EmployeeStatus.created,
          employees: updatedEmployees,
          createdEmployee: employee,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateEmployee(
      EmployeeUpdateRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    emit(
      state.copyWith(
        status: EmployeeStatus.updating,
        errorMessage: null,
      ),
    );

    try {
      final updatedEmployee = await _repository.updateEmployee(
        id: event.id,
        name: event.name,
        phone: event.phone,
        jobTitle: event.jobTitle,
        email: event.email,
        username: event.username,
        role: event.role,
      );

      final updatedEmployees = state.employees.map((employee) {
        if (employee.id == updatedEmployee.id) {
          return updatedEmployee;
        }

        return employee;
      }).toList();

      emit(
        state.copyWith(
          status: EmployeeStatus.updated,
          employees: updatedEmployees,
          updatedEmployee: updatedEmployee,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteEmployee(
      EmployeeDeleteRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    emit(
      state.copyWith(
        status: EmployeeStatus.deleting,
        errorMessage: null,
      ),
    );

    try {
      await _repository.deleteEmployee(event.id);

      final updatedEmployees = state.employees
          .where(
            (employee) => employee.id != event.id,
      )
          .toList();

      emit(
        state.copyWith(
          status: EmployeeStatus.deleted,
          employees: updatedEmployees,
          deletedEmployeeId: event.id,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}