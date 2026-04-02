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
  static const double _spacing = 32.0;
  static const double _radius = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Background fill
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.bg,
    );

    // Dots
    final dotPaint = Paint()..color = AppColors.bgDot;

    for (double x = _spacing; x < size.width; x += _spacing) {
      for (double y = _spacing; y < size.height; y += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
