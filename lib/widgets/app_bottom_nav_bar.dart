import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppBottomNavItem {
  const AppBottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({
    super.key,
    this.items = const [
      AppBottomNavItem(icon: Icons.trending_up, label: 'Trending'),
      AppBottomNavItem(icon: Icons.search, label: 'Search'),
      AppBottomNavItem(icon: Icons.bookmark_border, label: 'Watchlist'),
    ],
    this.initialIndex = 0,
    this.onTap,
  });

  final List<AppBottomNavItem> items;
  final int initialIndex;
  final ValueChanged<int>? onTap;

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  late int _selectedIndex = widget.initialIndex;

  @override
  void didUpdateWidget(covariant AppBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _selectedIndex = widget.initialIndex;
    }
  }

  void _select(int index) {
    setState(() => _selectedIndex = index);
    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurfaceMuted =
        Theme.of(context).textTheme.labelMedium?.color ??
        colorScheme.onSurfaceVariant;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.8),
          border: Border(top: BorderSide(color: colorScheme.outline)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < widget.items.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.xs),
              _NavItem(
                item: widget.items[i],
                selected: i == _selectedIndex,
                activeColor: colorScheme.primary,
                activeBackground: colorScheme.primary.withValues(alpha: 0.15),
                inactiveColor: onSurfaceMuted,
                onTap: () => _select(i),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.activeBackground,
    required this.inactiveColor,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final Color activeColor;
  final Color activeBackground;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdBorder,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? activeBackground : Colors.transparent,
          borderRadius: AppRadius.mdBorder,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 20,
              color: selected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.label,
              style: AppTypography.labelMd(
                selected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
