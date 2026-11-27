import 'package:flutter/material.dart';

/// Colour tokens for Modi Fire Safety.
///
/// Brand direction (proposed):
/// - Primary: Deep Navy `#14263D` — buttons, active navigation, key data.
/// - Secondary: Safety Red `#D9272E` — accents and safety-critical highlights.
/// - Background: Soft Grey `#F4F6F8`. Surfaces: White `#FFFFFF`.
/// - Text: dark charcoal. Secondary text: neutral grey.
///
/// Feature code must use these tokens (never raw hex or `Colors.*` for brand
/// or text colours). Semantic colours exist for status only.
class AppColors {
  const AppColors._();

  // ---- Brand -------------------------------------------------------------
  static const Color navy = Color(0xFF14263D);
  static const Color navyDeep = Color(0xFF0E1B2C);
  static const Color navyLight = Color(0xFF9FB3C8);
  static const Color navyTint = Color(0xFFE6ECF3);

  static const Color safetyRed = Color(0xFFD9272E);
  static const Color safetyRedDeep = Color(0xFFB01F25);
  static const Color safetyRedLight = Color(0xFFFF6B70);
  static const Color safetyRedTint = Color(0xFFFCE9EA);

  static const Color softGrey = Color(0xFFF4F6F8);
  static const Color white = Color(0xFFFFFFFF);

  // ---- Text and lines (light) -------------------------------------------
  /// Dark charcoal — primary text.
  static const Color ink = Color(0xFF1C2127);

  /// Slightly lighter charcoal for dense secondary copy.
  static const Color inkSoft = Color(0xFF2E353D);

  /// Neutral grey — secondary text and captions.
  static const Color slate = Color(0xFF5E6772);

  /// Hairlines, card borders and input outlines.
  static const Color line = Color(0xFFDDE2E8);

  // ---- Dark theme --------------------------------------------------------
  static const Color darkBg = Color(0xFF0B1420);
  static const Color darkSurface = Color(0xFF111D2D);
  static const Color darkSurfaceAlt = Color(0xFF182739);
  static const Color darkInk = Color(0xFFF2F5F8);
  static const Color darkMuted = Color(0xFFA7B4C2);
  static const Color darkLine = Color(0xFF2A3A4F);

  // ---- Semantic (status only) -------------------------------------------
  static const Color amber = Color(0xFF9A5B00);
  static const Color amberTint = Color(0xFFFDF5E4);
  static const Color success = Color(0xFF1E7A4F);
  static const Color successTint = Color(0xFFE6F4EC);
  static const Color info = Color(0xFF2B5C8A);
  static const Color infoTint = Color(0xFFE7EEF6);
  static const Color danger = Color(0xFFB3261E);
  static const Color dangerTint = Color(0xFFFDECEA);
}
