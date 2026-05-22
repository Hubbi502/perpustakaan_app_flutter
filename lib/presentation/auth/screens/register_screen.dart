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

/// Premium register screen with glassmorphism design.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = context.read<AuthProvider>();

    try {
      final user = await authProvider.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _confirmPasswordController.text,
      );

      if (!mounted) return;
      AppSnackbar.success(context, 'Registrasi berhasil! Selamat datang 🎉');
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
                      Icons.person_add_rounded,
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
                    'Buat Akun Baru',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 6),

                  Text(
                    'Daftar untuk mulai membaca',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textTertiary,
                    ),
                  ).animate(delay: 300.ms).fadeIn(),

                  const SizedBox(height: 32),

                  // Register Card — Glassmorphism
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
                            controller: _nameController,
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama lengkap',
                            prefixIcon: Icons.person_outline_rounded,
                            textInputAction: TextInputAction.next,
                            validator: Validators.name,
                          ),

                          const SizedBox(height: 18),

                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'nama@email.com',
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.email,
                          ),

                          const SizedBox(height: 18),

                          AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Minimal 8 karakter',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            onToggleObscure: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                            validator: Validators.password,
                          ),

                          const SizedBox(height: 18),

                          AppTextField(
                            controller: _confirmPasswordController,
                            label: 'Konfirmasi Password',
                            hint: 'Ulangi password',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            onToggleObscure: () {
                              setState(() => _obscureConfirm = !_obscureConfirm);
                            },
                            validator: (value) => Validators.confirmPassword(
                              value,
                              _passwordController.text,
                            ),
                          ),

                          const SizedBox(height: 28),

                          AppButton(
                            text: 'Daftar',
                            onPressed: _handleRegister,
                            isLoading: authProvider.isLoading,
                            icon: Icons.app_registration_rounded,
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.15),

                  const SizedBox(height: 28),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(AppRouter.login);
                        },
                        child: Text(
                          'Masuk Disini',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ).animate(delay: 600.ms).fadeIn(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
