class ApiConstants {
  ApiConstants._();

  // Base URL — change to production URL when deploying
  // Use 10.0.2.2 for Android Emulator, localhost for web/desktop
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String storageUrl = 'http://10.0.2.2:8000/storage';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String user = '/user';

  // Book Endpoints
  static const String books = '/books';
  static String bookById(int id) => '/books/$id';

  // Category Endpoints
  static const String categories = '/categories';
  static String categoryById(int id) => '/categories/$id';

  // Loan Endpoints
  static const String loans = '/loans';
  static String loanById(int id) => '/loans/$id';
  static String returnLoan(int id) => '/loans/$id/return';

  // User Management Endpoints (Admin)
  static const String users = '/users';
  static String userById(int id) => '/users/$id';

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;

  // Pagination
  static const int defaultPageSize = 15;
}
