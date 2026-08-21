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

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] as int,
      title: json['title'] as String? ?? json['original_title'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String? ?? '',
      tagline: json['tagline'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      releaseDate: json['release_date'] as String? ?? '',
      runtime: json['runtime'] as int? ?? 0,
      budget: json['budget'] as int? ?? 0,
      revenue: json['revenue'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'overview': overview,
      'tagline': tagline,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'runtime': runtime,
      'budget': budget,
      'revenue': revenue,
      'status': status,
      'genres': genres.map((g) => g.toJson()).toList(),
      'production_companies':
          productionCompanies.map((p) => p.toJson()).toList(),
    };
  }
}
