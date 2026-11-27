import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format_date.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/request_enums.dart';
import 'service_request_page.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = context.demoData.serviceRequests;

    return SingleChildScrollView(
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
            title: 'Servicing & refilling',
            subtitle: 'Request servicing, refilling or inspection for demo equipment.',
          ),
          const SizedBox(height: AppSpacing.md),
          ...ServiceType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(_iconFor(type), color: context.scheme.primary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(type.label, style: AppTypography.titleMedium),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(type.description, style: AppTypography.bodySmall),
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppButton(
                        label: 'Raise request',
                        variant: AppButtonVariant.secondary,
                        onPressed: () => Navigator.of(context).pushNamed(
                          AppRoutes.serviceRequest,
                          arguments: ServiceRequestArguments(initialType: type),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const AppSectionHeader(
            title: 'Request history',
            subtitle: 'All requests are simulated and stored locally.',
          ),
          const SizedBox(height: AppSpacing.md),
          if (requests.isEmpty)
            AppEmptyState(
              icon: Icons.history_toggle_off_outlined,
              title: 'No service requests yet',
              message: 'Raise a demo request above to see it here.',
            )
          else
            ...requests.reversed.map(
              (request) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${request.type.label} · ${request.id}',
                              style: AppTypography.titleSmall,
                            ),
                          ),
                          StatusBadge(status: request.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        request.equipmentLabel,
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Preferred: ${formatDate(request.preferredDate)}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          const LocalOnlyNotice(),
        ],
      ),
    );
  }

  static IconData _iconFor(ServiceType type) {
    switch (type) {
      case ServiceType.servicing:
        return Icons.build_outlined;
      case ServiceType.refilling:
        return Icons.local_fire_department_outlined;
      case ServiceType.inspection:
        return Icons.fact_check_outlined;
    }
  }
}
