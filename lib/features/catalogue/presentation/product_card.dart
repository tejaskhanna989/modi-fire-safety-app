import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/utils/product_visuals.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/product.dart';

/// Reusable product tile used by the catalogue, search and home dashboard.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width,
  });

  final Product product;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final icon = ProductVisuals.iconForCategory(product.categoryId);
    final tint = ProductVisuals.tintForCategory(product.categoryId);

    final card = AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 92,
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.darkSurfaceAlt : tint,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 38,
                color: context.isDark
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.inkSoft,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'DEMO ITEM',
                  style: AppTypography.labelSmall
                      .copyWith(color: context.scheme.primary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  product.name,
                  style: AppTypography.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${product.currency}${formatAmount(product.price)}',
                  style: AppTypography.titleMedium
                      .copyWith(color: context.scheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return width == null ? card : SizedBox(width: width, child: card);
  }
}
