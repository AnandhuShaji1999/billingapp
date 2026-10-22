class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      name: (json['name'] ??
          json['username'] ??
          json['full_name'] ??
          'User') as String,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'Shop Owner',
      phone: json['phone'] as String? ?? '',
    );
  }
}