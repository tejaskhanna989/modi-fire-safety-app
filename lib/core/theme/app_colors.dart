import 'package:flutter/material.dart';

/// Brand palette for Modi Fire Safety.
///
/// Kept as hard-coded token values so the design system does not depend on
/// generated colours or a remote design source.
class AppColors {
  const AppColors._();

  // Primary fire palette
  static const Color flame = Color(0xFFD9411E);
  static const Color flameDeep = Color(0xFFA92712);
  static const Color flameLight = Color(0xFFFF7A52);
  static const Color flameTint = Color(0xFFFFEFE9);

  // neutrals
  static const Color ink = Color(0xFF12161B);
  static const Color inkSoft = Color(0xFF2B3138);
  static const Color slate = Color(0xFF66717E);
  static const Color mist = Color(0xFFF4F6F8);
  static const Color paper = Color(0xFFFFFFFF);
  static const Color line = Color(0xFFE2E6EA);

  // Dark theme
  static const Color darkBg = Color(0xFF0C1014);
  static const Color darkSurface = Color(0xFF151B21);
  static const Color darkSurfaceAlt = Color(0xFF1D252C);
  static const Color darkInk = Color(0xFFF2F5F7);
  static const Color darkMuted = Color(0xFF9DA8B3);
  static const Color darkLine = Color(0xFF29313A);

  // Semantic
  static const Color amber = Color(0xFFD98916);
  static const Color amberTint = Color(0xFFFFF5E3);
  static const Color success = Color(0xFF23855C);
  static const Color successTint = Color(0xFFE7F5EE);
  static const Color info = Color(0xFF2B6CA8);
  static const Color infoTint = Color(0xFFE8F1F9);
  static const Color danger = Color(0xFFB3261E);
  static const Color dangerTint = Color(0xFFFDECEA);
}
