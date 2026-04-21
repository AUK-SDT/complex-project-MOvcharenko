import 'package:flutter/material.dart';
import 'app_router.dart';
import 'core/theme/app_theme.dart';

class CineLogApp extends StatelessWidget {
  const CineLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
