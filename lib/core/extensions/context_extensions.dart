import 'package:flutter/material.dart';

import '../state/cart_scope.dart';
import '../state/cart_state.dart';
import '../state/demo_data_scope.dart';
import '../state/demo_data_state.dart';
import '../state/theme_scope.dart';
import '../state/theme_state.dart';

extension AppContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get scheme => theme.colorScheme;
  TextTheme get typography => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isCompact => screenWidth < 600;
  bool get isWide => screenWidth >= 900;

  Future<T?> push<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
          MaterialPageRoute<T>(builder: (_) => page),
        );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}

extension CartContextX on BuildContext {
  CartState get cart => CartScope.of(this);
}

extension AppearanceContextX on BuildContext {
  ThemeState get appearance => ThemeScope.of(this);
}

extension DemoDataContextX on BuildContext {
  DemoDataState get demoData => DemoDataScope.of(this);
}
