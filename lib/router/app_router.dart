import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/movie_detail/movie_detail_page.dart';
import '../screens/movie_detail/trailer_player_page.dart';
import '../screens/search/search_page.dart';
import '../screens/trending/trending_page.dart';
import '../screens/watchlist/watchlist_page.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// App route paths, kept in one place so screens don't hardcode strings.
class AppRoutes {
  AppRoutes._();

  static const trending = '/trending';
  static const search = '/search';
  static const watchlist = '/watchlist';
  static String movieDetail(int movieId) => '/movie/$movieId';
  static String trailer(String videoId) => '/trailer/$videoId';
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
              builder: (context, state) => const WatchlistPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) {
        final movieId = int.parse(state.pathParameters['id']!);
        return MovieDetailPage(
          movieId: movieId,
          hideExtras: state.extra as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: '/trailer/:videoId',
      builder: (context, state) {
        final videoId = state.pathParameters['videoId']!;
        return TrailerPlayerPage(videoId: videoId);
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
