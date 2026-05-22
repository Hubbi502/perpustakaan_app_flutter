import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/utils/validators.dart';
import 'package:library_app/core/widgets/app_button.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/app_text_field.dart';
import 'package:library_app/presentation/auth/providers/auth_provider.dart';
import 'package:library_app/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Premium login screen with glassmorphism design.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = context.read<AuthProvider>();

    try {
      final user = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (!mounted) return;
      AppRouter.navigateToRoleHome(context, user.role);
    } on ValidationException catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, e.firstError);
    } on AppException catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, e.message);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Terjadi kesalahan, silakan coba lagi');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_library_rounded,
                      size: 42,
                      color: Colors.white,
                    ),
                  ).animate().scale(
                        begin: const Offset(0.6, 0.6),
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: 24),

                  Text(
                    'Selamat Datang',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 6),

                  Text(
                    'Masuk untuk melanjutkan',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textTertiary,
                    ),
                  ).animate(delay: 300.ms).fadeIn(),

                  const SizedBox(height: 36),

                  // Login Card — Glassmorphism
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.glassBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.glassBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'nama@email.com',
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.email,
                          ),

                          const SizedBox(height: 20),

                          AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Masukkan password',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onToggleObscure: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                            validator: Validators.password,
                          ),

                          const SizedBox(height: 12),

                          // Remember me
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: BorderSide(color: AppColors.textTertiary),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => setState(() => _rememberMe = !_rememberMe),
                                child: Text(
                                  'Ingat saya',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          AppButton(
                            text: 'Masuk',
                            onPressed: _handleLogin,
                            isLoading: authProvider.isLoading,
                            icon: Icons.login_rounded,
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.15),

                  const SizedBox(height: 28),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(AppRouter.register);
                        },
                        child: Text(
                          'Daftar Sekarang',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ).animate(delay: 600.ms).fadeIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
