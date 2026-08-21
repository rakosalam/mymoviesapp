import 'package:flutter/material.dart';

import '../../consts/api_constants.dart';
import '../../models/cast_member.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Horizontal scrolling row of cast avatars: photo, name, character.
class CastList extends StatelessWidget {
  const CastList({super.key, required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 108,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final member = cast[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: _CastAvatar(member: member),
          );
        },
      ),
    );
  }
}

class _CastAvatar extends StatelessWidget {
  const _CastAvatar({required this.member});

  final CastMember member;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: colorScheme.surfaceContainerHigh,
            backgroundImage: member.profilePath != null
                ? NetworkImage(
                    ApiConstants.imageUrl(
                      member.profilePath!,
                      size: ApiConstants.posterSizeSmall,
                    ),
                  )
                : null,
            child: member.profilePath == null
                ? Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant)
                : null,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.labelMd(colorScheme.onSurface),
          ),
          Text(
            member.character,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.labelMd(colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
