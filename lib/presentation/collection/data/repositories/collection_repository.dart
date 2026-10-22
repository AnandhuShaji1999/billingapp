import 'dart:convert';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_client.dart';
import '../../models/collection_response_model.dart';

class CollectionRepository {
  final ApiClient _apiClient;

  CollectionRepository({
    ApiClient? apiClient,
  }) : _apiClient =
      apiClient ?? ApiClient.instance;

  // ============================================================
  // GET COLLECTION
  // ============================================================

  Future<CollectionResponseModel> getCollection({
    required String period,
    DateTime? date,
    DateTime? month,
  }) async {
    final uri =
    _buildCollectionUri(
      period: period,
      date: date,
      month: month,
    );

    print('========================================');
    print('COLLECTION REPOSITORY');
    print('GET COLLECTION API');
    print('PERIOD: $period');
    print('DATE: $date');
    print('MONTH: $month');
    print('URL: $uri');
    print('========================================');

    final response =
    await _apiClient.get(uri);

    print('========================================');
    print('COLLECTION API RESPONSE');
    print(
      'STATUS: ${response.statusCode}',
    );
    print(
      'CONTENT TYPE: '
          '${response.headers['content-type']}',
    );
    print(
      'BODY: ${response.body}',
    );
    print('========================================');

    if (response.statusCode != 200) {
      throw CollectionException(
        'Failed to load collection '
            '(${response.statusCode})',
      );
    }

    try {
      final decoded =
      jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw CollectionException(
          'Invalid collection response format.',
        );
      }

      final result =
      CollectionResponseModel.fromJson(
        decoded,
      );

      print('========================================');
      print('COLLECTION API PARSED');
      print(
        'PERIOD: ${result.period}',
      );
      print(
        'START DATE: ${result.startDate}',
      );
      print(
        'END DATE: ${result.endDate}',
      );
      print(
        'TOTAL COLLECTION: '
            '${result.totalCollection}',
      );
      print(
        'BILL COUNT: '
            '${result.billCount}',
      );
      print(
        'GROSS PROFIT: '
            '${result.grossProfit}',
      );
      print(
        'UPI: ${result.upiTotal}',
      );
      print(
        'CASH: ${result.cashTotal}',
      );
      print(
        'CARD: ${result.cardTotal}',
      );
      print(
        'MIXED: ${result.mixedTotal}',
      );
      print(
        'CATEGORIES: '
            '${result.categoryCollection.length}',
      );
      print(
        'BILLS: '
            '${result.bills.length}',
      );
      print('========================================');

      return result;
    } catch (e, stackTrace) {
      print('========================================');
      print('COLLECTION PARSE ERROR');
      print(
        'ERROR: $e',
      );
      print(
        'STACK TRACE: $stackTrace',
      );
      print('========================================');

      if (e is CollectionException) {
        rethrow;
      }

      throw CollectionException(
        'Invalid collection response.',
      );
    }
  }

  // ============================================================
  // BUILD URI
  // ============================================================

  Uri _buildCollectionUri({
    required String period,
    DateTime? date,
    DateTime? month,
  }) {
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

    return Uri.parse(
      ApiConstants.collection,
    ).replace(
      queryParameters:
      queryParameters,
    );
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(
      DateTime date,
      ) {
    final month =
    date.month.toString().padLeft(
      2,
      '0',
    );

    final day =
    date.day.toString().padLeft(
      2,
      '0',
    );

    return '${date.year}-$month-$day';
  }

  // ============================================================
  // MONTH
  // ============================================================

  String _formatMonth(
      DateTime date,
      ) {
    final month =
    date.month.toString().padLeft(
      2,
      '0',
    );

    return '${date.year}-$month';
  }
}

// ============================================================================
// EXCEPTION
// ============================================================================

class CollectionException
    implements Exception {
  final String message;

  CollectionException(
      this.message,
      );

  @override
  String toString() => message;
}