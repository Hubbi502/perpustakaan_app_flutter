import 'package:flutter/material.dart';
import 'package:library_app/app.dart';
import 'package:library_app/presentation/admin/providers/user_management_provider.dart';
import 'package:library_app/presentation/auth/providers/auth_provider.dart';
import 'package:library_app/presentation/pengunjung/providers/book_provider.dart';
import 'package:library_app/presentation/pengunjung/providers/loan_provider.dart';
import 'package:library_app/presentation/petugas/providers/book_management_provider.dart';
import 'package:library_app/presentation/petugas/providers/category_management_provider.dart';
import 'package:library_app/presentation/petugas/providers/loan_management_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        // Auth
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Pengunjung
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),

        // Petugas
        ChangeNotifierProvider(create: (_) => BookManagementProvider()),
        ChangeNotifierProvider(create: (_) => CategoryManagementProvider()),
        ChangeNotifierProvider(create: (_) => LoanManagementProvider()),

        // Admin
        ChangeNotifierProvider(create: (_) => UserManagementProvider()),
      ],
      child: const App(),
    ),
  );
}