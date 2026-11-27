import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Editorial type scale. Fonts are the platform UI font for Phase 1;
/// a licensed/self-hosted family can be introduced in a later phase.
class AppTypography {
  const AppTypography._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    height: 1.12,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.9,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 30,
    height: 1.16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 26,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    height: 1.24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.35,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 19,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    height: 1.35,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.5,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.5,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
  );

  static TextTheme textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final strong = isDark ? AppColors.darkInk : AppColors.ink;
    final muted = isDark ? AppColors.darkMuted : AppColors.slate;

    return TextTheme(
      displayLarge: displayLarge.copyWith(color: strong),
      displayMedium: displayMedium.copyWith(color: strong),
      headlineLarge: headlineLarge.copyWith(color: strong),
      headlineMedium: headlineMedium.copyWith(color: strong),
      titleLarge: titleLarge.copyWith(color: strong),
      titleMedium: titleMedium.copyWith(color: strong),
      titleSmall: titleSmall.copyWith(color: strong),
      bodyLarge: bodyLarge.copyWith(color: strong),
      bodyMedium: bodyMedium.copyWith(color: muted),
      bodySmall: bodySmall.copyWith(color: muted),
      labelLarge: labelLarge.copyWith(color: strong),
      labelMedium: labelMedium.copyWith(color: muted),
      labelSmall: labelSmall.copyWith(color: muted),
    );
  }
}
