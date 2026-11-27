import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/demo_banner.dart';
import '../../../data/models/product.dart';
import '../../../data/models/product_category.dart';
import '../../../data/repositories/catalogue_repository.dart';
import 'product_card.dart';

/// Body of the catalogue. Used both as a tab and inside a routed page.
class CatalogueView extends StatefulWidget {
  const CatalogueView({
    super.key,
    this.initialQuery = '',
    this.showCategoryFilter = true,
    this.showDemoBanner = true,
    this.autofocusSearch = false,
  });

  final String initialQuery;
  final bool showCategoryFilter;
  final bool showDemoBanner;
  final bool autofocusSearch;

  @override
  State<CatalogueView> createState() => _CatalogueViewState();
}

class _CatalogueViewState extends State<CatalogueView> {
  static const CatalogueRepository _repository = MockCatalogueRepository();

  late final TextEditingController _controller;
  late Future<List<Product>> _productsFuture;
  late Future<List<ProductCategoryData>> _categoriesFuture;
  String? _selectedCategory;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _controller = TextEditingController(text: _query);
    _categoriesFuture = _repository
        .fetchCategories()
        .then((list) => list.map(ProductCategoryData.new).toList());
    _productsFuture = _repository.fetchProducts(query: _query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _repository.fetchProducts(
        categoryId: _selectedCategory,
        query: _query,
      );
    });
  }

  void _clearFilters() {
    _controller.clear();
    setState(() {
      _query = '';
      _selectedCategory = null;
      _productsFuture = _repository.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (widget.showDemoBanner) const DemoBanner(),
              if (widget.showDemoBanner) const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _controller,
                label: 'Search demo products',
                hint: 'Search by name or demo tag',
                prefixIcon: Icons.search_rounded,
                autofocus: widget.autofocusSearch,
                onChanged: (value) {
                  _query = value;
                  _refreshProducts();
                },
              ),
            ],
          ),
        ),
        if (widget.showCategoryFilter) _CategoryFilter(
          future: _categoriesFuture,
          selectedId: _selectedCategory,
          onSelected: (id) {
            setState(() => _selectedCategory = id);
            _refreshProducts();
          },
        ),
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return AppEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Unable to load demo catalogue',
                  message: 'This is a local demo repository. No network call was made.',
                );
              }

              final products = snapshot.data ?? <Product>[];
              if (products.isEmpty) {
                return AppEmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No demo products found',
                  message: 'Try a different search term or category.',
                  actionLabel: 'Clear filters',
                  onAction: _clearFilters,
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 1000
                      ? 4
                      : constraints.maxWidth >= 700
                          ? 3
                          : 2;

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.sm,
                      AppSpacing.xl,
                      AppSpacing.xxl,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.productDetail,
                          arguments: product,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Local presentation wrapper so the view does not depend on a data model
/// that carries no Flutter types.
class ProductCategoryData {
  const ProductCategoryData(this.category);

  final ProductCategory category;

  String get id => category.id;
  String get name => category.name;
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.future,
    required this.selectedId,
    required this.onSelected,
  });

  final Future<List<ProductCategoryData>> future;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductCategoryData>>(
      future: future,
      builder: (context, snapshot) {
        final categories = snapshot.data ?? <ProductCategoryData>[];

        return SizedBox(
          height: 54,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              if (index == 0) {
                return FilterChip(
                  label: const Text('All'),
                  selected: selectedId == null,
                  onSelected: (_) => onSelected(null),
                );
              }
              final category = categories[index - 1];
              return FilterChip(
                label: Text(category.name),
                selected: selectedId == category.id,
                onSelected: (selected) =>
                    onSelected(selected ? category.id : null),
              );
            },
          ),
        );
      },
    );
  }
}
