import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/theme/app_text_styles.dart';
import 'package:library_app/core/widgets/app_button.dart';

/// Styled error display widget with retry action.
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withValues(alpha: 0.1),
              ),
              child: Icon(icon, size: 48, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! Terjadi Kesalahan',
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: 'Coba Lagi',
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                isFullWidth: false,
                size: AppButtonSize.small,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
