import 'request_enums.dart';

/// Local demo profile. Supports both individual (B2C) and business (B2B) data.
class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.type,
    required this.name,
    required this.phone,
    required this.email,
    this.companyName,
    this.contactPerson,
    this.businessAddress,
    this.gstin,
    required this.createdAt,
  });

  final String id;
  final CustomerType type;
  final String name;
  final String phone;
  final String email;
  final String? companyName;
  final String? contactPerson;
  final String? businessAddress;
  final String? gstin;
  final DateTime createdAt;

  bool get isBusiness => type.isBusiness;

  String get displayName => isBusiness ? companyName ?? name : name;

  String get secondaryName => isBusiness ? contactPerson ?? name : email;
}
