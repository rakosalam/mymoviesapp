import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../consts/api_constants.dart';

import '../models/movie.dart';

class WatchlaterProvider extends ChangeNotifier {
  static const _prefsKey = 'watchlist_movies';
  final List<Movie> _watchlaterMovies = [];
  List<Movie> get watchlaterMovies => _watchlaterMovies;
  bool isInWatchlater(int movieId) {
    return _watchlaterMovies.any((movie) => movie.id == movieId);
  }

  WatchlaterProvider() {
    _loadWatchlist();
  }

  Future<void> toggleWatchlater(Movie movie) async {
    if (isInWatchlater(movie.id)) {
      _watchlaterMovies.removeWhere((m) => m.id == movie.id);
    } else {
      _watchlaterMovies.add(movie);
      _prefetchImages(movie);
    }
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(_watchlaterMovies.map((m) => m.toJson()).toList()),
    );
  }

  void _prefetchImages(Movie movie) {
    final urls = <String>[
      if (movie.posterPath != null)
        ApiConstants.imageUrl(
          movie.posterPath!,
          size: ApiConstants.posterSizeSmall,
        ),
      if (movie.posterPath != null) ApiConstants.imageUrl(movie.posterPath!),
      if (movie.backdropPath != null)
        ApiConstants.imageUrl(
          movie.backdropPath!,
          size: ApiConstants.posterSizeLarge,
        ),
    ];

    for (final url in urls) {
      DefaultCacheManager().downloadFile(url).then((_) {}).catchError((_) {});
    }
  }

  Future<void> _loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved == null) return;
    final decoded = jsonDecode(saved) as List;
    _watchlaterMovies
      ..clear()
      ..addAll(decoded.map((json) => Movie.fromJson(json)));
    notifyListeners();
  }
}
