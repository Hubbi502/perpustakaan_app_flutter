import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/empty_state.dart';
import 'package:library_app/core/widgets/error_widget.dart';
import 'package:library_app/presentation/pengunjung/providers/loan_provider.dart';
import 'package:library_app/presentation/pengunjung/widgets/loan_card.dart';
import 'package:provider/provider.dart';

/// Screen showing user's loan history and active loans.
class MyLoansScreen extends StatefulWidget {
  const MyLoansScreen({super.key});

  @override
  State<MyLoansScreen> createState() => _MyLoansScreenState();
}

class _MyLoansScreenState extends State<MyLoansScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanProvider>().fetchLoans();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cancelLoan(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Batalkan Peminjaman?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          'Peminjaman yang dibatalkan tidak dapat dikembalikan.',
          style: GoogleFonts.inter(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Tidak', style: GoogleFonts.inter(color: AppColors.textTertiary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Ya, Batalkan', style: GoogleFonts.inter(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      await context.read<LoanProvider>().cancelLoan(id);
      if (!mounted) return;
      AppSnackbar.success(context, 'Peminjaman berhasil dibatalkan');
    } on AppException catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = context.watch<LoanProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text('Peminjaman Saya', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Aktif (${loanProvider.activeLoans.length})'),
            Tab(text: 'Riwayat (${loanProvider.historyLoans.length})'),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceDark,
        onRefresh: () => loanProvider.fetchLoans(),
        child: loanProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              )
            : loanProvider.error != null
                ? AppErrorWidget(
                    message: loanProvider.error!,
                    onRetry: () => loanProvider.fetchLoans(),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // Active tab
                      _buildLoanList(loanProvider.activeLoans, isActive: true),
                      // History tab
                      _buildLoanList(loanProvider.historyLoans, isActive: false),
                    ],
                  ),
      ),
    );
  }

  Widget _buildLoanList(List loans, {required bool isActive}) {
    if (loans.isEmpty) {
      return EmptyState(
        icon: isActive ? Icons.bookmark_border_rounded : Icons.history_rounded,
        title: isActive ? 'Belum ada peminjaman aktif' : 'Belum ada riwayat',
        subtitle: isActive ? 'Pinjam buku untuk memulai' : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return LoanCard(
          loan: loan,
          onCancel: loan.isPending ? () => _cancelLoan(loan.id) : null,
        ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.05);
      },
    );
  }
}
