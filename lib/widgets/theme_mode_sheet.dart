import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_provider.dart';

const _options = [
  (mode: ThemeMode.light, label: 'Light', icon: Icons.light_mode_outlined),
  (mode: ThemeMode.dark, label: 'Dark', icon: Icons.dark_mode_outlined),
  (
    mode: ThemeMode.system,
    label: 'System',
    icon: Icons.brightness_auto_outlined,
  ),
];

/// Opens the appearance bottom sheet where the user picks Light/Dark/System.
Future<void> showThemeModeSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const ThemeModeSheet(),
  );
}

class ThemeModeSheet extends StatelessWidget {
  const ThemeModeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: AppRadius.xlBorder,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: AppRadius.fullBorder,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Appearance',
              style: AppTypography.headlineSm(colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final option in _options)
              _ThemeOptionTile(
                icon: option.icon,
                label: option.label,
                selected: themeMode == option.mode,
                onTap: () {
                  context.read<ThemeProvider>().setThemeMode(option.mode);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdBorder,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLg(
                  selected
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (selected) Icon(Icons.check, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
