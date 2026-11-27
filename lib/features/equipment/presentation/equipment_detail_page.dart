import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format_date.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../core/widgets/simulated_qr_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/equipment.dart';
import '../../../data/models/request_enums.dart';
import '../../services/presentation/service_request_page.dart';

class EquipmentDetailPage extends StatelessWidget {
  const EquipmentDetailPage({super.key, required this.equipment});

  final Equipment equipment;

  @override
  Widget build(BuildContext context) {
    final related = context.demoData.serviceRequests
        .where((request) => request.equipmentId == equipment.id)
        .toList();

    return Scaffold(
      appBar: const AppAppBar(title: 'Equipment detail'),
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
            Text(equipment.name, style: AppTypography.headlineLarge),
            const SizedBox(height: AppSpacing.sm),
            const AppBadge(label: 'LOCAL DEMO ASSET'),
            const SizedBox(height: AppSpacing.xxl),
            AppCard(
              child: Column(
                children: <Widget>[
                  const SimulatedQrView(token: equipment.token, size: 160),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _DetailRow(label: 'Asset tag', value: equipment.assetTag),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(label: 'Location', value: equipment.location),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    label: 'Registered',
                    value: formatDate(equipment.registeredAt),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    label: 'Notes',
                    value: equipment.notes.isEmpty ? '—' : equipment.notes,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const AppSectionHeader(title: 'Service history'),
            const SizedBox(height: AppSpacing.md),
            if (related.isEmpty)
              AppCard(
                child: Text(
                  'No demo service requests linked to this asset yet.',
                  style: AppTypography.bodyMedium,
                ),
              )
            else
              ...related.reversed.map(
                (request) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppCard(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${request.type.label} · ${request.id}',
                                style: AppTypography.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatDate(request.preferredDate),
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(status: request.status),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: 'Request service for this asset',
              icon: Icons.build_outlined,
              expanded: true,
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.serviceRequest,
                arguments: ServiceRequestArguments(
                  initialType: ServiceType.servicing,
                  equipmentId: equipment.id,
                  equipmentLabel: equipment.name,
                ),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 120,
          child: Text(label, style: AppTypography.bodySmall),
        ),
        Expanded(child: Text(value, style: AppTypography.bodyMedium)),
      ],
    );
  }
}
