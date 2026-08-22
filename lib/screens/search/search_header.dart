import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Back button, search text field, and a filter icon. Wrapped in [SafeArea]
/// so it never renders under the notch/status bar.
class SearchHeader extends StatefulWidget {
  const SearchHeader({
    super.key,
    this.onBackTap,
    this.onFilterTap,
    this.onChanged,
  });

  final VoidCallback? onBackTap;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final noBorder = OutlineInputBorder(
      borderRadius: AppRadius.fullBorder,
      borderSide: BorderSide.none,
    );

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: widget.onBackTap,
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  setState(() {});
                },
                style: AppTypography.bodyLg(colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: AppTypography.bodyLg(colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: _clear,
                          icon: Icon(
                            Icons.close,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                  border: noBorder,
                  enabledBorder: noBorder,
                  focusedBorder: noBorder,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),
            // IconButton(
            //   onPressed: widget.onFilterTap,
            //   icon: Icon(Icons.tune, color: colorScheme.onSurface),
            // ),
          ],
        ),
      ),
    );
  }
}
