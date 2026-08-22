import 'cast_member.dart';
import 'genre.dart';
import 'movie.dart';
import 'production_company.dart';
import 'video.dart';

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

  /// Only populated when the detail request used
  /// `append_to_response=videos,credits,similar` — empty otherwise.
  final List<Video> videos;
  final List<CastMember> cast;
  final List<Movie> similar;

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
    this.videos = const [],
    this.cast = const [],
    this.similar = const [],
  });

  /// A [Movie] view of this detail, for places (like the watchlist) that
  /// operate on the shared, lighter-weight model.
  Movie get asMovie => Movie(
    id: id,
    title: title,
    posterPath: posterPath,
    backdropPath: backdropPath,
    overview: overview,
    voteAverage: voteAverage,
    releaseDate: releaseDate,
  );

  /// The first official YouTube trailer, if one was fetched via
  /// `append_to_response=videos`.
  Video? get trailer {
    for (final video in videos) {
      if (video.isYoutubeTrailer && video.official) return video;
    }
    for (final video in videos) {
      if (video.isYoutubeTrailer) return video;
    }
    return null;
  }

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] as int,
      title:
          json['title'] as String? ?? json['original_title'] as String? ?? '',
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
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      productionCompanies:
          (json['production_companies'] as List<dynamic>?)
              ?.map(
                (e) => ProductionCompany.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      videos:
          ((json['videos'] as Map<String, dynamic>?)?['results']
                  as List<dynamic>?)
              ?.map((e) => Video.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cast:
          ((json['credits'] as Map<String, dynamic>?)?['cast']
                  as List<dynamic>?)
              ?.map((e) => CastMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      similar:
          ((json['similar'] as Map<String, dynamic>?)?['results']
                  as List<dynamic>?)
              ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
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
      'production_companies': productionCompanies
          .map((p) => p.toJson())
          .toList(),
      'videos': {'results': videos.map((v) => v.toJson()).toList()},
      'credits': {'cast': cast.map((c) => c.toJson()).toList()},
      'similar': {'results': similar.map((m) => m.toJson()).toList()},
    };
  }
}
