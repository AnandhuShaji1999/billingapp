import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../models/login_response_model.dart';
import '../../models/refresh_token_response_model.dart';


class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConstants.login);
    debugPrint('AuthRepository.login -> POST $uri');
    debugPrint('AuthRepository.login -> body: {email: $email}');

    final response = await http.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    debugPrint('AuthRepository.login <- status: ${response.statusCode}');
    debugPrint('AuthRepository.login <- body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponseModel.fromJson(json);
    }

    throw AuthException(
      'Login failed (${response.statusCode}): ${response.body}',
    );
  }

  Future<RefreshTokenResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    final uri = Uri.parse(ApiConstants.refreshToken);
    debugPrint('AuthRepository.refreshToken -> POST $uri');

    final response = await http.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    debugPrint('AuthRepository.refreshToken <- status: ${response.statusCode}');
    debugPrint('AuthRepository.refreshToken <- body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return RefreshTokenResponseModel.fromJson(json);
    }

    throw AuthException(
      'Refresh failed (${response.statusCode}): ${response.body}',
    );
  }
}