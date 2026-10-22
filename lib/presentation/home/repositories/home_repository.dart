


import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_client.dart';
import '../models/home_response_model.dart';

class HomeException implements Exception {
  final String message;

  HomeException(this.message);

  @override
  String toString() => message;
}

class HomeRepository {
  final ApiClient _apiClient;

  HomeRepository({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient.instance;

  /// ------------------------------------------------------------
  /// GET HOME DASHBOARD
  ///
  /// API:
  /// GET /api/mobile/home/?month=2026-09
  ///
  /// Example:
  /// final response = await repository.getHome(
  ///   month: '2026-09',
  /// );
  /// ------------------------------------------------------------
  Future<HomeResponseModel> getHome({
    required String month,
  }) async {
    try {
      final uri = Uri.parse(
        ApiConstants.homeForMonth(month),
      );

      debugPrint('========================================');
      debugPrint('HOME REPOSITORY');
      debugPrint('GET HOME API');
      debugPrint('URL: $uri');
      debugPrint('MONTH: $month');
      debugPrint('========================================');

      final response = await _apiClient.get(uri);

      debugPrint('========================================');
      debugPrint('HOME API RESPONSE');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');
      debugPrint('========================================');

      // ----------------------------------------------------------
      // HTTP ERROR
      // ----------------------------------------------------------

      if (response.statusCode != 200) {
        throw HomeException(
          'Failed to load home data '
              '(${response.statusCode})',
        );
      }

      // ----------------------------------------------------------
      // EMPTY RESPONSE
      // ----------------------------------------------------------

      if (response.body.isEmpty) {
        throw HomeException(
          'Home API returned an empty response.',
        );
      }

      // ----------------------------------------------------------
      // DECODE JSON
      // ----------------------------------------------------------

      dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } catch (e) {
        debugPrint(
          'HOME JSON DECODE ERROR: $e',
        );

        throw HomeException(
          'Invalid JSON response from home API.',
        );
      }

      // ----------------------------------------------------------
      // CHECK RESPONSE OBJECT
      // ----------------------------------------------------------

      if (decoded is! Map<String, dynamic>) {
        debugPrint(
          'HOME API INVALID RESPONSE TYPE: '
              '${decoded.runtimeType}',
        );

        throw HomeException(
          'Invalid response format from home API.',
        );
      }

      final json = decoded;

      debugPrint(
        'HOME API JSON KEYS: ${json.keys.toList()}',
      );

      // ----------------------------------------------------------
      // PARSE MODEL
      // ----------------------------------------------------------

      final homeResponse =
      HomeResponseModel.fromJson(json);

      // ----------------------------------------------------------
      // DEBUG PARSED DATA
      // ----------------------------------------------------------

      debugPrint('========================================');
      debugPrint('HOME PARSED DATA');
      debugPrint(
        'Month: ${homeResponse.month}',
      );
      debugPrint(
        'Total Sales: ${homeResponse.totalSales}',
      );
      debugPrint(
        'Income: ${homeResponse.income}',
      );
      debugPrint(
        'Expense: ${homeResponse.expense}',
      );
      debugPrint(
        'Cost Of Goods: ${homeResponse.costOfGoods}',
      );
      debugPrint(
        'Profit: ${homeResponse.profit}',
      );

      debugPrint(
        'Sales Trend Count: '
            '${homeResponse.salesTrend.length}',
      );

      debugPrint(
        'Transactions Count: '
            '${homeResponse.transactions.length}',
      );

      debugPrint(
        'Monthly Budgets Count: '
            '${homeResponse.monthlyBudgets.length}',
      );

      debugPrint(
        'Recent Activity Count: '
            '${homeResponse.recentActivity.length}',
      );

      debugPrint('========================================');

      return homeResponse;
    } on HomeException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );

      debugPrint(
        'HOME REPOSITORY ERROR',
      );

      debugPrint(
        'ERROR: $e',
      );

      debugPrint(
        'STACK TRACE: $stackTrace',
      );

      debugPrint(
        '========================================',
      );

      throw HomeException(
        'Unable to load home dashboard.',
      );
    }
  }
}