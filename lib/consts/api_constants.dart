import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl =>
      dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  static const String posterSizeSmall = 'w200';
  static const String posterSizeMedium = 'w342';
  static const String posterSizeLarge = 'w500';
  static const String imageSizeOriginal = 'original';

  static String trendingMovies(String timeWindow) =>
      '/trending/movie/$timeWindow';

  static String searchMovie(String query, {int page = 1}) =>
      '/search/movie?query=${Uri.encodeQueryComponent(query)}&page=$page&include_adult=false';

  static String movieDetailWithExtras(int movieId) =>
      '/movie/$movieId?append_to_response=videos,credits,similar';

  static String imageUrl(String path, {String size = posterSizeMedium}) {
    return '$imageBaseUrl/$size$path';
  }
}
