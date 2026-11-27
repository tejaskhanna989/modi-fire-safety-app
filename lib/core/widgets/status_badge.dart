import 'package:flutter/material.dart';

import '../../data/models/request_enums.dart';
import '../theme/app_colors.dart';
import 'app_badge.dart';

/// Semantic status pill. The text label always carries the meaning.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final Object status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color foreground;
    late final Color background;

    if (status is RequestStatus) {
      final s = status as RequestStatus;
      switch (s) {
        case RequestStatus.draft:
          label = s.label;
          foreground = AppColors.slate;
          background = AppColors.mist;
          break;
        case RequestStatus.submitted:
          label = s.label;
          foreground = AppColors.info;
          background = AppColors.infoTint;
          break;
        case RequestStatus.inProgress:
          label = s.label;
          foreground = AppColors.amber;
          background = AppColors.amberTint;
          break;
        case RequestStatus.completed:
          label = s.label;
          foreground = AppColors.success;
          background = AppColors.successTint;
          break;
      }
    } else if (status is OrderStatus) {
      final s = status as OrderStatus;
      switch (s) {
        case OrderStatus.placed:
          label = s.label;
          foreground = AppColors.info;
          background = AppColors.infoTint;
          break;
        case OrderStatus.processing:
          label = s.label;
          foreground = AppColors.amber;
          background = AppColors.amberTint;
          break;
        case OrderStatus.completed:
          label = s.label;
          foreground = AppColors.success;
          background = AppColors.successTint;
          break;
      }
    } else {
      label = status.toString().toUpperCase();
      foreground = AppColors.slate;
      background = AppColors.mist;
    }

    return AppBadge(label: label, foreground: foreground, background: background);
  }
}
