import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppButtonVariant { primary, secondary, outlined, danger, ghost }
enum AppButtonSize { small, medium, large }

/// Premium reusable button with gradient, loading state, and variants.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? prefixIcon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final height = switch (size) {
      AppButtonSize.small => 40.0,
      AppButtonSize.medium => 52.0,
      AppButtonSize.large => 60.0,
    };

    final fontSize = switch (size) {
      AppButtonSize.small => 13.0,
      AppButtonSize.medium => 15.0,
      AppButtonSize.large => 17.0,
    };

    final borderRadius = BorderRadius.circular(14);

    if (variant == AppButtonVariant.primary) {
      return SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: onPressed != null && !isLoading
                ? AppColors.primaryGradient
                : null,
            color: onPressed == null || isLoading
                ? AppColors.textTertiary.withValues(alpha: 0.3)
                : null,
            borderRadius: borderRadius,
            boxShadow: onPressed != null && !isLoading
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: _buildChild(fontSize, Colors.white),
          ),
        ),
      );
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: switch (variant) {
        AppButtonVariant.secondary => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cardDark,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
            child: _buildChild(fontSize, AppColors.primary),
          ),
        AppButtonVariant.outlined => OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              side: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            child: _buildChild(fontSize, AppColors.primary),
          ),
        AppButtonVariant.danger => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
            child: _buildChild(fontSize, Colors.white),
          ),
        AppButtonVariant.ghost => TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
            child: _buildChild(fontSize, AppColors.primary),
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildChild(double fontSize, Color color) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    final textWidget = Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );

    if (icon != null || prefixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon!,
            const SizedBox(width: 8),
          ] else if (icon != null) ...[
            Icon(icon, size: fontSize + 4, color: color),
            const SizedBox(width: 8),
          ],
          textWidget,
        ],
      );
    }

    return textWidget;
  }
}
