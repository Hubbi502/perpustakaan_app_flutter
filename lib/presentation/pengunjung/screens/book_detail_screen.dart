import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/utils/date_formatter.dart';
import 'package:library_app/core/widgets/app_button.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/error_widget.dart';
import 'package:library_app/presentation/auth/providers/auth_provider.dart';
import 'package:library_app/presentation/pengunjung/providers/book_provider.dart';
import 'package:library_app/presentation/pengunjung/providers/loan_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// Book detail screen with cover image, info, and borrow action.
class BookDetailScreen extends StatefulWidget {
  final int bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _isBorrowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().fetchBookDetail(widget.bookId);
    });
  }

  Future<void> _borrowBook() async {
    setState(() => _isBorrowing = true);

    try {
      await context.read<LoanProvider>().createLoan(widget.bookId);
      if (!mounted) return;
      AppSnackbar.success(context, 'Permintaan peminjaman berhasil dikirim! 📚');
      Navigator.of(context).pop();
    } on AppException catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, e.message);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Gagal meminjam buku');
    }

    if (mounted) setState(() => _isBorrowing = false);
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final authProvider = context.watch<AuthProvider>();
    final book = bookProvider.selectedBook;
    final canBorrow = authProvider.user?.canBorrowBooks ?? false;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: bookProvider.isLoading
          ? _buildShimmer()
          : bookProvider.error != null
              ? AppErrorWidget(
                  message: bookProvider.error!,
                  onRetry: () => bookProvider.fetchBookDetail(widget.bookId),
                )
              : book == null
                  ? const SizedBox.shrink()
                  : CustomScrollView(
                      slivers: [
                        // Cover image as app bar
                        SliverAppBar(
                          expandedHeight: 320,
                          pinned: true,
                          backgroundColor: AppColors.surfaceDark,
                          flexibleSpace: FlexibleSpaceBar(
                            background: book.coverImageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: book.coverImageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Shimmer.fromColors(
                                      baseColor: AppColors.cardDarkLight,
                                      highlightColor: AppColors.surfaceDark,
                                      child: Container(color: AppColors.cardDarkLight),
                                    ),
                                    errorWidget: (_, __, ___) => _buildCoverPlaceholder(),
                                  )
                                : _buildCoverPlaceholder(),
                          ),
                        ),

                        // Content
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category chip
                                if (book.category != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      book.category!.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 200.ms),

                                const SizedBox(height: 14),

                                // Title
                                Text(
                                  book.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    height: 1.3,
                                  ),
                                ).animate().fadeIn(delay: 300.ms),

                                const SizedBox(height: 8),

                                // Author
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline_rounded, size: 18, color: AppColors.textTertiary),
                                    const SizedBox(width: 6),
                                    Text(
                                      book.author,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ).animate().fadeIn(delay: 400.ms),

                                const SizedBox(height: 6),

                                // Date
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textTertiary),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Ditambahkan ${DateFormatter.timeAgo(book.createdAt)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ).animate().fadeIn(delay: 450.ms),

                                const SizedBox(height: 24),

                                // Divider
                                Container(height: 1, color: AppColors.divider),

                                const SizedBox(height: 20),

                                // Description
                                Text(
                                  'Deskripsi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  book.description ?? 'Tidak ada deskripsi.',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.7,
                                  ),
                                ).animate().fadeIn(delay: 500.ms),

                                const SizedBox(height: 32),

                                // Borrow button (only for pengunjung)
                                if (canBorrow)
                                  AppButton(
                                    text: 'Pinjam Buku',
                                    icon: Icons.bookmark_add_rounded,
                                    onPressed: _borrowBook,
                                    isLoading: _isBorrowing,
                                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      color: AppColors.cardDarkLight,
      child: const Center(
        child: Icon(Icons.menu_book_rounded, size: 80, color: AppColors.textTertiary),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.cardDarkLight,
      highlightColor: AppColors.surfaceDark,
      child: Column(
        children: [
          Container(height: 320, color: AppColors.cardDarkLight),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 80, height: 28, color: AppColors.cardDarkLight),
                const SizedBox(height: 14),
                Container(width: double.infinity, height: 30, color: AppColors.cardDarkLight),
                const SizedBox(height: 10),
                Container(width: 200, height: 20, color: AppColors.cardDarkLight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
