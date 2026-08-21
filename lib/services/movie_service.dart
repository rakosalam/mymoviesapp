import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../consts/api_constants.dart';
import '../models/movie.dart';

class MovieService {
  final Dio _dio;
  MovieService(this._dio);

  Future<List<Movie>> getTrendingMovies(String timeWindow) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}/trending/movie/$timeWindow',
      options: Options(
        headers: {'Authorization': 'Bearer ${dotenv.env['TMDB_ACCESS_TOKEN']}'},
      ),
    );
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }
}
