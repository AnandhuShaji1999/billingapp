//
//
//
// part of 'profile_bloc.dart';
//
// abstract class ProfileState {}
//
// class ProfileLoading extends ProfileState {}
//
// class ProfileError extends ProfileState {
//   final String message;
//   ProfileError(this.message);
// }
//
// class ProfileLoaded extends ProfileState {
//   final String username;
//   final String role;
//   final String phone;
//   final List<Employee> employees;
//   final bool isUpdating;
//   final String? updateErrorMessage;
//
//   ProfileLoaded({
//     required this.username,
//     required this.role,
//     required this.phone,
//     required this.employees,
//     this.isUpdating = false,
//     this.updateErrorMessage,
//   });
//
//   double get totalPayroll =>
//       employees.fold<double>(0, (sum, e) => sum + e.lastMonthSalary);
//
//   ProfileLoaded copyWith({
//     String? username,
//     String? role,
//     String? phone,
//     List<Employee>? employees,
//     bool? isUpdating,
//     String? updateErrorMessage,
//   }) {
//     return ProfileLoaded(
//       username: username ?? this.username,
//       role: role ?? this.role,
//       phone: phone ?? this.phone,
//       employees: employees ?? this.employees,
//       isUpdating: isUpdating ?? this.isUpdating,
//       updateErrorMessage: updateErrorMessage,
//     );
//   }
// }



part of 'profile_bloc.dart';

abstract class ProfileState {}

// ============================================================
// PROFILE LOADING
// ============================================================

class ProfileLoading extends ProfileState {}

// ============================================================
// PROFILE ERROR
// ============================================================

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

// ============================================================
// PROFILE LOADED
// ============================================================

class ProfileLoaded extends ProfileState {
  final String username;
  final String role;
  final String phone;

  final bool isUpdating;
  final String? updateErrorMessage;

  ProfileLoaded({
    required this.username,
    required this.role,
    required this.phone,
    this.isUpdating = false,
    this.updateErrorMessage,
  });

  // ==========================================================
  // COPY WITH
  // ==========================================================

  ProfileLoaded copyWith({
    String? username,
    String? role,
    String? phone,
    bool? isUpdating,
    String? updateErrorMessage,
  }) {
    return ProfileLoaded(
      username: username ?? this.username,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      isUpdating: isUpdating ?? this.isUpdating,
      updateErrorMessage: updateErrorMessage,
    );
  }
}