import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Brand lockup: the supplied flame logo plus the wordmark text. The logo
/// asset is declared in pubspec.yaml; change it here (and nowhere else) if
/// the brand assets are updated.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.onDark = false});

  /// Use light text colours when placed on a navy surface.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final primary = onDark ? AppColors.white : AppColors.navy;
    final secondary = onDark ? AppColors.navyLight : AppColors.ink;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          'assets/brand/flame_logo.png',
          height: 36,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          semanticLabel: 'Modi Fire Safety logo',
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          Text(
            'MODI',
            style: AppTypography.labelSmall.copyWith(
              color: primary,
              letterSpacing: 2.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'FIRE SAFETY',
            style: AppTypography.titleSmall.copyWith(
              color: secondary,
              height: 1.1,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          ],
        ),
      ],
    );
  }
}
