class Employee {
  final int id;
  final String email;
  final String username;
  final String name;
  final String phone;
  final String role;
  final String jobTitle;
  final double monthlySalary;
  final bool isActive;

  const Employee({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.phone,
    required this.role,
    required this.jobTitle,
    required this.monthlySalary,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: _toInt(json['id']),
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      jobTitle: json['job_title']?.toString() ?? '',
      monthlySalary: _toDouble(json['monthly_salary']),
      isActive: json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'phone': phone,
      'role': role,
      'job_title': jobTitle,
      'monthly_salary': monthlySalary.toStringAsFixed(2),
      'is_active': isActive,
    };
  }

  Employee copyWith({
    int? id,
    String? email,
    String? username,
    String? name,
    String? phone,
    String? role,
    String? jobTitle,
    double? monthlySalary,
    bool? isActive,
  }) {
    return Employee(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      jobTitle: jobTitle ?? this.jobTitle,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      isActive: isActive ?? this.isActive,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }
}