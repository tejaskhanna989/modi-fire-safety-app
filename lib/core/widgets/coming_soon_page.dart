import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_app_bar.dart';
import 'app_button.dart';
import 'demo_banner.dart';

/// Branded placeholder used for modules that are planned but not yet built.
/// Replaced route-by-route as each development phase lands.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppAppBar(title: title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DemoBanner(),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceAlt : AppColors.navyTint,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Icon(
                  Icons.construction_rounded,
                  size: 42,
                  color: isDark ? AppColors.navyLight : AppColors.navy,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(title, style: AppTypography.headlineLarge),
              const SizedBox(height: AppSpacing.md),
              Text(message, style: AppTypography.bodyLarge),
              const SizedBox(height: AppSpacing.md),
              Text(
                'This module is scheduled for the next reviewable phase. '
                'No placeholder data is being shown as if it were real.',
                style: AppTypography.bodySmall.copyWith(color: context.scheme.primary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton(
                  label: 'Back to dashboard',
                  icon: Icons.arrow_back_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
