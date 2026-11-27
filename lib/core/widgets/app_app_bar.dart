import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/config/app_mode.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'brand_wordmark.dart';

/// Shared top bar. Keeps branding, mode visibility and global actions
/// consistent on every screen.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.showBrand = true,
    this.actions = const <Widget>[],
  });

  final String? title;
  final bool showBrand;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : _Brand(showBrand: showBrand),
      actions: <Widget>[
        if (AppConfig.mode.isDemo) const _ModeChip(),
        IconButton(
          tooltip: 'Notifications',
          icon: const Icon(Icons.notifications_none_rounded),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
        ),
        const _CartAction(),
        IconButton(
          tooltip: 'Fire safety assistant',
          icon: const Icon(Icons.auto_awesome_outlined),
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.assistant),
        ),
        ...actions,
      ],
    );
  }
}

class _CartAction extends StatelessWidget {
  const _CartAction();

  @override
  Widget build(BuildContext context) {
    final count = context.cart.itemCount;

    return IconButton(
      tooltip: 'Demo cart',
      icon: count > 0
          ? Badge(
              label: Text('$count'),
              child: const Icon(Icons.shopping_bag_outlined),
            )
          : const Icon(Icons.shopping_bag_outlined),
      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.showBrand});

  final bool showBrand;

  @override
  Widget build(BuildContext context) {
    if (!showBrand) return const SizedBox.shrink();
    return const BrandWordmark();
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: context.isDark ? AppColors.darkSurfaceAlt : AppColors.amberTint,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: AppColors.amber.withOpacity(context.isDark ? 0.5 : 0.28),
          ),
        ),
        child: Text(
          AppConfig.mode.label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.amber),
        ),
      ),
    );
  }
}
