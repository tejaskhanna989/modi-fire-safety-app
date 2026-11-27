import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';

class EquipmentRegistrationPage extends StatefulWidget {
  const EquipmentRegistrationPage({super.key});

  @override
  State<EquipmentRegistrationPage> createState() =>
      _EquipmentRegistrationPageState();
}

class _EquipmentRegistrationPageState
    extends State<EquipmentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _assetTag = TextEditingController();
  final _location = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _assetTag.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final equipment = context.demoData.registerEquipment(
      name: _name.text.trim(),
      assetTag: _assetTag.text.trim(),
      location: _location.text.trim(),
      notes: _notes.text.trim(),
    );

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.equipmentDetail,
      arguments: equipment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Register equipment'),
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
              const AppSectionHeader(
                title: 'Add a demo asset',
                subtitle: 'A simulated token will be generated locally.',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _name,
                label: 'Equipment name',
                hint: 'e.g. Dry Powder Extinguisher — Demo',
                prefixIcon: Icons.fire_extinguisher_outlined,
                validator: (value) => _required(value, 'Equipment name'),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _assetTag,
                label: 'Asset tag',
                hint: 'e.g. AST-DEMO-003',
                prefixIcon: Icons.tag_outlined,
                validator: (value) => _required(value, 'Asset tag'),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _location,
                label: 'Location',
                hint: 'Site or floor',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) => _required(value, 'Location'),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _notes,
                label: 'Notes (optional)',
                hint: 'Illustrative details',
                prefixIcon: Icons.notes_rounded,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),
              const LocalOnlyNotice(),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Register demo equipment',
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
