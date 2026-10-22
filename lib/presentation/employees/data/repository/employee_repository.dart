import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/token_service.dart';
import '../../models/employee.dart';

class EmployeeRepository {
  EmployeeRepository({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  // ============================================================
  // HEADERS
  // ============================================================

  Future<Map<String, String>> _headers() async {
    final token =
    await TokenService.instance.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  // ============================================================
  // GET ALL EMPLOYEES
  // GET /api/mobile/employees/
  // ============================================================

  Future<List<Employee>> getEmployees() async {
    final url = ApiConstants.employees;

    print('EmployeeRepository -> GET $url');

    final response = await _client.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    print(
      'EmployeeRepository <- GET '
          '${response.statusCode}',
    );

    print(
      'EmployeeRepository <- body '
          '${response.body}',
    );

    if (response.statusCode == 200) {
      final data =
      jsonDecode(response.body)
      as Map<String, dynamic>;

      final results =
          data['results'] as List<dynamic>? ?? [];

      return results
          .map(
            (item) => Employee.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    throw Exception(
      _getErrorMessage(response),
    );
  }

  // ============================================================
  // GET SINGLE EMPLOYEE
  // GET /api/mobile/employees/{id}/
  // ============================================================

  Future<Employee> getEmployee(
      int id,
      ) async {
    final url =
    ApiConstants.employeeById(id);

    print(
      'EmployeeRepository -> GET $url',
    );

    final response = await _client.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    print(
      'EmployeeRepository <- GET '
          '${response.statusCode}',
    );

    print(
      'EmployeeRepository <- body '
          '${response.body}',
    );

    if (response.statusCode == 200) {
      final data =
      jsonDecode(response.body)
      as Map<String, dynamic>;

      return Employee.fromJson(data);
    }

    throw Exception(
      _getErrorMessage(response),
    );
  }

  // ============================================================
  // CREATE EMPLOYEE
  // POST /api/mobile/employees/
  // ============================================================

  Future<Employee> createEmployee({
    required String email,
    required String username,
    required String name,
    required String phone,
    required String role,
    required String jobTitle,
    required String monthlySalary,
    required String password,
  }) async {
    final url = ApiConstants.employees;

    final body = {
      'email': email,
      'username': username,
      'name': name,
      'phone': phone,
      'role': role,
      'job_title': jobTitle,
      'monthly_salary': monthlySalary,
      'password': password,
    };

    print(
      'EmployeeRepository -> POST $url',
    );

    print(
      'EmployeeRepository -> body $body',
    );

    final response = await _client.post(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    print(
      'EmployeeRepository <- POST '
          '${response.statusCode}',
    );

    print(
      'EmployeeRepository <- body '
          '${response.body}',
    );

    if (response.statusCode == 201) {
      final data =
      jsonDecode(response.body)
      as Map<String, dynamic>;

      return Employee.fromJson(data);
    }

    throw Exception(
      _getErrorMessage(response),
    );
  }

  // ============================================================
  // UPDATE EMPLOYEE
  // PATCH /api/mobile/employees/{id}/
  // ============================================================

  Future<Employee> updateEmployee({
    required int id,
    String? name,
    String? phone,
    String? jobTitle,
    String? email,
    String? username,
    String? role,
  }) async {
    final url =
    ApiConstants.employeeById(id);

    final Map<String, dynamic> body = {};

    if (name != null) {
      body['name'] = name;
    }

    if (phone != null) {
      body['phone'] = phone;
    }

    if (jobTitle != null) {
      body['job_title'] = jobTitle;
    }

    if (email != null) {
      body['email'] = email;
    }

    if (username != null) {
      body['username'] = username;
    }

    if (role != null) {
      body['role'] = role;
    }

    print(
      'EmployeeRepository -> PATCH $url',
    );

    print(
      'EmployeeRepository -> body $body',
    );

    final response = await _client.patch(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    print(
      'EmployeeRepository <- PATCH '
          '${response.statusCode}',
    );

    print(
      'EmployeeRepository <- body '
          '${response.body}',
    );

    if (response.statusCode == 200) {
      final data =
      jsonDecode(response.body)
      as Map<String, dynamic>;

      return Employee.fromJson(data);
    }

    throw Exception(
      _getErrorMessage(response),
    );
  }

  // ============================================================
  // DELETE / DEACTIVATE EMPLOYEE
  // DELETE /api/mobile/employees/{id}/
  // ============================================================

  Future<void> deleteEmployee(
      int id,
      ) async {
    final url =
    ApiConstants.employeeById(id);

    print(
      'EmployeeRepository -> DELETE $url',
    );

    final response = await _client.delete(
      Uri.parse(url),
      headers: await _headers(),
    );

    print(
      'EmployeeRepository <- DELETE '
          '${response.statusCode}',
    );

    if (response.statusCode == 204) {
      return;
    }

    print(
      'EmployeeRepository <- body '
          '${response.body}',
    );

    throw Exception(
      _getErrorMessage(response),
    );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getErrorMessage(
      http.Response response,
      ) {
    try {
      if (response.body.isEmpty) {
        return 'Request failed (${response.statusCode})';
      }

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        if (data['detail'] != null) {
          return data['detail'].toString();
        }

        return data.entries
            .map(
              (entry) =>
          '${entry.key}: ${entry.value}',
        )
            .join('\n');
      }

      return data.toString();
    } catch (_) {
      return 'Request failed (${response.statusCode})';
    }
  }
}