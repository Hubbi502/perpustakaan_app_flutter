import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/utils/date_formatter.dart';
import 'package:library_app/core/widgets/app_button.dart';
import 'package:library_app/presentation/auth/providers/auth_provider.dart';
import 'package:library_app/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Profile screen with user info and logout.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text('Profil', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : '?',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().scale(begin: const Offset(0.6, 0.6), curve: Curves.elasticOut),

            const SizedBox(height: 16),

            Text(
              user?.name ?? '-',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 4),

            Text(
              user?.email ?? '-',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ).animate(delay: 300.ms).fadeIn(),

            const SizedBox(height: 8),

            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (user?.role ?? 'pengunjung').toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: 32),

            // Info cards
            _buildInfoTile(
              icon: Icons.calendar_today_rounded,
              label: 'Bergabung sejak',
              value: DateFormatter.full(user?.createdAt),
            ).animate(delay: 500.ms).fadeIn().slideX(begin: 0.1),

            const SizedBox(height: 12),

            _buildInfoTile(
              icon: Icons.verified_user_outlined,
              label: 'Status akun',
              value: user?.emailVerifiedAt != null ? 'Terverifikasi' : 'Belum terverifikasi',
            ).animate(delay: 600.ms).fadeIn().slideX(begin: 0.1),

            const SizedBox(height: 40),

            // Logout button
            AppButton(
              text: 'Keluar',
              variant: AppButtonVariant.danger,
              icon: Icons.logout_rounded,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surfaceDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Text('Keluar?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    content: Text(
                      'Anda yakin ingin keluar dari akun?',
                      style: GoogleFonts.inter(color: AppColors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Batal', style: GoogleFonts.inter(color: AppColors.textTertiary)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Ya, Keluar', style: GoogleFonts.inter(color: AppColors.error)),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
                  }
                }
              },
            ).animate(delay: 700.ms).fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
