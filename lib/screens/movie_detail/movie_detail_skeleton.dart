import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Placeholder shown while a movie's detail request is in flight, mirroring
/// [MovieDetailPage]'s real layout so there's no jarring size jump once the
/// data lands.
class MovieDetailSkeleton extends StatefulWidget {
  const MovieDetailSkeleton({super.key});

  @override
  State<MovieDetailSkeleton> createState() => _MovieDetailSkeletonState();
}

class _MovieDetailSkeletonState extends State<MovieDetailSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.4,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Opacity(opacity: _opacity.value, child: child);
      },
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Box(
              width: double.infinity,
              height: 260,
              color: colorScheme.surfaceContainerHigh,
              radius: BorderRadius.zero,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  _Box(
                    width: 160,
                    height: 24,
                    color: colorScheme.surfaceContainerHigh,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      _Box(
                        width: 48,
                        height: 16,
                        color: colorScheme.surfaceContainerHigh,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _Box(
                        width: 48,
                        height: 16,
                        color: colorScheme.surfaceContainerHigh,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _Box(
                        width: 64,
                        height: 16,
                        color: colorScheme.surfaceContainerHigh,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Box(
                    width: double.infinity,
                    height: 44,
                    color: colorScheme.surfaceContainerHigh,
                    radius: AppRadius.mdBorder,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _Box(
                    width: double.infinity,
                    height: 44,
                    color: colorScheme.surfaceContainerHigh,
                    radius: AppRadius.mdBorder,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Box(
                    width: 90,
                    height: 20,
                    color: colorScheme.surfaceContainerHigh,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _Box(
                    width: double.infinity,
                    height: 14,
                    color: colorScheme.surfaceContainerHigh,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _Box(
                    width: double.infinity,
                    height: 14,
                    color: colorScheme.surfaceContainerHigh,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _Box(
                    width: 200,
                    height: 14,
                    color: colorScheme.surfaceContainerHigh,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Box(
                    width: 60,
                    height: 20,
                    color: colorScheme.surfaceContainerHigh,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 96,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: 4,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: _Box(
                    width: 64,
                    height: 64,
                    color: colorScheme.surfaceContainerHigh,
                    radius: AppRadius.fullBorder,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.width,
    required this.height,
    required this.color,
    this.radius,
  });

  final double width;
  final double height;
  final Color color;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius ?? AppRadius.smBorder,
      child: SizedBox(
        width: width,
        height: height,
        child: ColoredBox(color: color),
      ),
    );
  }
}
