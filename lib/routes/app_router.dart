import 'package:flutter/material.dart';
import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/domain/entities/user.dart';
import 'package:library_app/presentation/admin/screens/user_form_screen.dart';
import 'package:library_app/presentation/auth/screens/login_screen.dart';
import 'package:library_app/presentation/auth/screens/register_screen.dart';
import 'package:library_app/presentation/auth/screens/splash_screen.dart';
import 'package:library_app/presentation/common/main_scaffold.dart';
import 'package:library_app/presentation/pengunjung/screens/book_detail_screen.dart';
import 'package:library_app/presentation/pengunjung/screens/book_list_screen.dart';
import 'package:library_app/presentation/petugas/screens/book_form_screen.dart';
import 'package:library_app/presentation/petugas/screens/manage_categories_screen.dart';
import 'package:library_app/presentation/petugas/screens/manage_loans_screen.dart';
import 'package:library_app/presentation/admin/screens/manage_users_screen.dart';

/// Centralized app router with named routes and role-based navigation.
class AppRouter {
  AppRouter._();

  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Pengunjung
  static const String pengunjungHome = '/pengunjung';
  static const String bookList = '/books';
  static const String bookDetail = '/books/detail';

  // Petugas
  static const String petugasHome = '/petugas';
  static const String bookForm = '/books/form';
  static const String manageCategories = '/categories/manage';
  static const String manageLoans = '/loans/manage';

  // Admin
  static const String adminHome = '/admin';
  static const String manageUsers = '/users/manage';
  static const String userForm = '/users/form';

  /// Generate route based on settings.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashScreen(), settings);

      case login:
        return _fadeRoute(const LoginScreen(), settings);

      case register:
        return _fadeRoute(const RegisterScreen(), settings);

      case pengunjungHome:
        return _fadeRoute(const MainScaffold(role: 'pengunjung'), settings);

      case petugasHome:
        return _fadeRoute(const MainScaffold(role: 'petugas'), settings);

      case adminHome:
        return _fadeRoute(const MainScaffold(role: 'admin'), settings);

      case bookList:
        return _slideRoute(const BookListScreen(), settings);

      case bookDetail:
        final bookId = settings.arguments as int;
        return _slideRoute(BookDetailScreen(bookId: bookId), settings);

      case bookForm:
        final book = settings.arguments as Book?;
        return _slideRoute(BookFormScreen(book: book), settings);

      case manageCategories:
        return _slideRoute(const ManageCategoriesScreen(), settings);

      case manageLoans:
        return _slideRoute(const ManageLoansScreen(), settings);

      case manageUsers:
        return _slideRoute(const ManageUsersScreen(), settings);

      case userForm:
        final user = settings.arguments as User?;
        return _slideRoute(UserFormScreen(user: user), settings);

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  /// Navigate to role-appropriate home screen.
  static void navigateToRoleHome(BuildContext context, String role) {
    final route = switch (role) {
      'admin' => adminHome,
      'petugas' => petugasHome,
      _ => pengunjungHome,
    };

    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  /// Fade transition route.
  static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Slide transition route.
  static PageRoute _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
