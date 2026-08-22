import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/movie_detail.dart';
import '../../provider/movie_provider.dart';
import '../../provider/watchlater_provider.dart';
import '../../router/app_router.dart';
import '../../services/movie_service.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/no_internet_view.dart';
import '../trending/movie_error_view.dart';
import 'cast_list.dart';
import 'movie_detail_hero.dart';
import 'movie_detail_skeleton.dart';
import 'similar_movies_row.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.movieId,
    required this.hideExtras,
  });

  final int movieId;
  final bool hideExtras;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMovie());
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadMovie() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOffline = connectivityResult.contains(ConnectivityResult.none);
    if (!mounted) return;

    final cachedMovie = context
        .read<WatchlaterProvider>()
        .watchlaterMovies
        .where((movie) => movie.id == widget.movieId)
        .firstOrNull;

    if (isOffline && cachedMovie != null) {
      context.read<MovieProvider>().loadMovieDetail(
        () async => cachedMovie.asMovieDetail,
      );
    } else {
      context.read<MovieProvider>().loadMovieDetail(
        () => context.read<MovieService>().getMovieDetail(widget.movieId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final movie = movieProvider.movieDetail;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: switch (movieProvider.detailStatus) {
          MovieProviderStatus.loading => const MovieDetailSkeleton(),
          MovieProviderStatus.error =>
            _isOffline
                ? NoInternetView(
                    message:
                        'This movie isn\'t in your watchlist, so it can\'t '
                        'be shown offline.',
                    onGoToWatchlist: () => context.go(AppRoutes.watchlist),
                  )
                : MovieErrorView(
                    message: movieProvider.detailErrorMessage!,
                    onRetry: _loadMovie,
                  ),
          MovieProviderStatus.success when movie == null =>
            const MovieDetailSkeleton(),
          MovieProviderStatus.success => _MovieDetailContent(
            movie: movie!,
            isInWatchlist: context.watch<WatchlaterProvider>().isInWatchlater(
              movie.id,
            ),
            onToggleWatchlist: () => context
                .read<WatchlaterProvider>()
                .toggleWatchlater(movie.asMovie),
            showExtras: !widget.hideExtras && !_isOffline,
          ),
        },
      ),
    );
  }
}

class _MovieDetailContent extends StatelessWidget {
  const _MovieDetailContent({
    required this.movie,
    required this.isInWatchlist,
    required this.onToggleWatchlist,
    required this.showExtras,
  });

  final MovieDetail movie;
  final bool isInWatchlist;
  final VoidCallback onToggleWatchlist;
  final bool showExtras;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trailer = movie.trailer;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieDetailHero(movie: movie, onBackTap: () => context.pop()),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onToggleWatchlist,
                    icon: Icon(
                      isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                    ),
                    label: Text(
                      isInWatchlist ? 'In Watchlist' : 'Add to Watchlist',
                    ),
                  ),
                ),
                if (showExtras) ...[
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: trailer == null
                          ? null
                          : () => launchUrl(
                              Uri.parse(trailer.youtubeUrl),
                              mode: LaunchMode.externalApplication,
                            ),
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Watch Trailer'),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Overview',
                  style: AppTypography.headlineSm(colorScheme.onSurface),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  movie.overview,
                  style: AppTypography.bodyLg(colorScheme.onSurfaceVariant),
                ),
                if (showExtras) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Cast',
                    style: AppTypography.headlineSm(colorScheme.onSurface),
                  ),
                ],
              ],
            ),
          ),
          if (showExtras) ...[
            const SizedBox(height: AppSpacing.sm),
            CastList(cast: movie.cast),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'More Like This',
                style: AppTypography.headlineSm(colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SimilarMoviesRow(movies: movie.similar),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
