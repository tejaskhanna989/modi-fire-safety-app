import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../data/models/equipment.dart';

class EquipmentPage extends StatelessWidget {
  const EquipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final equipment = context.demoData.equipment;

    return Scaffold(
      appBar: const AppAppBar(title: 'Equipment register'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.massive,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DemoBanner(),
            const SizedBox(height: AppSpacing.xxl),
            const AppSectionHeader(
              title: 'My equipment',
              subtitle: 'Illustrative assets registered in local demo memory.',
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Register equipment',
              icon: Icons.add_outlined,
              expanded: true,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.equipmentRegister),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (equipment.isEmpty)
              AppEmptyState(
                icon: Icons.qr_code_2_outlined,
                title: 'No equipment registered',
                message: 'Register a demo asset to generate a simulated token.',
              )
            else
              ...equipment.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _EquipmentTile(item: item),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            const LocalOnlyNotice(),
          ],
        ),
      ),
    );
  }
}

class _EquipmentTile extends StatelessWidget {
  const _EquipmentTile({required this.item});

  final Equipment item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.equipmentDetail,
        arguments: item,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: context.isDark
                  ? AppSurfaceColors.dark
                  : AppSurfaceColors.light,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.fire_extinguisher_outlined,
              color: context.scheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.name, style: AppTypography.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${item.assetTag} · ${item.location}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

abstract final class AppSurfaceColors {
  static const Color light = Color(0xFFFFEFE9);
  static const Color dark = Color(0xFF1D252C);
}
