/// Form field validators for client-side validation.
class Validators {
  Validators._();

  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != password) {
      return 'Password tidak cocok';
    }
    return null;
  }

  static String? minLength(String? value, int min, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    if (value.trim().length < min) {
      return '$fieldName minimal $min karakter';
    }
    return null;
  }

  static String? maxLength(String? value, int max, [String fieldName = 'Field']) {
    if (value != null && value.trim().length > max) {
      return '$fieldName maksimal $max karakter';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }
    if (value.trim().length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }
}
