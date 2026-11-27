import 'package:flutter_test/flutter_test.dart';
import 'package:modi_fire_safety/core/state/demo_data_state.dart';
import 'package:modi_fire_safety/data/models/customer_profile.dart';
import 'package:modi_fire_safety/data/models/demo_order.dart';
import 'package:modi_fire_safety/data/models/quotation_request.dart';
import 'package:modi_fire_safety/data/models/request_enums.dart';

void main() {
  test('supports both B2C and B2B profiles', () {
    final state = DemoDataState();

    state.saveProfile(CustomerProfile(
      id: 'c1',
      type: CustomerType.b2c,
      name: 'Individual Customer',
      phone: '9999999999',
      email: 'individual@example.com',
      createdAt: DateTime(2026, 11, 27),
    ));
    expect(state.profile!.isBusiness, isFalse);

    state.saveProfile(CustomerProfile(
      id: 'c2',
      type: CustomerType.b2b,
      name: 'Contact Person',
      phone: '8888888888',
      email: 'business@example.com',
      companyName: 'Example Industries',
      contactPerson: 'Contact Person',
      businessAddress: 'Demo Address',
      gstin: 'DEMOGSTIN',
      createdAt: DateTime(2026, 11, 27),
    ));
    expect(state.profile!.isBusiness, isTrue);
    expect(state.profile!.displayName, 'Example Industries');
  });

  test('stores simulated quotation requests locally', () {
    final state = DemoDataState();
    final request = state.submitQuotation(
      companyName: 'Example Industries',
      contactPerson: 'Contact Person',
      phone: '8888888888',
      email: 'business@example.com',
      notes: 'Demo project',
      lines: const <QuotationLine>[
        QuotationLine(
          productId: 'p1',
          productName: 'Demo product',
          quantity: 2,
          unitPrice: 1000,
        ),
      ],
    );

    expect(request.id, 'Q-DEMO-0001');
    expect(state.quotations, hasLength(1));
    expect(state.quotations.first.estimatedTotal, 2000);
  });

  test('stores service requests and registered equipment', () {
    final state = DemoDataState();
    final equipment = state.registerEquipment(
      name: 'Demo extinguisher',
      assetTag: 'AST-DEMO-003',
      location: 'Site A',
      notes: '',
    );
    final request = state.submitServiceRequest(
      type: ServiceType.refilling,
      equipmentId: equipment.id,
      equipmentLabel: equipment.name,
      preferredDate: DateTime(2026, 12, 1),
      notes: '',
    );

    expect(equipment.token, startsWith('MODI-DEMO-EQ-'));
    expect(state.equipment.any((item) => item.id == equipment.id), isTrue);
    expect(state.serviceRequests, hasLength(1));
    expect(request.type, ServiceType.refilling);
  });

  test('creates in-memory demo orders', () {
    final state = DemoDataState();
    final order = state.placeDemoOrder(
      lines: const <DemoOrderLine>[
        DemoOrderLine(
          productId: 'p1',
          productName: 'Demo product',
          quantity: 1,
          unitPrice: 2499,
        ),
      ],
      total: 2499,
    );

    expect(order.id, 'O-DEMO-0003');
    expect(state.orders.any((item) => item.id == order.id), isTrue);
    expect(state.orders.first.total, 2499);
  });
}
