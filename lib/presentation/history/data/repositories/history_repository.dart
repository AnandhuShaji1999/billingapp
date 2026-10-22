import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_client.dart';
import '../../models/history_response_model.dart';


class HistoryException
    implements Exception {
  final String message;

  HistoryException(this.message);

  @override
  String toString() => message;
}

class HistoryRepository {
  final ApiClient _apiClient;

  HistoryRepository({
    ApiClient? apiClient,
  }) : _apiClient =
      apiClient ?? ApiClient.instance;

  // ======================================================
  // GET HISTORY
  // ======================================================

  Future<HistoryResponseModel> getHistory({
    required String period,
    DateTime? date,
    DateTime? month,
  }) async {
    try {
      final queryParameters =
      <String, String>{
        'period': period,
      };

      if (period == 'date' &&
          date != null) {
        queryParameters['date'] =
            _formatDate(date);
      }

      if (period == 'month' &&
          month != null) {
        queryParameters['month'] =
            _formatMonth(month);
      }

      final uri = Uri.parse(
        ApiConstants.history,
      ).replace(
        queryParameters:
        queryParameters,
      );

      debugPrint(
        '========================================',
      );

      debugPrint(
        'HISTORY REPOSITORY',
      );

      debugPrint(
        'GET HISTORY API',
      );

      debugPrint(
        'PERIOD: $period',
      );

      debugPrint(
        'URL: $uri',
      );

      debugPrint(
        '========================================',
      );

      final response =
      await _apiClient.get(uri);

      debugPrint(
        'HISTORY API STATUS: '
            '${response.statusCode}',
      );

      debugPrint(
        'HISTORY API BODY: '
            '${response.body}',
      );

      if (response.statusCode != 200) {
        throw HistoryException(
          'Failed to load history '
              '(${response.statusCode})',
        );
      }

      if (response.body.isEmpty) {
        throw HistoryException(
          'History API returned empty response.',
        );
      }

      dynamic decoded;

      try {
        decoded =
            jsonDecode(response.body);
      } catch (e) {
        debugPrint(
          'HISTORY JSON ERROR: $e',
        );

        throw HistoryException(
          'Invalid JSON response from history API.',
        );
      }

      if (decoded
      is! Map<String, dynamic>) {
        throw HistoryException(
          'Invalid history response format.',
        );
      }

      final result =
      HistoryResponseModel.fromJson(
        decoded,
      );

      debugPrint(
        '========================================',
      );

      debugPrint(
        'HISTORY PARSED',
      );

      debugPrint(
        'Period: ${result.period}',
      );

      debugPrint(
        'Start: ${result.startDate}',
      );

      debugPrint(
        'End: ${result.endDate}',
      );

      debugPrint(
        'Collection: ${result.collection}',
      );

      debugPrint(
        'Bills: ${result.billCount}',
      );

      debugPrint(
        'Insights: '
            '${result.collectionInsights.length}',
      );

      debugPrint(
        'Transactions: '
            '${result.transactions.length}',
      );

      debugPrint(
        '========================================',
      );

      return result;
    } on HistoryException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );

      debugPrint(
        'HISTORY REPOSITORY ERROR',
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

      throw HistoryException(
        'Unable to load history.',
      );
    }
  }

  // ======================================================
  // DOWNLOAD HISTORY PDF
  // ======================================================

  Future<http.Response>
  downloadHistoryReport({
    required String period,
    DateTime? date,
    DateTime? month,
  }) async {
    try {
      final queryParameters =
      <String, String>{
        'period': period,
      };

      if (period == 'date' &&
          date != null) {
        queryParameters['date'] =
            _formatDate(date);
      }

      if (period == 'month' &&
          month != null) {
        queryParameters['month'] =
            _formatMonth(month);
      }

      final uri = Uri.parse(
        ApiConstants.historyReport,
      ).replace(
        queryParameters:
        queryParameters,
      );

      debugPrint(
        '========================================',
      );

      debugPrint(
        'HISTORY PDF REPOSITORY',
      );

      debugPrint(
        'PERIOD: $period',
      );

      debugPrint(
        'DATE: $date',
      );

      debugPrint(
        'MONTH: $month',
      );

      debugPrint(
        'PDF URL: $uri',
      );

      debugPrint(
        '========================================',
      );

      final response =
      await _apiClient.get(uri);

      debugPrint(
        '========================================',
      );

      debugPrint(
        'PDF API RESPONSE',
      );

      debugPrint(
        'STATUS: ${response.statusCode}',
      );

      debugPrint(
        'CONTENT TYPE: '
            '${response.headers['content-type']}',
      );

      debugPrint(
        'CONTENT LENGTH: '
            '${response.headers['content-length']}',
      );

      debugPrint(
        'BODY BYTES: '
            '${response.bodyBytes.length}',
      );

      debugPrint(
        '========================================',
      );

      if (response.statusCode != 200) {
        throw HistoryException(
          'Failed to download report '
              '(${response.statusCode})',
        );
      }

      if (response.bodyBytes.isEmpty) {
        throw HistoryException(
          'PDF response is empty.',
        );
      }

      // IMPORTANT:
      // PDF is binary.
      // Do NOT jsonDecode(response.body).
      return response;
    } on HistoryException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint(
        '========================================',
      );

      debugPrint(
        'PDF REPOSITORY ERROR',
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

      throw HistoryException(
        'Unable to download history report.',
      );
    }
  }

  // ======================================================
  // FORMAT DATE
  // ======================================================

  String _formatDate(
      DateTime date,
      ) {
    final month =
    date.month
        .toString()
        .padLeft(2, '0');

    final day =
    date.day
        .toString()
        .padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  // ======================================================
  // FORMAT MONTH
  // ======================================================

  String _formatMonth(
      DateTime date,
      ) {
    final month =
    date.month
        .toString()
        .padLeft(2, '0');

    return '${date.year}-$month';
  }
}