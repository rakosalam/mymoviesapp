import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/movie_list_response.dart';

enum MovieProviderStatus { loading, error, success }

class MovieProvider extends ChangeNotifier {
  static const _searchDebounceDuration = Duration(milliseconds: 500);

  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MovieProviderStatus get moviesStatus {
    if (_isLoading) return MovieProviderStatus.loading;
    if (_errorMessage != null) return MovieProviderStatus.error;
    return MovieProviderStatus.success;
  }

  MovieDetail? _movieDetail;
  bool _isDetailLoading = false;
  String? _detailErrorMessage;

  MovieDetail? get movieDetail => _movieDetail;
  bool get isDetailLoading => _isDetailLoading;
  String? get detailErrorMessage => _detailErrorMessage;

  MovieProviderStatus get detailStatus {
    if (_isDetailLoading) return MovieProviderStatus.loading;
    if (_detailErrorMessage != null) return MovieProviderStatus.error;
    return MovieProviderStatus.success;
  }

  List<Movie> _searchResults = [];
  bool _isSearching = false;
  bool _isLoadingMoreSearchResults = false;
  String? _searchErrorMessage;
  int _searchPage = 1;
  int _searchTotalPages = 1;
  Timer? _debounce;

  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  bool get isLoadingMoreSearchResults => _isLoadingMoreSearchResults;
  String? get searchErrorMessage => _searchErrorMessage;
  bool get hasMoreSearchResults => _searchPage < _searchTotalPages;

  MovieProviderStatus get searchStatus {
    if (_isSearching) return MovieProviderStatus.loading;
    if (_searchErrorMessage != null) return MovieProviderStatus.error;
    return MovieProviderStatus.success;
  }

  Future<void> loadMovies(Future<List<Movie>> Function() fetchMovies) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _movies = await fetchMovies();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshMovies(Future<List<Movie>> Function() fetchMovies) async {
    _errorMessage = null;
    notifyListeners();

    try {
      _movies = await fetchMovies();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMovieDetail(
    Future<MovieDetail> Function() fetchMovieDetail,
  ) async {
    _isDetailLoading = true;
    _detailErrorMessage = null;
    notifyListeners();

    try {
      _movieDetail = await fetchMovieDetail();
    } catch (e) {
      _detailErrorMessage = e.toString();
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  void searchMovies(
    String query,
    Future<MovieListResponse> Function(String query, int page) search,
  ) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      _searchErrorMessage = null;
      _searchPage = 1;
      _searchTotalPages = 1;
      notifyListeners();
      return;
    }

    _debounce = Timer(_searchDebounceDuration, () async {
      _isSearching = true;
      _searchErrorMessage = null;
      notifyListeners();

      try {
        final response = await search(query, 1);
        _searchResults = response.results;
        _searchPage = response.page;
        _searchTotalPages = response.totalPages;
      } catch (e) {
        _searchErrorMessage = e.toString();
      } finally {
        _isSearching = false;
        notifyListeners();
      }
    });
  }

  /// Fetches the next page of the current search and appends it to
  /// [searchResults], for infinite scroll. No-op if a page is already
  /// loading or there are no more pages ([hasMoreSearchResults] is false).
  Future<void> loadMoreSearchResults(
    String query,
    Future<MovieListResponse> Function(String query, int page) search,
  ) async {
    if (_isLoadingMoreSearchResults || !hasMoreSearchResults) return;

    _isLoadingMoreSearchResults = true;
    notifyListeners();

    try {
      final response = await search(query, _searchPage + 1);
      _searchResults = [..._searchResults, ...response.results];
      _searchPage = response.page;
      _searchTotalPages = response.totalPages;
    } catch (e) {
      _searchErrorMessage = e.toString();
    } finally {
      _isLoadingMoreSearchResults = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
