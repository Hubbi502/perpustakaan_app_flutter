import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/presentation/admin/screens/admin_dashboard_screen.dart';
import 'package:library_app/presentation/admin/screens/manage_users_screen.dart';
import 'package:library_app/presentation/pengunjung/screens/home_screen.dart';
import 'package:library_app/presentation/pengunjung/screens/my_loans_screen.dart';
import 'package:library_app/presentation/pengunjung/screens/profile_screen.dart';
import 'package:library_app/presentation/petugas/screens/manage_books_screen.dart';
import 'package:library_app/presentation/petugas/screens/manage_loans_screen.dart';
import 'package:library_app/presentation/petugas/screens/staff_dashboard_screen.dart';

/// Main scaffold with role-based navigation bar.
class MainScaffold extends StatefulWidget {
  final String role;

  const MainScaffold({super.key, required this.role});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  List<Widget> get _screens {
    switch (widget.role) {
      case 'admin':
        return [
          const AdminDashboardScreen(),
          const ManageBooksScreen(),
          const ManageLoansScreen(),
          const ManageUsersScreen(),
          const ProfileScreen(),
        ];
      case 'petugas':
        return [
          const StaffDashboardScreen(),
          const ManageBooksScreen(),
          const ManageLoansScreen(),
          const ProfileScreen(),
        ];
      default: // pengunjung
        return [
          const HomeScreen(),
          const MyLoansScreen(),
          const ProfileScreen(),
        ];
    }
  }

  List<NavigationDestination> get _destinations {
    switch (widget.role) {
      case 'admin':
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Buku'),
          NavigationDestination(icon: Icon(Icons.assignment_rounded), label: 'Pinjaman'),
          NavigationDestination(icon: Icon(Icons.people_rounded), label: 'Pengguna'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ];
      case 'petugas':
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Buku'),
          NavigationDestination(icon: Icon(Icons.assignment_rounded), label: 'Pinjaman'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ];
      default: // pengunjung
        return const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.bookmark_rounded), label: 'Pinjaman'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: Border(top: BorderSide(color: AppColors.glassBorder)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: _destinations,
          height: 70,
        ),
      ),
    );
  }
}
