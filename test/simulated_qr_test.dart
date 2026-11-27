import 'package:flutter_test/flutter_test.dart';
import 'package:modi_fire_safety/core/utils/simulated_qr.dart';

void main() {
  test('demo token is deterministic and clearly namespaced', () {
    final first = SimulatedQr.generateToken('AST-DEMO-001');
    final second = SimulatedQr.generateToken('AST-DEMO-001');

    expect(first, second);
    expect(first, startsWith('MODI-DEMO-EQ-'));
  });

  test('matrix is square and disclosure is explicit', () {
    final matrix = SimulatedQr.buildMatrix('MODI-DEMO-EQ-00000001');

    expect(matrix.length, SimulatedQr.matrixSize);
    expect(matrix.every((row) => row.length == SimulatedQr.matrixSize), isTrue);
    expect(SimulatedQr.disclosure, 'DEMO QR – NOT SCANNABLE');
  });
}
