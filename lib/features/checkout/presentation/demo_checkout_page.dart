import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../data/models/demo_order.dart';

class DemoCheckoutPage extends StatelessWidget {
  const DemoCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.cart;
    final profile = context.demoData.profile;

    return Scaffold(
      appBar: const AppAppBar(title: 'Demo checkout'),
      body: cart.isEmpty
          ? AppEmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Nothing to check out',
              message: 'Add demo products to the cart first.',
              actionLabel: 'Browse catalogue',
              onAction: () => Navigator.of(context).pushNamed(AppRoutes.catalogue),
            )
          : SingleChildScrollView(
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
                  Text('Review demo order', style: AppTypography.headlineLarge),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Contact snapshot', style: AppTypography.titleMedium),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          profile == null
                              ? 'No demo profile saved'
                              : profile.displayName,
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          profile == null ? '—' : profile.email,
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Items', style: AppTypography.titleMedium),
                        const SizedBox(height: AppSpacing.md),
                        ...cart.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${item.quantity} × ${item.product.name}',
                                    style: AppTypography.bodyMedium,
                                  ),
                                ),
                                Text(
                                  '₹${formatAmount(item.lineTotal)}',
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
                            Text('Illustrative subtotal',
                                style: AppTypography.titleSmall),
                            Text(
                              '₹${formatAmount(cart.subtotal)}',
                              style: AppTypography.headlineMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppCard(
                    child: Text(
                      'Simulated checkout only. No payment gateway, no payment '
                      'processing, no external API and no actual order '
                      'transmission. The order is stored in local in-memory '
                      'demo state and resets when the app restarts.',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const LocalOnlyNotice(),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Place demo order',
                    icon: Icons.check_circle_outline,
                    expanded: true,
                    onPressed: () {
                      final lines = cart.items
                          .map(
                            (item) => DemoOrderLine(
                              productId: item.product.id,
                              productName: item.product.name,
                              quantity: item.quantity,
                              unitPrice: item.product.price,
                            ),
                          )
                          .toList();
                      final order = context.demoData.placeDemoOrder(
                        lines: lines,
                        total: cart.subtotal,
                      );
                      cart.clear();
                      Navigator.of(context).pushNamed(
                        AppRoutes.orderDetail,
                        arguments: order,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
