import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/empty_state.dart';
import 'package:library_app/core/widgets/error_widget.dart';
import 'package:library_app/presentation/petugas/providers/book_management_provider.dart';
import 'package:library_app/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Manage books screen with list, add, edit, delete.
class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({super.key});

  @override
  State<ManageBooksScreen> createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookManagementProvider>().fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookManagementProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text('Kelola Buku', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          Text('${provider.total} buku', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(AppRouter.bookForm);
          if (mounted) provider.fetchBooks();
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceDark,
        onRefresh: () => provider.fetchBooks(),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)))
            : provider.error != null
                ? AppErrorWidget(message: provider.error!, onRetry: () => provider.fetchBooks())
                : provider.books.isEmpty
                    ? const EmptyState(icon: Icons.menu_book_rounded, title: 'Belum ada buku')
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.books.length,
                        itemBuilder: (context, index) {
                          final book = provider.books[index];
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
                                width: 48,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.cardDarkLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.menu_book_rounded, color: AppColors.textTertiary, size: 24),
                              ),
                              title: Text(
                                book.title,
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${book.author} • ${book.category?.name ?? ""}',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              trailing: PopupMenuButton(
                                color: AppColors.surfaceDark,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                itemBuilder: (ctx) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(children: [
                                      const Icon(Icons.edit_rounded, size: 18, color: AppColors.primary),
                                      const SizedBox(width: 8),
                                      Text('Edit', style: GoogleFonts.inter(fontSize: 14)),
                                    ]),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(children: [
                                      const Icon(Icons.delete_rounded, size: 18, color: AppColors.error),
                                      const SizedBox(width: 8),
                                      Text('Hapus', style: GoogleFonts.inter(fontSize: 14, color: AppColors.error)),
                                    ]),
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await Navigator.of(context).pushNamed(AppRouter.bookForm, arguments: book);
                                    if (mounted) provider.fetchBooks();
                                  } else if (value == 'delete') {
                                    _confirmDelete(book.id, book.title);
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

  Future<void> _confirmDelete(int id, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Buku?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Buku "$title" akan dihapus permanen.', style: GoogleFonts.inter(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Hapus', style: GoogleFonts.inter(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await context.read<BookManagementProvider>().deleteBook(id);
        if (mounted) AppSnackbar.success(context, 'Buku berhasil dihapus');
      } on AppException catch (e) {
        if (mounted) AppSnackbar.error(context, e.message);
      }
    }
  }
}
