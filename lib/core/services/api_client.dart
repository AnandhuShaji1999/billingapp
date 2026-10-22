import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../navigation/navigation_service.dart';
import 'token_service.dart';
import '../../routes/app_routes.dart';

/// Shared HTTP client for every authenticated API call.
///
/// - Attaches the saved access token to every request.
/// - On a 401, tries once to refresh the access token via
///   ApiConstants.refreshToken, then retries the original request.
/// - If there's no refresh token, or the refresh call itself fails,
///   clears the stored tokens and forces navigation back to the login
///   screen (session expired).
class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  final TokenService _tokenService = TokenService.instance;

  Future<http.Response> get(Uri uri) => _send('GET', uri);

  Future<http.Response> post(Uri uri, {Object? body}) =>
      _send('POST', uri, body: body);

  Future<http.Response> patch(Uri uri, {Object? body}) =>
      _send('PATCH', uri, body: body);

  Future<http.Response> _send(
      String method,
      Uri uri, {
        Object? body,
        bool isRetry = false,
      }) async {
    final accessToken = await _tokenService.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    debugPrint('ApiClient.$method -> $uri (retry: $isRetry)');

    late http.Response response;
    switch (method) {
      case 'POST':
        response = await http.post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'PATCH':
        response = await http.patch(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      default:
        response = await http.get(uri, headers: headers);
    }

    debugPrint('ApiClient.$method <- status: ${response.statusCode}');

    if (response.statusCode == 401 && !isRetry) {
      debugPrint('ApiClient: 401 received, attempting token refresh');
      final refreshed = await _tryRefreshToken();

      if (refreshed) {
        debugPrint('ApiClient: refresh succeeded, retrying original request');
        return _send(method, uri, body: body, isRetry: true);
      }

      debugPrint('ApiClient: refresh failed, forcing logout');
      await _forceLogout();
    }

    return response;
  }

  Future<bool> _tryRefreshToken() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint('ApiClient._tryRefreshToken -> no refresh token stored');
      return false;
    }

    final uri = Uri.parse(ApiConstants.refreshToken);
    try {
      final response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      debugPrint(
        'ApiClient._tryRefreshToken <- status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccess = json['access'] as String?;
        if (newAccess != null && newAccess.isNotEmpty) {
          await _tokenService.saveAccessToken(newAccess);
          debugPrint('ApiClient._tryRefreshToken -> access token updated');
          return true;
        }
      }
    } catch (e) {
      debugPrint('ApiClient._tryRefreshToken -> error: $e');
    }
    return false;
  }

  Future<void> _forceLogout() async {
    await _tokenService.clearTokens();
    debugPrint('ApiClient: tokens cleared, navigating to login');
    NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
          (route) => false,
    );
  }
}