/// Deterministic, in-house QR-like visual generator.
///
/// This produces a decorative matrix only. It is NOT a QR code and must always
/// be shown with the label "DEMO QR – NOT SCANNABLE". No package is used.
class SimulatedQr {
  const SimulatedQr._();

  static const int matrixSize = 21;
  static const String disclosure = 'DEMO QR – NOT SCANNABLE';

  /// FNV-1a style 32-bit hash kept local and deterministic.
  static int _hash(String input, int seed) {
    var hash = seed;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 16777619) & 0xFFFFFFFF;
    }
    return hash;
  }

  static String generateToken(String seed) {
    final hash = _hash(seed, 0x811C9DC5);
    final hex = hash.toRadixString(16).toUpperCase().padLeft(8, '0');
    return 'MODI-DEMO-EQ-$hex';
  }

  static List<List<bool>> buildMatrix(String token) {
    final size = matrixSize;
    final matrix = List<List<bool>>.generate(
      size,
      (_) => List<bool>.filled(size, false, growable: false),
      growable: false,
    );

    var state = _hash(token, 0x811C9DC5);
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        state = _hash('$state:$x:$y', state);
        matrix[y][x] = (state & 0x1) == 1;
      }
    }

    _drawFinder(matrix, 0, 0);
    _drawFinder(matrix, size - 7, 0);
    _drawFinder(matrix, 0, size - 7);
    return matrix;
  }

  static void _drawFinder(List<List<bool>> matrix, int left, int top) {
    for (var y = 0; y < 7; y++) {
      for (var x = 0; x < 7; x++) {
        final border = x == 0 || y == 0 || x == 6 || y == 6;
        final core = x >= 2 && x <= 4 && y >= 2 && y <= 4;
        matrix[top + y][left + x] = border || core;
      }
    }
  }
}
