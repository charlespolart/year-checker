import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DottedBackground extends StatelessWidget {
  final Widget child;

  const DottedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedPainter(),
      child: child,
    );
  }
}

class _DottedPainter extends CustomPainter {
  static const double _spacing = 24.0;
  static const double _radius = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Background fill
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.bg,
    );

    // Dots — centered so margins are equal on both sides
    final dotPaint = Paint()..color = AppColors.bgDot;

    final colCount = (size.width / _spacing).floor();
    final rowCount = (size.height / _spacing).floor();
    final offsetX = (size.width - (colCount - 1) * _spacing) / 2;
    final offsetY = (size.height - (rowCount - 1) * _spacing) / 2;

    for (int c = 0; c < colCount; c++) {
      final x = offsetX + c * _spacing;
      for (int r = 0; r < rowCount; r++) {
        final y = offsetY + r * _spacing;
        canvas.drawCircle(Offset(x, y), _radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
