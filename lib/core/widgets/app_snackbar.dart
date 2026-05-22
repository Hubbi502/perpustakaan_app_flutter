import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Styled snackbar utility with variants.
class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.inter(fontSize: 14)),
          action: action,
          duration: duration,
        ),
      );
  }

  static void success(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.cardDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  static void error(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.cardDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  static void warning(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.cardDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
