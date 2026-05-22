import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_theme.dart';
import 'package:library_app/routes/app_router.dart';

/// Root app widget with theme and router configuration.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
