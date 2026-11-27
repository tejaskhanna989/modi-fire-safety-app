import '../../core/utils/simulated_qr.dart';
import '../models/demo_order.dart';
import '../models/equipment.dart';
import '../models/request_enums.dart';
import 'mock_catalogue.dart';

/// Illustrative seed data for Phase 3. Nothing here is verified business data.
class MockDemoData {
  const MockDemoData._();

  static const String localOnlyNotice =
      'Stored only in local demo memory. Not transmitted to Modi International.';

  static List<Equipment> get initialEquipment => <Equipment>[
        Equipment(
          id: 'eq-demo-seed-1',
          name: 'Dry Powder Extinguisher — Demo',
          assetTag: 'AST-DEMO-001',
          location: 'Warehouse 2',
          registeredAt: DateTime(2026, 10, 14),
          token: SimulatedQr.generateToken('AST-DEMO-001'),
          notes: 'Illustrative asset entry.',
        ),
        Equipment(
          id: 'eq-demo-seed-2',
          name: 'CO₂ Extinguisher — Demo',
          assetTag: 'AST-DEMO-002',
          location: 'Reception',
          registeredAt: DateTime(2026, 11, 2),
          token: SimulatedQr.generateToken('AST-DEMO-002'),
          notes: 'Illustrative asset entry.',
        ),
      ];

  static List<DemoOrder> get initialOrders => <DemoOrder>[
        DemoOrder(
          id: 'O-DEMO-0001',
          placedAt: DateTime(2026, 11, 3),
          lines: <DemoOrderLine>[
            DemoOrderLine(
              productId: MockCatalogue.products.first.id,
              productName: MockCatalogue.products.first.name,
              quantity: 1,
              unitPrice: MockCatalogue.products.first.price,
            ),
          ],
          total: MockCatalogue.products.first.price,
          status: OrderStatus.completed,
        ),
        DemoOrder(
          id: 'O-DEMO-0002',
          placedAt: DateTime(2026, 11, 18),
          lines: <DemoOrderLine>[
            DemoOrderLine(
              productId: MockCatalogue.products[4].id,
              productName: MockCatalogue.products[4].name,
              quantity: 2,
              unitPrice: MockCatalogue.products[4].price,
            ),
          ],
          total: MockCatalogue.products[4].price * 2,
          status: OrderStatus.processing,
        ),
      ];
}
