import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../data/models/customer_profile.dart';
import '../../../data/models/request_enums.dart';
import 'b2b_registration_page.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.demoData.profile;

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
            title: 'My profile',
            subtitle: 'Individual and business accounts share the same app.',
          ),
          const SizedBox(height: AppSpacing.md),
          if (profile == null)
            AppEmptyState(
              icon: Icons.person_outline_rounded,
              title: 'No demo profile yet',
              message: 'Create a B2C or B2B profile to try registration and '
                  'the connected demo workflows.',
              actionLabel: 'Create profile',
              onAction: () => context.push(B2BRegistrationPage(existing: profile)),
            )
          else
            _ProfileCard(profile: profile),
          const SizedBox(height: AppSpacing.xxl),
          const AppSectionHeader(title: 'My demo activity'),
          const SizedBox(height: AppSpacing.md),
          _MenuCard(
            icon: Icons.receipt_long_outlined,
            title: 'Orders & history',
            subtitle: 'Demo orders and service history',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.orders),
          ),
          _MenuCard(
            icon: Icons.qr_code_2_outlined,
            title: 'Equipment register',
            subtitle: 'Registered demo assets and tokens',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.equipment),
          ),
          _MenuCard(
            icon: Icons.history_toggle_off_outlined,
            title: 'Quotation requests',
            subtitle: 'View locally stored demo requests',
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.quotationHistory),
          ),
          _MenuCard(
            icon: Icons.request_quote_outlined,
            title: 'New quotation request',
            subtitle: 'Select demo products and submit locally',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.quotation),
          ),
          _MenuCard(
            icon: Icons.build_circle_outlined,
            title: 'Service requests',
            subtitle: 'Servicing, refilling and inspection',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.services),
          ),
          const AppSectionHeader(title: 'Appearance'),
          const SizedBox(height: AppSpacing.md),
          const _AppearanceCard(),
          const SizedBox(height: AppSpacing.xl),
          const LocalOnlyNotice(),
          const SizedBox(height: AppSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: profile == null ? 'Create profile' : 'Edit demo profile',
              icon: Icons.edit_outlined,
              variant: AppButtonVariant.secondary,
              onPressed: () =>
                  context.push(B2BRegistrationPage(existing: profile)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final CustomerProfile profile;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.isDark
                      ? AppColorsSurface.dark
                      : AppColorsSurface.light,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  profile.isBusiness
                      ? Icons.business_outlined
                      : Icons.person_outline_rounded,
                  color: context.scheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(profile.displayName, style: AppTypography.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(profile.type.label, style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _DetailRow(label: 'Phone', value: profile.phone),
          const SizedBox(height: AppSpacing.sm),
          _DetailRow(label: 'Email', value: profile.email),
          const SizedBox(height: AppSpacing.sm),
          _DetailRow(label: 'Contact', value: profile.secondaryName),
          if (profile.isBusiness) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
              label: 'Company',
              value: profile.companyName ?? '—',
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
              label: 'Business address',
              value: profile.businessAddress ?? '—',
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
              label: 'GSTIN',
              value: profile.gstin ?? 'Not provided',
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          const AppBadge(label: 'LOCAL DEMO PROFILE'),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 130,
          child: Text(label, style: AppTypography.bodySmall),
        ),
        Expanded(
          child: Text(value, style: AppTypography.bodyMedium),
        ),
      ],
    );
  }
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context) {
    final appearance = context.appearance;

    return ListenableBuilder(
      listenable: appearance,
      builder: (context, _) => AppCard(
        child: Row(
          children: <Widget>[
            Icon(Icons.dark_mode_outlined, color: context.scheme.primary),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Dark theme', style: AppTypography.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    'Off uses the light design (default).',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            Switch(value: appearance.isDark, onChanged: appearance.setDark),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Icon(icon, color: context.scheme.primary),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: AppTypography.titleSmall),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

abstract final class AppColorsSurface {
  static const Color light = Color(0xFFFFEFE9);
  static const Color dark = Color(0xFF1D252C);
}
