import 'package:flutter/material.dart';

import '../../../core/widgets/app_app_bar.dart';
import 'orders_view.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppAppBar(title: 'Orders & history'),
      body: OrdersView(),
    );
  }
}
