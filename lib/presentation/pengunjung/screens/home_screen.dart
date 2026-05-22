import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/widgets/empty_state.dart';
import 'package:library_app/core/widgets/error_widget.dart';
import 'package:library_app/presentation/auth/providers/auth_provider.dart';
import 'package:library_app/presentation/pengunjung/providers/book_provider.dart';
import 'package:library_app/presentation/pengunjung/widgets/book_card.dart';
import 'package:library_app/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// Pengunjung home screen with greeting, categories, and book grid.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookProvider = context.read<BookProvider>();
      bookProvider.fetchBooks();
      bookProvider.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bookProvider = context.watch<BookProvider>();
    final userName = authProvider.user?.name ?? 'Pengunjung';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surfaceDark,
            onRefresh: () async {
              await bookProvider.fetchBooks();
              await bookProvider.fetchCategories();
            },
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, $userName 👋',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                                const SizedBox(height: 4),
                                Text(
                                  'Temukan buku favoritmu',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textTertiary,
                                  ),
                                ).animate(delay: 200.ms).fadeIn(),
                              ],
                            ),
                            // Avatar
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ).animate(delay: 300.ms).scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Search bar
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRouter.bookList);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 22),
                                const SizedBox(width: 12),
                                Text(
                                  'Cari buku, penulis...',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),
                      ],
                    ),
                  ),
                ),

                // Categories
                if (bookProvider.categories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kategori',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: bookProvider.categories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final category = bookProvider.categories[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${category.name} (${category.booksCount ?? 0})',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 500.ms).fadeIn(),
                  ),

                // Section title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Buku Terbaru',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(AppRouter.bookList),
                          child: Text(
                            'Lihat Semua →',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 600.ms).fadeIn(),
                ),

                // Book Grid
                if (bookProvider.isLoading)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Shimmer.fromColors(
                          baseColor: AppColors.cardDarkLight,
                          highlightColor: AppColors.surfaceDark,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardDarkLight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        childCount: 4,
                      ),
                    ),
                  )
                else if (bookProvider.error != null)
                  SliverFillRemaining(
                    child: AppErrorWidget(
                      message: bookProvider.error!,
                      onRetry: () => bookProvider.fetchBooks(),
                    ),
                  )
                else if (bookProvider.books.isEmpty)
                  const SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.menu_book_rounded,
                      title: 'Belum ada buku',
                      subtitle: 'Buku akan muncul di sini saat tersedia',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final book = bookProvider.books[index];
                          return BookCard(
                            book: book,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRouter.bookDetail,
                                arguments: book.id,
                              );
                            },
                          ).animate(delay: (100 * index).ms).fadeIn().slideY(begin: 0.1);
                        },
                        childCount: bookProvider.books.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
