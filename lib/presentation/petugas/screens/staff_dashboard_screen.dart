import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/presentation/auth/providers/auth_provider.dart';
import 'package:library_app/presentation/petugas/providers/book_management_provider.dart';
import 'package:library_app/presentation/petugas/providers/category_management_provider.dart';
import 'package:library_app/presentation/petugas/providers/loan_management_provider.dart';
import 'package:library_app/presentation/petugas/widgets/stat_card.dart';
import 'package:library_app/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Staff dashboard with stats and quick actions.
class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookManagementProvider>().fetchBooks();
      context.read<CategoryManagementProvider>().fetchCategories();
      context.read<LoanManagementProvider>().fetchLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bookMgmt = context.watch<BookManagementProvider>();
    final catMgmt = context.watch<CategoryManagementProvider>();
    final loanMgmt = context.watch<LoanManagementProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surfaceDark,
            onRefresh: () async {
              await Future.wait([
                bookMgmt.fetchBooks(),
                catMgmt.fetchCategories(),
                loanMgmt.fetchLoans(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Halo, ${auth.user?.name ?? "Petugas"} 👋',
                            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            auth.user?.name.isNotEmpty == true ? auth.user!.name[0].toUpperCase() : 'P',
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 28),

                  // Stats grid
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatCard(
                        icon: Icons.menu_book_rounded,
                        label: 'Total Buku',
                        value: '${bookMgmt.total}',
                        iconColor: AppColors.primary,
                      ).animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.8, 0.8)),
                      StatCard(
                        icon: Icons.category_rounded,
                        label: 'Kategori',
                        value: '${catMgmt.categories.length}',
                        iconColor: AppColors.secondary,
                      ).animate(delay: 300.ms).fadeIn().scale(begin: const Offset(0.8, 0.8)),
                      StatCard(
                        icon: Icons.hourglass_bottom_rounded,
                        label: 'Menunggu Persetujuan',
                        value: '${loanMgmt.pendingLoans.length}',
                        iconColor: AppColors.warning,
                      ).animate(delay: 400.ms).fadeIn().scale(begin: const Offset(0.8, 0.8)),
                      StatCard(
                        icon: Icons.bookmark_rounded,
                        label: 'Dipinjam',
                        value: '${loanMgmt.activeLoans.length}',
                        iconColor: AppColors.success,
                      ).animate(delay: 500.ms).fadeIn().scale(begin: const Offset(0.8, 0.8)),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Quick actions
                  Text(
                    'Aksi Cepat',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ).animate(delay: 600.ms).fadeIn(),

                  const SizedBox(height: 14),

                  _buildQuickAction(
                    icon: Icons.add_box_rounded,
                    title: 'Tambah Buku',
                    subtitle: 'Tambahkan buku baru ke perpustakaan',
                    color: AppColors.primary,
                    onTap: () => Navigator.of(context).pushNamed(AppRouter.bookForm),
                  ).animate(delay: 700.ms).fadeIn().slideX(begin: 0.1),

                  _buildQuickAction(
                    icon: Icons.approval_rounded,
                    title: 'Kelola Peminjaman',
                    subtitle: '${loanMgmt.pendingLoans.length} menunggu persetujuan',
                    color: AppColors.warning,
                    onTap: () => Navigator.of(context).pushNamed(AppRouter.manageLoans),
                  ).animate(delay: 800.ms).fadeIn().slideX(begin: 0.1),

                  _buildQuickAction(
                    icon: Icons.category_rounded,
                    title: 'Kelola Kategori',
                    subtitle: '${catMgmt.categories.length} kategori tersedia',
                    color: AppColors.secondary,
                    onTap: () => Navigator.of(context).pushNamed(AppRouter.manageCategories),
                  ).animate(delay: 900.ms).fadeIn().slideX(begin: 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
