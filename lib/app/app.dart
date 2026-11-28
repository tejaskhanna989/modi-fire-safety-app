import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import '../core/router/app_router.dart';
import '../core/state/cart_scope.dart';
import '../core/state/cart_state.dart';
import '../core/state/demo_data_scope.dart';
import '../core/state/demo_data_state.dart';
import '../core/state/theme_scope.dart';
import '../core/state/theme_state.dart';
import '../core/theme/app_theme.dart';
import 'shell/app_shell.dart';

class ModiFireApp extends StatefulWidget {
  const ModiFireApp({super.key});

  @override
  State<ModiFireApp> createState() => _ModiFireAppState();
}

class _ModiFireAppState extends State<ModiFireApp> {
  /// In-memory demo cart. Nothing is persisted or transmitted.
  final CartState _cart = CartState();

  /// In-memory demo customer, request, equipment and order data.
  final DemoDataState _demoData = DemoDataState();

  /// Light by default. Switched from Profile > Appearance.
  final ThemeState _theme = ThemeState();

  @override
  Widget build(BuildContext context) {
    return DemoDataScope(
      data: _demoData,
      child: CartScope(
        cart: _cart,
        child: ThemeScope(
          theme: _theme,
          child: ListenableBuilder(
            listenable: _theme,
            builder: (context, _) => MaterialApp(
              title: AppConfig.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: _theme.mode,
              home: const AppShell(),
              onGenerateRoute: AppRouter.generateRoute,
            ),
          ),
        ),
      ),
    );
  }
}
