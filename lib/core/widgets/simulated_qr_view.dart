import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/simulated_qr.dart';

/// Decorative QR-like visual. Always explicitly labelled as non-scannable.
class SimulatedQrView extends StatelessWidget {
  const SimulatedQrView({
    super.key,
    required this.token,
    this.size = 168,
  });

  final String token;
  final double size;

  @override
  Widget build(BuildContext context) {
    final matrix = SimulatedQr.buildMatrix(token);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.line),
          ),
          child: CustomPaint(
            painter: _MatrixPainter(matrix),
            size: Size.square(size),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          SimulatedQr.disclosure,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(color: AppColors.amber),
        ),
        const SizedBox(height: AppSpacing.sm),
        SelectableText(
          token,
          textAlign: TextAlign.center,
          style: AppTypography.labelMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: token));
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              const SnackBar(content: Text('Demo token copied')),
            );
          },
          icon: const Icon(Icons.copy_all_outlined, size: 16),
          label: const Text('Copy token'),
        ),
      ],
    );
  }
}

class _MatrixPainter extends CustomPainter {
  const _MatrixPainter(this.matrix);

  final List<List<bool>> matrix;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / matrix.length;
    final paint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    for (var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (matrix[y][x]) {
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixPainter oldDelegate) =>
      oldDelegate.matrix != matrix;
}
