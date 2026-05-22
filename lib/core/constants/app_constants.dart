class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Perpustakaan';
  static const String appVersion = '1.0.0';

  // Roles
  static const String rolePengunjung = 'pengunjung';
  static const String rolePetugas = 'petugas';
  static const String roleAdmin = 'admin';

  // Secure Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String userRoleKey = 'user_role';
  static const String rememberMeKey = 'remember_me';

  // Image Upload
  static const int maxImageSizeBytes = 2 * 1024 * 1024; // 2MB
  static const List<String> allowedImageExtensions = [
    'jpeg',
    'jpg',
    'png',
    'webp',
  ];

  // Debounce
  static const Duration searchDebounce = Duration(milliseconds: 300);

  // Loan Status
  static const String loanStatusPending = 'pending';
  static const String loanStatusApproved = 'approved';
  static const String loanStatusReturned = 'returned';
  static const String loanStatusRejected = 'rejected';
  static const String loanStatusOverdue = 'overdue';
}
