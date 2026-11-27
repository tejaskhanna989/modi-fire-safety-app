import 'package:flutter/material.dart';

import '../../../core/widgets/app_app_bar.dart';
import 'catalogue_view.dart';

/// Routed catalogue screen (also reachable from the dashboard hero).
class CataloguePage extends StatelessWidget {
  const CataloguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppAppBar(title: 'Product catalogue'),
      body: CatalogueView(),
    );
  }
}
