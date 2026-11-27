/// Enum labels are kept here so status text is never inferred from colour
/// alone. All values describe demo workflow state only.
enum CustomerType { b2c, b2b }

enum RequestStatus { draft, submitted, inProgress, completed }

enum ServiceType { servicing, refilling, inspection }

enum OrderStatus { placed, processing, completed }

extension CustomerTypeLabel on CustomerType {
  String get label => this == CustomerType.b2c
      ? 'Individual (B2C)'
      : 'Business (B2B)';

  bool get isBusiness => this == CustomerType.b2b;
}

extension RequestStatusLabel on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.draft:
        return 'DRAFT';
      case RequestStatus.submitted:
        return 'SUBMITTED';
      case RequestStatus.inProgress:
        return 'IN PROGRESS';
      case RequestStatus.completed:
        return 'COMPLETED';
    }
  }
}

extension ServiceTypeLabel on ServiceType {
  String get label {
    switch (this) {
      case ServiceType.servicing:
        return 'Servicing';
      case ServiceType.refilling:
        return 'Refilling';
      case ServiceType.inspection:
        return 'Inspection';
    }
  }

  String get description {
    switch (this) {
      case ServiceType.servicing:
        return 'Request a routine service visit for registered equipment.';
      case ServiceType.refilling:
        return 'Request a refill for registered equipment.';
      case ServiceType.inspection:
        return 'Request an inspection of registered equipment.';
    }
  }
}

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'PLACED (DEMO)';
      case OrderStatus.processing:
        return 'PROCESSING (DEMO)';
      case OrderStatus.completed:
        return 'COMPLETED (DEMO)';
    }
  }
}
