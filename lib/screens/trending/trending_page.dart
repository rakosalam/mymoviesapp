import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/movie_provider.dart';
import '../../provider/watchlater_provider.dart';
import '../../router/app_router.dart';
import '../../services/movie_service.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/movie_list_tile.dart';
import '../../widgets/no_internet_view.dart';
import 'movie_card.dart';
import 'movie_error_view.dart';
import 'movie_grid_skeleton.dart';
import 'movie_view_mode.dart';
import 'trending_filter.dart';
import 'trending_header.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  TrendingTimeWindow _timeWindow = TrendingTimeWindow.day;
  MovieViewMode _viewMode = MovieViewMode.list;
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      setState(() => _isOffline = result.contains(ConnectivityResult.none));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMovies());
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _refreshOfflineStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!mounted) return;
    setState(() {
      _isOffline = connectivityResult.contains(ConnectivityResult.none);
    });
  }

  void _loadMovies() {
    _refreshOfflineStatus();
    context.read<MovieProvider>().loadMovies(
      () =>
          context.read<MovieService>().getTrendingMovies(_timeWindow.apiValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Column(
      children: [
        const TrendingHeader(),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TrendingFilter(
                selected: _timeWindow,
                onChanged: (value) {
                  setState(() => _timeWindow = value);
                  _loadMovies();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: IconButton(
                onPressed: () => setState(() => _viewMode = _viewMode.next),
                icon: Icon(_viewMode.toggleIcon),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: switch (movieProvider.moviesStatus) {
            MovieProviderStatus.loading => const MovieGridSkeleton(),
            MovieProviderStatus.error =>
              _isOffline
                  ? NoInternetView(
                      onGoToWatchlist: () => context.go(AppRoutes.watchlist),
                    )
                  : MovieErrorView(
                      message: movieProvider.errorMessage!,
                      onRetry: _loadMovies,
                    ),
            MovieProviderStatus.success =>
              _viewMode == MovieViewMode.grid
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ).copyWith(bottom: AppSpacing.md),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            childAspectRatio: 0.56,
                          ),
                      itemCount: movieProvider.movies.length,
                      itemBuilder: (context, index) {
                        final movie = movieProvider.movies[index];
                        return MovieCard(
                          movie: movie,
                          isBookmarked: context
                              .watch<WatchlaterProvider>()
                              .isInWatchlater(movie.id),
                          onBookmarkTap: () => context
                              .read<WatchlaterProvider>()
                              .toggleWatchlater(movie),
                          onTap: () =>
                              context.push(AppRoutes.movieDetail(movie.id)),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ).copyWith(bottom: AppSpacing.md),
                      itemCount: movieProvider.movies.length,
                      itemBuilder: (context, index) {
                        final movie = movieProvider.movies[index];
                        return MovieListTile(
                          movie: movie,
                          isBookmarked: context
                              .watch<WatchlaterProvider>()
                              .isInWatchlater(movie.id),
                          onBookmarkTap: () => context
                              .read<WatchlaterProvider>()
                              .toggleWatchlater(movie),
                          onTap: () =>
                              context.push(AppRoutes.movieDetail(movie.id)),
                        );
                      },
                    ),
          },
        ),
      ],
    );
  }
}
