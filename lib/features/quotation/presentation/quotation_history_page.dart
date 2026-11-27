import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format_date.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/quotation_request.dart';

/// Local, read-only history of simulated quotation requests.
class QuotationHistoryPage extends StatelessWidget {
  const QuotationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = context.demoData.quotationsNewestFirst;

    return Scaffold(
      appBar: const AppAppBar(title: 'Quotation requests'),
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
              title: 'Submitted demo requests',
              subtitle: 'Stored locally on this device. Nothing was transmitted.',
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'New quotation request',
              icon: Icons.add_outlined,
              expanded: true,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.quotation),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (requests.isEmpty)
              AppEmptyState(
                icon: Icons.request_quote_outlined,
                title: 'No quotation requests yet',
                message: 'Submit a demo quotation to see its reference, '
                    'products, quantities and status here.',
                actionLabel: 'New request',
                onAction: () =>
                    Navigator.of(context).pushNamed(AppRoutes.quotation),
              )
            else
              ...requests.map(
                (request) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _QuotationCard(request: request),
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

class _QuotationCard extends StatelessWidget {
  const _QuotationCard({required this.request});

  final QuotationRequest request;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(request.id, style: AppTypography.titleMedium),
              ),
              StatusBadge(status: request.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Submitted ${formatDate(request.submittedAt)}',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(request.companyName, style: AppTypography.titleSmall),
          const SizedBox(height: 2),
          Text(
            '${request.contactPerson} · ${request.phone} · ${request.email}',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Selected products', style: AppTypography.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          ...request.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${line.quantity} × ${line.productName}',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  Text(
                    '₹${formatAmount(line.lineTotal)}',
                    style: AppTypography.labelMedium,
                  ),
                ],
              ),
            ),
          ),
          if (request.notes.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Notes: ${request.notes}',
              style: AppTypography.bodySmall,
            ),
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${request.itemCount} items · illustrative total',
                style: AppTypography.bodySmall,
              ),
              Text(
                '₹${formatAmount(request.estimatedTotal)}',
                style: AppTypography.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
