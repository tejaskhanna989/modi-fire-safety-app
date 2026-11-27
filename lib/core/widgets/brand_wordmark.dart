import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Temporary text-only brand treatment. No logo asset has been supplied, so
/// this is typography only. Replace the body of this widget (and nowhere
/// else) when an approved logo is available.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.onDark = false});

  /// Use light text colours when placed on a navy surface.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final primary = onDark ? AppColors.white : AppColors.navy;
    final secondary = onDark ? AppColors.navyLight : AppColors.ink;

    return Column(
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
    );
  }
}
