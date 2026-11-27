import 'package:flutter/material.dart';

import '../../../core/widgets/app_app_bar.dart';
import 'services_view.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppAppBar(title: 'Servicing & refilling'),
      body: ServicesView(),
    );
  }
}
