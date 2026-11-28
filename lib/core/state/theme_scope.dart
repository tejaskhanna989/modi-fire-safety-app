import 'package:flutter/widgets.dart';

import 'theme_state.dart';

/// Makes the appearance preference available to every descendant.
class ThemeScope extends InheritedNotifier<ThemeState> {
  const ThemeScope({
    super.key,
    required ThemeState theme,
    required super.child,
  }) : super(notifier: theme);

  static ThemeState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope is missing above this widget.');
    assert(scope!.notifier != null, 'ThemeScope has no theme state.');
    return scope!.notifier!;
  }
}
