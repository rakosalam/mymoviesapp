import 'package:dio/dio.dart';

import '../consts/api_constants.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';

class MovieService {
  final Dio _dio;
  MovieService(this._dio);

  Future<List<Movie>> getTrendingMovies(String timeWindow) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.trendingMovies(timeWindow)}',
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.movieDetailWithExtras(movieId)}',
    );
    return MovieDetail.fromJson(response.data);
  }
}
