import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/movies/presentation/pages/trending_page.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'widgets/app_bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'CineTrack',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const HomeShell(),
          );
        },
      ),
    );
  }
}

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TrendingPage(),
      bottomNavigationBar: AppBottomNavBar(),
    );
  }
}
