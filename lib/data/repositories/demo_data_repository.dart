import '../models/customer_profile.dart';
import '../models/demo_order.dart';
import '../models/equipment.dart';
import '../models/quotation_request.dart';
import '../models/service_request.dart';

/// Boundary for all locally simulated customer data.
/// A future API-backed implementation can replace the in-memory state without
/// changing the feature screens.
abstract class DemoDataRepository {
  CustomerProfile? get profile;
  void saveProfile(CustomerProfile profile);
  void clearProfile();

  List<QuotationRequest> get quotations;
  void addQuotation(QuotationRequest request);

  List<ServiceRequest> get serviceRequests;
  void addServiceRequest(ServiceRequest request);

  List<Equipment> get equipment;
  void addEquipment(Equipment equipment);

  List<DemoOrder> get orders;
  void addOrder(DemoOrder order);
}
