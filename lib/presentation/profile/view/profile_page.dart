// //
// //
// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../../core/constants/app_colors.dart';
// // import '../../../core/models/employee.dart';
// // import '../../../core/services/token_service.dart';
// // import '../../../core/widgets/custom_app_bar.dart';
// // import '../../../core/widgets/custom_bottom_nav_bar.dart';
// // import '../../../routes/app_routes.dart';
// // import '../../add_employee/view/add_employee_page.dart';
// // import '../bloc/profile_bloc.dart';
// //
// // class ProfilePage extends StatefulWidget {
// //   const ProfilePage({super.key});
// //
// //   @override
// //   State<ProfilePage> createState() => _ProfilePageState();
// // }
// //
// // class _ProfilePageState extends State<ProfilePage> {
// //   int _navIndex = 4;
// //
// //   Future<void> _addEmployee(BuildContext context) async {
// //     final profileBloc = context.read<ProfileBloc>();
// //     final employee = await Navigator.push<Employee>(
// //       context,
// //       MaterialPageRoute(builder: (_) => const AddEmployeePage()),
// //     );
// //     if (employee != null) {
// //       profileBloc.add(ProfileEmployeeAdded(employee));
// //     }
// //   }
// //
// //   Future<void> _editProfile(
// //       BuildContext context,
// //       ProfileLoaded loaded,
// //       ) async {
// //     final profileBloc = context.read<ProfileBloc>();
// //     await showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: AppColors.surface,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       builder: (sheetContext) {
// //         return _EditProfileSheet(profileBloc: profileBloc, initial: loaded);
// //       },
// //     );
// //   }
// //
// //   Future<void> _logout(BuildContext context) async {
// //     final confirmed = await showDialog<bool>(
// //       context: context,
// //       builder: (dialogContext) {
// //         return AlertDialog(
// //           title: const Text('Logout'),
// //           content: const Text('Are you sure you want to logout?'),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(dialogContext, false),
// //               child: const Text('Cancel'),
// //             ),
// //             TextButton(
// //               onPressed: () => Navigator.pop(dialogContext, true),
// //               child: const Text(
// //                 'Logout',
// //                 style: TextStyle(color: AppColors.error),
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //
// //     if (confirmed == true) {
// //       await TokenService.instance.clearTokens();
// //       if (context.mounted) {
// //         Navigator.pushNamedAndRemoveUntil(
// //           context,
// //           AppRoutes.login,
// //               (route) => false,
// //         );
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (_) => ProfileBloc()..add(ProfileStarted()),
// //       child: Scaffold(
// //         backgroundColor: AppColors.background,
// //         appBar: const CustomAppBar(title: 'Profile'),
// //         body: BlocBuilder<ProfileBloc, ProfileState>(
// //           builder: (context, state) {
// //             if (state is ProfileLoading) {
// //               return const Center(child: CircularProgressIndicator());
// //             }
// //             if (state is ProfileError) {
// //               return Center(
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(24),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       const Icon(
// //                         Icons.error_outline_rounded,
// //                         size: 40,
// //                         color: AppColors.error,
// //                       ),
// //                       const SizedBox(height: 12),
// //                       Text(
// //                         state.message,
// //                         textAlign: TextAlign.center,
// //                         style: const TextStyle(
// //                           color: AppColors.textSecondary,
// //                           fontSize: 13,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       ElevatedButton(
// //                         onPressed: () =>
// //                             context.read<ProfileBloc>().add(ProfileStarted()),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: AppColors.primary,
// //                           foregroundColor: Colors.white,
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                         ),
// //                         child: const Text('Retry'),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             }
// //             final loaded = state as ProfileLoaded;
// //             return SingleChildScrollView(
// //               padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _ProfileHeaderCard(
// //                     username: loaded.username,
// //                     role: loaded.role,
// //                     onEditTap: () => _editProfile(context, loaded),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: _SummaryCard(
// //                           label: 'Employees',
// //                           value: '${loaded.employees.length}',
// //                           icon: Icons.groups_rounded,
// //                           color: AppColors.primary,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: _SummaryCard(
// //                           label: 'Payroll (Last Month)',
// //                           value: '\$${loaded.totalPayroll.toStringAsFixed(0)}',
// //                           icon: Icons.payments_rounded,
// //                           color: AppColors.success,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 24),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       const Text(
// //                         'Employee Cards',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w700,
// //                           color: AppColors.textPrimary,
// //                         ),
// //                       ),
// //                       GestureDetector(
// //                         onTap: () => _addEmployee(context),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 12,
// //                             vertical: 7,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: AppColors.navSelectedBackground,
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                           child: const Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               Icon(
// //                                 Icons.add_rounded,
// //                                 size: 16,
// //                                 color: AppColors.primary,
// //                               ),
// //                               SizedBox(width: 4),
// //                               Text(
// //                                 'Add Employee',
// //                                 style: TextStyle(
// //                                   color: AppColors.primary,
// //                                   fontWeight: FontWeight.w600,
// //                                   fontSize: 12,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 12),
// //                   ...loaded.employees.map(
// //                         (e) => Padding(
// //                       padding: const EdgeInsets.only(bottom: 12),
// //                       child: _EmployeeCard(employee: e),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 12),
// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 50,
// //                     child: OutlinedButton.icon(
// //                       onPressed: () => _logout(context),
// //                       icon: const Icon(
// //                         Icons.logout_rounded,
// //                         color: AppColors.error,
// //                         size: 18,
// //                       ),
// //                       label: const Text(
// //                         'Logout',
// //                         style: TextStyle(
// //                           color: AppColors.error,
// //                           fontWeight: FontWeight.w600,
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                       style: OutlinedButton.styleFrom(
// //                         side: const BorderSide(color: AppColors.error),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(14),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //         bottomNavigationBar: CustomBottomNavBar(
// //           currentIndex: _navIndex,
// //           onTap: (index) {
// //             if (index == 0) {
// //               Navigator.pushReplacementNamed(context, AppRoutes.home);
// //             } else if (index == 1) {
// //               Navigator.pushReplacementNamed(context, AppRoutes.history);
// //             } else if (index == 2) {
// //               Navigator.pushReplacementNamed(context, AppRoutes.stock);
// //             } else if (index == 3) {
// //               Navigator.pushReplacementNamed(context, AppRoutes.collection);
// //             } else {
// //               setState(() => _navIndex = index);
// //             }
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class _EditProfileSheet extends StatefulWidget {
// //   final ProfileBloc profileBloc;
// //   final ProfileLoaded initial;
// //
// //   const _EditProfileSheet({
// //     required this.profileBloc,
// //     required this.initial,
// //   });
// //
// //   @override
// //   State<_EditProfileSheet> createState() => _EditProfileSheetState();
// // }
// //
// // class _EditProfileSheetState extends State<_EditProfileSheet> {
// //   late final TextEditingController _nameController;
// //   late final TextEditingController _phoneController;
// //   bool _submitted = false;
// //   bool _updated = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _nameController = TextEditingController(text: widget.initial.username);
// //     _phoneController = TextEditingController(text: widget.initial.phone);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _phoneController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: EdgeInsets.only(
// //         left: 20,
// //         right: 20,
// //         top: 20,
// //         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
// //       ),
// //       child: BlocConsumer<ProfileBloc, ProfileState>(
// //         bloc: widget.profileBloc,
// //         listener: (context, state) async {
// //           if (_submitted &&
// //               state is ProfileLoaded &&
// //               !state.isUpdating &&
// //               state.updateErrorMessage == null) {
// //             _submitted = false;
// //             setState(() => _updated = true);
// //
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(
// //                 content: Text('Profile updated successfully'),
// //                 duration: Duration(seconds: 3),
// //                 backgroundColor: AppColors.success,
// //               ),
// //             );
// //
// //             await Future.delayed(const Duration(seconds: 3));
// //             if (context.mounted) {
// //               Navigator.of(context).pop();
// //             }
// //           }
// //         },
// //         builder: (context, state) {
// //           final current = state is ProfileLoaded ? state : widget.initial;
// //           return Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'Edit Profile',
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w700,
// //                   color: AppColors.textPrimary,
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               TextField(
// //                 controller: _nameController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Name',
// //                   filled: true,
// //                   fillColor: AppColors.background,
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(14),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 14),
// //               TextField(
// //                 controller: _phoneController,
// //                 keyboardType: TextInputType.phone,
// //                 decoration: InputDecoration(
// //                   labelText: 'Phone',
// //                   filled: true,
// //                   fillColor: AppColors.background,
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(14),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                 ),
// //               ),
// //               if (current.updateErrorMessage != null) ...[
// //                 const SizedBox(height: 10),
// //                 Text(
// //                   current.updateErrorMessage!,
// //                   style: const TextStyle(
// //                     color: AppColors.error,
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ],
// //               if (_updated) ...[
// //                 const SizedBox(height: 10),
// //                 const Row(
// //                   children: [
// //                     Icon(
// //                       Icons.check_circle_rounded,
// //                       size: 16,
// //                       color: AppColors.success,
// //                     ),
// //                     SizedBox(width: 6),
// //                     Text(
// //                       'Profile updated successfully',
// //                       style: TextStyle(
// //                         color: AppColors.success,
// //                         fontSize: 12,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //               const SizedBox(height: 20),
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 50,
// //                 child: ElevatedButton(
// //                   onPressed: (current.isUpdating || _updated)
// //                       ? null
// //                       : () {
// //                     setState(() => _submitted = true);
// //                     widget.profileBloc.add(
// //                       ProfileUpdateRequested(
// //                         name: _nameController.text.trim(),
// //                         phone: _phoneController.text.trim(),
// //                       ),
// //                     );
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: AppColors.primary,
// //                     foregroundColor: Colors.white,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(14),
// //                     ),
// //                     elevation: 0,
// //                   ),
// //                   child: current.isUpdating
// //                       ? const SizedBox(
// //                     width: 20,
// //                     height: 20,
// //                     child: CircularProgressIndicator(
// //                       strokeWidth: 2.5,
// //                       valueColor:
// //                       AlwaysStoppedAnimation<Color>(Colors.white),
// //                     ),
// //                   )
// //                       : const Text(
// //                     'Save Changes',
// //                     style: TextStyle(
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// // class _ProfileHeaderCard extends StatelessWidget {
// //   final String username;
// //   final String role;
// //   final VoidCallback onEditTap;
// //
// //   const _ProfileHeaderCard({
// //     required this.username,
// //     required this.role,
// //     required this.onEditTap,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [AppColors.primary, AppColors.secondary],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(24),
// //         boxShadow: [
// //           BoxShadow(
// //             color: AppColors.cardShadow,
// //             blurRadius: 20,
// //             offset: const Offset(0, 10),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 64,
// //             height: 64,
// //             decoration: BoxDecoration(
// //               color: Colors.white.withOpacity(0.2),
// //               shape: BoxShape.circle,
// //             ),
// //             child: const Icon(
// //               Icons.person_rounded,
// //               color: Colors.white,
// //               size: 34,
// //             ),
// //           ),
// //           const SizedBox(width: 16),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   username,
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   role,
// //                   style: const TextStyle(color: Colors.white70, fontSize: 13),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           GestureDetector(
// //             onTap: onEditTap,
// //             child: Container(
// //               width: 36,
// //               height: 36,
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.15),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(
// //                 Icons.edit_rounded,
// //                 color: Colors.white,
// //                 size: 16,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _SummaryCard extends StatelessWidget {
// //   final String label;
// //   final String value;
// //   final IconData icon;
// //   final Color color;
// //
// //   const _SummaryCard({
// //     required this.label,
// //     required this.value,
// //     required this.icon,
// //     required this.color,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.surface,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.03),
// //             blurRadius: 8,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             width: 36,
// //             height: 36,
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.12),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Icon(icon, color: color, size: 18),
// //           ),
// //           const SizedBox(height: 10),
// //           Text(
// //             value,
// //             style: const TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.textPrimary,
// //             ),
// //           ),
// //           const SizedBox(height: 2),
// //           Text(
// //             label,
// //             style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _EmployeeCard extends StatelessWidget {
// //   final Employee employee;
// //   const _EmployeeCard({required this.employee});
// //
// //   String get _initials {
// //     final parts = employee.name.trim().split(' ').where((p) => p.isNotEmpty);
// //     if (parts.isEmpty) return '?';
// //     return parts.map((p) => p[0]).take(2).join().toUpperCase();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: AppColors.surface,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.03),
// //             blurRadius: 8,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 44,
// //             height: 44,
// //             decoration: const BoxDecoration(
// //               color: AppColors.navSelectedBackground,
// //               shape: BoxShape.circle,
// //             ),
// //             child: Center(
// //               child: Text(
// //                 _initials,
// //                 style: const TextStyle(
// //                   color: AppColors.primary,
// //                   fontWeight: FontWeight.w700,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   employee.name,
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w700,
// //                     color: AppColors.textPrimary,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Text(
// //                   employee.role,
// //                   style: const TextStyle(
// //                     fontSize: 12,
// //                     color: AppColors.textSecondary,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Text(
// //                 '\$${employee.lastMonthSalary.toStringAsFixed(0)}',
// //                 style: const TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w700,
// //                   color: AppColors.primary,
// //                 ),
// //               ),
// //               const SizedBox(height: 2),
// //               const Text(
// //                 'Last month',
// //                 style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../core/constants/app_colors.dart';
// import '../../../core/services/token_service.dart';
// import '../../../core/widgets/custom_app_bar.dart';
// import '../../../core/widgets/custom_bottom_nav_bar.dart';
// import '../../../routes/app_routes.dart';
//
// import '../../employees/add_employee/view/add_employee_page.dart';
// import '../../employees/bloc/employee_bloc.dart';
// import '../../employees/models/employee.dart';
//
// import '../bloc/profile_bloc.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   int _navIndex = 4;
//
//   // ============================================================
//   // ADD EMPLOYEE
//   // ============================================================
//
//   Future<void> _addEmployee(BuildContext context) async {
//     // IMPORTANT:
//     // Get the existing EmployeeBloc before navigating.
//     final employeeBloc = context.read<EmployeeBloc>();
//
//     await Navigator.push<Employee>(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BlocProvider.value(
//           value: employeeBloc,
//           child: const AddEmployeePage(),
//         ),
//       ),
//     );
//
//     if (!context.mounted) return;
//
//     // Refresh employees after returning.
//     employeeBloc.add(
//       EmployeesLoadRequested(),
//     );
//   }
//
//   // ============================================================
//   // EDIT PROFILE
//   // ============================================================
//
//   Future<void> _editProfile(
//       BuildContext context,
//       ProfileLoaded loaded,
//       ) async {
//     final profileBloc = context.read<ProfileBloc>();
//
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: AppColors.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       builder: (_) {
//         return _EditProfileSheet(
//           profileBloc: profileBloc,
//           initial: loaded,
//         );
//       },
//     );
//   }
//
//   // ============================================================
//   // EDIT EMPLOYEE
//   // ============================================================
//
//   Future<void> _editEmployee(
//       BuildContext context,
//       Employee employee,
//       ) async {
//     final nameController = TextEditingController(
//       text: employee.name,
//     );
//
//     final jobTitleController = TextEditingController(
//       text: employee.jobTitle,
//     );
//
//     final phoneController = TextEditingController(
//       text: employee.phone,
//     );
//
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: AppColors.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       builder: (_) {
//         return _EditEmployeeSheet(
//           employee: employee,
//           nameController: nameController,
//           jobTitleController: jobTitleController,
//           phoneController: phoneController,
//         );
//       },
//     );
//
//     nameController.dispose();
//     jobTitleController.dispose();
//     phoneController.dispose();
//   }
//
//   // ============================================================
//   // DELETE EMPLOYEE
//   // ============================================================
//
//   Future<void> _deleteEmployee(
//       BuildContext context,
//       Employee employee,
//       ) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text(
//             'Deactivate Employee',
//           ),
//           content: Text(
//             'Are you sure you want to deactivate ${employee.name}?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(
//                   dialogContext,
//                   false,
//                 );
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(
//                   dialogContext,
//                   true,
//                 );
//               },
//               child: const Text(
//                 'Deactivate',
//                 style: TextStyle(
//                   color: AppColors.error,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmed != true) return;
//     if (!context.mounted) return;
//
//     context.read<EmployeeBloc>().add(
//       EmployeeDeleteRequested(
//         employee.id,
//       ),
//     );
//   }
//
//   // ============================================================
//   // LOGOUT
//   // ============================================================
//
//   Future<void> _logout(BuildContext context) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text(
//             'Are you sure you want to logout?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(
//                   dialogContext,
//                   false,
//                 );
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(
//                   dialogContext,
//                   true,
//                 );
//               },
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(
//                   color: AppColors.error,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmed == true) {
//       await TokenService.instance.clearTokens();
//
//       if (!context.mounted) return;
//
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         AppRoutes.login,
//             (route) => false,
//       );
//     }
//   }
//
//   // ============================================================
//   // BUILD
//   // ============================================================
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // PROFILE BLOC
//         BlocProvider<ProfileBloc>(
//           create: (_) => ProfileBloc()
//             ..add(
//               ProfileStarted(),
//             ),
//         ),
//
//         // EMPLOYEE BLOC
//         BlocProvider<EmployeeBloc>(
//           create: (_) => EmployeeBloc()
//             ..add(
//               EmployeesLoadRequested(),
//             ),
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//
//         // ========================================================
//         // APP BAR
//         // ========================================================
//
//         appBar: const CustomAppBar(
//           title: 'Profile',
//         ),
//
//         // ========================================================
//         // BODY
//         // ========================================================
//
//         body: BlocBuilder<ProfileBloc, ProfileState>(
//           builder: (context, state) {
//             // PROFILE LOADING
//             if (state is ProfileLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//
//             // PROFILE ERROR
//             if (state is ProfileError) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.error_outline_rounded,
//                         size: 40,
//                         color: AppColors.error,
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       Text(
//                         state.message,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: AppColors.textSecondary,
//                           fontSize: 13,
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       ElevatedButton(
//                         onPressed: () {
//                           context.read<ProfileBloc>().add(
//                             ProfileStarted(),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//
//             // WAITING
//             if (state is! ProfileLoaded) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//
//             final loaded = state;
//
//             return RefreshIndicator(
//               onRefresh: () async {
//                 context.read<ProfileBloc>().add(
//                   ProfileStarted(),
//                 );
//
//                 context.read<EmployeeBloc>().add(
//                   EmployeesLoadRequested(),
//                 );
//
//                 await Future.delayed(
//                   const Duration(milliseconds: 500),
//                 );
//               },
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.fromLTRB(
//                   20,
//                   16,
//                   20,
//                   24,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ==================================================
//                     // PROFILE HEADER
//                     // ==================================================
//
//                     _ProfileHeaderCard(
//                       username: loaded.username,
//                       role: loaded.role,
//                       onEditTap: () {
//                         _editProfile(
//                           context,
//                           loaded,
//                         );
//                       },
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // ==================================================
//                     // SUMMARY CARDS
//                     // ==================================================
//
//                     BlocBuilder<EmployeeBloc, EmployeeState>(
//                       builder: (
//                           context,
//                           employeeState,
//                           ) {
//                         final employees =
//                             employeeState.employees;
//
//                         double totalSalary = 0;
//
//                         for (final employee in employees) {
//                           totalSalary += employee.monthlySalary;
//                         }
//
//                         return Row(
//                           children: [
//                             Expanded(
//                               child: _SummaryCard(
//                                 label: 'Employees',
//                                 value: '${employees.length}',
//                                 icon: Icons.groups_rounded,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//
//                             const SizedBox(width: 12),
//
//                             Expanded(
//                               child: _SummaryCard(
//                                 label: 'Monthly Payroll',
//                                 value:
//                                 '₹${totalSalary.toStringAsFixed(0)}',
//                                 icon: Icons.payments_rounded,
//                                 color: AppColors.success,
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//
//                     const SizedBox(height: 24),
//
//                     // ==================================================
//                     // EMPLOYEE HEADER
//                     // ==================================================
//
//                     Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Employee Cards',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//
//                         GestureDetector(
//                           onTap: () {
//                             _addEmployee(context);
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 7,
//                             ),
//                             decoration: BoxDecoration(
//                               color:
//                               AppColors.navSelectedBackground,
//                               borderRadius:
//                               BorderRadius.circular(10),
//                             ),
//                             child: const Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.add_rounded,
//                                   size: 16,
//                                   color: AppColors.primary,
//                                 ),
//
//                                 SizedBox(width: 4),
//
//                                 Text(
//                                   'Add Employee',
//                                   style: TextStyle(
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     // ==================================================
//                     // EMPLOYEE LIST
//                     // ==================================================
//
//                     BlocConsumer<EmployeeBloc, EmployeeState>(
//                       listener: (
//                           context,
//                           employeeState,
//                           ) {
//                         // CREATED
//                         if (employeeState.status ==
//                             EmployeeStatus.created) {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'Employee added successfully',
//                               ),
//                               backgroundColor:
//                               AppColors.success,
//                             ),
//                           );
//
//                           // Refresh list
//                           context.read<EmployeeBloc>().add(
//                             EmployeesLoadRequested(),
//                           );
//                         }
//
//                         // UPDATED
//                         if (employeeState.status ==
//                             EmployeeStatus.updated) {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'Employee updated successfully',
//                               ),
//                               backgroundColor:
//                               AppColors.success,
//                             ),
//                           );
//
//                           context.read<EmployeeBloc>().add(
//                             EmployeesLoadRequested(),
//                           );
//                         }
//
//                         // DELETED
//                         if (employeeState.status ==
//                             EmployeeStatus.deleted) {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'Employee deactivated successfully',
//                               ),
//                               backgroundColor:
//                               AppColors.success,
//                             ),
//                           );
//
//                           context.read<EmployeeBloc>().add(
//                             EmployeesLoadRequested(),
//                           );
//                         }
//
//                         // ERROR
//                         if (employeeState.status ==
//                             EmployeeStatus.error) {
//                           ScaffoldMessenger.of(context)
//                               .showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 employeeState.errorMessage ??
//                                     'Something went wrong',
//                               ),
//                               backgroundColor:
//                               AppColors.error,
//                             ),
//                           );
//                         }
//                       },
//                       builder: (
//                           context,
//                           employeeState,
//                           ) {
//                         // LOADING
//                         if (employeeState.status ==
//                             EmployeeStatus.loading) {
//                           return const Padding(
//                             padding:
//                             EdgeInsets.symmetric(
//                               vertical: 40,
//                             ),
//                             child: Center(
//                               child:
//                               CircularProgressIndicator(),
//                             ),
//                           );
//                         }
//
//                         // CREATING
//                         if (employeeState.status ==
//                             EmployeeStatus.creating) {
//                           return const Padding(
//                             padding:
//                             EdgeInsets.symmetric(
//                               vertical: 30,
//                             ),
//                             child: Center(
//                               child:
//                               CircularProgressIndicator(),
//                             ),
//                           );
//                         }
//
//                         final employees =
//                             employeeState.employees;
//
//                         // EMPTY
//                         if (employees.isEmpty) {
//                           return _EmptyEmployeeView(
//                             onAdd: () {
//                               _addEmployee(context);
//                             },
//                           );
//                         }
//
//                         // LIST
//                         return Column(
//                           children: employees.map(
//                                 (employee) {
//                               return Padding(
//                                 padding:
//                                 const EdgeInsets.only(
//                                   bottom: 12,
//                                 ),
//                                 child: _EmployeeCard(
//                                   employee: employee,
//                                   onEdit: () {
//                                     _editEmployee(
//                                       context,
//                                       employee,
//                                     );
//                                   },
//                                   onDelete: () {
//                                     _deleteEmployee(
//                                       context,
//                                       employee,
//                                     );
//                                   },
//                                 ),
//                               );
//                             },
//                           ).toList(),
//                         );
//                       },
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     // ==================================================
//                     // LOGOUT
//                     // ==================================================
//
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: OutlinedButton.icon(
//                         onPressed: () {
//                           _logout(context);
//                         },
//                         icon: const Icon(
//                           Icons.logout_rounded,
//                           color: AppColors.error,
//                           size: 18,
//                         ),
//                         label: const Text(
//                           'Logout',
//                           style: TextStyle(
//                             color: AppColors.error,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                         ),
//                         style:
//                         OutlinedButton.styleFrom(
//                           side: const BorderSide(
//                             color: AppColors.error,
//                           ),
//                           shape:
//                           RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.circular(14),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//
//         // ==========================================================
//         // BOTTOM NAVIGATION
//         // ==========================================================
//
//         bottomNavigationBar:
//         CustomBottomNavBar(
//           currentIndex: _navIndex,
//           onTap: (index) {
//             if (index == 0) {
//               Navigator.pushReplacementNamed(
//                 context,
//                 AppRoutes.home,
//               );
//             } else if (index == 1) {
//               Navigator.pushReplacementNamed(
//                 context,
//                 AppRoutes.history,
//               );
//             } else if (index == 2) {
//               Navigator.pushReplacementNamed(
//                 context,
//                 AppRoutes.stock,
//               );
//             } else if (index == 3) {
//               Navigator.pushReplacementNamed(
//                 context,
//                 AppRoutes.collection,
//               );
//             } else {
//               setState(() {
//                 _navIndex = index;
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // EDIT EMPLOYEE SHEET
// // ============================================================================
//
// class _EditEmployeeSheet extends StatefulWidget {
//   final Employee employee;
//   final TextEditingController nameController;
//   final TextEditingController jobTitleController;
//   final TextEditingController phoneController;
//
//   const _EditEmployeeSheet({
//     required this.employee,
//     required this.nameController,
//     required this.jobTitleController,
//     required this.phoneController,
//   });
//
//   @override
//   State<_EditEmployeeSheet> createState() =>
//       _EditEmployeeSheetState();
// }
//
// class _EditEmployeeSheetState
//     extends State<_EditEmployeeSheet> {
//   bool _isLoading = false;
//
//   Future<void> _updateEmployee() async {
//     if (widget.nameController.text.trim().isEmpty) {
//       _showError('Please enter name');
//       return;
//     }
//
//     if (widget.jobTitleController.text.trim().isEmpty) {
//       _showError('Please enter job title');
//       return;
//     }
//
//     if (widget.phoneController.text.trim().isEmpty) {
//       _showError('Please enter phone number');
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final bloc = context.read<EmployeeBloc>();
//
//     bloc.add(
//       EmployeeUpdateRequested(
//         id: widget.employee.id,
//         name: widget.nameController.text.trim(),
//         jobTitle:
//         widget.jobTitleController.text.trim(),
//         phone:
//         widget.phoneController.text.trim(),
//       ),
//     );
//
//     try {
//       final result = await bloc.stream.firstWhere(
//             (state) =>
//         state.status ==
//             EmployeeStatus.updated ||
//             state.status ==
//                 EmployeeStatus.error,
//       );
//
//       if (!mounted) return;
//
//       if (result.status ==
//           EmployeeStatus.updated) {
//         Navigator.pop(context);
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//
//         _showError(
//           result.errorMessage ??
//               'Failed to update employee',
//         );
//       }
//     } catch (_) {
//       if (!mounted) return;
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       _showError(
//         'Failed to update employee',
//       );
//     }
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.error,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 20,
//         right: 20,
//         top: 20,
//         bottom:
//         MediaQuery.of(context).viewInsets.bottom +
//             20,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Expanded(
//                 child: Text(
//                   'Edit Employee',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color:
//                     AppColors.textPrimary,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: _isLoading
//                     ? null
//                     : () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(
//                   Icons.close_rounded,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           TextField(
//             controller: widget.nameController,
//             textInputAction:
//             TextInputAction.next,
//             decoration: InputDecoration(
//               labelText: 'Name',
//               filled: true,
//               fillColor:
//               AppColors.background,
//               border: OutlineInputBorder(
//                 borderRadius:
//                 BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 14),
//
//           TextField(
//             controller:
//             widget.jobTitleController,
//             textInputAction:
//             TextInputAction.next,
//             decoration: InputDecoration(
//               labelText: 'Job Title',
//               filled: true,
//               fillColor:
//               AppColors.background,
//               border: OutlineInputBorder(
//                 borderRadius:
//                 BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 14),
//
//           TextField(
//             controller:
//             widget.phoneController,
//             keyboardType:
//             TextInputType.phone,
//             decoration: InputDecoration(
//               labelText: 'Phone',
//               filled: true,
//               fillColor:
//               AppColors.background,
//               border: OutlineInputBorder(
//                 borderRadius:
//                 BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: _isLoading
//                   ? null
//                   : _updateEmployee,
//               style:
//               ElevatedButton.styleFrom(
//                 backgroundColor:
//                 AppColors.primary,
//                 foregroundColor:
//                 Colors.white,
//                 elevation: 0,
//                 shape:
//                 RoundedRectangleBorder(
//                   borderRadius:
//                   BorderRadius.circular(14),
//                 ),
//               ),
//               child: _isLoading
//                   ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child:
//                 CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   valueColor:
//                   AlwaysStoppedAnimation<
//                       Color>(
//                     Colors.white,
//                   ),
//                 ),
//               )
//                   : const Text(
//                 'Update Employee',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight:
//                   FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // EDIT PROFILE SHEET
// // ============================================================================
//
// class _EditProfileSheet
//     extends StatefulWidget {
//   final ProfileBloc profileBloc;
//   final ProfileLoaded initial;
//
//   const _EditProfileSheet({
//     required this.profileBloc,
//     required this.initial,
//   });
//
//   @override
//   State<_EditProfileSheet> createState() =>
//       _EditProfileSheetState();
// }
//
// class _EditProfileSheetState
//     extends State<_EditProfileSheet> {
//   late final TextEditingController
//   _nameController;
//
//   late final TextEditingController
//   _phoneController;
//
//   bool _submitted = false;
//   bool _updated = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _nameController =
//         TextEditingController(
//           text: widget.initial.username,
//         );
//
//     _phoneController =
//         TextEditingController(
//           text: widget.initial.phone,
//         );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 20,
//         right: 20,
//         top: 20,
//         bottom:
//         MediaQuery.of(context)
//             .viewInsets
//             .bottom +
//             20,
//       ),
//       child: BlocConsumer<ProfileBloc,
//           ProfileState>(
//         bloc: widget.profileBloc,
//         listener: (context, state) async {
//           if (_submitted &&
//               state is ProfileLoaded &&
//               !state.isUpdating &&
//               state.updateErrorMessage ==
//                   null) {
//             _submitted = false;
//
//             setState(() {
//               _updated = true;
//             });
//
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Profile updated successfully',
//                 ),
//                 duration:
//                 Duration(seconds: 3),
//                 backgroundColor:
//                 AppColors.success,
//               ),
//             );
//
//             await Future.delayed(
//               const Duration(seconds: 2),
//             );
//
//             if (context.mounted) {
//               Navigator.of(context).pop();
//             }
//           }
//         },
//         builder: (context, state) {
//           final current =
//           state is ProfileLoaded
//               ? state
//               : widget.initial;
//
//           return Column(
//             mainAxisSize:
//             MainAxisSize.min,
//             crossAxisAlignment:
//             CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Edit Profile',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight:
//                   FontWeight.w700,
//                   color:
//                   AppColors.textPrimary,
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               TextField(
//                 controller:
//                 _nameController,
//                 decoration:
//                 InputDecoration(
//                   labelText: 'Name',
//                   filled: true,
//                   fillColor:
//                   AppColors.background,
//                   border:
//                   OutlineInputBorder(
//                     borderRadius:
//                     BorderRadius.circular(
//                         14),
//                     borderSide:
//                     BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 14),
//
//               TextField(
//                 controller:
//                 _phoneController,
//                 keyboardType:
//                 TextInputType.phone,
//                 decoration:
//                 InputDecoration(
//                   labelText: 'Phone',
//                   filled: true,
//                   fillColor:
//                   AppColors.background,
//                   border:
//                   OutlineInputBorder(
//                     borderRadius:
//                     BorderRadius.circular(
//                         14),
//                     borderSide:
//                     BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               if (current
//                   .updateErrorMessage !=
//                   null) ...[
//                 const SizedBox(height: 10),
//                 Text(
//                   current
//                       .updateErrorMessage!,
//                   style:
//                   const TextStyle(
//                     color:
//                     AppColors.error,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//
//               const SizedBox(height: 20),
//
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed:
//                   current.isUpdating ||
//                       _updated
//                       ? null
//                       : () {
//                     if (_nameController
//                         .text
//                         .trim()
//                         .isEmpty) {
//                       return;
//                     }
//
//                     setState(() {
//                       _submitted =
//                       true;
//                     });
//
//                     widget.profileBloc
//                         .add(
//                       ProfileUpdateRequested(
//                         name:
//                         _nameController
//                             .text
//                             .trim(),
//                         phone:
//                         _phoneController
//                             .text
//                             .trim(),
//                       ),
//                     );
//                   },
//                   style:
//                   ElevatedButton.styleFrom(
//                     backgroundColor:
//                     AppColors.primary,
//                     foregroundColor:
//                     Colors.white,
//                     shape:
//                     RoundedRectangleBorder(
//                       borderRadius:
//                       BorderRadius.circular(
//                           14),
//                     ),
//                     elevation: 0,
//                   ),
//                   child:
//                   current.isUpdating
//                       ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child:
//                     CircularProgressIndicator(
//                       strokeWidth:
//                       2.5,
//                       valueColor:
//                       AlwaysStoppedAnimation<
//                           Color>(
//                         Colors.white,
//                       ),
//                     ),
//                   )
//                       : const Text(
//                     'Save Changes',
//                     style:
//                     TextStyle(
//                       fontSize: 15,
//                       fontWeight:
//                       FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // PROFILE HEADER CARD
// // ============================================================================
//
// class _ProfileHeaderCard
//     extends StatelessWidget {
//   final String username;
//   final String role;
//   final VoidCallback onEditTap;
//
//   const _ProfileHeaderCard({
//     required this.username,
//     required this.role,
//     required this.onEditTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding:
//       const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient:
//         const LinearGradient(
//           colors: [
//             AppColors.primary,
//             AppColors.secondary,
//           ],
//           begin:
//           Alignment.topLeft,
//           end:
//           Alignment.bottomRight,
//         ),
//         borderRadius:
//         BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color:
//             AppColors.cardShadow,
//             blurRadius: 20,
//             offset:
//             const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration:
//             BoxDecoration(
//               color: Colors.white
//                   .withOpacity(0.2),
//               shape:
//               BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.person_rounded,
//               color: Colors.white,
//               size: 34,
//             ),
//           ),
//
//           const SizedBox(width: 16),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   username,
//                   maxLines: 1,
//                   overflow:
//                   TextOverflow.ellipsis,
//                   style:
//                   const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight:
//                     FontWeight.bold,
//                   ),
//                 ),
//
//                 const SizedBox(height: 4),
//
//                 Text(
//                   role,
//                   style:
//                   const TextStyle(
//                     color:
//                     Colors.white70,
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           GestureDetector(
//             onTap: onEditTap,
//             child: Container(
//               width: 36,
//               height: 36,
//               decoration:
//               BoxDecoration(
//                 color: Colors.white
//                     .withOpacity(0.15),
//                 shape:
//                 BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.edit_rounded,
//                 color: Colors.white,
//                 size: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // SUMMARY CARD
// // ============================================================================
//
// class _SummaryCard
//     extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color color;
//
//   const _SummaryCard({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding:
//       const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius:
//         BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black
//                 .withOpacity(0.03),
//             blurRadius: 8,
//             offset:
//             const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration:
//             BoxDecoration(
//               color:
//               color.withOpacity(0.12),
//               borderRadius:
//               BorderRadius.circular(
//                   10),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 18,
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           Text(
//             value,
//             maxLines: 1,
//             overflow:
//             TextOverflow.ellipsis,
//             style:
//             const TextStyle(
//               fontSize: 18,
//               fontWeight:
//               FontWeight.bold,
//               color:
//               AppColors.textPrimary,
//             ),
//           ),
//
//           const SizedBox(height: 2),
//
//           Text(
//             label,
//             style:
//             const TextStyle(
//               fontSize: 12,
//               color:
//               AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // EMPLOYEE CARD
// // ============================================================================
//
// class _EmployeeCard
//     extends StatelessWidget {
//   final Employee employee;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//
//   const _EmployeeCard({
//     required this.employee,
//     required this.onEdit,
//     required this.onDelete,
//   });
//
//   String get _initials {
//     final parts = employee.name
//         .trim()
//         .split(' ')
//         .where(
//           (p) => p.isNotEmpty,
//     )
//         .toList();
//
//     if (parts.isEmpty) {
//       return '?';
//     }
//
//     return parts
//         .map(
//           (p) => p[0],
//     )
//         .take(2)
//         .join()
//         .toUpperCase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding:
//       const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius:
//         BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black
//                 .withOpacity(0.03),
//             blurRadius: 8,
//             offset:
//             const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // AVATAR
//           Container(
//             width: 44,
//             height: 44,
//             decoration:
//             const BoxDecoration(
//               color:
//               AppColors.navSelectedBackground,
//               shape:
//               BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 _initials,
//                 style:
//                 const TextStyle(
//                   color:
//                   AppColors.primary,
//                   fontWeight:
//                   FontWeight.w700,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // DETAILS
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//               CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   employee.name,
//                   maxLines: 1,
//                   overflow:
//                   TextOverflow.ellipsis,
//                   style:
//                   const TextStyle(
//                     fontSize: 14,
//                     fontWeight:
//                     FontWeight.w700,
//                     color:
//                     AppColors.textPrimary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 3),
//
//                 Text(
//                   employee.jobTitle,
//                   maxLines: 1,
//                   overflow:
//                   TextOverflow.ellipsis,
//                   style:
//                   const TextStyle(
//                     fontSize: 12,
//                     color:
//                     AppColors.textSecondary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 3),
//
//                 Text(
//                   employee.phone,
//                   style:
//                   const TextStyle(
//                     fontSize: 11,
//                     color:
//                     AppColors.textSecondary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 5),
//
//                 Row(
//                   children: [
//                     Container(
//                       width: 7,
//                       height: 7,
//                       decoration:
//                       BoxDecoration(
//                         color: employee
//                             .isActive
//                             ? AppColors.success
//                             : AppColors.error,
//                         shape:
//                         BoxShape.circle,
//                       ),
//                     ),
//
//                     const SizedBox(width: 5),
//
//                     Text(
//                       employee.isActive
//                           ? 'Active'
//                           : 'Inactive',
//                       style:
//                       TextStyle(
//                         fontSize: 10,
//                         fontWeight:
//                         FontWeight.w600,
//                         color: employee
//                             .isActive
//                             ? AppColors.success
//                             : AppColors.error,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(width: 8),
//
//           // SALARY + ACTIONS
//           Column(
//             crossAxisAlignment:
//             CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '₹${employee.monthlySalary.toStringAsFixed(0)}',
//                 style:
//                 const TextStyle(
//                   fontSize: 14,
//                   fontWeight:
//                   FontWeight.w700,
//                   color:
//                   AppColors.primary,
//                 ),
//               ),
//
//               const SizedBox(height: 2),
//
//               const Text(
//                 'Monthly',
//                 style:
//                 TextStyle(
//                   fontSize: 10,
//                   color:
//                   AppColors.textSecondary,
//                 ),
//               ),
//
//               const SizedBox(height: 4),
//
//               Row(
//                 mainAxisSize:
//                 MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     onPressed: onEdit,
//                     padding:
//                     EdgeInsets.zero,
//                     constraints:
//                     const BoxConstraints(
//                       minWidth: 30,
//                       minHeight: 30,
//                     ),
//                     icon:
//                     const Icon(
//                       Icons.edit_rounded,
//                       size: 17,
//                       color:
//                       AppColors.primary,
//                     ),
//                   ),
//
//                   IconButton(
//                     onPressed: onDelete,
//                     padding:
//                     EdgeInsets.zero,
//                     constraints:
//                     const BoxConstraints(
//                       minWidth: 30,
//                       minHeight: 30,
//                     ),
//                     icon:
//                     const Icon(
//                       Icons
//                           .delete_outline_rounded,
//                       size: 18,
//                       color:
//                       AppColors.error,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ============================================================================
// // EMPTY EMPLOYEE
// // ============================================================================
//
// class _EmptyEmployeeView
//     extends StatelessWidget {
//   final VoidCallback onAdd;
//
//   const _EmptyEmployeeView({
//     required this.onAdd,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding:
//       const EdgeInsets.symmetric(
//         vertical: 30,
//         horizontal: 20,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius:
//         BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           const Icon(
//             Icons.groups_outlined,
//             size: 45,
//             color:
//             AppColors.textSecondary,
//           ),
//
//           const SizedBox(height: 10),
//
//           const Text(
//             'No employees found',
//             style:
//             TextStyle(
//               fontSize: 14,
//               fontWeight:
//               FontWeight.w600,
//               color:
//               AppColors.textPrimary,
//             ),
//           ),
//
//           const SizedBox(height: 5),
//
//           const Text(
//             'Add your first employee',
//             style:
//             TextStyle(
//               fontSize: 12,
//               color:
//               AppColors.textSecondary,
//             ),
//           ),
//
//           const SizedBox(height: 15),
//
//           ElevatedButton.icon(
//             onPressed: onAdd,
//             icon: const Icon(
//               Icons.add_rounded,
//             ),
//             label: const Text(
//               'Add Employee',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/token_service.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../routes/app_routes.dart';

import '../../employees/add_employee/view/add_employee_page.dart';
import '../../employees/bloc/employee_bloc.dart';
import '../../employees/models/employee.dart';
import '../../employees/salary/view/employee_salary_page.dart';

import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _navIndex = 4;

  // ============================================================
  // ADD EMPLOYEE
  // ============================================================

  Future<void> _addEmployee(BuildContext context) async {
    final employeeBloc = context.read<EmployeeBloc>();

    await Navigator.push<Employee>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: employeeBloc,
          child: const AddEmployeePage(),
        ),
      ),
    );

    if (!context.mounted) return;

    employeeBloc.add(
      EmployeesLoadRequested(),
    );
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  Future<void> _editProfile(
      BuildContext context,
      ProfileLoaded loaded,
      ) async {
    final profileBloc = context.read<ProfileBloc>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return _EditProfileSheet(
          profileBloc: profileBloc,
          initial: loaded,
        );
      },
    );
  }

  // ============================================================
  // EDIT EMPLOYEE
  // ============================================================

  Future<void> _editEmployee(
      BuildContext context,
      Employee employee,
      ) async {
    final nameController = TextEditingController(
      text: employee.name,
    );

    final jobTitleController = TextEditingController(
      text: employee.jobTitle,
    );

    final phoneController = TextEditingController(
      text: employee.phone,
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return _EditEmployeeSheet(
          employee: employee,
          nameController: nameController,
          jobTitleController: jobTitleController,
          phoneController: phoneController,
        );
      },
    );

    nameController.dispose();
    jobTitleController.dispose();
    phoneController.dispose();
  }

  // ============================================================
  // DELETE EMPLOYEE
  // ============================================================

  Future<void> _deleteEmployee(
      BuildContext context,
      Employee employee,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Deactivate Employee',
          ),
          content: Text(
            'Are you sure you want to deactivate ${employee.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Deactivate',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    context.read<EmployeeBloc>().add(
      EmployeeDeleteRequested(
        employee.id,
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await TokenService.instance.clearTokens();

      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // PROFILE BLOC
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc()
            ..add(
              ProfileStarted(),
            ),
        ),

        // EMPLOYEE BLOC
        BlocProvider<EmployeeBloc>(
          create: (_) => EmployeeBloc()
            ..add(
              EmployeesLoadRequested(),
            ),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,

        // ========================================================
        // APP BAR
        // ========================================================

        appBar: const CustomAppBar(
          title: 'Profile',
        ),

        // ========================================================
        // BODY
        // ========================================================

        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            // PROFILE LOADING
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // PROFILE ERROR
            if (state is ProfileError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 40,
                        color: AppColors.error,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                            ProfileStarted(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // WAITING
            if (state is! ProfileLoaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final loaded = state;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(
                  ProfileStarted(),
                );

                context.read<EmployeeBloc>().add(
                  EmployeesLoadRequested(),
                );

                await Future.delayed(
                  const Duration(milliseconds: 500),
                );
              },

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // PROFILE HEADER
                    // ==================================================

                    _ProfileHeaderCard(
                      username: loaded.username,
                      role: loaded.role,
                      onEditTap: () {
                        _editProfile(
                          context,
                          loaded,
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // SUMMARY CARDS
                    // ==================================================

                    BlocBuilder<EmployeeBloc, EmployeeState>(
                      builder: (
                          context,
                          employeeState,
                          ) {
                        final employees =
                            employeeState.employees;

                        double totalSalary = 0;

                        for (final employee in employees) {
                          totalSalary += employee.monthlySalary;
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: _SummaryCard(
                                label: 'Employees',
                                value: '${employees.length}',
                                icon: Icons.groups_rounded,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _SummaryCard(
                                label: 'Monthly Payroll',
                                value:
                                '₹${totalSalary.toStringAsFixed(0)}',
                                icon: Icons.payments_rounded,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // EMPLOYEE HEADER
                    // ==================================================

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Employee Cards',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            _addEmployee(context);
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color:
                              AppColors.navSelectedBackground,
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),

                                SizedBox(width: 4),

                                Text(
                                  'Add Employee',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ==================================================
                    // EMPLOYEE LIST
                    // ==================================================

                    BlocConsumer<EmployeeBloc, EmployeeState>(
                      listener: (
                          context,
                          employeeState,
                          ) {
                        // CREATED
                        if (employeeState.status ==
                            EmployeeStatus.created) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Employee added successfully',
                              ),
                              backgroundColor:
                              AppColors.success,
                            ),
                          );

                          context
                              .read<EmployeeBloc>()
                              .add(
                            EmployeesLoadRequested(),
                          );
                        }

                        // UPDATED
                        if (employeeState.status ==
                            EmployeeStatus.updated) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Employee updated successfully',
                              ),
                              backgroundColor:
                              AppColors.success,
                            ),
                          );

                          context
                              .read<EmployeeBloc>()
                              .add(
                            EmployeesLoadRequested(),
                          );
                        }

                        // DELETED
                        if (employeeState.status ==
                            EmployeeStatus.deleted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Employee deactivated successfully',
                              ),
                              backgroundColor:
                              AppColors.success,
                            ),
                          );

                          context
                              .read<EmployeeBloc>()
                              .add(
                            EmployeesLoadRequested(),
                          );
                        }

                        // ERROR
                        if (employeeState.status ==
                            EmployeeStatus.error) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                employeeState.errorMessage ??
                                    'Something went wrong',
                              ),
                              backgroundColor:
                              AppColors.error,
                            ),
                          );
                        }
                      },

                      builder: (
                          context,
                          employeeState,
                          ) {
                        // LOADING
                        if (employeeState.status ==
                            EmployeeStatus.loading) {
                          return const Padding(
                            padding:
                            EdgeInsets.symmetric(
                              vertical: 40,
                            ),
                            child: Center(
                              child:
                              CircularProgressIndicator(),
                            ),
                          );
                        }

                        // CREATING
                        if (employeeState.status ==
                            EmployeeStatus.creating) {
                          return const Padding(
                            padding:
                            EdgeInsets.symmetric(
                              vertical: 30,
                            ),
                            child: Center(
                              child:
                              CircularProgressIndicator(),
                            ),
                          );
                        }

                        final employees =
                            employeeState.employees;

                        // EMPTY
                        if (employees.isEmpty) {
                          return _EmptyEmployeeView(
                            onAdd: () {
                              _addEmployee(context);
                            },
                          );
                        }

                        // LIST
                        return Column(
                          children: employees.map(
                                (employee) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: _EmployeeCard(
                                  employee: employee,

                                  onEdit: () {
                                    _editEmployee(
                                      context,
                                      employee,
                                    );
                                  },

                                  onDelete: () {
                                    _deleteEmployee(
                                      context,
                                      employee,
                                    );
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // ==================================================
                    // LOGOUT
                    // ==================================================

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _logout(context);
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: AppColors.error,
                          size: 18,
                        ),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        style:
                        OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.error,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // ==========================================================
        // BOTTOM NAVIGATION
        // ==========================================================

        bottomNavigationBar:
        CustomBottomNavBar(
          currentIndex: _navIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.home,
              );
            } else if (index == 1) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.history,
              );
            } else if (index == 2) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.stock,
              );
            } else if (index == 3) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.collection,
              );
            } else {
              setState(() {
                _navIndex = index;
              });
            }
          },
        ),
      ),
    );
  }
}

