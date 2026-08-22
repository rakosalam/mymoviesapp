import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/watchlater_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/movie_list_tile.dart';
import '../trending/movie_card.dart';
import '../trending/movie_view_mode.dart';
import 'watchlist_empty_state.dart';

/// Watchlist tab: same grid/list toggle and card/tile widgets as
/// [TrendingPage], sourced from [WatchlaterProvider] instead of the API.
class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  MovieViewMode _viewMode = MovieViewMode.list;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final watchlist = context.watch<WatchlaterProvider>().watchlaterMovies;

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Watchlist',
                  style: AppTypography.headlineMd(colorScheme.onSurface),
                ),
                if (watchlist.isNotEmpty)
                  IconButton(
                    onPressed: () => setState(() => _viewMode = _viewMode.next),
                    icon: Icon(_viewMode.toggleIcon),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: watchlist.isEmpty
              ? const WatchlistEmptyState()
              : _viewMode == MovieViewMode.grid
              ? GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ).copyWith(bottom: AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.56,
                  ),
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    final movie = watchlist[index];
                    return MovieCard(
                      movie: movie,
                      isBookmarked: true,
                      onBookmarkTap: () => context
                          .read<WatchlaterProvider>()
                          .toggleWatchlater(movie),
                      onTap: () => context.push(
                        AppRoutes.movieDetail(movie.id),
                        extra: true,
                      ),
                    );
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ).copyWith(bottom: AppSpacing.md),
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    final movie = watchlist[index];
                    return MovieListTile(
                      movie: movie,
                      isBookmarked: true,
                      onBookmarkTap: () => context
                          .read<WatchlaterProvider>()
                          .toggleWatchlater(movie),
                      onTap: () => context.push(
                        AppRoutes.movieDetail(movie.id),
                        extra: true,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
