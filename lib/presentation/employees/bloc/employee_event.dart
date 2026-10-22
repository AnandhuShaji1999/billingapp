part of 'employee_bloc.dart';

abstract class EmployeeEvent {
  const EmployeeEvent();
}

class EmployeesLoadRequested extends EmployeeEvent {
  const EmployeesLoadRequested();
}

class EmployeeCreateRequested extends EmployeeEvent {
  final String email;
  final String username;
  final String name;
  final String phone;
  final String role;
  final String jobTitle;
  final String monthlySalary;
  final String password;

  const EmployeeCreateRequested({
    required this.email,
    required this.username,
    required this.name,
    required this.phone,
    required this.role,
    required this.jobTitle,
    required this.monthlySalary,
    required this.password,
  });
}

class EmployeeUpdateRequested extends EmployeeEvent {
  final int id;
  final String? name;
  final String? phone;
  final String? jobTitle;
  final String? email;
  final String? username;
  final String? role;

  const EmployeeUpdateRequested({
    required this.id,
    this.name,
    this.phone,
    this.jobTitle,
    this.email,
    this.username,
    this.role,
  });
}

class EmployeeDeleteRequested extends EmployeeEvent {
  final int id;

  const EmployeeDeleteRequested(this.id);
}