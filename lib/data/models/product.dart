import '../../core/utils/price_formatter.dart';

/// A catalogue entry.
///
/// Deliberately contains no certification, approval, review or specification
/// fields. Those may only be added when verified data is supplied by an API.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.summary,
    required this.price,
    required this.currency,
    required this.priceDisclosure,
    this.imageUrl,
    this.tags = const <String>[],
    this.details = const <String, String>{},
  });

  final String id;
  final String name;
  final String categoryId;
  final String summary;

  /// Illustrative numeric value. Never presented as a real company price.
  final double price;
  final String currency;
  final String priceDisclosure;

  /// Reserved for verified imagery supplied by a future API.
  final String? imageUrl;

  /// Neutral labels only (for example: "Demo item").
  final List<String> tags;

  /// Reserved for verified specification data from a future API.
  final Map<String, String> details;

  String get priceLabel => '$currency${formatAmount(price)}';
}
