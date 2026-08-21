import 'genre.dart';
import 'production_company.dart';

class MovieDetail {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final String? tagline;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final int runtime;
  final int budget;
  final int revenue;
  final String status;
  final List<Genre> genres;
  final List<ProductionCompany> productionCompanies;

  const MovieDetail({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    this.tagline,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.runtime,
    required this.budget,
    required this.revenue,
    required this.status,
    this.genres = const [],
    this.productionCompanies = const [],
  });
}
