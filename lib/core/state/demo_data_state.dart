import 'package:flutter/foundation.dart';

import '../../core/utils/simulated_qr.dart';
import '../../data/models/customer_profile.dart';
import '../../data/models/demo_order.dart';
import '../../data/models/equipment.dart';
import '../../data/models/quotation_request.dart';
import '../../data/models/request_enums.dart';
import '../../data/models/service_request.dart';
import '../../data/mock/mock_demo_data.dart';
import '../../data/repositories/demo_data_repository.dart';

/// In-memory demo implementation of [DemoDataRepository].
/// Nothing is persisted to disk or transmitted anywhere.
class DemoDataState extends ChangeNotifier implements DemoDataRepository {
  DemoDataState() {
    _equipment.addAll(MockDemoData.initialEquipment);
    _orders.addAll(MockDemoData.initialOrders);
  }

  final List<QuotationRequest> _quotations = <QuotationRequest>[];
  final List<ServiceRequest> _serviceRequests = <ServiceRequest>[];
  final List<Equipment> _equipment = <Equipment>[];
  final List<DemoOrder> _orders = <DemoOrder>[];

  CustomerProfile? _profile;
  int _quotationCounter = 0;
  int _serviceCounter = 0;
  int _orderCounter = 2;
  int _equipmentCounter = 2;

  @override
  CustomerProfile? get profile => _profile;

  @override
  void saveProfile(CustomerProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  @override
  void clearProfile() {
    if (_profile == null) return;
    _profile = null;
    notifyListeners();
  }

  @override
  List<QuotationRequest> get quotations =>
      List<QuotationRequest>.unmodifiable(_quotations);

  /// Newest-first view used by the local quotation history screen.
  List<QuotationRequest> get quotationsNewestFirst =>
      List<QuotationRequest>.unmodifiable(_quotations.reversed.toList());

  @override
  void addQuotation(QuotationRequest request) {
    _quotations.add(request);
    notifyListeners();
  }

  @override
  List<ServiceRequest> get serviceRequests =>
      List<ServiceRequest>.unmodifiable(_serviceRequests);

  @override
  void addServiceRequest(ServiceRequest request) {
    _serviceRequests.add(request);
    notifyListeners();
  }

  @override
  List<Equipment> get equipment => List<Equipment>.unmodifiable(_equipment);

  @override
  void addEquipment(Equipment equipment) {
    _equipment.add(equipment);
    notifyListeners();
  }

  @override
  List<DemoOrder> get orders => List<DemoOrder>.unmodifiable(_orders);

  @override
  void addOrder(DemoOrder order) {
    _orders.add(order);
    notifyListeners();
  }

  String nextQuotationId() =>
      'Q-DEMO-${(++_quotationCounter).toString().padLeft(4, '0')}';

  String nextServiceRequestId() =>
      'SR-DEMO-${(++_serviceCounter).toString().padLeft(4, '0')}';

  String nextOrderId() =>
      'O-DEMO-${(++_orderCounter).toString().padLeft(4, '0')}';

  String nextEquipmentId() => 'eq-demo-${++_equipmentCounter}';

  QuotationRequest submitQuotation({
    required String companyName,
    required String contactPerson,
    required String phone,
    required String email,
    required String notes,
    required List<QuotationLine> lines,
  }) {
    final request = QuotationRequest(
      id: nextQuotationId(),
      submittedAt: DateTime.now(),
      companyName: companyName,
      contactPerson: contactPerson,
      phone: phone,
      email: email,
      lines: lines,
      notes: notes,
    );
    addQuotation(request);
    return request;
  }

  ServiceRequest submitServiceRequest({
    required ServiceType type,
    required String? equipmentId,
    required String equipmentLabel,
    required DateTime preferredDate,
    required String notes,
  }) {
    final request = ServiceRequest(
      id: nextServiceRequestId(),
      createdAt: DateTime.now(),
      type: type,
      equipmentId: equipmentId,
      equipmentLabel: equipmentLabel,
      preferredDate: preferredDate,
      notes: notes,
    );
    addServiceRequest(request);
    return request;
  }

  Equipment registerEquipment({
    required String name,
    required String assetTag,
    required String location,
    required String notes,
  }) {
    final equipment = Equipment(
      id: nextEquipmentId(),
      name: name,
      assetTag: assetTag,
      location: location,
      registeredAt: DateTime.now(),
      token: SimulatedQr.generateToken('$assetTag|$name'),
      notes: notes,
    );
    addEquipment(equipment);
    return equipment;
  }

  DemoOrder placeDemoOrder({
    required List<DemoOrderLine> lines,
    required double total,
  }) {
    final order = DemoOrder(
      id: nextOrderId(),
      placedAt: DateTime.now(),
      lines: lines,
      total: total,
    );
    addOrder(order);
    return order;
  }
}