// ============================================================================
// EDIT EMPLOYEE SHEET
// ============================================================================

class _EditEmployeeSheet extends StatefulWidget {
  final Employee employee;
  final TextEditingController nameController;
  final TextEditingController jobTitleController;
  final TextEditingController phoneController;

  const _EditEmployeeSheet({
    required this.employee,
    required this.nameController,
    required this.jobTitleController,
    required this.phoneController,
  });

  @override
  State<_EditEmployeeSheet> createState() =>
      _EditEmployeeSheetState();
}

class _EditEmployeeSheetState
    extends State<_EditEmployeeSheet> {
  bool _isLoading = false;

  Future<void> _updateEmployee() async {
    if (widget.nameController.text.trim().isEmpty) {
      _showError('Please enter name');
      return;
    }

    if (widget.jobTitleController.text.trim().isEmpty) {
      _showError('Please enter job title');
      return;
    }

    if (widget.phoneController.text.trim().isEmpty) {
      _showError('Please enter phone number');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final bloc = context.read<EmployeeBloc>();

    bloc.add(
      EmployeeUpdateRequested(
        id: widget.employee.id,
        name: widget.nameController.text.trim(),
        jobTitle:
        widget.jobTitleController.text.trim(),
        phone:
        widget.phoneController.text.trim(),
      ),
    );

    try {
      final result = await bloc.stream.firstWhere(
            (state) =>
        state.status == EmployeeStatus.updated ||
            state.status == EmployeeStatus.error,
      );

      if (!mounted) return;

      if (result.status ==
          EmployeeStatus.updated) {
        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });

        _showError(
          result.errorMessage ??
              'Failed to update employee',
        );
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showError(
        'Failed to update employee',
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom:
        MediaQuery.of(context)
            .viewInsets
            .bottom +
            20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Edit Employee',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              IconButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          TextField(
            controller: widget.nameController,
            textInputAction:
            TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Name',
              filled: true,
              fillColor:
              AppColors.background,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),
                borderSide:
                BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller:
            widget.jobTitleController,
            textInputAction:
            TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Job Title',
              filled: true,
              fillColor:
              AppColors.background,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),
                borderSide:
                BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller:
            widget.phoneController,
            keyboardType:
            TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone',
              filled: true,
              fillColor:
              AppColors.background,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),
                borderSide:
                BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _updateEmployee,
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppColors.primary,
                foregroundColor:
                Colors.white,
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                  AlwaysStoppedAnimation<
                      Color>(
                    Colors.white,
                  ),
                ),
              )
                  : const Text(
                'Update Employee',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EDIT PROFILE SHEET
// ============================================================================

class _EditProfileSheet
    extends StatefulWidget {
  final ProfileBloc profileBloc;
  final ProfileLoaded initial;

  const _EditProfileSheet({
    required this.profileBloc,
    required this.initial,
  });

  @override
  State<_EditProfileSheet> createState() =>
      _EditProfileSheetState();
}

class _EditProfileSheetState
    extends State<_EditProfileSheet> {
  late final TextEditingController
  _nameController;

  late final TextEditingController
  _phoneController;

  bool _submitted = false;
  bool _updated = false;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(
          text: widget.initial.username,
        );

    _phoneController =
        TextEditingController(
          text: widget.initial.phone,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom:
        MediaQuery.of(context)
            .viewInsets
            .bottom +
            20,
      ),
      child: BlocConsumer<ProfileBloc,
          ProfileState>(
        bloc: widget.profileBloc,

        listener: (context, state) async {
          if (_submitted &&
              state is ProfileLoaded &&
              !state.isUpdating &&
              state.updateErrorMessage ==
                  null) {
            _submitted = false;

            setState(() {
              _updated = true;
            });

            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Profile updated successfully',
                ),
                duration:
                Duration(seconds: 3),
                backgroundColor:
                AppColors.success,
              ),
            );

            await Future.delayed(
              const Duration(seconds: 2),
            );

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },

        builder: (context, state) {
          final current =
          state is ProfileLoaded
              ? state
              : widget.initial;

          return Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller:
                _nameController,
                decoration:
                InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor:
                  AppColors.background,
                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller:
                _phoneController,
                keyboardType:
                TextInputType.phone,
                decoration:
                InputDecoration(
                  labelText: 'Phone',
                  filled: true,
                  fillColor:
                  AppColors.background,
                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              if (current
                  .updateErrorMessage !=
                  null) ...[
                const SizedBox(height: 10),

                Text(
                  current
                      .updateErrorMessage!,
                  style:
                  const TextStyle(
                    color:
                    AppColors.error,
                    fontSize: 12,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                ElevatedButton(
                  onPressed:
                  current.isUpdating ||
                      _updated
                      ? null
                      : () {
                    if (_nameController
                        .text
                        .trim()
                        .isEmpty) {
                      return;
                    }

                    setState(() {
                      _submitted =
                      true;
                    });

                    widget
                        .profileBloc
                        .add(
                      ProfileUpdateRequested(
                        name:
                        _nameController
                            .text
                            .trim(),
                        phone:
                        _phoneController
                            .text
                            .trim(),
                      ),
                    );
                  },
                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    AppColors.primary,
                    foregroundColor:
                    Colors.white,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        14,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child:
                  current.isUpdating
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth:
                      2.5,
                      valueColor:
                      AlwaysStoppedAnimation<
                          Color>(
                        Colors.white,
                      ),
                    ),
                  )
                      : const Text(
                    'Save Changes',
                    style:
                    TextStyle(
                      fontSize:
                      15,
                      fontWeight:
                      FontWeight
                          .w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// PROFILE HEADER CARD
// ============================================================================

class _ProfileHeaderCard
    extends StatelessWidget {
  final String username;
  final String role;
  final VoidCallback onEditTap;

  const _ProfileHeaderCard({
    required this.username,
    required this.role,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin:
          Alignment.topLeft,
          end:
          Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
            AppColors.cardShadow,
            blurRadius: 20,
            offset:
            const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration:
            BoxDecoration(
              color: Colors.white
                  .withOpacity(0.2),
              shape:
              BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  username,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  role,
                  style:
                  const TextStyle(
                    color:
                    Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 36,
              height: 36,
              decoration:
              BoxDecoration(
                color: Colors.white
                    .withOpacity(0.15),
                shape:
                BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SUMMARY CARD
// ============================================================================

class _SummaryCard
    extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.03),
            blurRadius: 8,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration:
            BoxDecoration(
              color:
              color.withOpacity(
                0.12,
              ),
              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style:
            const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
              color:
              AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style:
            const TextStyle(
              fontSize: 12,
              color:
              AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPLOYEE CARD
// ============================================================================

class _EmployeeCard
    extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmployeeCard({
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  String get _initials {
    final parts = employee.name
        .trim()
        .split(' ')
        .where(
          (p) => p.isNotEmpty,
    )
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    return parts
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();
  }

  // ============================================================
  // OPEN SALARY HISTORY
  // ============================================================

  void _openSalaryHistory(
      BuildContext context,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EmployeeSalaryPage(
              // ✅ IMPORTANT:
              // EmployeeSalaryPage requires Employee,
              // NOT employeeId.
              employee: employee,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openSalaryHistory(context);
      },
      child: Container(
        padding:
        const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius:
          BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.03),
              blurRadius: 8,
              offset:
              const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ==================================================
            // AVATAR
            // ==================================================

            Container(
              width: 44,
              height: 44,
              decoration:
              const BoxDecoration(
                color: AppColors
                    .navSelectedBackground,
                shape:
                BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials,
                  style:
                  const TextStyle(
                    color:
                    AppColors.primary,
                    fontWeight:
                    FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ==================================================
            // EMPLOYEE DETAILS
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Text(
                    employee.name,
                    maxLines: 1,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style:
                    const TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w700,
                      color:
                      AppColors
                          .textPrimary,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    employee.jobTitle
                        .isEmpty
                        ? employee.role
                        : employee.jobTitle,
                    maxLines: 1,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style:
                    const TextStyle(
                      fontSize: 12,
                      color:
                      AppColors
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    employee.phone,
                    style:
                    const TextStyle(
                      fontSize: 11,
                      color:
                      AppColors
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration:
                        BoxDecoration(
                          color: employee
                              .isActive
                              ? AppColors
                              .success
                              : AppColors
                              .error,
                          shape:
                          BoxShape
                              .circle,
                        ),
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Text(
                        employee.isActive
                            ? 'Active'
                            : 'Inactive',
                        style:
                        TextStyle(
                          fontSize: 10,
                          fontWeight:
                          FontWeight
                              .w600,
                          color: employee
                              .isActive
                              ? AppColors
                              .success
                              : AppColors
                              .error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ==================================================
            // SALARY + ACTIONS
            // ==================================================

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${employee.monthlySalary.toStringAsFixed(0)}',
                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    AppColors.primary,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                const Text(
                  'Monthly',
                  style:
                  TextStyle(
                    fontSize: 10,
                    color: AppColors
                        .textSecondary,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    // SALARY HISTORY
                    IconButton(
                      onPressed: () {
                        _openSalaryHistory(
                          context,
                        );
                      },
                      padding:
                      EdgeInsets.zero,
                      constraints:
                      const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      tooltip:
                      'Salary & History',
                      icon: const Icon(
                        Icons
                            .payments_outlined,
                        size: 18,
                        color:
                        AppColors
                            .primary,
                      ),
                    ),

                    // EDIT
                    IconButton(
                      onPressed: onEdit,
                      padding:
                      EdgeInsets.zero,
                      constraints:
                      const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      tooltip:
                      'Edit Employee',
                      icon: const Icon(
                        Icons.edit_rounded,
                        size: 17,
                        color:
                        AppColors
                            .primary,
                      ),
                    ),

                    // DELETE
                    IconButton(
                      onPressed:
                      onDelete,
                      padding:
                      EdgeInsets.zero,
                      constraints:
                      const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      tooltip:
                      'Deactivate Employee',
                      icon: const Icon(
                        Icons
                            .delete_outline_rounded,
                        size: 18,
                        color:
                        AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY EMPLOYEE
// ============================================================================

class _EmptyEmployeeView
    extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyEmployeeView({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.groups_outlined,
            size: 45,
            color:
            AppColors.textSecondary,
          ),

          const SizedBox(height: 10),

          const Text(
            'No employees found',
            style:
            TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w600,
              color:
              AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Add your first employee',
            style:
            TextStyle(
              fontSize: 12,
              color:
              AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: const Text(
              'Add Employee',
            ),
          ),
        ],
      ),
    );
  }
}