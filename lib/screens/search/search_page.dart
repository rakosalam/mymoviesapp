import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/provider/watchlater_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/movie_provider.dart';
import '../../router/app_router.dart';
import '../../services/movie_service.dart';
import '../../widgets/movie_list_tile.dart';
import '../trending/movie_error_view.dart';
import 'search_empty_state.dart';
import 'search_header.dart';

/// Design-only skeleton: header (back/search field/filter) plus the empty
/// prompt state. No search logic wired up yet.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';
  final _scrollcontroller = ScrollController();
  void _onScroll() {
    final threshold = _scrollcontroller.position.maxScrollExtent - 200;
    if (_scrollcontroller.position.pixels >= threshold) {
      context.read<MovieProvider>().loadMoreSearchResults(
        _query,
        (q, p) => context.read<MovieService>().searchMovies(q, page: p),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollcontroller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
    });
    context.read<MovieProvider>().searchMovies(
      value,
      (q, p) => context.read<MovieService>().searchMovies(q, page: p),
    );
  }

  void _retrySearch() {
    context.read<MovieProvider>().searchMovies(
      _query,
      (q, p) => context.read<MovieService>().searchMovies(q, page: p),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    return Column(
      children: [
        SearchHeader(
          onBackTap: () => context.push(AppRoutes.trending),
          onFilterTap: () {},
          onChanged: _onSearchChanged,
        ),
        Expanded(
          child: switch (movieProvider.searchStatus) {
            MovieProviderStatus.loading => Center(
              child: CircularProgressIndicator(),
            ),
            MovieProviderStatus.error => MovieErrorView(
              message: movieProvider.searchErrorMessage!,
              onRetry: _retrySearch,
            ),
            MovieProviderStatus.success
                when movieProvider.searchResults.isEmpty =>
              SearchEmptyState(),
            MovieProviderStatus.success => ListView.builder(
              controller: _scrollcontroller,
              itemCount:
                  movieProvider.searchResults.length +
                  (movieProvider.hasMoreSearchResults ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= movieProvider.searchResults.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final movie = movieProvider.searchResults[index];
                return MovieListTile(
                  movie: movie,
                  isBookmarked: context
                      .watch<WatchlaterProvider>()
                      .isInWatchlater(movie.id),
                  onBookmarkTap: () => context
                      .read<WatchlaterProvider>()
                      .toggleWatchlater(movie),
                  onTap: () => context.push(AppRoutes.movieDetail(movie.id)),
                );
              },
            ),
          },
        ),
      ],
    );
  }
}
