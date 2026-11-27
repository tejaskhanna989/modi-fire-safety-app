import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format_date.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/demo_order.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.order});

  final DemoOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Order detail'),
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(order.id, style: AppTypography.headlineLarge),
                ),
                StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Placed ${formatDate(order.placedAt)}',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Demo line items', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.lg),
                  ...order.lines.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(line.productName, style: AppTypography.titleSmall),
                                const SizedBox(height: 2),
                                Text(
                                  '${line.quantity} × '
                                  '₹${formatAmount(line.unitPrice)}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${formatAmount(line.lineTotal)}',
                            style: AppTypography.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Illustrative total', style: AppTypography.titleSmall),
                      Text(
                        '₹${formatAmount(order.total)}',
                        style: AppTypography.headlineMedium,
                      ),
                    ],
                  ),
                ],
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
