//
//
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../employees/models/employee.dart';
// import '../data/repositories/profile_repository.dart';
// import '../models/profile_response_model.dart';
// import '../models/user_profile_model.dart';
//
// part 'profile_event.dart';
// part 'profile_state.dart';
//
// class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
//   final ProfileRepository _profileRepository;
//
//   ProfileBloc({ProfileRepository? profileRepository})
//       : _profileRepository = profileRepository ?? ProfileRepository(),
//         super(ProfileLoading()) {
//     on<ProfileStarted>(_onStarted);
//     on<ProfileEmployeeAdded>(_onEmployeeAdded);
//     on<ProfileUpdateRequested>(_onUpdateRequested);
//   }
//
//   // Employee cards are intentionally still static — the employee card API
//   // comes next. Only the profile header (name / title) is dynamic for now.
//   static const List<Employee> _sampleEmployees = [
//     Employee(
//       id: 'E101',
//       name: 'Ravi Kumar',
//       role: 'Sales Associate',
//       lastMonthSalary: 18000,
//     ),
//     Employee(
//       id: 'E102',
//       name: 'Anita Sharma',
//       role: 'Cashier',
//       lastMonthSalary: 15000,
//     ),
//     Employee(
//       id: 'E103',
//       name: 'Manoj Verma',
//       role: 'Store Manager',
//       lastMonthSalary: 25000,
//     ),
//   ];
//
//   Future<void> _onStarted(
//       ProfileStarted event,
//       Emitter<ProfileState> emit,
//       ) async {
//     emit(ProfileLoading());
//     debugPrint('ProfileBloc: fetching profile via /api/mobile/profile/');
//
//     try {
//       final ProfileResponseModel profile =
//       await _profileRepository.getProfile();
//
//       debugPrint(
//         'ProfileBloc: profile loaded -> name=${profile.user.name}, '
//             'title=${profile.user.displayTitle}, role=${profile.user.role}',
//       );
//
//       // The mobile profile response has no phone number. Fetch it from
//       // /api/auth/me/ (best effort) so the edit sheet stays pre-filled.
//       var phone = profile.user.phone;
//       if (phone.isEmpty) {
//         try {
//           final UserProfileModel me = await _profileRepository.getMe();
//           phone = me.phone;
//           debugPrint('ProfileBloc: phone filled from /api/auth/me/ -> $phone');
//         } catch (e) {
//           debugPrint('ProfileBloc: phone lookup failed (non-fatal) -> $e');
//         }
//       }
//
//       emit(
//         ProfileLoaded(
//           username: profile.user.name,
//           role: profile.user.displayTitle,
//           phone: phone,
//           employees: _sampleEmployees,
//         ),
//       );
//     } catch (e) {
//       debugPrint('ProfileBloc: profile fetch failed -> $e');
//       emit(ProfileError('Could not load profile. Please try again.'));
//     }
//   }
//
//   void _onEmployeeAdded(
//       ProfileEmployeeAdded event,
//       Emitter<ProfileState> emit,
//       ) {
//     final current = state;
//     if (current is! ProfileLoaded) return;
//     emit(current.copyWith(employees: [...current.employees, event.employee]));
//   }
//
//   Future<void> _onUpdateRequested(
//       ProfileUpdateRequested event,
//       Emitter<ProfileState> emit,
//       ) async {
//     final current = state;
//     if (current is! ProfileLoaded) return;
//
//     emit(current.copyWith(isUpdating: true, updateErrorMessage: null));
//     debugPrint(
//       'ProfileBloc: updating profile -> name=${event.name}, phone=${event.phone}',
//     );
//
//     try {
//       final UserProfileModel updated = await _profileRepository.updateProfile(
//         name: event.name,
//         phone: event.phone,
//       );
//       debugPrint('ProfileBloc: profile updated -> name=${updated.name}');
//
//       // Only name/phone change on edit. The title under the name
//       // (job_title) is kept as loaded from the mobile profile API.
//       emit(
//         current.copyWith(
//           username: updated.name,
//           phone: updated.phone,
//           isUpdating: false,
//           updateErrorMessage: null,
//         ),
//       );
//     } catch (e) {
//       debugPrint('ProfileBloc: profile update failed -> $e');
//       emit(
//         current.copyWith(
//           isUpdating: false,
//           updateErrorMessage: 'Could not update profile. Please try again.',
//         ),
//       );
//     }
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/profile_repository.dart';
import '../models/profile_response_model.dart';
import '../models/user_profile_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({
    ProfileRepository? profileRepository,
  })  : _profileRepository =
      profileRepository ?? ProfileRepository(),
        super(ProfileLoading()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileUpdateRequested>(_onUpdateRequested);
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> _onStarted(
      ProfileStarted event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());

    debugPrint(
      'ProfileBloc: fetching profile via /api/mobile/profile/',
    );

    try {
      // ----------------------------------------------------------
      // GET /api/mobile/profile/
      // ----------------------------------------------------------

      final ProfileResponseModel profile =
      await _profileRepository.getProfile();

      debugPrint(
        'ProfileBloc: profile loaded -> '
            'name=${profile.user.name}, '
            'title=${profile.user.displayTitle}, '
            'role=${profile.user.role}',
      );

      // ----------------------------------------------------------
      // GET /api/auth/me/
      //
      // Profile API doesn't contain phone in some cases.
      // So get phone from /api/auth/me/ as fallback.
      // ----------------------------------------------------------

      var phone = profile.user.phone;

      if (phone.isEmpty) {
        try {
          final UserProfileModel me =
          await _profileRepository.getMe();

          phone = me.phone;

          debugPrint(
            'ProfileBloc: phone loaded from /api/auth/me/ '
                '-> $phone',
          );
        } catch (e) {
          debugPrint(
            'ProfileBloc: phone lookup failed '
                '(non-fatal) -> $e',
          );
        }
      }

      // ----------------------------------------------------------
      // PROFILE LOADED
      // ----------------------------------------------------------

      emit(
        ProfileLoaded(
          username: profile.user.name,
          role: profile.user.displayTitle,
          phone: phone,
        ),
      );
    } catch (e) {
      debugPrint(
        'ProfileBloc: profile fetch failed -> $e',
      );

      emit(
        ProfileError(
          'Could not load profile. Please try again.',
        ),
      );
    }
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<void> _onUpdateRequested(
      ProfileUpdateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    final current = state;

    if (current is! ProfileLoaded) {
      return;
    }

    emit(
      current.copyWith(
        isUpdating: true,
        updateErrorMessage: null,
      ),
    );

    debugPrint(
      'ProfileBloc: updating profile -> '
          'name=${event.name}, '
          'phone=${event.phone}',
    );

    try {
      // ----------------------------------------------------------
      // PUT/PATCH /api/auth/profile/
      // ----------------------------------------------------------

      final UserProfileModel updated =
      await _profileRepository.updateProfile(
        name: event.name,
        phone: event.phone,
      );

      debugPrint(
        'ProfileBloc: profile updated -> '
            'name=${updated.name}',
      );

      // ----------------------------------------------------------
      // UPDATE LOCAL PROFILE STATE
      // ----------------------------------------------------------

      emit(
        current.copyWith(
          username: updated.name,
          phone: updated.phone,
          isUpdating: false,
          updateErrorMessage: null,
        ),
      );
    } catch (e) {
      debugPrint(
        'ProfileBloc: profile update failed -> $e',
      );

      emit(
        current.copyWith(
          isUpdating: false,
          updateErrorMessage:
          'Could not update profile. Please try again.',
        ),
      );
    }
  }
}