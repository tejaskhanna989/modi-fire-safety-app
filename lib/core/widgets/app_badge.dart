import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Small status pill. Semantic colours are passed in explicitly so status is
/// never implied by colour alone — the label always carries the meaning.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.foreground,
    this.background,
  });

  final String label;
  final Color? foreground;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = foreground ?? scheme.onSurface;
    final bg = background ?? scheme.surface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: fg.withOpacity(0.22)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: fg),
      ),
    );
  }
}
