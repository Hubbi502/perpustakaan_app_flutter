import 'package:intl/intl.dart';

/// Date formatting utilities.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _fullFormat = DateFormat('dd MMMM yyyy', 'id');
  static final DateFormat _shortFormat = DateFormat('dd MMM yyyy', 'id');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, HH:mm', 'id');
  static final DateFormat _timeAgo = DateFormat('dd/MM/yyyy');

  /// Parse ISO 8601 date string.
  static DateTime? parse(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Format to "16 Mei 2026"
  static String full(String? dateString) {
    final date = parse(dateString);
    if (date == null) return '-';
    return _fullFormat.format(date);
  }

  /// Format to "16 Mei 2026"
  static String short(String? dateString) {
    final date = parse(dateString);
    if (date == null) return '-';
    return _shortFormat.format(date);
  }

  /// Format to "16 Mei 2026, 14:30"
  static String dateTime(String? dateString) {
    final date = parse(dateString);
    if (date == null) return '-';
    return _dateTimeFormat.format(date);
  }

  /// Relative time ago: "2 jam lalu", "3 hari lalu"
  static String timeAgo(String? dateString) {
    final date = parse(dateString);
    if (date == null) return '-';

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} minggu lalu';
    return _timeAgo.format(date);
  }

  /// Check if a date is overdue (past today).
  static bool isOverdue(String? dateString) {
    final date = parse(dateString);
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }

  /// Days remaining until a date.
  static int daysRemaining(String? dateString) {
    final date = parse(dateString);
    if (date == null) return 0;
    return date.difference(DateTime.now()).inDays;
  }
}
