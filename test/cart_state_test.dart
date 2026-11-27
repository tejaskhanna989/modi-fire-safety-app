import 'package:flutter_test/flutter_test.dart';
import 'package:modi_fire_safety/core/state/cart_state.dart';
import 'package:modi_fire_safety/data/mock/mock_catalogue.dart';

void main() {
  test('demo cart tracks quantities and subtotal', () {
    final cart = CartState();
    final product = MockCatalogue.products.first;

    cart.add(product);
    expect(cart.itemCount, 1);
    expect(cart.subtotal, product.price);

    cart.increment(product.id);
    expect(cart.itemCount, 2);
    expect(cart.subtotal, product.price * 2);

    cart.decrement(product.id);
    expect(cart.itemCount, 1);

    cart.remove(product.id);
    expect(cart.isEmpty, isTrue);
  });
}
