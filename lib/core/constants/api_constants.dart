class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'http://34.171.55.230';

  static const String login = '$baseUrl/api/auth/login/';
  static const String refreshToken = '$baseUrl/api/auth/refresh/';
  static const String me = '$baseUrl/api/auth/me/';
  static const String updateProfile = '$baseUrl/api/auth/profile/';


  static String homeForMonth(String month) =>
      '$baseUrl/api/mobile/home/?month=$month';
  static const String history =
      '$baseUrl/api/mobile/history/';

  static const String historyReport =
      '$baseUrl/api/mobile/history/report.pdf';

  static const String stock =
      '$baseUrl/api/mobile/stock/';

  static const String collection =
      '$baseUrl/api/mobile/collection/';

  static const String profile =
      '$baseUrl/api/mobile/profile/';

  static const String updateMobileProfile =
      '$baseUrl/api/mobile/profile/';


  static const String employees =
      '$baseUrl/api/mobile/employees/';


  static String employeeById(int id) =>
      '$baseUrl/api/mobile/employees/$id/';

  static String employeeSalary(int id) =>
      '$baseUrl/api/mobile/employees/$id/salary/';



  static String employeeSalaryHistory(int id) =>
      '$baseUrl/api/mobile/employees/$id/salary-history/';
}