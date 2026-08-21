import 'package:flutter/material.dart';

import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

/// Matches TMDB's `time_window` path param for `/trending/movie/{time_window}`.
enum TrendingTimeWindow {
  day('day', 'Today'),
  week('week', 'This Week');

  const TrendingTimeWindow(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

/// Segmented pill control to switch between "Today" and "This Week" trending.
class TrendingFilter extends StatelessWidget {
  const TrendingFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TrendingTimeWindow selected;
  final ValueChanged<TrendingTimeWindow> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: AppRadius.fullBorder,
        ),
        child: Row(
          children: [
            for (final option in TrendingTimeWindow.values)
              Expanded(
                child: _FilterSegment(
                  label: option.label,
                  selected: option == selected,
                  onTap: () => onChanged(option),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterSegment extends StatelessWidget {
  const _FilterSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : Colors.transparent,
          borderRadius: AppRadius.fullBorder,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.bodyMd(
            selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
