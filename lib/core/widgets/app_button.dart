import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, quiet }

/// Branded button used across the app rather than raw Material buttons.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment:
          expanded ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(child: Text(label, style: AppTypography.labelLarge)),
      ],
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(onPressed: onPressed, child: child);
      case AppButtonVariant.secondary:
        return OutlinedButton(onPressed: onPressed, child: child);
      case AppButtonVariant.quiet:
        return TextButton(onPressed: onPressed, child: child);
    }
  }
}
