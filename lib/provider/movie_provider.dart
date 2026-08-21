import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import '../models/movie_detail.dart';

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

  List<Movie> _searchResults = [];
  bool _isSearching = false;
  String? _searchErrorMessage;
  Timer? _debounce;

  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get searchErrorMessage => _searchErrorMessage;

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
      Future<MovieDetail> Function() fetchMovieDetail) async {
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
    Future<List<Movie>> Function(String query) search,
  ) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      _searchErrorMessage = null;
      notifyListeners();
      return;
    }

    _debounce = Timer(_searchDebounceDuration, () async {
      _isSearching = true;
      _searchErrorMessage = null;
      notifyListeners();

      try {
        _searchResults = await search(query);
      } catch (e) {
        _searchErrorMessage = e.toString();
      } finally {
        _isSearching = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
