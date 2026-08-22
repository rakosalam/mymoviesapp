import 'package:flutter/material.dart';

import '../../models/movie.dart';
import '../../theme/app_spacing.dart';
import '../trending/movie_card.dart';

/// Horizontal scrolling row of similar/recommended movies, reusing the
/// same [MovieCard] the trending grid uses.
class SimilarMoviesRow extends StatelessWidget {
  const SimilarMoviesRow({super.key, required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: SizedBox(width: 130, child: MovieCard(movie: movies[index])),
          );
        },
      ),
    );
  }
}
