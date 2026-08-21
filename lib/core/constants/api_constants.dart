class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  static const String posterSizeSmall = 'w200';
  static const String posterSizeMedium = 'w342';
  static const String posterSizeLarge = 'w500';
  static const String imageSizeOriginal = 'original';

  static const String trendingMoviesDay = '/trending/movie/day';
  static const String trendingMoviesWeek = '/trending/movie/week';

  static const String searchMovie = '/search/movie';

  static String movieDetail(int movieId) => '/movie/$movieId';

  static const String configuration = '/configuration';

  static String imageUrl(String path, {String size = posterSizeMedium}) {
    return '$imageBaseUrl/$size$path';
  }
}
