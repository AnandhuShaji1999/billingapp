// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import '../../../../core/constants/api_constants.dart';
// import '../../../../core/services/api_client.dart';
// import '../../models/user_profile_model.dart';
//
// class ProfileException implements Exception {
//   final String message;
//   ProfileException(this.message);
//
//   @override
//   String toString() => message;
// }
//
// class ProfileRepository {
//   final ApiClient _apiClient;
//
//   ProfileRepository({ApiClient? apiClient})
//       : _apiClient = apiClient ?? ApiClient.instance;
//
//   Future<UserProfileModel> getMe() async {
//     final uri = Uri.parse(ApiConstants.me);
//     debugPrint('ProfileRepository.getMe -> GET $uri');
//
//     final response = await _apiClient.get(uri);
//
//     debugPrint('ProfileRepository.getMe <- status: ${response.statusCode}');
//     debugPrint('ProfileRepository.getMe <- body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body) as Map<String, dynamic>;
//       return UserProfileModel.fromJson(json);
//     }
//
//     throw ProfileException(
//       'Failed to load profile (${response.statusCode}): ${response.body}',
//     );
//   }
//
//   Future<UserProfileModel> updateProfile({
//     required String name,
//     required String phone,
//   }) async {
//     final uri = Uri.parse(ApiConstants.updateProfile);
//     debugPrint('ProfileRepository.updateProfile -> PATCH $uri');
//     debugPrint(
//       'ProfileRepository.updateProfile -> body: {name: $name, phone: $phone}',
//     );
//
//     final response = await _apiClient.patch(
//       uri,
//       body: {'name': name, 'phone': phone},
//     );
//
//     debugPrint(
//       'ProfileRepository.updateProfile <- status: ${response.statusCode}',
//     );
//     debugPrint('ProfileRepository.updateProfile <- body: ${response.body}');
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final json = jsonDecode(response.body) as Map<String, dynamic>;
//       return UserProfileModel.fromJson(json);
//     }
//
//     throw ProfileException(
//       'Failed to update profile (${response.statusCode}): ${response.body}',
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_client.dart';
import '../../models/profile_response_model.dart';
import '../../models/user_profile_model.dart';

class ProfileException implements Exception {
  final String message;
  ProfileException(this.message);

  @override
  String toString() => message;
}

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// GET /api/mobile/profile/
  Future<ProfileResponseModel> getProfile() async {
    final uri = Uri.parse(ApiConstants.profile);
    debugPrint('ProfileRepository.getProfile -> GET $uri');

    final response = await _apiClient.get(uri);

    debugPrint('ProfileRepository.getProfile <- status: ${response.statusCode}');
    debugPrint('ProfileRepository.getProfile <- body: ${response.body}');

    if (response.statusCode != 200) {
      throw ProfileException(
        'Failed to load profile (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ProfileException('Unexpected response shape from profile API');
    }

    debugPrint('ProfileRepository.getProfile <- keys: ${decoded.keys.toList()}');

    final model = ProfileResponseModel.fromJson(decoded);

    debugPrint(
      'ProfileRepository.getProfile -> parsed: '
          'user=${model.user.name} (${model.user.displayTitle}), '
          'employeeCount=${model.employeeCount}, '
          'lastMonth=${model.lastMonth}, '
          'payroll=${model.lastMonthScheduledPayroll}, '
          'employees=${model.employees.length}',
    );

    return model;
  }

  /// GET /api/auth/me/ — only used to fill the phone number for the edit
  /// sheet, because the mobile profile response has no phone field.
  Future<UserProfileModel> getMe() async {
    final uri = Uri.parse(ApiConstants.me);
    debugPrint('ProfileRepository.getMe -> GET $uri');

    final response = await _apiClient.get(uri);

    debugPrint('ProfileRepository.getMe <- status: ${response.statusCode}');
    debugPrint('ProfileRepository.getMe <- body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserProfileModel.fromJson(json);
    }

    throw ProfileException(
      'Failed to load profile (${response.statusCode}): ${response.body}',
    );
  }

  /// PATCH /api/auth/profile/  (profile edit endpoint per the API notes)
  Future<UserProfileModel> updateProfile({
    required String name,
    required String phone,
  }) async {
    final uri = Uri.parse(ApiConstants.updateProfile);
    debugPrint('ProfileRepository.updateProfile -> PATCH $uri');
    debugPrint(
      'ProfileRepository.updateProfile -> body: {name: $name, phone: $phone}',
    );

    final response = await _apiClient.patch(
      uri,
      body: {'name': name, 'phone': phone},
    );

    debugPrint(
      'ProfileRepository.updateProfile <- status: ${response.statusCode}',
    );
    debugPrint('ProfileRepository.updateProfile <- body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserProfileModel.fromJson(json);
    }

    throw ProfileException(
      'Failed to update profile (${response.statusCode}): ${response.body}',
    );
  }
}