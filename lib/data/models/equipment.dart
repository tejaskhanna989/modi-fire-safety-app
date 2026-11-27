class Equipment {
  const Equipment({
    required this.id,
    required this.name,
    required this.assetTag,
    required this.location,
    required this.registeredAt,
    required this.token,
    this.notes = '',
  });

  final String id;
  final String name;
  final String assetTag;
  final String location;
  final DateTime registeredAt;

  /// Deterministic local token. Not a real QR payload.
  final String token;
  final String notes;
}
