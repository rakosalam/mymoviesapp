import 'package:flutter/material.dart';

import '../../../../theme/app_spacing.dart';
import '../../domain/entities/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/trending_filter.dart';
import '../widgets/trending_header.dart';

const _dummyMovies = [
  Movie(
    id: 1,
    title: 'Stellar Voyage',
    overview: 'A lone astronaut charts the unknown.',
    voteAverage: 8.5,
    releaseDate: '2024-03-12',
  ),
  Movie(
    id: 2,
    title: 'Midnight Echoes',
    overview: 'A noir thriller through empty streets.',
    voteAverage: 7.9,
    releaseDate: '2023-11-02',
  ),
  Movie(
    id: 3,
    title: 'The Sylvan King',
    overview: 'An epic fantasy journey beyond imagination.',
    voteAverage: 9.2,
    releaseDate: '2024-10-26',
  ),
  Movie(
    id: 4,
    title: 'Apex Protocol',
    overview: 'A journey beyond the known.',
    voteAverage: 8.1,
    releaseDate: '2024-06-01',
  ),
];

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  TrendingTimeWindow _timeWindow = TrendingTimeWindow.day;
  final Set<int> _bookmarkedIds = {};

  void _toggleBookmark(int movieId) {
    setState(() {
      if (!_bookmarkedIds.add(movieId)) {
        _bookmarkedIds.remove(movieId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TrendingHeader(),
        const SizedBox(height: AppSpacing.sm),
        TrendingFilter(
          selected: _timeWindow,
          onChanged: (value) => setState(() => _timeWindow = value),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ).copyWith(bottom: AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.56,
            ),
            itemCount: _dummyMovies.length,
            itemBuilder: (context, index) {
              final movie = _dummyMovies[index];
              return MovieCard(
                movie: movie,
                isBookmarked: _bookmarkedIds.contains(movie.id),
                onBookmarkTap: () => _toggleBookmark(movie.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
