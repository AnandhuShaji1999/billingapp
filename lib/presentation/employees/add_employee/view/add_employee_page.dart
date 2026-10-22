import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../bloc/employee_bloc.dart';


class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _salaryController = TextEditingController();
  final _passwordController = TextEditingController();

  String _role = 'staff';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    _salaryController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // ============================================================
  // CREATE EMPLOYEE
  // ============================================================

  void _createEmployee() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<EmployeeBloc>().add(
      EmployeeCreateRequested(
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _role,
        jobTitle: _jobTitleController.text.trim(),
        monthlySalary: _salaryController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  // ============================================================
  // VALIDATORS
  // ============================================================

  String? _requiredValidator(
      String? value,
      String field,
      ) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    if (value.trim().length < 10) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  String? _salaryValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Monthly salary is required';
    }

    final salary = double.tryParse(value.trim());

    if (salary == null) {
      return 'Enter a valid salary';
    }

    if (salary < 0) {
      return 'Salary cannot be negative';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        size: 20,
        color: AppColors.textSecondary,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Add Employee',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state.status == EmployeeStatus.created) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Employee added successfully',
                ),
                backgroundColor: AppColors.success,
              ),
            );

            Navigator.pop(
              context,
              state.createdEmployee,
            );
          }

          if (state.status == EmployeeStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Failed to add employee',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isCreating =
              state.status == EmployeeStatus.creating;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                30,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                          Colors.white24,
                          child: Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Employee',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Enter employee details below',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // PERSONAL INFORMATION
                  // ==================================================

                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _nameController,
                    textInputAction:
                    TextInputAction.next,
                    decoration: _inputDecoration(
                      label: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      hint: 'Enter employee name',
                    ),
                    validator: (value) =>
                        _requiredValidator(
                          value,
                          'Name',
                        ),
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction:
                    TextInputAction.next,
                    decoration: _inputDecoration(
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      hint: '9876543211',
                    ),
                    validator: _phoneValidator,
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _emailController,
                    keyboardType:
                    TextInputType.emailAddress,
                    textInputAction:
                    TextInputAction.next,
                    decoration: _inputDecoration(
                      label: 'Email',
                      icon: Icons.email_outlined,
                      hint: 'employee@example.com',
                    ),
                    validator: _emailValidator,
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // ACCOUNT INFORMATION
                  // ==================================================

                  const Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _usernameController,
                    textInputAction:
                    TextInputAction.next,
                    decoration: _inputDecoration(
                      label: 'Username',
                      icon: Icons.alternate_email_rounded,
                      hint: 'cashier',
                    ),
                    validator: (value) =>
                        _requiredValidator(
                          value,
                          'Username',
                        ),
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: _role,
                    decoration: _inputDecoration(
                      label: 'Role',
                      icon: Icons.badge_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'staff',
                        child: Text('Staff'),
                      ),
                      DropdownMenuItem(
                        value: 'manager',
                        child: Text('Manager'),
                      ),
                      DropdownMenuItem(
                        value: 'admin',
                        child: Text('Admin'),
                      ),
                    ],
                    onChanged: isCreating
                        ? null
                        : (value) {
                      if (value == null) return;

                      setState(() {
                        _role = value;
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction:
                    TextInputAction.next,
                    decoration: _inputDecoration(
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      hint: 'Enter password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword =
                            !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons
                              .visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: _passwordValidator,
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // JOB INFORMATION
                  // ==================================================

                  const Text(
                    'Job Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _jobTitleController,
                    textInputAction:
                    TextInputAction.next,
                    decoration: _inputDecoration(
                      label: 'Job Title',
                      icon: Icons.work_outline_rounded,
                      hint: 'Cashier',
                    ),
                    validator: (value) =>
                        _requiredValidator(
                          value,
                          'Job title',
                        ),
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _salaryController,
                    keyboardType:
                    const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction:
                    TextInputAction.done,
                    decoration: _inputDecoration(
                      label: 'Monthly Salary',
                      icon: Icons.payments_outlined,
                      hint: '15000.00',
                    ),
                    validator: _salaryValidator,
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // CREATE BUTTON
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                      isCreating
                          ? null
                          : _createEmployee,
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
                          BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                      child: isCreating
                          ? const SizedBox(
                        width: 22,
                        height: 22,
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
                          : const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons
                                .person_add_alt_1_rounded,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Create Employee',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}