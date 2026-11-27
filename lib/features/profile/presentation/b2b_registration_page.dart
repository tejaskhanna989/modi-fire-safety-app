import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../data/models/customer_profile.dart';
import '../../../data/models/request_enums.dart';

class B2BRegistrationPage extends StatefulWidget {
  const B2BRegistrationPage({super.key, this.existing});

  /// When supplied, the form opens with this profile's details and saving
  /// updates the same record instead of creating a blank replacement.
  final CustomerProfile? existing;

  @override
  State<B2BRegistrationPage> createState() => _B2BRegistrationPageState();
}

class _B2BRegistrationPageState extends State<B2BRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  CustomerType _type = CustomerType.b2c;

  final _name = TextEditingController();
  final _company = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _gstin = TextEditingController();

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing == null) return;

    _type = existing.type;
    _name.text = existing.type.isBusiness
        ? existing.contactPerson ?? existing.name
        : existing.name;
    _company.text = existing.companyName ?? '';
    _contact.text = existing.contactPerson ?? '';
    _phone.text = existing.phone;
    _email.text = existing.email;
    _address.text = existing.businessAddress ?? '';
    _gstin.text = existing.gstin ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _company.dispose();
    _contact.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _gstin.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Enter a valid email address';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final isBusiness = _type.isBusiness;
    final existing = widget.existing;
    final profile = CustomerProfile(
      id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: _type,
      name: isBusiness ? _contact.text.trim() : _name.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      companyName: isBusiness ? _company.text.trim() : null,
      contactPerson: isBusiness ? _contact.text.trim() : null,
      businessAddress: isBusiness ? _address.text.trim() : null,
      gstin: isBusiness && _gstin.text.trim().isNotEmpty
          ? _gstin.text.trim()
          : null,
      createdAt: existing?.createdAt ?? DateTime.now(),
    );

    context.demoData.saveProfile(profile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Demo profile updated on this device'
              : 'Demo profile saved on this device',
        ),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isBusiness = _type.isBusiness;

    return Scaffold(
      appBar: const AppAppBar(title: 'Customer registration'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.massive,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DemoBanner(),
              const SizedBox(height: AppSpacing.xxl),
              AppSectionHeader(
                title: _isEditing
                    ? 'Edit your demo profile'
                    : 'Create your demo profile',
                subtitle: 'Both individual and business customers are supported.',
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: <Widget>[
                  ChoiceChip(
                    label: const Text('Individual (B2C)'),
                    selected: !isBusiness,
                    onSelected: _isEditing
                        ? null
                        : (_) => setState(() => _type = CustomerType.b2c),
                  ),
                  ChoiceChip(
                    label: const Text('Business (B2B)'),
                    selected: isBusiness,
                    onSelected: _isEditing
                        ? null
                        : (_) => setState(() => _type = CustomerType.b2b),
                  ),
                ],
              ),
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    'Account type is locked while editing an existing profile.',
                    style: AppTypography.bodySmall,
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              if (isBusiness) ...<Widget>[
                AppTextField(
                  controller: _company,
                  label: 'Company name',
                  hint: 'Registered business name',
                  prefixIcon: Icons.business_outlined,
                  validator: (value) => _required(value, 'Company name'),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _contact,
                  label: 'Contact person',
                  hint: 'Primary contact',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (value) => _required(value, 'Contact person'),
                ),
                const SizedBox(height: AppSpacing.lg),
              ] else ...<Widget>[
                AppTextField(
                  controller: _name,
                  label: 'Full name',
                  hint: 'Your name',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (value) => _required(value, 'Name'),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              AppTextField(
                controller: _phone,
                label: 'Phone',
                hint: 'Contact number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) => _required(value, 'Phone'),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _email,
                label: 'Email',
                hint: 'name@example.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: _emailValidator,
              ),
              if (isBusiness) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _address,
                  label: 'Business address',
                  hint: 'Registered address',
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 3,
                  validator: (value) => _required(value, 'Business address'),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _gstin,
                  label: 'GSTIN (optional demo field)',
                  hint: 'Leave blank if not applicable',
                  prefixIcon: Icons.badge_outlined,
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'This profile is stored only in local demo memory. It is not '
                'registered with Modi International.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Save demo profile',
                icon: Icons.save_outlined,
                expanded: true,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
