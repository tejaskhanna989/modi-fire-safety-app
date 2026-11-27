import 'package:flutter/foundation.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';

/// Lightweight in-memory cart. Simulation only — nothing is persisted or
/// transmitted, and no checkout is performed.
class CartState extends ChangeNotifier {
  final Map<String, CartItem> _items = <String, CartItem>{};

  List<CartItem> get items => List<CartItem>.unmodifiable(_items.values);

  int get itemCount => _items.values.fold<int>(
        0,
        (total, item) => total + item.quantity,
      );

  int get distinctCount => _items.length;

  double get subtotal => _items.values.fold<double>(
        0,
        (total, item) => total + item.lineTotal,
      );

  bool get isEmpty => _items.isEmpty;

  void add(Product product, {int quantity = 1}) {
    if (quantity <= 0) return;
    final existing = _items[product.id];
    _items[product.id] = existing == null
        ? CartItem(product: product, quantity: quantity)
        : existing.copyWith(quantity: existing.quantity + quantity);
    notifyListeners();
  }

  void setQuantity(String productId, int quantity) {
    final existing = _items[productId];
    if (existing == null) return;

    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items[productId] = existing.copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  void increment(String productId) {
    final existing = _items[productId];
    if (existing == null) return;
    setQuantity(productId, existing.quantity + 1);
  }

  void decrement(String productId) {
    final existing = _items[productId];
    if (existing == null) return;
    setQuantity(productId, existing.quantity - 1);
  }

  void remove(String productId) {
    if (_items.remove(productId) != null) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
