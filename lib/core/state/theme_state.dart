import 'package:flutter/material.dart';

/// In-memory appearance preference. Light is the default. The choice is not
/// saved, so the app opens in light mode each time it starts.
class ThemeState extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void setDark(bool value) {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (next == _mode) return;
    _mode = next;
    notifyListeners();
  }
}
