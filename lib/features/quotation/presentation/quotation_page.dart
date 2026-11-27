import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../core/widgets/local_only_notice.dart';
import '../../../data/models/product.dart';
import '../../../data/models/quotation_request.dart';
import '../../../data/repositories/catalogue_repository.dart';

class QuotationPage extends StatefulWidget {
  const QuotationPage({super.key});

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  static const CatalogueRepository _repository = MockCatalogueRepository();

  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _notes = TextEditingController();
  final Map<String, int> _quantities = <String, int>{};

  late Future<List<Product>> _productsFuture;
  List<Product> _products = <Product>[];

  @override
  void initState() {
    super.initState();
    final profile = context.demoData.profile;
    if (profile != null) {
      _company.text = profile.companyName ?? profile.displayName;
      _contact.text = profile.contactPerson ?? profile.name;
      _phone.text = profile.phone;
      _email.text = profile.email;
    }
    _productsFuture = _repository.fetchProducts().then((products) {
      _products = products;
      return products;
    });
  }

  @override
  void dispose() {
    _company.dispose();
    _contact.dispose();
    _phone.dispose();
    _email.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  void _changeQuantity(String id, int delta) {
    final current = _quantities[id] ?? 1;
    final next = current + delta;
    setState(() {
      if (next <= 0) {
        _quantities.remove(id);
      } else {
        _quantities[id] = next;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_quantities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one demo product')),
      );
      return;
    }

    final lines = _products
        .where((product) => _quantities.containsKey(product.id))
        .map(
          (product) => QuotationLine(
            productId: product.id,
            productName: product.name,
            quantity: _quantities[product.id]!,
            unitPrice: product.price,
          ),
        )
        .toList();

    final request = context.demoData.submitQuotation(
      companyName: _company.text.trim(),
      contactPerson: _contact.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      notes: _notes.text.trim(),
      lines: lines,
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
              '${request.itemCount} demo items · illustrative total '
              '₹${formatAmount(request.estimatedTotal)}',
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
    return Scaffold(
      appBar: const AppAppBar(title: 'Request quotation'),
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
                title: 'Request a quotation',
                subtitle: 'Select demo products and quantities, then submit locally.',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _company,
                label: 'Company / customer name',
                hint: 'Business or individual name',
                prefixIcon: Icons.business_outlined,
                validator: (value) => _required(value, 'Name'),
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
              AppTextField(
                controller: _phone,
                label: 'Phone',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) => _required(value, 'Phone'),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _email,
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => _required(value, 'Email'),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _notes,
                label: 'Notes (optional)',
                hint: 'Project details or site information',
                prefixIcon: Icons.notes_rounded,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const AppSectionHeader(title: 'Select demo products'),
              const SizedBox(height: AppSpacing.md),
              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final products = snapshot.data ?? <Product>[];

                  return Column(
                    children: products.map((product) {
                      final selected = _quantities.containsKey(product.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          child: Column(
                            children: <Widget>[
                              CheckboxListTile(
                                value: selected,
                                onChanged: (value) => setState(() {
                                  if (value == true) {
                                    _quantities[product.id] = 1;
                                  } else {
                                    _quantities.remove(product.id);
                                  }
                                }),
                                title: Text(product.name, style: AppTypography.titleSmall),
                                subtitle: Text(
                                  '${product.currency}${formatAmount(product.price)} · '
                                  'illustrative price',
                                  style: AppTypography.bodySmall,
                                ),
                              ),
                              if (selected)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        tooltip: 'Decrease quantity',
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () =>
                                            _changeQuantity(product.id, -1),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          '${_quantities[product.id]}',
                                          textAlign: TextAlign.center,
                                          style: AppTypography.labelLarge,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Increase quantity',
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () =>
                                            _changeQuantity(product.id, 1),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              const LocalOnlyNotice(),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Submit demo quotation request',
                icon: Icons.send_outlined,
                expanded: true,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'View submitted demo requests',
                icon: Icons.history_toggle_off_outlined,
                variant: AppButtonVariant.secondary,
                expanded: true,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.quotationHistory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
