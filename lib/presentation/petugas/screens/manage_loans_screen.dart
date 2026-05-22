import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/utils/date_formatter.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/empty_state.dart';
import 'package:library_app/core/widgets/error_widget.dart';
import 'package:library_app/domain/entities/loan.dart';
import 'package:library_app/presentation/petugas/providers/loan_management_provider.dart';
import 'package:provider/provider.dart';

/// Manage loans screen — approve, reject, return.
class ManageLoansScreen extends StatefulWidget {
  const ManageLoansScreen({super.key});

  @override
  State<ManageLoansScreen> createState() => _ManageLoansScreenState();
}

class _ManageLoansScreenState extends State<ManageLoansScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanManagementProvider>().fetchLoans();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _approveLoan(int id) async {
    try {
      await context.read<LoanManagementProvider>().approveLoan(id);
      if (mounted) AppSnackbar.success(context, 'Peminjaman disetujui ✅');
    } on AppException catch (e) {
      if (mounted) AppSnackbar.error(context, e.message);
    }
  }

  Future<void> _rejectLoan(int id) async {
    try {
      await context.read<LoanManagementProvider>().rejectLoan(id);
      if (mounted) AppSnackbar.warning(context, 'Peminjaman ditolak');
    } on AppException catch (e) {
      if (mounted) AppSnackbar.error(context, e.message);
    }
  }

  Future<void> _returnLoan(int id) async {
    try {
      await context.read<LoanManagementProvider>().returnLoan(id);
      if (mounted) AppSnackbar.success(context, 'Buku dikembalikan 📚');
    } on AppException catch (e) {
      if (mounted) AppSnackbar.error(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoanManagementProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text('Kelola Peminjaman', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Pending (${provider.pendingLoans.length})'),
            Tab(text: 'Aktif (${provider.activeLoans.length})'),
            Tab(text: 'Selesai (${provider.completedLoans.length})'),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceDark,
        onRefresh: () => provider.fetchLoans(),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)))
            : provider.error != null
                ? AppErrorWidget(message: provider.error!, onRetry: () => provider.fetchLoans())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(provider.pendingLoans, 'pending'),
                      _buildList(provider.activeLoans, 'active'),
                      _buildList(provider.completedLoans, 'completed'),
                    ],
                  ),
      ),
    );
  }

  Widget _buildList(List<Loan> loans, String type) {
    if (loans.isEmpty) {
      return EmptyState(
        icon: type == 'pending' ? Icons.hourglass_empty : type == 'active' ? Icons.bookmark : Icons.done_all,
        title: type == 'pending' ? 'Tidak ada yang menunggu' : type == 'active' ? 'Tidak ada peminjaman aktif' : 'Belum ada riwayat',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.book?.title ?? 'Buku #${loan.bookId}',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Peminjam: ${loan.user?.name ?? "User #${loan.userId}"}',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tanggal: ${DateFormatter.short(loan.createdAt)}',
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textTertiary),
                        ),
                        if (loan.dueDate != null)
                          Text(
                            'Tenggat: ${DateFormatter.short(loan.dueDate)}',
                            style: GoogleFonts.inter(fontSize: 11, color: loan.isOverdue ? AppColors.error : AppColors.textTertiary),
                          ),
                      ],
                    ),
                  ),
                  if (loan.isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('TERLAMBAT', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.error)),
                    ),
                ],
              ),
              if (type == 'pending') ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => _rejectLoan(loan.id),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('Tolak', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => _approveLoan(loan.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('Setujui', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (type == 'active') ...[
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () => _returnLoan(loan.id),
                    icon: const Icon(Icons.assignment_return_rounded, size: 18),
                    label: Text('Kembalikan', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.05);
      },
    );
  }
}
