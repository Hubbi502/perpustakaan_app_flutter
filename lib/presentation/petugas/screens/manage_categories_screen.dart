import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/utils/validators.dart';
import 'package:library_app/core/widgets/app_button.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/app_text_field.dart';
import 'package:library_app/core/widgets/empty_state.dart';
import 'package:library_app/core/widgets/error_widget.dart';
import 'package:library_app/domain/entities/category.dart';
import 'package:library_app/presentation/petugas/providers/category_management_provider.dart';
import 'package:provider/provider.dart';

/// Manage categories screen with add/edit/delete.
class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryManagementProvider>().fetchCategories();
    });
  }

  void _showCategoryForm({Category? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final descController = TextEditingController(text: category?.description ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 20),
                Text(
                  category != null ? 'Edit Kategori' : 'Tambah Kategori',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 20),
                AppTextField(controller: nameController, label: 'Nama', hint: 'Nama kategori', validator: (v) => Validators.required(v, 'Nama')),
                const SizedBox(height: 16),
                AppTextField(controller: descController, label: 'Deskripsi', hint: 'Deskripsi singkat', maxLines: 3),
                const SizedBox(height: 24),
                Consumer<CategoryManagementProvider>(
                  builder: (_, provider, __) => AppButton(
                    text: category != null ? 'Simpan' : 'Tambah',
                    isLoading: provider.isSaving,
                    onPressed: () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      try {
                        if (category != null) {
                          await provider.updateCategory(category.id, name: nameController.text.trim(), description: descController.text.trim());
                        } else {
                          await provider.createCategory(name: nameController.text.trim(), description: descController.text.trim());
                        }
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          AppSnackbar.success(context, category != null ? 'Kategori diperbarui' : 'Kategori ditambahkan');
                        }
                      } on AppException catch (e) {
                        if (ctx.mounted) AppSnackbar.error(context, e.message);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryManagementProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text('Kelola Kategori', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryForm(),
        child: const Icon(Icons.add_rounded),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceDark,
        onRefresh: () => provider.fetchCategories(),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)))
            : provider.error != null
                ? AppErrorWidget(message: provider.error!, onRetry: () => provider.fetchCategories())
                : provider.categories.isEmpty
                    ? const EmptyState(icon: Icons.category_rounded, title: 'Belum ada kategori')
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.categories.length,
                        itemBuilder: (context, index) {
                          final cat = provider.categories[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.category_rounded, color: AppColors.secondary, size: 22),
                              ),
                              title: Text(cat.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              subtitle: Text('${cat.booksCount ?? 0} buku • ${cat.description ?? ""}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                              trailing: PopupMenuButton(
                                color: AppColors.surfaceDark,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                itemBuilder: (_) => [
                                  PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit_rounded, size: 18, color: AppColors.primary), const SizedBox(width: 8), Text('Edit', style: GoogleFonts.inter(fontSize: 14))])),
                                  PopupMenuItem(value: 'delete', child: Row(children: [const Icon(Icons.delete_rounded, size: 18, color: AppColors.error), const SizedBox(width: 8), Text('Hapus', style: GoogleFonts.inter(fontSize: 14, color: AppColors.error))])),
                                ],
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    _showCategoryForm(category: cat);
                                  } else if (value == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        backgroundColor: AppColors.surfaceDark,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        title: Text('Hapus Kategori?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                        content: Text('Buku terkait juga akan dihapus!', style: GoogleFonts.inter(color: AppColors.error)),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Hapus', style: GoogleFonts.inter(color: AppColors.error))),
                                        ],
                                      ),
                                    );
                                    if (confirm == true && mounted) {
                                      try {
                                        await provider.deleteCategory(cat.id);
                                        if (mounted) AppSnackbar.success(context, 'Kategori dihapus');
                                      } on AppException catch (e) {
                                        if (mounted) AppSnackbar.error(context, e.message);
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
