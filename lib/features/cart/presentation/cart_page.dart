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
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../data/models/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.cart;

    return Scaffold(
      appBar: const AppAppBar(title: 'Demo cart'),
      body: cart.isEmpty
          ? AppEmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your demo cart is empty',
              message: 'Add an illustrative product from the catalogue to try '
                  'the quantity controls and cart summary.',
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
                  const SizedBox(height: AppSpacing.xl),
                  AppSectionLabel(count: cart.itemCount),
                  const SizedBox(height: AppSpacing.md),
                  ...cart.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _CartLine(item: item),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _SummaryRow(
                          label: 'Items',
                          value: '${cart.itemCount}',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _SummaryRow(
                          label: 'Subtotal',
                          value: '₹${formatAmount(cart.subtotal)}',
                          emphasized: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Illustrative demo price — not an actual Modi '
                          'International quote. Checkout is simulated and no '
                          'payment will be taken.',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.amber),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Proceed to demo checkout',
                    icon: Icons.arrow_forward_rounded,
                    expanded: true,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.checkout),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Clear demo cart',
                    variant: AppButtonVariant.quiet,
                    expanded: true,
                    onPressed: () => cart.clear(),
                  ),
                ],
              ),
            ),
    );
  }
}

class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count ${count == 1 ? 'item' : 'items'} in demo cart',
      style: AppTypography.headlineMedium,
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.cart;
    final tint = ProductVisuals.tintForCategory(item.product.categoryId);
    final icon = ProductVisuals.iconForCategory(item.product.categoryId);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              icon,
              color: context.isDark ? context.scheme.primary : AppColors.flameDeep,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.product.name,
                  style: AppTypography.titleSmall,
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '₹${formatAmount(item.lineTotal)}',
                  style: AppTypography.labelMedium
                      .copyWith(color: context.scheme.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _QuantityButton(
                      icon: Icons.remove_rounded,
                      tooltip: 'Decrease quantity',
                      onPressed: () => cart.decrement(item.product.id),
                    ),
                    SizedBox(
                      width: 34,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: AppTypography.labelLarge,
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add_rounded,
                      tooltip: 'Increase quantity',
                      onPressed: () => cart.increment(item.product.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove item',
            icon: const Icon(Icons.close_rounded),
            onPressed: () => cart.remove(item.product.id),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: AppTypography.bodyMedium),
        Text(
          value,
          style: emphasized
              ? AppTypography.headlineMedium.copyWith(
                  color: context.scheme.primary,
                )
              : AppTypography.titleMedium,
        ),
      ],
    );
  }
}
