import 'package:flutter/material.dart';
import 'package:library_app/presentation/petugas/screens/staff_dashboard_screen.dart';

/// Admin dashboard extends staff dashboard (admin has all staff features + user management).
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaffDashboardScreen();
  }
}
