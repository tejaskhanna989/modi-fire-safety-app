import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/format_date.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../data/models/equipment.dart';
import '../../../data/models/request_enums.dart';

class ServiceRequestArguments {
  const ServiceRequestArguments({
    this.initialType = ServiceType.servicing,
    this.equipmentId,
    this.equipmentLabel,
  });

  final ServiceType initialType;
  final String? equipmentId;
  final String? equipmentLabel;
}

class ServiceRequestPage extends StatefulWidget {
  const ServiceRequestPage({
    super.key,
    this.arguments = const ServiceRequestArguments(),
  });

  final ServiceRequestArguments arguments;

  @override
  State<ServiceRequestPage> createState() => _ServiceRequestPageState();
}

class _ServiceRequestPageState extends State<ServiceRequestPage> {
  /// Non-null sentinel keeps every DropdownMenuItem value non-null, avoiding
  /// Flutter's mixed-nullness assertion. Converted to `null` only on submit.
  static const String otherEquipmentId = 'other';

  late ServiceType _type;
  String _selectedEquipmentId = otherEquipmentId;
  DateTime _preferredDate = DateTime.now();
  final _equipmentLabel = TextEditingController();
  final _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _type = widget.arguments.initialType;
    _selectedEquipmentId = widget.arguments.equipmentId ?? otherEquipmentId;
    _equipmentLabel.text = widget.arguments.equipmentLabel ?? '';
  }

  /// Guarantees the dropdown value is one of its available items.
  String _effectiveEquipmentId(List<Equipment> equipment) {
    final id = _selectedEquipmentId;
    if (id == otherEquipmentId) return otherEquipmentId;
    for (final item in equipment) {
      if (item.id == id) return id;
    }
    return otherEquipmentId;
  }

  @override
  void dispose() {
    _equipmentLabel.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _preferredDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _preferredDate = picked);
  }

  void _submit() {
    final equipment = context.demoData.equipment;
    final selectedId = _effectiveEquipmentId(equipment);
    final equipmentIdForRequest =
        selectedId == otherEquipmentId ? null : selectedId;
    String label;

    if (equipmentIdForRequest != null) {
      final match = equipment.where(
        (item) => item.id == equipmentIdForRequest,
      );
      label = match.isEmpty ? _equipmentLabel.text.trim() : match.first.name;
    } else {
      label = _equipmentLabel.text.trim();
    }

    if (label.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select or describe the equipment')),
      );
      return;
    }

    final request = context.demoData.submitServiceRequest(
      type: _type,
      equipmentId: equipmentIdForRequest,
      equipmentLabel: label,
      preferredDate: _preferredDate,
      notes: _notes.text.trim(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Demo request saved'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Reference: ${request.id}', style: AppTypography.titleMedium),
            const SizedBox(height: 4),
            Text(
              '${request.type.label} · ${formatDate(request.preferredDate)}',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            const LocalOnlyNotice(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final equipment = context.demoData.equipment;

    return Scaffold(
      appBar: const AppAppBar(title: 'Request a service'),
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
              title: 'Service details',
              subtitle: 'Choose a request type and registered equipment.',
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: ServiceType.values.map(
                (type) => ChoiceChip(
                  label: Text(type.label),
                  selected: _type == type,
                  onSelected: (_) => setState(() => _type = type),
                ),
              ).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(_type.description, style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.xl),
            DropdownButtonFormField<String>(
              value: _effectiveEquipmentId(equipment),
              decoration: const InputDecoration(
                labelText: 'Registered equipment',
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              items: <DropdownMenuItem<String>>[
                const DropdownMenuItem<String>(
                  value: otherEquipmentId,
                  child: Text('Not registered / other'),
                ),
                ...equipment.map(
                  (item) => DropdownMenuItem<String>(
                    value: item.id,
                    child: Text('${item.name} · ${item.assetTag}'),
                  ),
                ),
              ],
              onChanged: (value) => setState(
                () => _selectedEquipmentId = value ?? otherEquipmentId,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _equipmentLabel,
              label: 'Equipment description',
              hint: 'Required when equipment is not registered',
              prefixIcon: Icons.description_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event_outlined),
              label: Text('Preferred date: ${formatDate(_preferredDate)}'),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _notes,
              label: 'Notes (optional)',
              hint: 'Additional context for the demo request',
              prefixIcon: Icons.notes_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.xl),
            const LocalOnlyNotice(),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Submit demo service request',
              icon: Icons.send_outlined,
              expanded: true,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
