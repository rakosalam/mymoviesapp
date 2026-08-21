import 'package:flutter/material.dart';

import '../../modals/theme_mode_sheet.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Top app header: ticket icon, "CineTrack" wordmark, appearance picker.
/// Wrapped in [SafeArea] so it never renders under the notch/status bar.
class TrendingHeader extends StatelessWidget {
  const TrendingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: AppRadius.mdBorder,
              ),
              child: Icon(
                Icons.confirmation_number_outlined,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Cine',
                    style: AppTypography.headlineMd(colorScheme.onSurface),
                  ),
                  TextSpan(
                    text: 'Track',
                    style: AppTypography.headlineMd(colorScheme.primary),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => showThemeModeSheet(context),
              icon: Icon(
                isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
