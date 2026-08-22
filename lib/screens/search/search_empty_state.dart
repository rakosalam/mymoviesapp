import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

const _suggestions = ['john wick', 'The Dark Knight', 'Inception', 'naruto'];

/// Shown before the user has typed anything: a prompt plus a handful of
/// tappable search suggestions.
class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key, this.onSuggestionTap});

  final ValueChanged<String>? onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_movies_outlined,
              size: 64,
              color: colorScheme.surfaceContainerHigh,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Explore the Universe of Cinema',
              textAlign: TextAlign.center,
              style: AppTypography.headlineSm(colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Search for your favorite movies, directors, or explore new '
              'genres to add to your watchlist.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd(colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final suggestion in _suggestions)
                  _SuggestionChip(
                    label: suggestion,
                    onTap: () => onSuggestionTap?.call(suggestion),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.fullBorder,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: AppRadius.fullBorder,
        ),
        child: Text(label, style: AppTypography.bodyMd(colorScheme.onSurface)),
      ),
    );
  }
}
