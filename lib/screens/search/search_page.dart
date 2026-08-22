import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/movie_provider.dart';
import '../../provider/watchlater_provider.dart';
import '../../router/app_router.dart';
import '../../services/movie_service.dart';
import '../../widgets/movie_list_tile.dart';
import '../../widgets/no_internet_view.dart';
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
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

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
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      setState(() => _isOffline = result.contains(ConnectivityResult.none));
    });
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
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

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
    });
    _refreshOfflineStatus();
    context.read<MovieProvider>().searchMovies(
      value,
      (q, p) => context.read<MovieService>().searchMovies(q, page: p),
    );
  }

  void _retrySearch() {
    _refreshOfflineStatus();
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
            MovieProviderStatus.error =>
              _isOffline
                  ? NoInternetView(
                      onGoToWatchlist: () => context.go(AppRoutes.watchlist),
                    )
                  : MovieErrorView(
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: MovieListTile(
                    movie: movie,
                    isBookmarked: context
                        .watch<WatchlaterProvider>()
                        .isInWatchlater(movie.id),
                    onBookmarkTap: () => context
                        .read<WatchlaterProvider>()
                        .toggleWatchlater(movie),
                    onTap: () => context.push(AppRoutes.movieDetail(movie.id)),
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
