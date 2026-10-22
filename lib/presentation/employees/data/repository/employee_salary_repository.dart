import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/token_service.dart';
import '../../models/salary_history.dart';
import '../../models/salary_update_response.dart';

class EmployeeSalaryRepository {
  EmployeeSalaryRepository({
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
  // UPDATE SALARY
  //
  // PATCH /api/mobile/employees/{id}/salary/
  // ============================================================

  Future<SalaryUpdateResponse> updateSalary({
    required int employeeId,
    required String monthlySalary,
    String? effectiveOn,
    String? reason,
  }) async {
    final url =
    ApiConstants.employeeSalary(employeeId);

    final Map<String, dynamic> body = {
      'monthly_salary': monthlySalary,
    };

    if (effectiveOn != null &&
        effectiveOn.isNotEmpty) {
      body['effective_on'] = effectiveOn;
    }

    if (reason != null &&
        reason.trim().isNotEmpty) {
      body['reason'] = reason.trim();
    }

    debugPrint(
      'EmployeeSalaryRepository -> PATCH $url',
    );

    debugPrint(
      'EmployeeSalaryRepository -> body $body',
    );

    final response = await _client.patch(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    debugPrint(
      'EmployeeSalaryRepository <- status '
          '${response.statusCode}',
    );

    debugPrint(
      'EmployeeSalaryRepository <- body '
          '${response.body}',
    );

    if (response.statusCode == 200) {
      final data =
      jsonDecode(response.body)
      as Map<String, dynamic>;

      return SalaryUpdateResponse.fromJson(data);
    }

    throw Exception(
      _getErrorMessage(response),
    );
  }

  // ============================================================
  // GET SALARY HISTORY
  //
  // GET /api/mobile/employees/{id}/salary-history/
  // ============================================================

  Future<List<SalaryHistory>> getSalaryHistory({
    required int employeeId,
  }) async {
    final url =
    ApiConstants.employeeSalaryHistory(
      employeeId,
    );

    debugPrint(
      'EmployeeSalaryRepository -> GET $url',
    );

    final response = await _client.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    debugPrint(
      'EmployeeSalaryRepository <- status '
          '${response.statusCode}',
    );

    debugPrint(
      'EmployeeSalaryRepository <- body '
          '${response.body}',
    );

    if (response.statusCode == 200) {
      final data =
      jsonDecode(response.body)
      as Map<String, dynamic>;

      final List<dynamic> results =
          data['results'] as List<dynamic>? ?? [];

      return results
          .map(
            (item) => SalaryHistory.fromJson(
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
  // ERROR
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

        // Example:
        //
        // {
        //   "monthly_salary": [
        //     "New salary must differ from current salary."
        //   ]
        // }

        if (data['monthly_salary'] is List) {
          final errors =
          data['monthly_salary'] as List;

          if (errors.isNotEmpty) {
            return errors.first.toString();
          }
        }

        return data.entries
            .map(
              (entry) =>
          '${entry.key}: ${entry.value}',
        )
            .join('\n');
      }
    } catch (_) {}

    return 'Request failed (${response.statusCode})';
  }
}