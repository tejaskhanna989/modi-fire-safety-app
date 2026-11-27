import '../mock/mock_catalogue.dart';
import '../models/product.dart';
import '../models/product_category.dart';

/// Boundary between UI and product data. A live implementation can replace
/// [MockCatalogueRepository] without any feature-page changes.
abstract class CatalogueRepository {
  const CatalogueRepository();

  Future<List<ProductCategory>> fetchCategories();

  Future<List<Product>> fetchProducts({String? categoryId, String query});

  Future<Product?> fetchProductById(String id);
}

class MockCatalogueRepository extends CatalogueRepository {
  const MockCatalogueRepository();

  @override
  Future<List<ProductCategory>> fetchCategories() async {
    return MockCatalogue.categories;
  }

  @override
  Future<List<Product>> fetchProducts({
    String? categoryId,
    String query = '',
  }) async {
    final normalizedQuery = query.trim().toLowerCase();

    return MockCatalogue.products.where((product) {
      final matchesCategory = categoryId == null ||
          categoryId == 'all' ||
          product.categoryId == categoryId;

      final matchesQuery = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.summary.toLowerCase().contains(normalizedQuery) ||
          product.tags.any(
            (tag) => tag.toLowerCase().contains(normalizedQuery),
          );

      return matchesCategory && matchesQuery;
    }).toList(growable: false);
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    for (final product in MockCatalogue.products) {
      if (product.id == id) return product;
    }
    return null;
  }
}
