
import 'employee.dart';
import 'salary_history.dart';

class SalaryUpdateResponse {
  final Employee employee;
  final SalaryHistory salaryChange;

  const SalaryUpdateResponse({
    required this.employee,
    required this.salaryChange,
  });

  factory SalaryUpdateResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return SalaryUpdateResponse(
      employee: Employee.fromJson(
        json['employee'] as Map<String, dynamic>,
      ),
      salaryChange: SalaryHistory.fromJson(
        json['salary_change']
        as Map<String, dynamic>,
      ),
    );
  }
}