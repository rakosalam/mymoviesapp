import 'package:flutter/material.dart';

import '../../consts/api_constants.dart';
import '../../models/movie_detail.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Backdrop image with back/share buttons floated over it, plus the poster
/// thumbnail + title/year/runtime/genre chips that overlap its bottom edge.
class MovieDetailHero extends StatelessWidget {
  const MovieDetailHero({
    super.key,
    required this.movie,
    this.onBackTap,
    this.onShareTap,
  });

  final MovieDetail movie;
  final VoidCallback? onBackTap;
  final VoidCallback? onShareTap;

  static const _backdropHeight = 260.0;
  static const _posterOverlap = 64.0;
  static const _posterHeight = 144.0;
  static const _totalHeight = _backdropHeight - _posterOverlap + _posterHeight;

  String get _year =>
      movie.releaseDate.length >= 4 ? movie.releaseDate.substring(0, 4) : '—';

  String get _runtime => movie.runtime > 0 ? '${movie.runtime}m' : '—';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: _totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: _backdropHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                movie.backdropPath != null
                    ? Image.network(
                        ApiConstants.imageUrl(
                          movie.backdropPath!,
                          size: ApiConstants.posterSizeLarge,
                        ),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            ColoredBox(color: colorScheme.surfaceContainerHigh),
                      )
                    : ColoredBox(color: colorScheme.surfaceContainerHigh),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        colorScheme.surface,
                      ],
                      stops: const [0.4, 1],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CircleIconButton(
                            icon: Icons.arrow_back,
                            onTap: onBackTap,
                          ),
                          _CircleIconButton(
                            icon: Icons.share_outlined,
                            onTap: onShareTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: _backdropHeight - _posterOverlap,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.lgBorder,
                  child: SizedBox(
                    width: 96,
                    height: _posterHeight,
                    child: movie.posterPath != null
                        ? Image.network(
                            ApiConstants.imageUrl(
                              movie.posterPath!,
                              size: ApiConstants.posterSizeMedium,
                            ),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => ColoredBox(
                              color: colorScheme.surfaceContainerHigh,
                              child: Icon(
                                Icons.local_movies_outlined,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ColoredBox(
                            color: colorScheme.surfaceContainerHigh,
                            child: Icon(
                              Icons.local_movies_outlined,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: AppTypography.headlineSm(
                            colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: [
                            _InfoChip(label: _year),
                            _InfoChip(label: _runtime),
                            if (movie.genres.isNotEmpty)
                              _InfoChip(label: movie.genres.first.name),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.4),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: AppRadius.smBorder,
      ),
      child: Text(
        label,
        style: AppTypography.labelMd(colorScheme.onSurfaceVariant),
      ),
    );
  }
}
