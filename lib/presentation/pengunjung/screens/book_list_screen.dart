import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/widgets/empty_state.dart';
import 'package:library_app/core/widgets/error_widget.dart';
import 'package:library_app/presentation/pengunjung/providers/book_provider.dart';
import 'package:library_app/presentation/pengunjung/widgets/book_card.dart';
import 'package:library_app/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// Book list screen with infinite scroll pagination.
class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().fetchBooks();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BookProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text(
          'Semua Buku',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '${bookProvider.total} buku',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
      body: bookProvider.isLoading
          ? _buildShimmer()
          : bookProvider.error != null
              ? AppErrorWidget(
                  message: bookProvider.error!,
                  onRetry: () => bookProvider.fetchBooks(),
                )
              : bookProvider.books.isEmpty
                  ? const EmptyState(
                      icon: Icons.menu_book_rounded,
                      title: 'Belum ada buku',
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: bookProvider.books.length + (bookProvider.hasMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= bookProvider.books.length) {
                          return Shimmer.fromColors(
                            baseColor: AppColors.cardDarkLight,
                            highlightColor: AppColors.surfaceDark,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardDarkLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          );
                        }

                        final book = bookProvider.books[index];
                        return BookCard(
                          book: book,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.bookDetail,
                              arguments: book.id,
                            );
                          },
                        );
                      },
                    ),
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.cardDarkLight,
        highlightColor: AppColors.surfaceDark,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardDarkLight,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
