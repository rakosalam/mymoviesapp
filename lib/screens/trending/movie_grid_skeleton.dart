import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'movie_card_skeleton.dart';

/// Grid of pulsing placeholder cards shown while trending movies load.
/// Mirrors the real grid's delegate so there's no layout jump once data
/// arrives.
class MovieGridSkeleton extends StatelessWidget {
  const MovieGridSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ).copyWith(bottom: AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.56,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const MovieCardSkeleton(),
    );
  }
}
