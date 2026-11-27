import 'request_enums.dart';

class QuotationLine {
  const QuotationLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String productName;
  final int quantity;

  /// Illustrative demo price snapshot, never a real quote.
  final double unitPrice;

  double get lineTotal => unitPrice * quantity;
}

class QuotationRequest {
  const QuotationRequest({
    required this.id,
    required this.submittedAt,
    required this.companyName,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.lines,
    required this.notes,
    this.status = RequestStatus.submitted,
  });

  final String id;
  final DateTime submittedAt;
  final String companyName;
  final String contactPerson;
  final String phone;
  final String email;
  final List<QuotationLine> lines;
  final String notes;
  final RequestStatus status;

  int get itemCount => lines.fold<int>(0, (sum, line) => sum + line.quantity);

  double get estimatedTotal =>
      lines.fold<double>(0, (sum, line) => sum + line.lineTotal);
}
