import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shown instead of the raw network error when content couldn't be loaded
/// because the device is offline and nothing is cached for it.
class NoInternetView extends StatelessWidget {
  const NoInternetView({
    super.key,
    required this.onGoToWatchlist,
    this.message =
        'Check your internet connection and try again, or browse what '
        'you\'ve already saved offline.',
  });

  final VoidCallback onGoToWatchlist;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Internet Connection',
              style: AppTypography.headlineSm(colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTypography.bodyMd(colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: onGoToWatchlist,
              child: const Text('Go to Watchlist'),
            ),
          ],
        ),
      ),
    );
  }
}
