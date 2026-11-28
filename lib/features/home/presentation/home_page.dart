import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/catalogue_repository.dart';
import '../../catalogue/presentation/product_card.dart';

/// Premium dashboard. All catalogue highlights come from the same mock
/// repository as the catalogue screen and are labelled as demo data.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<_QuickAction> _quickActions = <_QuickAction>[
    _QuickAction(
      title: 'Request quote',
      subtitle: 'Bulk & project pricing',
      icon: Icons.request_quote_outlined,
      route: AppRoutes.quotation,
    ),
    _QuickAction(
      title: 'Service & refill',
      subtitle: 'Book a technician',
      icon: Icons.build_outlined,
      route: AppRoutes.serviceRequest,
    ),
    _QuickAction(
      title: 'Equipment',
      subtitle: 'Register & track',
      icon: Icons.qr_code_2_outlined,
      route: AppRoutes.equipment,
    ),
    _QuickAction(
      title: 'Ask assistant',
      subtitle: 'Safety guidance',
      icon: Icons.auto_awesome_outlined,
      route: AppRoutes.assistant,
    ),
  ];

  static const CatalogueRepository _repository = MockCatalogueRepository();

  @override
  Widget build(BuildContext context) {
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
          _Greeting(name: 'Customer'),
          const SizedBox(height: AppSpacing.xl),
          const _HeroCard(),
          const SizedBox(height: AppSpacing.xxxl),
          const AppSectionHeader(
            title: 'Quick actions',
            subtitle: 'The most common requests, one tap away.',
          ),
          const SizedBox(height: AppSpacing.md),
            LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 720 ? 4 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.28,
                ),
                itemCount: _quickActions.length,
                itemBuilder: (context, index) {
                  return _QuickActionTile(action: _quickActions[index]);
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppSectionHeader(
            title: 'Popular essentials',
            subtitle: 'Illustrative catalogue items for the demo.',
            actionLabel: 'View all',
            onAction: () => Navigator.of(context).pushNamed(AppRoutes.catalogue),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 190,
            child: FutureBuilder<List<Product>>(
              future: _repository.fetchProducts(),
              builder: (context, snapshot) {
                final products = snapshot.data?.take(4).toList() ??
                    <Product>[];
                if (products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      width: 178,
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.productDetail,
                        arguments: product,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          const AppSectionHeader(title: 'Service reminder'),
          const _ServiceReminderCard(),
          const SizedBox(height: AppSpacing.xxxl),
          const _TrustStrip(),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name});

  final String name;

  String get _salutation {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_salutation, style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Hello, $name',
          style: AppTypography.displayMedium.copyWith(color: context.scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Explore illustrative products and demo service flows.',
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    // Flat navy panel with a single safety-red accent line. No gradients,
    // decorative shapes or shadows.
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        color: AppColors.navy,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 4,
              child: ColoredBox(color: AppColors.fire),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'DEMO CATALOGUE',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.navyLight),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Protection you\ncan count on.',
                    style: AppTypography.displayMedium
                        .copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Equipment, service and expertise for every site.',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.navyLight),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.catalogue),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.navy,
                    ),
                    child: const Text('Explore catalogue'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.of(context).pushNamed(action.route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.darkSurfaceAlt : AppColors.navyTint,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              action.icon,
              size: 20,
              color: context.isDark ? AppColors.navyLight : AppColors.navy,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(action.title, style: AppTypography.titleSmall),
              const SizedBox(height: 2),
              Text(action.subtitle, style: AppTypography.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceReminderCard extends StatelessWidget {
  const _ServiceReminderCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.darkSurfaceAlt : AppColors.amberTint,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: context.isDark ? AppColors.amber : AppColors.inkSoft,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Dry Powder Extinguisher — Demo', style: AppTypography.titleSmall),
                const SizedBox(height: 4),
                Text(
                  'Illustrative reminder · Due in 12 days · Site: Warehouse 2',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const AppBadge(label: 'DUE SOON', foreground: AppColors.amber),
        ],
      ),
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.lg,
      alignment: WrapAlignment.spaceBetween,
      children: const <Widget>[
        _TrustItem(icon: Icons.info_outline_rounded, label: 'Illustrative data'),
        _TrustItem(icon: Icons.tune_rounded, label: 'API-configurable'),
        _TrustItem(icon: Icons.phone_android_outlined, label: 'Local demo build'),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 18, color: context.scheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
}
