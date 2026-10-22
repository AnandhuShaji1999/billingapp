class SalaryHistory {
  final int id;
  final int employee;
  final double previousSalary;
  final double newSalary;
  final String effectiveOn;
  final String reason;
  final int changedBy;
  final DateTime? createdAt;

  const SalaryHistory({
    required this.id,
    required this.employee,
    required this.previousSalary,
    required this.newSalary,
    required this.effectiveOn,
    required this.reason,
    required this.changedBy,
    required this.createdAt,
  });

  factory SalaryHistory.fromJson(
      Map<String, dynamic> json,
      ) {
    return SalaryHistory(
      id: _toInt(json['id']),
      employee: _toInt(json['employee']),
      previousSalary: _toDouble(
        json['previous_salary'],
      ),
      newSalary: _toDouble(
        json['new_salary'],
      ),
      effectiveOn:
      json['effective_on']?.toString() ?? '',
      reason:
      json['reason']?.toString() ?? '',
      changedBy:
      _toInt(json['changed_by']),
      createdAt: _parseDate(
        json['created_at'],
      ),
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

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }
}