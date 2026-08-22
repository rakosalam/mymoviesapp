import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../consts/api_constants.dart';
import '../../models/movie.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Poster card for a single movie: rating badge, poster art (or a fallback
/// gradient when there's no `posterPath` yet), title, release year, and a
/// bookmark toggle for the watchlist.
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmarkTap,
  });

  final Movie movie;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  String get _year =>
      movie.releaseDate.length >= 4 ? movie.releaseDate.substring(0, 4) : '—';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
              borderRadius: AppRadius.lgBorder,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: movie.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl: ApiConstants.imageUrl(movie.posterPath!),
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) =>
                                _PosterFallback(title: movie.title),
                          )
                        : _PosterFallback(title: movie.title),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: _RatingBadge(voteAverage: movie.voteAverage),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMd(colorScheme.onSurface),
                    ),
                    Text(
                      _year,
                      style: AppTypography.labelMd(
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onBookmarkTap,
                borderRadius: AppRadius.smBorder,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.voteAverage});

  final double voteAverage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: AppRadius.smBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Color(0xFFF5A623)),
          const SizedBox(width: 2),
          Text(
            voteAverage.toStringAsFixed(1),
            style: AppTypography.labelMd(Colors.white),
          ),
        ],
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final hue = (title.hashCode % 360).toDouble();
    final baseColor = HSLColor.fromAHSL(1, hue, 0.35, 0.35).toColor();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [baseColor, baseColor.withValues(alpha: 0.6)],
        ),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_movies_outlined,
        color: Colors.white70,
        size: 40,
      ),
    );
  }
}
