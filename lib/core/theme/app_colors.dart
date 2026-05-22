import 'package:flutter/material.dart';

/// Curated color palette for the library app.
/// Uses a sophisticated dark theme with indigo/blue accents.
class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B83FF);
  static const Color primaryDark = Color(0xFF4A42E8);

  // Secondary Palette
  static const Color secondary = Color(0xFF00D2FF);
  static const Color secondaryLight = Color(0xFF5CE1FF);
  static const Color secondaryDark = Color(0xFF009DC7);

  // Accent
  static const Color accent = Color(0xFFFF6B9D);
  static const Color accentLight = Color(0xFFFF8DB5);
  static const Color accentDark = Color(0xFFE84D7E);

  // Background (Dark Theme)
  static const Color backgroundDark = Color(0xFF0A0E21);
  static const Color surfaceDark = Color(0xFF1A1F38);
  static const Color cardDark = Color(0xFF222750);
  static const Color cardDarkLight = Color(0xFF2A2F58);

  // Background (Light Theme)
  static const Color backgroundLight = Color(0xFFF5F7FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFF2F2F2);
  static const Color textSecondary = Color(0xFFB0B3C5);
  static const Color textTertiary = Color(0xFF6B6F8A);
  static const Color textDark = Color(0xFF1A1F38);
  static const Color textDarkSecondary = Color(0xFF6B6F8A);

  // Status Colors
  static const Color success = Color(0xFF00E676);
  static const Color successLight = Color(0xFFB9F6CA);
  static const Color warning = Color(0xFFFFB74D);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color error = Color(0xFFFF5252);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color info = Color(0xFF448AFF);
  static const Color infoLight = Color(0xFFBBDEFB);

  // Loan Status Colors
  static const Color statusPending = Color(0xFFFFB74D);
  static const Color statusApproved = Color(0xFF00E676);
  static const Color statusReturned = Color(0xFF448AFF);
  static const Color statusRejected = Color(0xFFFF5252);
  static const Color statusOverdue = Color(0xFFFF1744);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, Color(0xFF141834)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2A2F58), Color(0xFF1A1F38)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFFF3D85)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism
  static Color glassBackground = Colors.white.withValues(alpha: 0.08);
  static Color glassBorder = Colors.white.withValues(alpha: 0.15);
  static Color glassShadow = Colors.black.withValues(alpha: 0.3);

  // Divider
  static Color divider = Colors.white.withValues(alpha: 0.08);
}
