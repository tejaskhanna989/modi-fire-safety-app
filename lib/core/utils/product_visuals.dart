import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Maps data-layer ids to presentation-layer visuals.
///
/// Keeping this out of the models means a future API can supply products
/// without carrying Flutter-specific icon or colour data.
class ProductVisuals {
  const ProductVisuals._();

  static IconData iconForCategory(String categoryId) {
    switch (categoryId) {
      case 'extinguishers':
        return Icons.fire_extinguisher_outlined;
      case 'alarms':
        return Icons.sensors_outlined;
      case 'hoses':
        return Icons.water_drop_outlined;
      case 'blankets':
        return Icons.bed_outlined;
      case 'ppe':
        return Icons.shield_outlined;
      case 'first-aid':
        return Icons.medical_services_outlined;
      case 'signage':
        return Icons.signpost_outlined;
      case 'kitchen':
        return Icons.soup_kitchen_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  static Color tintForCategory(String categoryId) {
    switch (categoryId) {
      case 'extinguishers':
        return AppColors.flameTint;
      case 'alarms':
        return AppColors.amberTint;
      case 'hoses':
        return AppColors.infoTint;
      case 'blankets':
        return AppColors.successTint;
      case 'ppe':
        return AppColors.mist;
      case 'first-aid':
        return AppColors.successTint;
      case 'signage':
        return AppColors.amberTint;
      case 'kitchen':
        return AppColors.flameTint;
      default:
        return AppColors.mist;
    }
  }
}
