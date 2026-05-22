import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/utils/date_formatter.dart';
import 'package:library_app/domain/entities/loan.dart';

/// Loan card widget with status badge.
class LoanCard extends StatelessWidget {
  final Loan loan;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const LoanCard({super.key, required this.loan, this.onTap, this.onCancel});

  Color get _statusColor {
    if (loan.isOverdue) return AppColors.statusOverdue;
    switch (loan.status) {
      case 'pending':
        return AppColors.statusPending;
      case 'approved':
        return AppColors.statusApproved;
      case 'returned':
        return AppColors.statusReturned;
      case 'rejected':
        return AppColors.statusRejected;
      default:
        return AppColors.textTertiary;
    }
  }

  String get _statusText {
    if (loan.isOverdue) return 'Terlambat';
    switch (loan.status) {
      case 'pending':
        return 'Menunggu';
      case 'approved':
        return 'Dipinjam';
      case 'returned':
        return 'Dikembalikan';
      case 'rejected':
        return 'Ditolak';
      default:
        return loan.status;
    }
  }

  IconData get _statusIcon {
    if (loan.isOverdue) return Icons.warning_amber_rounded;
    switch (loan.status) {
      case 'pending':
        return Icons.hourglass_bottom_rounded;
      case 'approved':
        return Icons.check_circle_outline_rounded;
      case 'returned':
        return Icons.assignment_return_outlined;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            // Book icon placeholder
            Container(
              width: 52,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.cardDarkLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: AppColors.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loan.book?.title ?? 'Buku #${loan.bookId}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (loan.book?.author != null)
                    Text(
                      loan.book!.author,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        loan.dueDate != null
                            ? 'Tenggat: ${DateFormatter.short(loan.dueDate)}'
                            : DateFormatter.short(loan.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: loan.isOverdue ? AppColors.statusOverdue : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Status + Cancel
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, size: 14, color: _statusColor),
                      const SizedBox(width: 4),
                      Text(
                        _statusText,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (loan.isPending && onCancel != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onCancel,
                    child: Text(
                      'Batalkan',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
