import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/app_mode.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Unmistakable, always-visible disclosure that the current experience is
/// simulated. Live mode omits it entirely.
class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppConfig.mode.isLive) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceAlt : AppColors.amberTint,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.amber.withOpacity(0.35)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: isDark ? AppColors.amber : AppColors.inkSoft,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              AppConfig.demoNotice,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkInk : AppColors.inkSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
