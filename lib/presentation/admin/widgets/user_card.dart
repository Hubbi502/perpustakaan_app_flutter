import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/domain/entities/user.dart';

/// User card widget for admin management.
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UserCard({super.key, required this.user, this.onEdit, this.onDelete});

  Color get _roleColor {
    switch (user.role) {
      case 'admin': return AppColors.accent;
      case 'petugas': return AppColors.secondary;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _roleColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: _roleColor),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(user.email, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _roleColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              user.role.toUpperCase(),
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _roleColor, letterSpacing: 0.5),
            ),
          ),
          if (onEdit != null || onDelete != null) ...[
            const SizedBox(width: 8),
            PopupMenuButton(
              color: AppColors.surfaceDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              itemBuilder: (_) => [
                if (onEdit != null)
                  PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit_rounded, size: 18, color: AppColors.primary), const SizedBox(width: 8), Text('Edit', style: GoogleFonts.inter(fontSize: 14))])),
                if (onDelete != null)
                  PopupMenuItem(value: 'delete', child: Row(children: [const Icon(Icons.delete_rounded, size: 18, color: AppColors.error), const SizedBox(width: 8), Text('Hapus', style: GoogleFonts.inter(fontSize: 14, color: AppColors.error))])),
              ],
              onSelected: (v) {
                if (v == 'edit') onEdit?.call();
                if (v == 'delete') onDelete?.call();
              },
            ),
          ],
        ],
      ),
    );
  }
}
