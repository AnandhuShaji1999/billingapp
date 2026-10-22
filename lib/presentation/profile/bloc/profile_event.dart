//
//
// part of 'profile_bloc.dart';
//
// abstract class ProfileEvent {}
//
// class ProfileStarted extends ProfileEvent {}
//
// class ProfileEmployeeAdded extends ProfileEvent {
//   final Employee employee;
//   ProfileEmployeeAdded(this.employee);
// }
//
// class ProfileUpdateRequested extends ProfileEvent {
//   final String name;
//   final String phone;
//   ProfileUpdateRequested({required this.name, required this.phone});
// }



part of 'profile_bloc.dart';

abstract class ProfileEvent {}

/// Load the current user profile.
class ProfileStarted extends ProfileEvent {}

/// Update the current user's profile.
class ProfileUpdateRequested extends ProfileEvent {
  final String name;
  final String phone;

  ProfileUpdateRequested({
    required this.name,
    required this.phone,
  });
}