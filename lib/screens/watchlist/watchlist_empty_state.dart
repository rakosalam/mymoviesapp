import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Shown when the watchlist has no saved movies yet.
class WatchlistEmptyState extends StatelessWidget {
  const WatchlistEmptyState({super.key});

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
              Icons.bookmark_border,
              size: 64,
              color: colorScheme.surfaceContainerHigh,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Your Watchlist is Empty',
              textAlign: TextAlign.center,
              style: AppTypography.headlineSm(colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Movies you bookmark from Trending or Search will show up '
              'here, saved for offline viewing.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd(colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
