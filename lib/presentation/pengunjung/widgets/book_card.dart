import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/domain/entities/book.dart';
import 'package:shimmer/shimmer.dart';

/// Premium book card widget with image caching and hover effect.
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: book.coverImageUrl != null && book.coverImageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: book.coverImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AppColors.cardDarkLight,
                          highlightColor: AppColors.surfaceDark,
                          child: Container(color: AppColors.cardDarkLight),
                        ),
                        errorWidget: (context, url, error) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),

            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category chip
                    if (book.category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.category!.name,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      book.title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Author
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 13,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            book.author,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.cardDarkLight,
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 40,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
