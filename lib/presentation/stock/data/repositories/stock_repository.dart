import 'dart:convert';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_client.dart';
import '../../models/stock_response_model.dart';

class StockRepository {
  final ApiClient _apiClient;

  StockRepository({
    ApiClient? apiClient,
  }) : _apiClient =
      apiClient ?? ApiClient.instance;

  // ============================================================
  // GET STOCK
  // ============================================================

  Future<StockResponseModel> getStock() async {
    print('========================================');
    print('STOCK REPOSITORY');
    print('GET STOCK API');
    print(
      'URL: ${ApiConstants.stock}',
    );
    print('========================================');

    final uri = Uri.parse(
      ApiConstants.stock,
    );

    final response =
    await _apiClient.get(uri);

    print('========================================');
    print('STOCK API RESPONSE');
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

    // ==========================================================
    // STATUS CHECK
    // ==========================================================

    if (response.statusCode != 200) {
      throw StockException(
        'Failed to load stock '
            '(${response.statusCode})',
      );
    }

    // ==========================================================
    // PARSE RESPONSE
    // ==========================================================

    try {
      final decoded =
      jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw StockException(
          'Invalid stock response format.',
        );
      }

      final stock =
      StockResponseModel.fromJson(
        decoded,
      );

      print('========================================');
      print('STOCK API PARSED');
      print(
        'DATE: ${stock.date}',
      );
      print(
        'TOTAL STOCK LEFT: '
            '${stock.totalStockLeft}',
      );
      print(
        'SOLD TODAY: '
            '${stock.soldToday}',
      );
      print(
        'STOCK LEVELS: '
            '${stock.stockLevels.length}',
      );
      print('========================================');

      return stock;
    } catch (e, stackTrace) {
      print('========================================');
      print('STOCK PARSE ERROR');
      print(
        'ERROR: $e',
      );
      print(
        'STACK TRACE: $stackTrace',
      );
      print('========================================');

      if (e is StockException) {
        rethrow;
      }

      throw StockException(
        'Invalid stock response.',
      );
    }
  }
}

// ============================================================
// STOCK EXCEPTION
// ============================================================

class StockException implements Exception {
  final String message;

  StockException(this.message);

  @override
  String toString() => message;
}