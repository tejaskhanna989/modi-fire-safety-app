import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/utils/product_visuals.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../data/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final icon = ProductVisuals.iconForCategory(product.categoryId);
    final tint = ProductVisuals.tintForCategory(product.categoryId);

    return Scaffold(
      appBar: const AppAppBar(title: 'Product details'),
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
            const SizedBox(height: AppSpacing.xl),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Icon(
                icon,
                size: 84,
                color: context.isDark
                    ? context.scheme.primary
                    : AppColors.flameDeep,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Wrap(
              spacing: AppSpacing.sm,
              children: <Widget>[
                const AppBadge(label: 'DEMO ITEM'),
                ...product.tags.map(
                  (tag) => AppBadge(label: tag.toUpperCase()),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(product.name, style: AppTypography.headlineLarge),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '${product.currency}${formatAmount(product.price)}',
              style: AppTypography.displayMedium
                  .copyWith(color: context.scheme.primary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              product.priceDisclosure,
              style: AppTypography.bodySmall.copyWith(color: AppColors.amber),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('About this demo entry', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(product.summary, style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Text(
                'Full specifications, certifications and verified pricing '
                'will be shown here when connected to the approved data '
                'source. None are asserted in this demo.',
                style: AppTypography.bodySmall,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: 'Add to demo cart',
              icon: Icons.add_shopping_cart_outlined,
              expanded: true,
              onPressed: () {
                context.cart.add(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to the demo cart')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Add and view cart',
              icon: Icons.shopping_bag_outlined,
              variant: AppButtonVariant.secondary,
              expanded: true,
              onPressed: () {
                context.cart.add(product);
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Used when a route is opened without a valid product argument.
class ProductDetailFallback extends StatelessWidget {
  const ProductDetailFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Product details'),
      body: AppEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Product unavailable',
        message: 'Open a product from the demo catalogue to see its details.',
        actionLabel: 'Back',
        onAction: () => context.pop(),
      ),
    );
  }
}
