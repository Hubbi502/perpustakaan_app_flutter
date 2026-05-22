import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/presentation/auth/providers/auth_provider.dart';
import 'package:library_app/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Animated splash screen with auto-login check.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final isLoggedIn = await authProvider.checkAuthStatus();

    if (!mounted) return;

    if (isLoggedIn && authProvider.user != null) {
      AppRouter.navigateToRoleHome(context, authProvider.user!.role);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_library_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 28),

              // Title
              Text(
                'Perpustakaan',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Kelola perpustakaanmu dengan mudah',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              )
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 48),

              // Loading indicator
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ).animate(delay: 700.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
