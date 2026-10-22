class RefreshTokenResponseModel {
  final String access;

  const RefreshTokenResponseModel({required this.access});

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      access: json['access'] as String? ?? '',
    );
  }
}