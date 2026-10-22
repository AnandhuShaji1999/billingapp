double _profileToDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _profileToInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

/// "user" block of GET /api/mobile/profile/
class ProfileUser {
  final int id;
  final String name;
  final String role; // e.g. "admin"
  final String jobTitle; // e.g. "Shop Owner"
  final String phone; // not in the response today, kept for future use

  const ProfileUser({
    required this.id,
    required this.name,
    required this.role,
    required this.jobTitle,
    required this.phone,
  });

  /// Text shown under the name on the profile header.
  String get displayTitle => jobTitle.isNotEmpty ? jobTitle : role;

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: _profileToInt(json['id']),
      name: (json['name'] ?? json['username'] ?? 'User').toString(),
      role: (json['role'] ?? '').toString(),
      jobTitle: (json['job_title'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }
}

/// One entry of "employees" in GET /api/mobile/profile/
class ProfileEmployee {
  final int id;
  final String name;
  final String jobTitle;
  final double monthlySalary;

  const ProfileEmployee({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.monthlySalary,
  });

  factory ProfileEmployee.fromJson(Map<String, dynamic> json) {
    return ProfileEmployee(
      id: _profileToInt(json['id']),
      name: (json['name'] ?? '').toString(),
      jobTitle: (json['job_title'] ?? '').toString(),
      monthlySalary: _profileToDouble(json['monthly_salary']),
    );
  }
}

/// Full response of GET /api/mobile/profile/
///
/// {
///   "user": { id, name, role, job_title },
///   "employee_count": 1,
///   "last_month": "2026-08",
///   "last_month_scheduled_payroll": "15000.00",
///   "employees": [ { id, name, job_title, monthly_salary } ]
/// }
///
/// last_month_scheduled_payroll is the configured salary of active staff who
/// joined by last month — it is NOT salary-payment history.
class ProfileResponseModel {
  final ProfileUser user;
  final int employeeCount;
  final String lastMonth;
  final double lastMonthScheduledPayroll;
  final List<ProfileEmployee> employees;

  const ProfileResponseModel({
    required this.user,
    required this.employeeCount,
    required this.lastMonth,
    required this.lastMonthScheduledPayroll,
    required this.employees,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final userRaw = json['user'];
    final employeesRaw = json['employees'];

    return ProfileResponseModel(
      user: ProfileUser.fromJson(
        userRaw is Map ? userRaw.cast<String, dynamic>() : const {},
      ),
      employeeCount: _profileToInt(json['employee_count']),
      lastMonth: (json['last_month'] ?? '').toString(),
      lastMonthScheduledPayroll:
      _profileToDouble(json['last_month_scheduled_payroll']),
      employees: employeesRaw is List
          ? employeesRaw
          .whereType<Map>()
          .map(
            (e) => ProfileEmployee.fromJson(e.cast<String, dynamic>()),
      )
          .toList()
          : <ProfileEmployee>[],
    );
  }
}