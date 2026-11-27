import 'request_enums.dart';

class DemoOrderLine {
  const DemoOrderLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  double get lineTotal => unitPrice * quantity;
}

class DemoOrder {
  const DemoOrder({
    required this.id,
    required this.placedAt,
    required this.lines,
    required this.total,
    this.status = OrderStatus.placed,
  });

  final String id;
  final DateTime placedAt;
  final List<DemoOrderLine> lines;
  final double total;
  final OrderStatus status;

  int get itemCount => lines.fold<int>(0, (sum, line) => sum + line.quantity);
}
