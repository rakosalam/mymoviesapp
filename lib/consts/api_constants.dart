class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  static const String posterSizeSmall = 'w200';
  static const String posterSizeMedium = 'w342';
  static const String posterSizeLarge = 'w500';
  static const String imageSizeOriginal = 'original';

  static String trendingMovies(String timeWindow) =>
      '/trending/movie/$timeWindow';

  static const String searchMovie = '/search/movie';

  // static String movieDetail(int movieId) => '/movie/$movieId';

  // static String movieVideos(int movieId) => '/movie/$movieId/videos';

  // static String movieCredits(int movieId) => '/movie/$movieId/credits';

  // static String movieSimilar(int movieId) => '/movie/$movieId/similar';

  static String movieDetailWithExtras(int movieId) =>
      '/movie/$movieId?append_to_response=videos,credits,similar';

  // static const String configuration = '/configuration';

  static String imageUrl(String path, {String size = posterSizeMedium}) {
    return '$imageBaseUrl/$size$path';
  }
}
