import 'request_enums.dart';

class ServiceRequest {
  const ServiceRequest({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.equipmentId,
    required this.equipmentLabel,
    required this.preferredDate,
    required this.notes,
    this.status = RequestStatus.submitted,
  });

  final String id;
  final DateTime createdAt;
  final ServiceType type;
  final String? equipmentId;
  final String equipmentLabel;
  final DateTime preferredDate;
  final String notes;
  final RequestStatus status;
}
