import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/movie_detail.dart';
import '../../provider/movie_provider.dart';
import '../../services/movie_service.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../trending/movie_error_view.dart';
import 'cast_list.dart';
import 'movie_detail_hero.dart';
import 'movie_detail_skeleton.dart';
import 'similar_movies_row.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movieId});

  final int movieId;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMovie());
  }

  void _loadMovie() {
    context.read<MovieProvider>().loadMovieDetail(
      () => context.read<MovieService>().getMovieDetail(widget.movieId),
    );
  }

  void _toggleWatchlist() {
    setState(() => _isInWatchlist = !_isInWatchlist);
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
          MovieProviderStatus.error => MovieErrorView(
            message: movieProvider.detailErrorMessage!,
            onRetry: _loadMovie,
          ),
          MovieProviderStatus.success when movie == null =>
            const MovieDetailSkeleton(),
          MovieProviderStatus.success => _MovieDetailContent(
            movie: movie!,
            isInWatchlist: _isInWatchlist,
            onToggleWatchlist: _toggleWatchlist,
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
  });

  final MovieDetail movie;
  final bool isInWatchlist;
  final VoidCallback onToggleWatchlist;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trailer = movie.trailer;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieDetailHero(
            movie: movie,
            onBackTap: () => Navigator.of(context).maybePop(),
            onShareTap: () {},
          ),
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
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Cast',
                  style: AppTypography.headlineSm(colorScheme.onSurface),
                ),
              ],
            ),
          ),
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
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
