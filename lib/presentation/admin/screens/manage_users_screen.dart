import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/empty_state.dart';
import 'package:library_app/core/widgets/error_widget.dart';
import 'package:library_app/presentation/admin/providers/user_management_provider.dart';
import 'package:library_app/presentation/admin/widgets/user_card.dart';
import 'package:library_app/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Manage users screen for admin.
class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserManagementProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserManagementProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text('Kelola Pengguna', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          Text('${provider.users.length} pengguna', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(AppRouter.userForm);
          if (mounted) provider.fetchUsers();
        },
        child: const Icon(Icons.person_add_rounded),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceDark,
        onRefresh: () => provider.fetchUsers(),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)))
            : provider.error != null
                ? AppErrorWidget(message: provider.error!, onRetry: () => provider.fetchUsers())
                : provider.users.isEmpty
                    ? const EmptyState(icon: Icons.people_rounded, title: 'Belum ada pengguna')
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.users.length,
                        itemBuilder: (context, index) {
                          final user = provider.users[index];
                          return UserCard(
                            user: user,
                            onEdit: () async {
                              await Navigator.of(context).pushNamed(AppRouter.userForm, arguments: user);
                              if (mounted) provider.fetchUsers();
                            },
                            onDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: AppColors.surfaceDark,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  title: Text('Hapus Pengguna?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                  content: Text('"${user.name}" akan dihapus permanen.', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Hapus', style: GoogleFonts.inter(color: AppColors.error))),
                                  ],
                                ),
                              );
                              if (confirm == true && mounted) {
                                try {
                                  await provider.deleteUser(user.id);
                                  if (mounted) AppSnackbar.success(context, 'Pengguna dihapus');
                                } on AppException catch (e) {
                                  if (mounted) AppSnackbar.error(context, e.message);
                                }
                              }
                            },
                          );
                        },
                      ),
      ),
    );
  }
}
