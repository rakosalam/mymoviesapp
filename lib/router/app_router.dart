import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/movie_detail/movie_detail_page.dart';
import '../screens/search/search_page.dart';
import '../screens/trending/trending_page.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// App route paths, kept in one place so screens don't hardcode strings.
class AppRoutes {
  AppRoutes._();

  static const trending = '/trending';
  static const search = '/search';
  static const watchlist = '/watchlist';
  static String movieDetail(int movieId) => '/movie/$movieId';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.trending,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _HomeShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.trending,
              builder: (context, state) => const TrendingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.watchlist,
              builder: (context, state) =>
                  const Center(child: Text('Watchlist Page')),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final movieId = int.parse(state.pathParameters['id']!);
        return MovieDetailPage(movieId: movieId);
      },
    ),
  ],
);

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        initialIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
