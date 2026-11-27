import 'package:flutter/material.dart';

import '../../../core/widgets/app_app_bar.dart';
import 'catalogue_view.dart';

/// Dedicated search screen. Category filter is hidden to keep the results
/// focused; the catalogue tab retains full filtering.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppAppBar(title: 'Search'),
      body: CatalogueView(
        showCategoryFilter: false,
        autofocusSearch: true,
      ),
    );
  }
}
