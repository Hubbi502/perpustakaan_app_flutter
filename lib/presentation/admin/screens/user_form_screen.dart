import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/utils/validators.dart';
import 'package:library_app/core/widgets/app_button.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/app_text_field.dart';
import 'package:library_app/domain/entities/user.dart';
import 'package:library_app/presentation/admin/providers/user_management_provider.dart';
import 'package:provider/provider.dart';

/// User add/edit form screen for admin.
class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'pengunjung';
  bool _obscurePassword = true;
  bool get isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<UserManagementProvider>();

    try {
      if (isEditing) {
        await provider.updateUser(
          widget.user!.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          role: _selectedRole,
          password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
        );
        if (mounted) AppSnackbar.success(context, 'Pengguna berhasil diperbarui');
      } else {
        await provider.createUser(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole,
        );
        if (mounted) AppSnackbar.success(context, 'Pengguna berhasil ditambahkan');
      }
      if (mounted) Navigator.pop(context);
    } on ValidationException catch (e) {
      if (mounted) AppSnackbar.error(context, e.firstError);
    } on AppException catch (e) {
      if (mounted) AppSnackbar.error(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserManagementProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text(isEditing ? 'Edit Pengguna' : 'Tambah Pengguna', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                hint: 'Masukkan nama',
                prefixIcon: Icons.person_outline_rounded,
                validator: Validators.name,
              ),

              const SizedBox(height: 18),

              AppTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'nama@email.com',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),

              const SizedBox(height: 18),

              AppTextField(
                controller: _passwordController,
                label: isEditing ? 'Password Baru (opsional)' : 'Password',
                hint: isEditing ? 'Kosongkan jika tidak diubah' : 'Minimal 8 karakter',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                validator: isEditing ? null : Validators.password,
              ),

              const SizedBox(height: 18),

              // Role selector
              Text(
                'Role',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                dropdownColor: AppColors.surfaceDark,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.admin_panel_settings_rounded)),
                items: const [
                  DropdownMenuItem(value: 'pengunjung', child: Text('Pengunjung')),
                  DropdownMenuItem(value: 'petugas', child: Text('Petugas')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (v) => setState(() => _selectedRole = v ?? 'pengunjung'),
              ),

              const SizedBox(height: 32),

              AppButton(
                text: isEditing ? 'Simpan Perubahan' : 'Tambah Pengguna',
                icon: isEditing ? Icons.save_rounded : Icons.person_add_rounded,
                onPressed: _save,
                isLoading: provider.isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
