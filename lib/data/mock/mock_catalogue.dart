import '../models/product.dart';
import '../models/product_category.dart';

/// 100% illustrative catalogue data for the demo.
///
/// - No certifications, approvals or safety ratings are asserted.
/// - No customer reviews or business claims are included.
/// - Prices are NOT real Modi International prices and are always displayed
///   alongside [priceDisclosure].
class MockCatalogue {
  const MockCatalogue._();

  static const String priceDisclosure =
      'Illustrative demo price — not an actual Modi International quote.';

  static const String summary =
      'Illustrative catalogue entry used to demonstrate browsing, filtering '
      'and the demo cart. Verified product information will be supplied by '
      'the API.';

  static const List<ProductCategory> categories = <ProductCategory>[
    ProductCategory(
      id: 'extinguishers',
      name: 'Extinguishers',
      description: 'Demo entries for portable extinguishers.',
    ),
    ProductCategory(
      id: 'alarms',
      name: 'Alarms & detectors',
      description: 'Demo entries for detection and alarm devices.',
    ),
    ProductCategory(
      id: 'hoses',
      name: 'Hoses & reels',
      description: 'Demo entries for hose and reel systems.',
    ),
    ProductCategory(
      id: 'blankets',
      name: 'Fire blankets',
      description: 'Demo entries for blanket products.',
    ),
    ProductCategory(
      id: 'ppe',
      name: 'Protective equipment',
      description: 'Demo entries for personal protective equipment.',
    ),
    ProductCategory(
      id: 'first-aid',
      name: 'First aid',
      description: 'Demo entries for first-aid supplies.',
    ),
    ProductCategory(
      id: 'signage',
      name: 'Safety signage',
      description: 'Demo entries for safety signage.',
    ),
    ProductCategory(
      id: 'kitchen',
      name: 'Kitchen systems',
      description: 'Demo entries for kitchen fire systems.',
    ),
  ];

  static const List<Product> products = <Product>[
    Product(
      id: 'demo-ext-001',
      name: 'Dry Powder Extinguisher — Demo',
      categoryId: 'extinguishers',
      summary: summary,
      price: 2499,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-ext-002',
      name: 'CO₂ Extinguisher — Demo',
      categoryId: 'extinguishers',
      summary: summary,
      price: 5850,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-ext-003',
      name: 'Foam Extinguisher — Demo',
      categoryId: 'extinguishers',
      summary: summary,
      price: 4250,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-ext-004',
      name: 'Water Mist Extinguisher — Demo',
      categoryId: 'extinguishers',
      summary: summary,
      price: 6900,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-alm-001',
      name: 'Smoke Detector — Demo',
      categoryId: 'alarms',
      summary: summary,
      price: 1199,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-alm-002',
      name: 'Heat Detector — Demo',
      categoryId: 'alarms',
      summary: summary,
      price: 1450,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-alm-003',
      name: 'Manual Call Point — Demo',
      categoryId: 'alarms',
      summary: summary,
      price: 890,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-alm-004',
      name: 'Fire Alarm Panel — Demo',
      categoryId: 'alarms',
      summary: summary,
      price: 18900,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-hos-001',
      name: 'Fire Hose Reel — Demo',
      categoryId: 'hoses',
      summary: summary,
      price: 8900,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-hos-002',
      name: 'Canvas Hose — Demo',
      categoryId: 'hoses',
      summary: summary,
      price: 3600,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-bln-001',
      name: 'Fire Blanket — Demo',
      categoryId: 'blankets',
      summary: summary,
      price: 990,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-ppe-001',
      name: 'Safety Helmet — Demo',
      categoryId: 'ppe',
      summary: summary,
      price: 650,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-ppe-002',
      name: 'Safety Gloves — Demo',
      categoryId: 'ppe',
      summary: summary,
      price: 420,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-aid-001',
      name: 'First Aid Kit — Demo',
      categoryId: 'first-aid',
      summary: summary,
      price: 1350,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-sgn-001',
      name: 'Exit Signage — Demo',
      categoryId: 'signage',
      summary: summary,
      price: 780,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
    Product(
      id: 'demo-kit-001',
      name: 'Kitchen Suppression System — Demo',
      categoryId: 'kitchen',
      summary: summary,
      price: 24500,
      currency: '₹',
      priceDisclosure: priceDisclosure,
      tags: <String>['Demo item'],
    ),
  ];
}
