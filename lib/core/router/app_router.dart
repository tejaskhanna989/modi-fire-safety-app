import 'package:flutter/material.dart';

import '../../core/widgets/coming_soon_page.dart';
import '../../data/models/demo_order.dart';
import '../../data/models/equipment.dart';
import '../../data/models/product.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/catalogue/presentation/catalogue_page.dart';
import '../../features/catalogue/presentation/product_detail_page.dart';
import '../../features/catalogue/presentation/search_page.dart';
import '../../features/checkout/presentation/demo_checkout_page.dart';
import '../../features/equipment/presentation/equipment_detail_page.dart';
import '../../features/equipment/presentation/equipment_page.dart';
import '../../features/equipment/presentation/equipment_registration_page.dart';
import '../../features/orders/presentation/order_detail_page.dart';
import '../../features/orders/presentation/orders_page.dart';
import '../../features/profile/presentation/b2b_registration_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/quotation/presentation/quotation_history_page.dart';
import '../../features/quotation/presentation/quotation_page.dart';
import '../../features/services/presentation/service_request_page.dart';
import '../../features/services/presentation/services_page.dart';
import 'app_routes.dart';

/// Central route table. Only the assistant and notifications remain planned
/// modules after Phase 3.
class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.catalogue:
        return _page(settings, const CataloguePage());
      case AppRoutes.search:
        return _page(settings, const SearchPage());
      case AppRoutes.cart:
        return _page(settings, const CartPage());
      case AppRoutes.productDetail:
        final argument = settings.arguments;
        return _page(
          settings,
          argument is Product
              ? ProductDetailPage(product: argument)
              : const ComingSoonPage(
                  title: 'Product details',
                  message: 'Open a product from the demo catalogue first.',
                ),
        );
      case AppRoutes.checkout:
        return _page(settings, const DemoCheckoutPage());
      case AppRoutes.orders:
        return _page(settings, const OrdersPage());
      case AppRoutes.orderDetail:
        final argument = settings.arguments;
        return _page(
          settings,
          argument is DemoOrder
              ? OrderDetailPage(order: argument)
              : const ComingSoonPage(
                  title: 'Order detail',
                  message: 'Open a demo order from Orders & history first.',
                ),
        );
      case AppRoutes.services:
        return _page(settings, const ServicesPage());
      case AppRoutes.serviceRequest:
        final argument = settings.arguments;
        return _page(
          settings,
          argument is ServiceRequestArguments
              ? ServiceRequestPage(arguments: argument)
              : const ServiceRequestPage(),
        );
      case AppRoutes.equipment:
        return _page(settings, const EquipmentPage());
      case AppRoutes.equipmentRegister:
        return _page(settings, const EquipmentRegistrationPage());
      case AppRoutes.equipmentDetail:
        final argument = settings.arguments;
        return _page(
          settings,
          argument is Equipment
              ? EquipmentDetailPage(equipment: argument)
              : const ComingSoonPage(
                  title: 'Equipment detail',
                  message: 'Open a registered demo asset first.',
                ),
        );
      case AppRoutes.quotation:
        return _page(settings, const QuotationPage());
      case AppRoutes.quotationHistory:
        return _page(settings, const QuotationHistoryPage());
      case AppRoutes.b2bRegistration:
        return _page(settings, const B2BRegistrationPage());
      case AppRoutes.profile:
        return _page(settings, const ProfilePage());
      default:
        return _page(
          settings,
          ComingSoonPage(
            title: _moduleTitle(settings.name),
            message: _moduleMessage(settings.name),
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> _page(RouteSettings settings, Widget child) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => child,
    );
  }

  static String _moduleTitle(String? name) {
    switch (name) {
      case AppRoutes.assistant:
        return 'Fire safety assistant';
      case AppRoutes.notifications:
        return 'Notifications';
      default:
        return 'Page not found';
    }
  }

  static String _moduleMessage(String? name) {
    switch (name) {
      case AppRoutes.assistant:
        return 'The assistant is planned for a later phase with a local rule engine.';
      case AppRoutes.notifications:
        return 'Notifications are planned for a later phase.';
      case null:
        return 'The requested route is unknown.';
      default:
        return 'This module is planned for the next reviewable development phase.';
    }
  }
}
