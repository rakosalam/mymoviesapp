import 'package:dio/dio.dart';

import '../consts/api_constants.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/movie_list_response.dart';

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

  Future<MovieListResponse> searchMovies(String query, {int page = 1}) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.searchMovie(query, page: page)}',
    );
    final results = response.data['results'] as List;
    return MovieListResponse(
      results: results.map((json) => Movie.fromJson(json)).toList(),
      page: response.data['page'] as int,
      totalPages: response.data['total_pages'] as int,
      totalResults: response.data['total_results'] as int,
    );
  }
}
