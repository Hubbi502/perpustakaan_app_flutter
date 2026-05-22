/// Base exception for all app-specific errors.
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'AppException: $message (statusCode: $statusCode)';
}

/// 401 — Invalid credentials or token expired.
class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Sesi telah berakhir, silakan login kembali'])
      : super(message, statusCode: 401);
}

/// 401 — Wrong password specifically.
class WrongPasswordException extends AppException {
  const WrongPasswordException([String message = 'Email atau password salah'])
      : super(message, statusCode: 401);
}

/// 404 — Resource not found.
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Data tidak ditemukan'])
      : super(message, statusCode: 404);
}

/// 422 — Validation errors from server.
class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException({
    String message = 'Data tidak valid',
    required this.errors,
  }) : super(message, statusCode: 422);

  /// Get first error message from all fields.
  String get firstError {
    for (final fieldErrors in errors.values) {
      if (fieldErrors.isNotEmpty) return fieldErrors.first;
    }
    return message;
  }
}

/// 429 — Rate limit exceeded.
class RateLimitException extends AppException {
  const RateLimitException([String message = 'Terlalu banyak request, coba lagi nanti'])
      : super(message, statusCode: 429);
}

/// 500 — Server error.
class ServerException extends AppException {
  const ServerException([String message = 'Terjadi kesalahan pada server'])
      : super(message, statusCode: 500);
}

/// Network connectivity issues.
class NetworkException extends AppException {
  const NetworkException([String message = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.'])
      : super(message);
}

/// 403 — Forbidden / insufficient role.
class ForbiddenException extends AppException {
  const ForbiddenException([String message = 'Anda tidak memiliki akses untuk melakukan aksi ini'])
      : super(message, statusCode: 403);
}

/// Timeout exception.
class TimeoutException extends AppException {
  const TimeoutException([String message = 'Koneksi timeout, coba lagi'])
      : super(message);
}
