import 'package:flutter/widgets.dart';

import 'demo_data_state.dart';

class DemoDataScope extends InheritedNotifier<DemoDataState> {
  const DemoDataScope({
    super.key,
    required DemoDataState data,
    required super.child,
  }) : super(notifier: data);

  static DemoDataState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DemoDataScope>();
    assert(scope != null, 'DemoDataScope is missing above this widget.');
    assert(scope!.notifier != null, 'DemoDataScope has no state.');
    return scope.notifier!;
  }
}
