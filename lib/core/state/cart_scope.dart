import 'package:flutter/widgets.dart';

import 'cart_state.dart';

/// Makes the demo cart available to every descendant without a package.
class CartScope extends InheritedNotifier<CartState> {
  const CartScope({
    super.key,
    required CartState cart,
    required super.child,
  }) : super(notifier: cart);

  static CartState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope is missing above this widget.');
    assert(scope!.notifier != null, 'CartScope has no cart state.');
    return scope!.notifier!;
  }
}
