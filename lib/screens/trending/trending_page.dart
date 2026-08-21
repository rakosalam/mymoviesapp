import 'package:flutter/material.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:movieapp/services/movie_service.dart';
import 'package:provider/provider.dart';

import '../../theme/app_spacing.dart';
import '../movie_detail/movie_detail_page.dart';
import 'movie_card.dart';
import 'movie_error_view.dart';
import 'movie_grid_skeleton.dart';
import 'movie_list_tile.dart';
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
  final Set<int> _bookmarkedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMovies());
  }

  void _toggleBookmark(int movieId) {
    setState(() {
      if (!_bookmarkedIds.add(movieId)) {
        _bookmarkedIds.remove(movieId);
      }
    });
  }

  void _loadMovies() {
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
            MovieProviderStatus.error => MovieErrorView(
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
                          isBookmarked: _bookmarkedIds.contains(movie.id),
                          onBookmarkTap: () => _toggleBookmark(movie.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MovieDetailPage(
                                movieId: movie.id,
                              ), // Replace with actual movie ID
                            ),
                          ),
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
                          isBookmarked: _bookmarkedIds.contains(movie.id),
                          onBookmarkTap: () => _toggleBookmark(movie.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MovieDetailPage(
                                movieId: movie.id,
                              ), // Replace with actual movie ID
                            ),
                          ),
                        );
                      },
                    ),
          },
        ),
      ],
    );
  }
}
