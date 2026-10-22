// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class TokenService {
//   TokenService._internal();
//   static final TokenService instance = TokenService._internal();
//
//   static const String _accessTokenKey = 'access_token';
//   static const String _refreshTokenKey = 'refresh_token';
//
//   Future<void> saveTokens({
//     required String accessToken,
//     required String refreshToken,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_accessTokenKey, accessToken);
//     await prefs.setString(_refreshTokenKey, refreshToken);
//     debugPrint('TokenService: tokens saved');
//   }
//
//   Future<void> saveAccessToken(String accessToken) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_accessTokenKey, accessToken);
//     debugPrint('TokenService: access token updated');
//   }
//
//   Future<String?> getAccessToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(_accessTokenKey);
//     debugPrint('TokenService: getAccessToken -> ${token != null ? 'found' : 'null'}');
//     return token;
//   }
//
//   Future<String?> getRefreshToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(_refreshTokenKey);
//     debugPrint('TokenService: getRefreshToken -> ${token != null ? 'found' : 'null'}');
//     return token;
//   }
//
//   Future<bool> hasToken() async {
//     final token = await getAccessToken();
//     return token != null && token.isNotEmpty;
//   }
//
//   Future<void> clearTokens() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_accessTokenKey);
//     await prefs.remove(_refreshTokenKey);
//     debugPrint('TokenService: tokens cleared');
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  TokenService._internal();

  static final TokenService instance =
  TokenService._internal();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // ============================================================
  // SAVE BOTH TOKENS
  // ============================================================

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _accessTokenKey,
      accessToken,
    );

    await prefs.setString(
      _refreshTokenKey,
      refreshToken,
    );

    debugPrint(
      'TokenService: access + refresh tokens saved',
    );
  }

  // ============================================================
  // SAVE ACCESS TOKEN
  // ============================================================

  Future<void> saveAccessToken(
      String accessToken,
      ) async {
    final token = accessToken.trim();

    if (token.isEmpty) {
      debugPrint(
        'TokenService: refusing to save empty access token',
      );
      return;
    }

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _accessTokenKey,
      token,
    );

    debugPrint(
      'TokenService: access token updated',
    );
  }

  // ============================================================
  // GET ACCESS TOKEN
  // ============================================================

  Future<String?> getAccessToken() async {
    final prefs =
    await SharedPreferences.getInstance();

    final token =
    prefs.getString(_accessTokenKey);

    if (token == null || token.trim().isEmpty) {
      debugPrint(
        'TokenService: getAccessToken -> null',
      );

      return null;
    }

    debugPrint(
      'TokenService: getAccessToken -> found',
    );

    return token.trim();
  }

  // ============================================================
  // GET REFRESH TOKEN
  // ============================================================

  Future<String?> getRefreshToken() async {
    final prefs =
    await SharedPreferences.getInstance();

    final token =
    prefs.getString(_refreshTokenKey);

    if (token == null || token.trim().isEmpty) {
      debugPrint(
        'TokenService: getRefreshToken -> null',
      );

      return null;
    }

    debugPrint(
      'TokenService: getRefreshToken -> found',
    );

    return token.trim();
  }

  // ============================================================
  // HAS ACCESS TOKEN
  // ============================================================

  Future<bool> hasToken() async {
    final token =
    await getAccessToken();

    return token != null &&
        token.isNotEmpty;
  }

  // ============================================================
  // CLEAR TOKENS
  // ============================================================

  Future<void> clearTokens() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(
      _accessTokenKey,
    );

    await prefs.remove(
      _refreshTokenKey,
    );

    debugPrint(
      'TokenService: tokens cleared',
    );
  }
}