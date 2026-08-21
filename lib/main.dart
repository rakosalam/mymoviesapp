import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:movieapp/services/movie_service.dart';
import 'package:provider/provider.dart';

import 'provider/theme_provider.dart';
import 'screens/trending/trending_page.dart';
import 'theme/app_theme.dart';
import 'widgets/app_bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        Provider<MovieService>(create: (_) => MovieService(Dio())),
      ],
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
