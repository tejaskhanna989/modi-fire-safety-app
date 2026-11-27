import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format_date.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/request_enums.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.demoData.orders;
    final serviceRequests = context.demoData.serviceRequests;

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
            title: 'Orders & history',
            subtitle: 'All records are stored only in local demo memory.',
          ),
          const SizedBox(height: AppSpacing.md),
          if (orders.isEmpty)
            AppEmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No demo orders',
              message: 'Complete a demo checkout to create an order record.',
            )
          else
            ...orders.reversed.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.orderDetail,
                    arguments: order,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(order.id, style: AppTypography.titleSmall),
                            const SizedBox(height: 4),
                            Text(
                              '${formatDate(order.placedAt)} · '
                              '${order.itemCount} items · '
                              '₹${formatAmount(order.total)}',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: order.status),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
          const AppSectionHeader(
            title: 'Service history',
            subtitle: 'Simulated servicing, refilling and inspection requests.',
          ),
          const SizedBox(height: AppSpacing.md),
          if (serviceRequests.isEmpty)
            AppCard(
              child: Text(
                'No demo service requests yet.',
                style: AppTypography.bodyMedium,
              ),
            )
          else
            ...serviceRequests.reversed.map(
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
                              '${request.equipmentLabel} · '
                              '${formatDate(request.preferredDate)}',
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
          const SizedBox(height: AppSpacing.lg),
          const LocalOnlyNotice(),
        ],
      ),
    );
  }
}
